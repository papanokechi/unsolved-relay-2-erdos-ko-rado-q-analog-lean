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
-- The mission is held at the v4.29.0 + Mathlib-only-substrate state
-- (this commit) pending operator decision per the substep-(1) surface
-- among options (i)/(ii)/(iii). See `harness/h10_dry_run_M3-1_algcomb.md`
-- for the full evidence record and `capability/algcomb_lakedep.gap.md`
-- for the K_0 §0.2 capability classification.
--
-- The `QEkr` and `QBinomialClean` libraries below remain split for
-- forward optionality (Path B clean re-implementation in
-- `QBinomialClean` is the operator's option (i)/(iii) substrate).

@[default_target]
lean_lib QEkr where
  -- Tier 1 closed-proof track; mission-repo-internal.

lean_lib QBinomialClean where
  -- Path C parallel artifact (stretch); Apache-2.0; Mathlib4 PR candidate.
  -- ENFORCED INVARIANT: this library MUST NOT import from `algcomb`.
