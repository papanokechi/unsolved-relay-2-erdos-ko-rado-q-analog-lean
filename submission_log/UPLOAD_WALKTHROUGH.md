# UPLOAD WALKTHROUGH — q-EKR Tier-2 Zenodo deposit

Step-by-step operator guide for depositing the q-EKR Tier-2 artifact (a formalized
**statement** + documented capability gap — **NOT a proof**). Companion to
`OPERATOR_CHECKLIST.md` (the terse checkbox version) and
`zenodo_metadata_qekr_DRAFT.json` (the field source).

**House pattern** (from the live K_0 `10.5281/zenodo.20246708` and EBR-II
`10.5281/zenodo.20566466` records): a **manual Zenodo web deposit**, files uploaded
directly, resource type **Preprint**, license **CC-BY-4.0**.

> Standing rule: every step here is an **operator hand-action**. The agent prepared to
> ready-state and stopped — no commit, push, tag, visibility flip, or DOI mint by the agent.

---

## 0. Pre-flight — reproduce the honesty signal
```powershell
cd C:\LocalWork\unsolved-relay-2-erdos-ko-rado-q-analog-lean
lake exe cache get
lake build QEkr.PointPencilCounting.Basic
```
Expect exit 0 and **exactly one** warning: `Basic.lean:173:8: declaration uses 'sorry'`.
Optionally confirm the axiom cone: temporarily append a line `#print axioms QEkr.q_ekr`,
rebuild, confirm it prints **`[propext, sorryAx, Classical.choice, Quot.sound]`**
(`sorryAx` present = the statement-not-proof guarantee), then delete the temp line.
**Do not deposit if `sorryAx` is absent** (it would mean the proof was silently assumed).

## 1. Resolve the 4 decision flags
Open `submission_log/zenodo_metadata_qekr_DRAFT.json` → `_operator_decisions`. The draft
is already set to the **house-aligned default** for each; confirm or override:

| # | Field | Default in draft | Alternative |
|---|-------|------------------|-------------|
| 1 | resource_type | **Preprint** (`publication/preprint`) | `software` (code-archive framing) |
| 2 | license | **CC-BY-4.0** | MIT / Apache-2.0 (only if you switch to Software) |
| 3 | creator name | **`Papanokechi`** (matches EBR-II) | `papanokechi, papanokechi` (matches K_0) |
| 4 | Apache-header vs MIT `LICENSE` | left as-is | reconcile if you intend a Mathlib4 PR |

Flag 3 (precedents disagree) and flag 4 (pre-existing repo inconsistency: Lean headers
say *"Released under Apache 2.0"* but `LICENSE` is **MIT**) are the two that genuinely
need your call. Flag 4 does **not** affect the CC-BY-4.0 deposit; it only matters for a
future Mathlib PR (which requires Apache-2.0 headers **and** an Apache-2.0 LICENSE).

## 2. Commit the gap-marker drafts
```powershell
git add QEkr/PointPencilCounting/Basic.lean README.md capability/qekr_substrate.gap.md submission_log/
git commit -m "q-EKR: Tier-2 close — formalized statement + documented Mathlib substrate gap (not a proof)

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push origin main
```

## 3. Flip the repository public (M6 precedent)
```powershell
gh repo edit papanokechi/unsolved-relay-2-erdos-ko-rado-q-analog-lean `
  --visibility public --accept-visibility-change-consequences
```
Do this **before** minting, so the GitHub `related_identifier` in the metadata resolves
(it returns 404 while the repo is private).

## 4. Build the deposit payload (clean source archive)
```powershell
git archive --format=zip -o submission_log\qekr-tier2-source.zip HEAD
```
`git archive HEAD` includes only the ~35 tracked files and **excludes** the gitignored
`.lake/` build cache (~7 GB) — so the zip is small and reproducible. Run it **after** the
commit in step 2 so the archive matches the snapshot you publish.

**Files to upload to Zenodo:**
1. `qekr-tier2-source.zip` — the full formalization (reproducible `lake build`).
2. `capability/qekr_substrate.gap.md` — standalone, so reviewers read the gap analysis
   without unzipping.
3. `submission_log/DEPOSIT_MANIFEST.md` — integrity (SHA-256/MD5 + build/honesty note).

## 5. Zenodo web form → field mapping
At <https://zenodo.org/uploads/new>, drag in the step-4 files, then fill:

| Zenodo form field | Value (source: `zenodo_metadata_qekr_DRAFT.json`) |
|-------------------|---------------------------------------------------|
| Resource type | **Publication → Preprint** |
| Title | the JSON `title` (statement-unambiguous — do **not** retitle to imply a proof) |
| Creators | `Papanokechi` · Independent Researcher · ORCID `0009-0000-6192-8273` |
| Description | the JSON `description` (ready-made HTML; states the 3 substrates + `sorryAx` + venue-reset) |
| License | Creative Commons Attribution 4.0 International (**CC-BY-4.0**) |
| Keywords | the JSON `keywords` list |
| Version | `1.0` |
| Language | `eng` |
| Related identifiers | `https://github.com/papanokechi/unsolved-relay-2-erdos-ko-rado-q-analog-lean` → *is supplement to*; `10.5281/zenodo.20246707` (K_0) → *references* |
| Additional notes | the JSON `notes` (carries the AI-use disclosure + Tier-2 status) |
| DOI | leave blank → **Reserve DOI** / mint on publish. **Do not** pre-fill the concept DOI. |

*(If you switch flag 1 to Software: set Resource type = Software, License = MIT, and add
the repo as `code:codeRepository`.)*

## 6. Publish, record, and verify
- Click **Publish** → Zenodo mints the version DOI + concept DOI.
- Record the minted DOI into `README.md` and `submission_log/` (e.g. fill
  `_concept_doi` in a copy of the metadata draft); commit + push.
- **Post-mint verify** (analogous to the EBR-II erratum verify):
  - the published record's title/description say *statement … gap* — no "proof of…";
  - the GitHub related-identifier now resolves;
  - a fresh clone of the public repo still builds green with the one `sorry` warning and
    `#print axioms QEkr.q_ekr` lists `sorryAx`.

---

### Venue framing (set expectations honestly)
A statement + capability-gap is an honest **short note / Mathlib-statement contribution**
— not the closed-proof Math.Comp/JAR PR originally targeted. Frame any onward submission
accordingly.
