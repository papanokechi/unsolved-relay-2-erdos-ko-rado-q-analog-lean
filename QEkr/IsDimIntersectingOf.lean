/-
Copyright (c) 2026 papanokechi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: papanokechi

# `IsDimIntersectingOf`: q-analog of `Set.IsIntersectingOf` for submodules

This file defines the q-analog of Mathlib's `Set.IsIntersectingOf` predicate
for families of submodules of a module over a (division) ring. Whereas
`Set.IsIntersectingOf` measures the intersection of finsets by their
cardinality (`Finset.card`), `IsDimIntersectingOf` measures the intersection
of submodules by their `Module.finrank` (linear-algebra dimension).

This is the M3.1 substrate for the q-EKR formalization under U-MISSION-2-J's
option (iii) — direct point-pencil counting proof method. See
`capability/intersecting_substrate.available.md` Step 2 for the motivating
H7 audit (the literal port of `Set.IsIntersectingOf` to subspaces is wrong
because it uses set-cardinality of the underlying carrier, not subspace
dimension) and `mutation_log/M3-2.md` entry 3 for the U-MISSION-2-J
resolution that selected option (iii) and dropped Path B (CC BY-NC algcomb
Lake dep / Apache-2.0 `QBinomialClean` parallel track) per substep
ordering.

The predicate is stated for any `R`-module `M` with `R` a (division) ring;
specialisation to `R = F_q` and `M = Fin n → F_q` is delegated to the
q-EKR statement file (`QEkr/PointPencilCounting/` or analogous, substep
(3)).

## Main definition

* `QEkr.IsDimIntersectingOf L 𝒜` -- for `L : Set ℕ` and `𝒜 : Set (Submodule R M)`,
  asserts that every pair of distinct members of `𝒜` has intersection of
  `Module.finrank` in `L`. This mirrors `Set.IsIntersectingOf` from
  `Mathlib.Combinatorics.SetFamily.Intersecting`.

## Main API (mirrors `Set.IsIntersectingOf`)

* `IsDimIntersectingOf.mono` -- if `L ⊆ L'` then `L`-dim-intersecting
  implies `L'`-dim-intersecting (`@[gcongr]`).
* `IsDimIntersectingOf.anti` -- if `ℬ ⊆ 𝒜` then `L`-dim-intersecting on
  `𝒜` restricts to `ℬ` (`@[gcongr]`).
* `IsDimIntersectingOf.empty` -- the empty family is `L`-dim-intersecting
  vacuously.
* `IsDimIntersectingOf.singleton` -- any singleton family is
  `L`-dim-intersecting vacuously.
* `IsDimIntersectingOf.univ` -- every family is `univ`-dim-intersecting.

## Forward reference

The bridge from `Set.Intersecting` (Mathlib's `¬Disjoint` predicate) to
`IsDimIntersectingOf {n | 0 < n}` requires `[Module.Free R M]` and
`[Module.Finite R M]` hypotheses (via `finrank_pos_iff_of_free`); this
bridge will be added in substep (3) where the F_q^n specialisation
introduces those instances naturally.

## References

* Mathlib4 `Mathlib.Combinatorics.SetFamily.Intersecting` (the
  `Set.IsIntersectingOf` original whose signature this file ports).
* Frankl-Wilson 1986 (literature ledger entry 2): the q-analog
  intersecting-families framework whose statement-level objects this
  predicate captures.
* `capability/intersecting_substrate.available.md` (M2.2 Fire 2): the
  H7 audit motivating this file.
-/

import Mathlib.Combinatorics.SetFamily.Intersecting
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

namespace QEkr

open Set Submodule

universe u v

variable {R : Type u} [DivisionRing R]
variable {M : Type v} [AddCommGroup M] [Module R M]
variable {L L' : Set ℕ}
variable {𝒜 ℬ : Set (Submodule R M)}

/--
A family `𝒜` of `R`-submodules of `M` is `L`-dim-intersecting if the
`Module.finrank` of the intersection of every pair of distinct members of
`𝒜` belongs to `L ⊆ ℕ`.

That is, for all `V, W ∈ 𝒜` with `V ≠ W`, we have
`Module.finrank R (V ⊓ W) ∈ L`.

This is the q-analog of `Set.IsIntersectingOf` (which measures cardinality
of finset intersections), with `Module.finrank` as the size measure
replacing `Finset.card`. See the file docstring for the motivating H7 audit.
-/
def IsDimIntersectingOf (L : Set ℕ) (𝒜 : Set (Submodule R M)) : Prop :=
  𝒜.Pairwise fun V W ↦ Module.finrank R ((V ⊓ W : Submodule R M)) ∈ L

namespace IsDimIntersectingOf

/--
An `L`-dim-intersecting family is also `L'`-dim-intersecting whenever
`L ⊆ L'`.
-/
@[gcongr]
theorem mono (h : L ⊆ L') (hL : IsDimIntersectingOf L 𝒜) :
    IsDimIntersectingOf L' 𝒜 :=
  fun _V hV _W hW hVW ↦ h (hL hV hW hVW)

/--
An `L`-dim-intersecting family remains `L`-dim-intersecting under
restriction to any subfamily.
-/
@[gcongr]
theorem anti (h : ℬ ⊆ 𝒜) (h𝒜 : IsDimIntersectingOf L 𝒜) :
    IsDimIntersectingOf L ℬ :=
  Set.Pairwise.mono h h𝒜

/--
The empty family of submodules is `L`-dim-intersecting, vacuously,
because it contains no pairs of distinct members.
-/
@[simp]
protected theorem empty : IsDimIntersectingOf L (∅ : Set (Submodule R M)) :=
  Set.pairwise_empty _

/--
Every singleton family of submodules is `L`-dim-intersecting, vacuously,
because it contains no pair of distinct members.
-/
@[simp]
protected theorem singleton (V : Submodule R M) :
    IsDimIntersectingOf L ({V} : Set (Submodule R M)) :=
  Set.pairwise_singleton _ _

/--
Every family of submodules is `univ`-dim-intersecting.
-/
@[simp]
protected theorem univ : IsDimIntersectingOf Set.univ 𝒜 :=
  𝒜.pairwise_of_forall _ fun _ _ ↦ trivial

end IsDimIntersectingOf

end QEkr
