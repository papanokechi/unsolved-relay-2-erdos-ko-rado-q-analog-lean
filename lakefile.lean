/-
Copyright (c) 2026 papanokechi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: papanokechi

Mission: unsolved-relay-2 (D-4 Erdos-Ko-Rado q-analog Lean 4 formalization).
Milestone: M3.1 (substrate work, post-gold/M2-2).
Selection authority: Operator U-MISSION-2-H (framing) + U-MISSION-2-I (ratification).

# Lake project structure

Two lean_libs:

* `QEkr`           -- Tier 1 closed-proof track. May depend on the
                      `algcomb` external Lake dep (CC BY-NC 4.0, see disclosure
                      below). This library is **mission-repo-internal** and is
                      NOT a candidate for Mathlib4 PR.

* `QBinomialClean` -- Path C parallel artifact. Apache-2.0 only; clean
                      re-implementation of minimal q-binomial substrate suitable
                      for Mathlib4 PR. MUST NOT import from the `algcomb`
                      namespace; MUST NOT depend on CC-BY-NC code.

# External dependency license disclosure (H9 class: field_standard_practice)

`algcomb` resolves to `facebookresearch/algebraic-combinatorics`, which is
licensed under **CC BY-NC 4.0** (NON-COMMERCIAL). Per
`capability/q_binomial.available.md` and `targets/success_predicate.md`:

* Use within `QEkr` library is research-only and license-disclosed.
* `QBinomialClean` MUST NOT import from `algcomb`.
* No Mathlib4 PR will include any `algcomb`-derived code.
-/

import Lake
open Lake DSL

package qEkr where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩
  ]

-- Toolchain pin is in `lean-toolchain` (leanprover/lean4:v4.29.0), per
-- U-MISSION-2-I decision 2 (RATIFIED at M2.4 Gold Freeze G2-2).
require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.0"

-- `algcomb` (facebookresearch/algebraic-combinatorics, CC BY-NC 4.0) is
-- NOT enabled as a Lake dep. The H10 sub-step on toolchain-skew (run at
-- M3.1 between commits `6e16279` and this one) determined that algcomb
-- is unusable as a Lake dep in this environment under either v4.29.0 or
-- v4.28.0 toolchain pin:
--
--   * At v4.29.0 (mission's primary pin): algcomb's source pins
--     `mathlib v4.28.0` and was last released against the v4.28.0 API.
--     With `require mathlib` re-ordered LAST so Mathlib's transitive
--     pins win and `lake exe cache get` resolves, the build of
--     `AlgebraicCombinatorics.QBinomialBasic` against Mathlib v4.29.0
--     produces an `unsolved goals` error at line 1336 on a `Fin.cast`
--     inequality (plus 4 `push_neg` deprecation warnings and 2 linter
--     warnings -- collectively showing real v4.28 -> v4.29 API drift on
--     the load-bearing q-binomial file).
--
--   * At v4.28.0 (downpin per U-MISSION-2-I §5.2 fallback): mathlib
--     v4.28.0 itself compiles fine for trivial modules, but any module
--     that transitively imports `Mathlib.Tactic.*` (including
--     `Mathlib.Combinatorics.SetFamily.Intersecting`, the M2.2 Fire 2
--     substrate file) triggers `proofwidgets/widgetJsAll` rebuild, which
--     Mathlib v4.28.0 short-circuits via its `errorOnBuild` safeguard.
--     The proofwidgets v0.0.87 release archive is fetched cleanly but
--     Lake's trace check determines the cached widget state is "not
--     up-to-date" on this Windows environment, irrespective of whether
--     the on-disk tar.gz / build/js artifacts are present.
--
-- Conclusion: outcome (c) per operator's H10 sub-step decision tree.
-- The mission was held at the v4.29.0 + Mathlib-only-substrate state
-- (commit `20ce78c`) for operator surface among options (i)/(ii)/(iii).
-- See `harness/h10_dry_run_M3-1_algcomb.md` for the full evidence record
-- and `capability/algcomb_lakedep.gap.md` for the K_0 §0.2 capability
-- classification.
--
-- # Method substitution decision (operator U-MISSION-2-J, 2026-05-18)
--
-- Operator selected **option (iii)** -- direct point-pencil counting
-- proof method, substituted for compression-argument per M2.2 §3
-- pre-enumerated alternative-methods envelope. This is method-family
-- substitution within M2.2's H7 functional-verification output, NOT
-- a strategic-direction mutation per Brief §7. Mutation budget remains
-- **0 / 1** at M3-2.
--
-- Method substitution rationale:
--   * Preserves 6-week window (mission close ~2026-06-28 unchanged).
--   * Preserves Tier 1 closed-proof primary deliverable.
--   * Eliminates q-binomial substrate dependency entirely; proof operates
--     directly on `Set.Intersecting` over subspace families (H7-verified
--     at M2.2 Fire 2 via `capability/intersecting_substrate.available.md`).
--   * Strongest methodology-paper transferability evidence per Stream M:
--     AEAL produces adaptive method substitution within pre-enumerated
--     envelope rather than mission shrinkage (option ii) or scope
--     expansion (option i).
--
-- Trade-off accepted: compression-argument's mathematical elegance is
-- replaced by direct counting. To be framed in M6-2 manuscript §Discussion
-- as substrate-blocked method substitution, recorded transparently.
--
-- # QBinomialClean parallel-track decision (CLI default (4a), 2026-05-18)
--
-- With q-binomial substrate NOT load-bearing on the Tier 1 deliverable
-- under option (iii), the `QBinomialClean` Mathlib4 PR parallel track
-- is **dropped** per CLI-default (4a). The `QBinomialClean` lean_lib
-- below is retained as scaffolded structure for forward optionality
-- (e.g., post-mission Mathlib4 PR if operator revisits) but receives
-- NO IMPLEMENTATION WORK during this mission. The Apache-2.0 invariant
-- (NO `algcomb` imports) remains structurally enforced at the lean_lib
-- boundary, even though no implementation is added.
--
-- M3.1 substep ordering under option (iii):
--   (2) `IsDimIntersectingOf` predicate (~50-150 lines) under
--       `QEkr/IsDimIntersectingOf.lean`, substrate = `Set.Intersecting`.
--   (3) Direct point-pencil counting proof under
--       `QEkr/PointPencilCounting/` (~500-800 lines, staged top-down
--       with `sorry` placeholders, multi-session).
--   (4) DROPPED per (4a).

@[default_target]
lean_lib QEkr where
  -- Tier 1 closed-proof track; mission-repo-internal.

lean_lib QBinomialClean where
  -- Path B/C parallel artifact: DROPPED per CLI-default (4a) at
  -- U-MISSION-2-J (2026-05-18); see comment block above.
  -- Lean_lib retained as scaffolded structure for forward optionality
  -- (post-mission Mathlib4 PR revisit). No implementation work during
  -- this mission.
  --
  -- ENFORCED INVARIANT: this library MUST NOT import from `algcomb`.
  -- (Structural enforcement retained even though no implementation is
  -- added, to preserve the license-as-structural-invariant pattern for
  -- the methodology paper's framework discussion.)
