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
| 2026-05-17 ~18:55 | same | `git commit -F <file>` (BOM-less, M2.1 close message) | repeated crash even with BOM-less file; fell back to Workaround C |

**Workaround A is therefore not fully reliable** — the BOM-less precaution is
necessary but not sufficient. **The pattern is intermittent**: Workaround A
worked at commits `c8e5bca` and `31697f9` but crashed at the M2.1 close
commit on the same day with the same procedure. Treat A as a probabilistic
recovery, not a deterministic one. The M2.1 close commit message succeeded
only via inline `-m` (see Workaround C below).

**Recommended default policy (added 2026-05-17 per operator directive)**:

- For commit messages that are **one logical line** (subject + single
  trailer concatenated with `; ` separator): use **Workaround C** (inline
  `-m`). Reliable, no harness interaction with file-stdio.
- For commit messages that are **multi-paragraph and the paragraph
  structure is load-bearing** (e.g., freeze-tag annotations, manuscript
  artifacts, mutation-log narration): default to **Workaround D**
  (external terminal escape hatch). Do not attempt Workaround A first;
  the probability of crash is high enough that it wastes time.
- For **annotated tags**: continue to use **Workaround B** (GitHub REST
  API) regardless of message length. The `git tag -a` path is
  effectively unrecoverable under the current harness.

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

## Workaround C — short messages via inline `-m` (added 2026-05-17)

When Workaround A (BOM-less `-F` file) crashes recurrently, a more reliable
path exists for short messages:

```powershell
git commit -m "<subject>; <one-line trailer>"
```

The trailer can be appended to the subject with a `; ` separator. Git tools
that parse trailers by regex on the last line of the commit message will still
detect `Co-authored-by:`; tools that strictly require the trailer to be in a
separate paragraph from the subject will not. For mission-record purposes the
former is sufficient.

If the message exceeds what's comfortable on a subject line, use multiple
`-m` flags — each `-m` argument becomes a separate paragraph:

```powershell
git commit -m "<subject>" -m "<body paragraph 1>" -m "<body paragraph 2>" -m "<trailer>"
```

Multiple `-m` flags work reliably for `git tag -a` (verified during M1.3 Gold
Freeze G1-2 attempt; the crash there was triggered by the multi-line content of
a single `-m` argument's value, not by the number of `-m` flags themselves —
though even that path eventually failed and required the GitHub REST fallback,
Workaround B).

**Workaround C trade-off**: less reliable for long messages with explicit
paragraph breaks; loses the trailer-paragraph convention that some commit
analyzers prefer. Acceptable for routine commits; not acceptable for
freeze-tag annotations where commit-message hygiene matters more.

## Workaround D — degraded mode

If A and C both fail and the operator requires the commit message in
unmodified multi-paragraph form, fall back to:

1. Compose the message in a session-state file.
2. Open a *separate* terminal (outside the Copilot CLI harness) and run
   `git commit -F <file>` directly from there.
3. Return to the harness and run `git push` to publish.

This is a true escape hatch — it removes the Copilot CLI harness from the
multi-line input path entirely. Not applicable in fully autonomous /
autopilot sessions where no separate terminal is available.

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
