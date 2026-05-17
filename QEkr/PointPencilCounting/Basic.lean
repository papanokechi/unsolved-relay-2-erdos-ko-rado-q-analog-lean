/-
Copyright (c) 2026 papanokechi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: papanokechi

# Point-pencil substrate for q-EKR via direct counting

This file scaffolds the **direct point-pencil counting proof method**
(substep (3) of M3.1 per U-MISSION-2-J option (iii)). See
`mutation_log/M3-2.md` entry 3 and `capability/algcomb_lakedep.gap.md`
§RESOLUTION for the method-substitution decision; see
`capability/intersecting_substrate.available.md` Step 3 for the method
selection rationale.

A **point-pencil** through a subspace `V₀ : Submodule K M` at dimension
`k : ℕ` is the family of all `k`-dimensional subspaces of `M` containing
`V₀`. For the classical q-EKR scenario (`t = 1`), `V₀` is a
1-dimensional subspace (a "point" in projective-geometric terms),
`M = Fin n → F_q`, and `k` is the uniform subspace dimension of the
family being bounded. The q-EKR bound is exactly the cardinality of
any such point-pencil — equal to the q-binomial coefficient
$\binom{n-1}{k-1}_q$, but stated here set-theoretically to avoid the
q-binomial substrate gap surfaced at M2.2 Fire 1 / M3.1 H10 sub-step 1.

This file is the **FIRST STAGED COMMIT** of substep (3); subsequent
commits will incrementally replace `sorry` placeholders with the
counting argument (per the operator-calibrated multi-session staging
pattern).

## Main definition

* `QEkr.pointPencil V₀ k` — the family of all `k`-dim subspaces of `M`
  containing `V₀`.

## Main statement

* `QEkr.q_ekr` — the q-EKR (t=1) bound: every intersecting family of
  `k`-dim subspaces of `F_q^n` has cardinality bounded by any
  point-pencil through a fixed 1-dim subspace.

## Status (substep (3) first staged commit)

* `pointPencil` definition: **complete**.
* `pointPencil.mem_iff`, `pointPencil.uniform_dim`,
  `pointPencil.contains_centre`, `pointPencil.le_inf_of_mem_mem`:
  **complete** (basic API, no `sorry`).
* `pointPencil.isDimIntersectingOf_ge`: scaffolded with `sorry`. The
  argument is short (`V₀ ≤ V ⊓ W` via `le_inf` plus finrank
  monotonicity), but the exact Mathlib lemma name for
  `Submodule.finrank_mono` will be looked up at the next staged
  commit.
* `q_ekr` theorem: scaffolded with `sorry`; proof to be completed
  top-down across subsequent staged commits.

## References

* `QEkr.IsDimIntersectingOf` (substep (2), commit `a17ed3e`) — the
  q-analog intersecting-families predicate this file builds on.
* `targets/selected.md` (gold/M1-2) — the bounded sub-question
  (q-EKR for k-dim subspaces of F_q^n, t=1).
* `targets/success_predicate.md` §3.1 (gold/M2-2) — Tier 1 closed-proof
  target this file scaffolds towards.
-/

import QEkr.IsDimIntersectingOf
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

namespace QEkr

open Set Submodule

universe u v

variable {K : Type u} [DivisionRing K]
variable {M : Type v} [AddCommGroup M] [Module K M]

/--
The **point-pencil** through a subspace `V₀ : Submodule K M` at dimension
`k : ℕ` is the family of all `k`-dimensional subspaces of `M` containing
`V₀`.

For the classical q-EKR scenario (`t = 1`), `V₀` is a 1-dimensional
subspace (a "point" in projective-geometric terms), `M = Fin n → F_q`,
and `k` is the uniform subspace dimension of the family being bounded.
The q-EKR bound is exactly the cardinality of any such point-pencil.
-/
def pointPencil (V₀ : Submodule K M) (k : ℕ) : Set (Submodule K M) :=
  {V : Submodule K M | V₀ ≤ V ∧ Module.finrank K V = k}

namespace pointPencil

variable {V₀ : Submodule K M} {k : ℕ}

/-- Membership characterisation. -/
lemma mem_iff {V : Submodule K M} :
    V ∈ pointPencil V₀ k ↔ V₀ ≤ V ∧ Module.finrank K V = k :=
  Iff.rfl

/-- Every member of a point-pencil has `finrank` exactly `k`. -/
lemma uniform_dim {V : Submodule K M} (hV : V ∈ pointPencil V₀ k) :
    Module.finrank K V = k := hV.2

