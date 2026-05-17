# Tooling note — PowerShell harness crash on multi-line `git` input

**Scope**: tooling-environment-wide (PowerShell + Copilot CLI harness). Documented
here under the mission-2 repo for convenience; promote to a shared tooling location
(or the K_0 repo `tooling/`) when operator instructs. This document is *not* a
mission-2 deliverable; it captures a recurring environment defect plus working
recoveries so future missions on the same harness don't rediscover it.

## Class pattern (H11-style)

`git` subcommands that accept multi-line message input via `-F <file>` or `-m
"<multi-line string>"` flags consistently crash the Copilot CLI PowerShell harness
mid-call (Node.js shell-spawn level, not git level — git itself completes the
operation when the working files / refs are inspected afterward, but the
PowerShell session terminates abruptly and the tool returns "shellId not found"
or hangs past initial_wait without producing output).

The crash class is reproducible across:

- `git commit -F <file>` (UTF-8 with BOM specifically triggers a stdin/stderr
  buffering interaction; even BOM-less files have shown the same harness-level
  truncation, though the commit completes server-side)
- `git tag -a -m "<message>"`
- `git tag -a -F <file>`

The crash is independent of GPG signing (verified: no `commit.gpgsign`,
`tag.gpgsign`, or `tag.forceSignAnnotated` set in repo or global config) and
independent of editor invocation (verified: `core.editor` unset; `-m`/`-F`
already bypass editor).

## Known instances

| Date (JST) | Repo | Command class | Resolution |
|---|---|---|---|
| K_0 mission, dates not in mission-2 session record | `papanokechi/khinchin-k0-bounded` | `git commit -F <file>` | recovered (per operator memory) |
| 2026-05-17 13:55 | `papanokechi/unsolved-relay-2-erdos-ko-rado-q-analog-lean` | `git commit -F <file>` (BOM-laden) | amend round below |
| 2026-05-17 13:58 | same | `git commit --amend -F <file>` (BOM-less) | succeeded |
| 2026-05-17 14:0x | same | `git tag -a -F <file>` and `git tag -a -m "..."` | repeated crash; GitHub REST fallback |

Operator should backfill K_0 instance dates from K_0 `mutation_log/` if precise
chronology becomes relevant. They are not load-bearing on mission 2.

## Symptom signature

1. Tool dispatches a powershell call running `git commit -F <file>` or `git tag
   -a {-F | -m}` from a fresh or existing shell.
2. `initial_wait` elapses with no output.
3. `read_powershell` on the supplied `shellId` returns "shellId X not found or
   was never created" or "still running" past further waits.
4. `list_powershell` may show the shell as completed or as absent.
5. Server-side state (commit on HEAD, tag in refs) is inspected via a *new*
   shell or via `gh api` and is found to have completed successfully.

The data hazard is therefore not lost work — git's operation is atomic at the
ref level — but lost *visibility*: the harness cannot confirm the write, so
without an out-of-band check the CLI may assume failure and retry, risking
duplicate commits or duplicate tag-object SHAs.

## Hypothesis (unverified)

Most likely an interaction between (a) PowerShell's argument-passing /
encoding pipeline for multi-line strings or files containing newlines, (b)
the Copilot CLI harness's Node.js `child_process` stdout / stderr buffering
when the child process writes a mix of stdout + stderr from `git`'s
post-commit / post-tag status reports, and (c) potentially a buffer flush
race when the PowerShell session is asked to terminate cleanly after
emitting native-command output. The exact root cause has not been
characterised; the workarounds below are sufficient for current mission
purposes.

## Workaround A — commit messages

1. Compose the message as a PowerShell here-string (`@"..."@`) or single
   variable.
2. Write it to a temp file using `[System.IO.File]::WriteAllText("$PWD\.git\COMMIT_MSG.tmp", $msg, (New-Object System.Text.UTF8Encoding $false))`.
   The `$false` argument ensures **no BOM** is emitted; Windows PowerShell's
   `Out-File -Encoding utf8` will add a BOM and the BOM becomes the first
   visible character of the commit subject line.
3. Run `git commit -F .\.git\COMMIT_MSG.tmp` (or `git commit --amend -F ...`).
4. After the initial_wait elapses without confirmation, **do not retry**.
   Switch to a fresh shell and run `git --no-pager log --oneline -n 1` to
   verify the commit actually landed. If it did, proceed (and amend the
   subject if a BOM byte slipped through).
5. Remove the temp file.

## Workaround B — annotated tags

The local `git tag -a` crash is more reliable than the commit crash; do not
attempt local annotated-tag creation at all. Instead:

1. Resolve the target commit SHA: `gh api repos/<owner>/<repo>/git/refs/heads/<branch> --jq '.object.sha'`.
2. POST a tag object:
   ```
   gh api -X POST repos/<owner>/<repo>/git/tags \
     --input <(jq -n --arg tag "$TAG" --arg msg "$MSG" --arg sha "$SHA" \
       '{tag:$tag, message:$msg, object:$sha, type:"commit",
         tagger:{name:"<gh-login>", email:"<gh-login>@users.noreply.github.com",
                 date:"<RFC3339 timestamp>"}}')
   ```
   On Windows PowerShell, write the JSON body to a temp file with
   `[System.IO.File]::WriteAllText(..., $body, UTF8Encoding $false)` and pass
   `--input <path>` to `gh api`.
3. Capture the returned tag-object SHA.
4. POST the ref:
   ```
   gh api -X POST repos/<owner>/<repo>/git/refs \
     --input <body containing ref="refs/tags/<TAG>" and sha=<tag-object SHA>>
   ```
5. `git fetch --tags origin` in the local clone to bring the new tag down for
   parity. (`git fetch` is a single-line command and is unaffected by the
   crash class.)

The resulting tag object has `type: "tag"` (annotated), identical in kind to a
tag produced by `git tag -a` and to K_0's `gold/M6` reference (which was used
as the type-precedent for mission 2's `gold/M1-2`).

## Open question

Whether the root cause is fixable at the harness layer (Copilot CLI Node.js
`child_process` stdio handling, PowerShell `&` invocation argument quoting, or
the way native commands' interleaved stdout/stderr are surfaced through the
MCP shell tool) or whether mission-time discipline should continue to rely on
the workarounds above indefinitely. Not within mission-2's scope to
investigate; flag for tooling-side investigation when convenient.

## When this document fires

- Any future PowerShell-harness mission encountering `git commit -F` or
  `git tag -a` instability should consult this file first.
- Any tooling-side investigation should treat the two known mission-2
  instances as reproducible test cases and the K_0 instance as historical
  evidence.
- If the harness is later patched and the crash class disappears, append a
  resolution entry to this file and date it; do not delete the historical
  workaround documentation (it remains relevant for older harness
  versions).
