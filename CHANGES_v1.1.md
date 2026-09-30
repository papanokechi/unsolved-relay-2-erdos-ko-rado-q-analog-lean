# q-EKR statement v1.1 (2026-09-30)

1. **Statement corrected.** `QEkr.q_ekr` now assumes `(_h2k : 2 * k ≤ n)` instead of
   `(_hk_le : k ≤ n)`. The v1.0 statement is false when `2k > n`: any two k-dimensional
   subspaces of an n-dimensional space then meet nontrivially, so the whole Grassmannian
   (size `[n choose k]_q`) is an intersecting family, larger than a point-pencil
   (`[n-1 choose k-1]_q`). The corrected statement is the Frankl–Wilson bound.
2. **Default build now compiles the theorem.** `QEkr.lean` imports
   `QEkr.PointPencilCounting.Basic`. In v1.0 it imported only `QEkr.Substrate`, so
   `lake build` exited 0 without compiling `q_ekr` and without the documented `sorry`
   warning.
3. **Axiom check added.** `check_axioms.lean` prints the statement and its axioms. v1.0
   shipped no such file; its checklist asked the reader to add a temporary
   `#print axioms` line.
4. README build line, `capability/qekr_substrate.gap.md` signature, and the literature
   ledger's equality range (`n ≥ 2k + 1`) updated. Three prose restatements of the theorem
   that also lacked the hypothesis now carry it: the module docstring summary in
   `QEkr/PointPencilCounting/Basic.lean`, and the gloss under the signature and §2(c) of
   the gap file.
5. **Not edited: the files of `submission_log/`.** It is the historical v1.0 submission
   record. `zenodo_metadata_qekr_DRAFT.json` there repeats the v1.0 statement sentence
   without the hypothesis `n ≥ 2k`; it is kept as filed, and item 1 supersedes it. It was
   never sent to any venue: its only destination was this Zenodo record.
6. **The June post-deposit record, first committed here.** `submission_log/DEPOSITED.md`
   (written 2026-06-07, after the v1.0 mint) is added unchanged, with a dated note at its
   end. The README now says the repository is public and gives the DOIs; its DOI row
   labels 20575745 as v1.0.

The proof of `q_ekr` is still a deliberate `sorry`. The artifact remains a formalized
statement with a documented gap, not a proof.

Reproduce from a clean unzip (Lean v4.29.0, Mathlib 8a178386):

```
lake exe cache get
lake build                        # exactly one warning: declaration uses 'sorry' (q_ekr)
lake env lean check_axioms.lean   # [propext, sorryAx, Classical.choice, Quot.sound]
```