/-- Every member of a point-pencil contains the centre `V₀`. -/
lemma contains_centre {V : Submodule K M} (hV : V ∈ pointPencil V₀ k) :
    V₀ ≤ V := hV.1

/-- The centre `V₀` is contained in the intersection of any two members
of a point-pencil. -/
lemma le_inf_of_mem_mem {V W : Submodule K M}
    (hV : V ∈ pointPencil V₀ k) (hW : W ∈ pointPencil V₀ k) :
    V₀ ≤ V ⊓ W :=
  le_inf hV.1 hW.1

/--
The point-pencil family through `V₀` is `{d | t ≤ d}`-dim-intersecting
whenever `t ≤ Module.finrank K V₀`.

For the classical q-EKR case (`V₀` is 1-dim, so `t = 1` is the relevant
threshold), this is the standard "every two subspaces of a pencil meet
in at least the centre" observation.

**Proof outline (for next staged commit)**:
For `V, W ∈ pointPencil V₀ k` distinct, `V₀ ≤ V ⊓ W` (by
`le_inf_of_mem_mem`), so `finrank K V₀ ≤ finrank K (V ⊓ W)` by
`Submodule.finrank_mono` (or equivalent). Combining with `ht`,
`t ≤ finrank K (V ⊓ W)`, i.e., `finrank K (V ⊓ W) ∈ {d | t ≤ d}`.

The `[Module.Finite K M]` hypothesis is needed for `Submodule.finrank_mono`
to be well-behaved on the ambient module.
-/
theorem isDimIntersectingOf_ge [Module.Finite K M] {t : ℕ}
    (_ht : t ≤ Module.finrank K V₀) :
    IsDimIntersectingOf {d | t ≤ d} (pointPencil V₀ k) := by
  -- TODO: substep (3) staged commit ≥2 — fill in via
  --   intro V hV W hW _hne
  --   have h_le : V₀ ≤ V ⊓ W := le_inf_of_mem_mem hV hW
  --   have : Module.finrank K V₀ ≤ Module.finrank K (V ⊓ W) :=
  --     Submodule.finrank_mono h_le  -- or analogous Mathlib lemma
  --   exact le_trans _ht this
  sorry

end pointPencil

/--
The **q-Erdős-Ko-Rado theorem (t=1)** for k-dim intersecting families
of subspaces of `F_q^n`.

**Statement**: every intersecting family `𝒜` of k-dimensional subspaces
of `F_q^n` (with `1 ≤ k ≤ n`) has cardinality bounded by
`|pointPencil V₀ k|` for any 1-dim subspace `V₀`. This bound equals the
q-binomial coefficient $\binom{n-1}{k-1}_q$, stated here
set-theoretically via point-pencil cardinality to avoid the q-binomial
substrate gap (M2.2 Fire 1 / M3.1 H10 sub-step 1 / U-MISSION-2-J).

**Proof method**: direct point-pencil counting per U-MISSION-2-J option
(iii) / M2.2 §3 documented alternative method. The proof will proceed
top-down across substep (3) staged commits.

**Status**: statement-shape complete; proof body `sorry`. Subsequent
staged commits will incrementally fill in the proof.
-/
theorem q_ekr {K : Type*} [Field K] [Fintype K]
    {n : ℕ} (k : ℕ) (_hk_pos : 1 ≤ k) (_hk_le : k ≤ n)
    (𝒜 : Set (Submodule K (Fin n → K)))
    (_h_dim : ∀ V ∈ 𝒜, Module.finrank K V = k)
    (_h_int : IsDimIntersectingOf {d | 1 ≤ d} 𝒜)
    (V₀ : Submodule K (Fin n → K)) (_hV₀_dim : Module.finrank K V₀ = 1) :
    Set.ncard 𝒜 ≤ Set.ncard (pointPencil V₀ k) := by
  -- TODO: substep (3) staged commits — direct point-pencil counting
  -- proof. Anticipated top-down decomposition:
  -- (a) Every intersecting family of k-dim subspaces is contained in
  --     some point-pencil (for the extremal case) OR is strictly
  --     smaller than any point-pencil (non-extremal case).
  -- (b) All point-pencils through a fixed-dim centre have the same
  --     cardinality (by basis-extension / linear-algebra bijection).
  -- (c) Combine (a) + (b) to conclude `|𝒜| ≤ |pointPencil V₀ k|`.
  sorry

end QEkr
