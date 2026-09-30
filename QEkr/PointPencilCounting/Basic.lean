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

**Tier-2 outcome (M5):** this file provides a formalized *statement* of
q-EKR plus an explicitly documented capability gap — it is **NOT** a
proof. The `q_ekr` proof body is a deliberate `sorry` marking an AEAL
CAPABILITY GAP (the required Mathlib substrate is absent); see
`capability/qekr_substrate.gap.md`. The predicate and the statement
type-check, and `lake build` succeeds modulo the single, intended `sorry`
warning (the honest statement-not-proof signal).

## Main definition

* `QEkr.pointPencil V₀ k` — the family of all `k`-dim subspaces of `M`
  containing `V₀`.

## Main statement

* `QEkr.q_ekr` — the q-EKR (t=1) bound: for `1 ≤ k`, `2 * k ≤ n`, every
  intersecting family of `k`-dim subspaces of `F_q^n` has cardinality
  bounded by any point-pencil through a fixed 1-dim subspace.

## Status (substep (3) first staged commit)

* `pointPencil` definition: **complete**.
* `pointPencil.mem_iff`, `pointPencil.uniform_dim`,
  `pointPencil.contains_centre`, `pointPencil.le_inf_of_mem_mem`:
  **complete** (basic API, no `sorry`).
* `pointPencil.isDimIntersectingOf_ge`: **complete** (2-line proof
  composing `le_inf_of_mem_mem` with `Submodule.finrank_mono` via
  `le_trans`; the `[Module.Finite K (V ⊓ W)]` instance required by
  `Submodule.finrank_mono` is synthesised automatically from
  `[Module.Finite K M]` over a `DivisionRing` via
  `finiteDimensional_submodule`).
* `q_ekr` theorem: **statement formalized; proof NOT formalized**
  (Tier-2). The body is a deliberate `sorry` = a documented AEAL
  CAPABILITY GAP — the honest signal that the theorem is asserted, not
  proved (`#print axioms q_ekr` lists `sorryAx`). See
  `capability/qekr_substrate.gap.md`.

## References

* `QEkr.IsDimIntersectingOf` (substep (2), commit `a17ed3e`) — the
  q-analog intersecting-families predicate this file builds on.
* `targets/selected.md` (gold/M1-2) — the bounded sub-question
  (q-EKR for k-dim subspaces of F_q^n, t=1).
* `targets/success_predicate.md` §2.2 (Tier 2 — statement + substrate-gap
  comment) — the success-predicate form this file realizes; §2.1 (Tier 1
  closed proof) is the target that the documented substrate gap blocks.
-/

import QEkr.IsDimIntersectingOf
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.Dimension.Constructions

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

**Proof**: for `V, W ∈ pointPencil V₀ k` distinct, `V₀ ≤ V ⊓ W` (by
`le_inf_of_mem_mem`), so `finrank K V₀ ≤ finrank K (V ⊓ W)` by
`Submodule.finrank_mono`. Composing with `ht` via `le_trans` gives
`t ≤ finrank K (V ⊓ W)`, i.e., `finrank K (V ⊓ W) ∈ {d | t ≤ d}`.

The `[Module.Finite K M]` hypothesis is needed so that the
`Module.Finite K (V ⊓ W)` instance required by `Submodule.finrank_mono`
is synthesised (via `finiteDimensional_submodule` over a `DivisionRing`).
-/
theorem isDimIntersectingOf_ge [Module.Finite K M] {t : ℕ}
    (ht : t ≤ Module.finrank K V₀) :
    IsDimIntersectingOf {d | t ≤ d} (pointPencil V₀ k) := by
  intro V hV W hW _hne
  exact le_trans ht (Submodule.finrank_mono (le_inf_of_mem_mem hV hW))

end pointPencil

/--
The **q-Erdős-Ko-Rado theorem (t=1)** for k-dim intersecting families
of subspaces of `F_q^n`.

**Statement**: every intersecting family `𝒜` of k-dimensional subspaces
of `F_q^n` (with `1 ≤ k` and `2 * k ≤ n`) has cardinality bounded by
`|pointPencil V₀ k|` for any 1-dim subspace `V₀`. This bound equals the
q-binomial coefficient $\binom{n-1}{k-1}_q$, stated here
set-theoretically via point-pencil cardinality to avoid the q-binomial
substrate gap (M2.2 Fire 1 / M3.1 H10 sub-step 1 / U-MISSION-2-J).

