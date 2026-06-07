# OPERATOR CHECKLIST — q-EKR Tier-2 deposit

The agent prepared everything to ready-state and STOPPED. Every item below is an
operator hand-action. Nothing here has been done by the agent (no commit, push, tag,
visibility flip, or DOI mint).

---

## A. Review the honesty contract (do this first)

- [ ] Confirm `QEkr/PointPencilCounting/Basic.lean` `q_ekr` body is a `sorry` inside an
      AEAL CAPABILITY-GAP comment block — **not** an `axiom`, **not** otherwise
      discharged. The `sorry` build warning is the honest signal; it MUST remain.
- [ ] Confirm no metadata / README / gap-doc text claims a *proof*. The title, README
      Status, and Zenodo description all say "statement … documented capability gap".
- [ ] Read `capability/qekr_substrate.gap.md` — this is the deliverable's substance.

## B. Build-verify (reproduce before depositing)

```
cd <repo>
lake exe cache get            # ~17 min on a cold host (8058 oleans)
lake build QEkr.PointPencilCounting.Basic
```
Expected: exit 0, **exactly one** warning — `declaration uses 'sorry'` at the `q_ekr`
body. Then check the axiom cone (the file does not contain a `#print axioms` line — run
it interactively, e.g. add a temporary `#print axioms QEkr.q_ekr` and rebuild, or use
the Lean server):
```
#print axioms QEkr.q_ekr
```
Expected axiom cone: includes `sorryAx` (the honest statement-not-proof marker),
alongside `propext`, `Classical.choice`, `Quot.sound`.

> Agent build-verify result (recorded Step 4): **PASS.** `lake build
> QEkr.PointPencilCounting.Basic` → exit 0, 1514 jobs, **exactly one** warning:
> `QEkr/PointPencilCounting/Basic.lean:173:8: declaration uses 'sorry'` (the `q_ekr`
> body). Axiom cone via `#print axioms QEkr.q_ekr`:
> `[propext, sorryAx, Classical.choice, Quot.sound]` — `sorryAx` present, confirming an
> honest statement-not-proof artifact. (The `#print axioms` line was temporary, used
> only for verification, and is NOT in the deposited file.)

## C. Ordered hand-actions (do in this order)

### C.1 — Resolve the 4 decision flags
Full detail in `submission_log/zenodo_metadata_qekr_DRAFT.json` → `_operator_decisions`.
The metadata draft is **already set to the house-aligned default** for each (matching
the live K_0 `20246708` and EBR-II `20566466` records); confirm or override:

- [ ] **resource_type** — set to `publication / preprint` (**house-aligned default**).
      Both K_0 and EBR-II are Preprints. Alternative `software` only if a code-archive
      framing is preferred; couple to the license choice.
- [ ] **license** — set to `cc-by-4.0` (**house-aligned default**). Both K_0 and EBR-II
      use CC-BY-4.0. Use a code license (MIT/Apache-2.0) only if resource_type is
      switched to `software`. (Repo itself: code = MIT `LICENSE`, docs = CC-BY-4.0
      `LICENSE-DOCS`.)
- [ ] **creators[0].name** — set to `Papanokechi` (**default**, matches EBR-II + program
      memory). ⚠ The K_0 statement-shape sibling renders `papanokechi, papanokechi`;
      switch to that form if unsolved-relay-series display consistency is preferred.
      ORCID `0009-0000-6192-8273` is unambiguous across all records.
- [ ] **Lean-header vs LICENSE discrepancy** (pre-existing; NOT fixed here) — `QEkr/*.lean`
      headers say *"Released under Apache 2.0 license as described in the file LICENSE"*
      but `LICENSE` is **MIT**. Reconcile header-vs-LICENSE consistency before any
      Mathlib4 PR (Mathlib requires Apache-2.0 headers **and** an Apache-2.0 LICENSE).
      Independent of the CC-BY-4.0 Zenodo deposit license.
- [ ] **(note) SIARC-umbrella link intentionally omitted** — q-EKR is extremal
      combinatorics, not a polynomial-continued-fraction result, so the K_0-style
      `isPartOf` to SIARC-PCF umbrella `10.5281/zenodo.19885549` was NOT added. Add an
      `unsolved-relay` series umbrella DOI here only if one exists.

### C.2 — Commit the gap-marker change
- [ ] Stage exactly the draft changes (see `DEPOSIT_MANIFEST.md` §2):
      `QEkr/PointPencilCounting/Basic.lean`, `README.md`,
      `capability/qekr_substrate.gap.md`, `submission_log/` (this folder).
- [ ] Commit with a Tier-2-explicit message, e.g.
      `q-EKR: Tier-2 close — formalized statement + documented Mathlib substrate gap (not a proof)`.
- [ ] Push to `main`.

### C.3 — Flip the repo public
- [ ] Flip `papanokechi/unsolved-relay-2-erdos-ko-rado-q-analog-lean` **public** (per the
      M6 precedent). It is currently PRIVATE — the GitHub `related_identifier` in the
      metadata returns 404 until this is done, so flip **before** minting.

### C.4 — Mint the Zenodo deposit
- [ ] Create a GitHub release/tag for the snapshot (Zenodo–GitHub integration) or upload
      the archive manually.
- [ ] Mint using `zenodo_metadata_qekr_DRAFT.json` `metadata` block.
      **Concept DOI is intentionally empty — Zenodo mints it.**

### C.5 — Record the new DOI
- [ ] Write the minted DOI back into `submission_log/` and `README.md`.

### C.6 — Re-run a read-only verify (analogous to the EBR-II erratum verify)
- [ ] Re-clone the now-public repo fresh, `lake exe cache get` + `lake build
      QEkr.PointPencilCounting.Basic`; confirm exit 0 with **exactly one** `sorry`
      warning and that `#print axioms QEkr.q_ekr` lists `sorryAx`.
- [ ] Confirm the published Zenodo record's title/description carry the
      statement-not-proof framing (no "proof of…" phrasing) and that the GitHub
      related-identifier now resolves.

## D. Venue framing (reset honestly)

- [ ] A statement + capability-gap is an honest **short note / Mathlib-statement
      contribution**, not the closed-proof PR originally targeted for Math.Comp / JAR.
      Frame any submission accordingly; do not present it as a completed proof.

---

### Reminder
This is the AEAL standing meta-rule for this program: the agent prepares to ready-state
and stops; commit / push / tag / visibility-flip / DOI-mint are operator-only.
