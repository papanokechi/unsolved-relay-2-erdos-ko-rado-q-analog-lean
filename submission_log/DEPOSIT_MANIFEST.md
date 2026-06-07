# DEPOSIT MANIFEST — q-EKR Tier-2 (statement + documented capability gap)

**Status:** deposit-ready DRAFT (PREPARE-ONLY). The agent has NOT committed, pushed,
flipped visibility, or minted any DOI. All such actions are operator hand-actions.

**Repository:** papanokechi/unsolved-relay-2-erdos-ko-rado-q-analog-lean (currently PRIVATE)
**Base HEAD at drafting:** `ab4c9430aeac84531cd46a18a0625fbfae6fa114` (2026-05-18, branch main)
**Toolchain:** `leanprover/lean4:v4.29.0`; Mathlib SHA `8a178386ffc0` (all 9 deps SHA-pinned in `lake-manifest.json`)
**Outcome:** Tier-2 — formalized STATEMENT + documented capability gap. NOT a proof.
**Honesty signal (reconfirmed this prepare pass):** `#print axioms QEkr.q_ekr` →
`[propext, sorryAx, Classical.choice, Quot.sound]`. `sorryAx` present ⇒ statement, not proof.

---

## 1. Deposit-bundle artifacts (uncommitted draft changes)

| File | SHA-256 | MD5 | Bytes | Change |
|------|---------|-----|-------|--------|
| `QEkr/PointPencilCounting/Basic.lean` | `9ec959e8042a6f4a5fd44adb63e0a0588c19d7cb06463068d3c2bc9d5cb1ff63` | `36cc1cc31910e6a41607e35d42d50da3` | 10440 | MODIFIED — AEAL CAPABILITY-GAP marker replaces proof-body TODO; `sorry` retained as honest signal; docstrings reframed statement-not-proof. `q_ekr` signature unchanged. **This SHA is the gap-marked (sorryAx-bearing) version, not a pre-gap copy.** |
| `QEkr/IsDimIntersectingOf.lean` | `2b20325f63f8be0e4098219a214ecb9d2843f831441050a90041c54f8cad23c0` | `4194805d8c8643918d16d5484bc9edad` | 5394 | UNCHANGED — the fully-proved q-analog intersecting predicate (the clean contribution). Listed for integrity. |
| `capability/qekr_substrate.gap.md` | `37cb301ccea2be71fe8dec5d7b9df3e9955781fa4b73b04d392574481d1450e0` | `4f509c65c426dc7c5917738b4d77de4a` | 13216 | NEW — the substantive deliverable: full capability-gap analysis + future-formalizer roadmap. |
| `README.md` | `9eac5ed3cb683daf30279228bf430634c84f4538d9986d289fd7f0063cb62e7f` | `98f406d0fffc58c8f5dc17569deab56f` | 4774 | MODIFIED — Status section reframed to Tier-2 honest statement+gap. |
| `submission_log/zenodo_metadata_qekr_DRAFT.json` | `6816c0bf3a3d0279d4eb0802c508dce553e471f95e6c39afe0a1884092274a0d` | `61d0882b9def333cc11397e2defafc79` | 10321 | NEW (refreshed) — Zenodo metadata, house-aligned to K_0/EBR (Preprint + CC-BY-4.0); `metadata` block + `_operator_decisions`. |

Companion submission_log files (not part of the scientific bundle; operator-facing):
`DEPOSIT_MANIFEST.md` (this file) and `OPERATOR_CHECKLIST.md`.

> Source `.lean`/`.md` hashes are final for the draft; the build-verify and the
> axiom-cone check do NOT modify any source file (the temporary `#print axioms` line is
> added and then reverted; `Basic.lean` SHA is back to `9ec959e8…`).

## 2. git status at drafting (confirming git untouched)

```
 M QEkr/PointPencilCounting/Basic.lean
 M README.md
?? capability/qekr_substrate.gap.md
?? submission_log/DEPOSIT_MANIFEST.md
?? submission_log/OPERATOR_CHECKLIST.md
?? submission_log/zenodo_metadata_qekr_DRAFT.json
```
HEAD unchanged (`ab4c943`); no commits, tags, or branch moves by the agent.

## 3. Build verification (reproduced this prepare pass)

```
lake exe cache get                           # exit 0 (8058 oleans, cached)
lake build QEkr.PointPencilCounting.Basic    # exit 0, 1514 jobs
```
Result: exit 0; **exactly one** warning —
`QEkr/PointPencilCounting/Basic.lean:173:8: declaration uses 'sorry'` (the `q_ekr`
body). Axiom cone via a temporary `#print axioms QEkr.q_ekr` (then reverted):
`[propext, sorryAx, Classical.choice, Quot.sound]` — `sorryAx` present, confirming the
honest statement-not-proof artifact. No Mathlib-drift / ProofWidgets / algcomb breakage.

## 4. Alignment with prior statement-shape uploads

| Field | This deposit | K_0 (20246708) | EBR-II (20566466) |
|-------|--------------|----------------|-------------------|
| resource_type | Preprint | Preprint | Preprint |
| license | cc-by-4.0 | cc-by-4.0 | cc-by-4.0 |
| creator name | Papanokechi *(flag: K_0 = "papanokechi, papanokechi")* | papanokechi, papanokechi | Papanokechi |
| ORCID | 0009-0000-6192-8273 | 0009-0000-6192-8273 | 0009-0000-6192-8273 |
| status framing | statement + documented gap (NOT a proof) | null result + structural gap | characterization (graded) |

See `submission_log/zenodo_metadata_qekr_DRAFT.json` → `_operator_decisions` for the
four flags requiring operator confirmation and `OPERATOR_CHECKLIST.md` for the ordered
hand-actions.