**Hypothesis `2 * k ≤ n` (v1.1 correction).** v1.0 assumed only `k ≤ n`, under which
the statement is false: if `2 * k > n`, any two k-dimensional subspaces meet
nontrivially, so the whole Grassmannian is intersecting and has more elements than a
point-pencil. With `2 * k ≤ n` the bound is the Frankl–Wilson theorem. (Equality only
for point-pencils needs `n ≥ 2 * k + 1`: at `n = 2 * k` the k-subspaces of a fixed
hyperplane also attain the bound. Only the bound is stated here.)

**Proof status (Tier-2 — a documented capability gap, NOT a proof)**: the
statement above is formalized and type-checks; the proof is **not**
formalized. The body is a deliberate `sorry` marking an AEAL CAPABILITY
GAP — the Mathlib v4.29.0 substrate needed to discharge it (q-binomial /
Gaussian-binomial subspace counting + the q-analog Erdős–Ko–Rado extremal
argument) is **absent**. The direct point-pencil counting reframing
(U-MISSION-2-J option (iii) / M2.2 §3) dodges the missing q-binomial
*definition* (the bound is stated set-theoretically via `Set.ncard`), but
the extremal + counting substrate remains required. See
`capability/qekr_substrate.gap.md` for the full gap analysis and
dependency-ordered roadmap, and `targets/success_predicate.md` §2.2 for
the Tier-2 success-predicate form. This deposit is a formalized STATEMENT
of q-EKR with an explicitly documented capability gap; it is NOT a proof.
-/
theorem q_ekr {K : Type*} [Field K] [Fintype K]
    {n : ℕ} (k : ℕ) (_hk_pos : 1 ≤ k) (_h2k : 2 * k ≤ n)
    (𝒜 : Set (Submodule K (Fin n → K)))
    (_h_dim : ∀ V ∈ 𝒜, Module.finrank K V = k)
    (_h_int : IsDimIntersectingOf {d | 1 ≤ d} 𝒜)
    (V₀ : Submodule K (Fin n → K)) (_hV₀_dim : Module.finrank K V₀ = 1) :
    Set.ncard 𝒜 ≤ Set.ncard (pointPencil V₀ k) := by
  -- ══════════════════════════════════════════════════════════════════
  --  AEAL CAPABILITY GAP — DOCUMENTED · FUNDAMENTAL (substrate-absent)
  -- ══════════════════════════════════════════════════════════════════
  -- This is a Tier-2 deliverable. The STATEMENT of q-EKR above is the
  -- contribution; the PROOF is NOT formalized. The `sorry` below is kept
  -- DELIBERATELY: the `lake build` warning and `#print axioms q_ekr`
  -- (which lists `sorryAx`) are the HONEST signal that this theorem is
  -- ASSERTED, NOT PROVED. Do not suppress the warning; do not replace the
  -- `sorry` with an `axiom` (that would silently discharge the goal and
  -- make the file read as a proof).
  --
  -- Gap class: FUNDAMENTAL — the Mathlib v4.29.0 substrate required to
  -- discharge this goal is ABSENT (this is a substrate gap, NOT budget /
  -- time exhaustion). Specifically missing, in dependency order:
  --   (a) q-binomial / Gaussian-binomial coefficients over 𝔽_q
  --       (`qBinomial` / `gaussBinomial`: 0 declarations in Mathlib
  --       v4.29.0, confirmed by source grep);
  --   (b) subspace counting over 𝔽_q — the Gaussian-binomial Grassmannian
  --       enumeration #{k-subspaces ⊇ a fixed line} = ⟨n-1, k-1⟩_q —
  --       which both gives `Set.ncard (pointPencil V₀ k)` its value and
  --       proves all point-pencils through a 1-dim centre equinumerous;
  --   (c) the q-analog Erdős–Ko–Rado extremal argument itself (no q-EKR /
  --       subspace extremal-set theory in Mathlib; the classical
  --       `erdos_ko_rado` at Mathlib/Combinatorics/SetFamily/
  --       KruskalKatona.lean is FINSET-only and does NOT transfer to
  --       subspaces of 𝔽_q^n).
  --
  -- Each (a)–(c) is a multi-month substrate formalization, out of this
  -- mission's scope. Full analysis, dependency-ordered roadmap, and the
  -- method-substitution history (Frankl–Wilson → compression →
  -- point-pencil counting) are in: capability/qekr_substrate.gap.md
  sorry

end QEkr
