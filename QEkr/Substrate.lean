/-
Copyright (c) 2026 papanokechi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: papanokechi

# Substrate sanity check for M3.1 H10 dry-run

This file imports Mathlib4 substrate that the Tier 1 closed-proof track
will rely on and exercises the type-class chain confirmed at M2.2 Fire 2:

* `Set.Intersecting` is scheme-agnostic (`SemilatticeInf + OrderBot`).
* `Submodule R M` for `R` a field and `M` a finite-dimensional vector
  space forms exactly that lattice structure (`⊓ = ∩`, `⊥ = {0}`).

The file is intentionally minimal: it declares a few `example`s that elaborate
to `True` if and only if the substrate types are reachable and the
type-class instances resolve. No new definitions, no proofs of mathematical
interest. The purpose is to make `lake build` succeed with a smoke-test target.

Subsequent M3.1 work will replace this file with `QEkr.IsDimIntersectingOf`
(the actual predicate, ~50-150 lines) and start the compression-argument
proof scaffold (~600-1000 lines anticipated).
-/

import Mathlib.Combinatorics.SetFamily.Intersecting
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

namespace QEkr.Substrate

open Set Submodule

universe u v

variable {R : Type u} [Field R]
variable {M : Type v} [AddCommGroup M] [Module R M]

/-- Smoke-test: `Submodule R M` is a `SemilatticeInf` with `OrderBot`.
This is the substrate-generality claim used in `Set.Intersecting`
(scheme-agnostic) per `capability/intersecting_substrate.available.md` Fire 2.

If this `example` elaborates, the substrate is reachable at the
toolchain + Mathlib pin captured in `lean-toolchain` + `lakefile.lean`.
-/
example : SemilatticeInf (Submodule R M) := by infer_instance

example : OrderBot (Submodule R M) := by infer_instance

/-- Smoke-test: `Set.Intersecting` applies to a family of subspaces.
The predicate "every pair of subspaces in the family has non-trivial
intersection" is reachable; this is the literal q-EKR antichain-style
predicate at dimension 1 (i.e., the case where `L = {d : ℕ | d ≥ 1}`).

The actual q-EKR predicate at dimension `k > 1` requires
`IsDimIntersectingOf` (a new predicate to be defined at M3.1; not in
this smoke-test file).
-/
example (s : Set (Submodule R M)) (_ : Set.Intersecting s) : True := by
  trivial

end QEkr.Substrate
