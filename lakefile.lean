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

-- `algcomb` is intentionally NOT enabled by default at M3.1 first-build.
-- Activation procedure (gated by H10 dry-run):
--   1. Verify `lake exe cache get` succeeds on Mathlib4 v4.29.0 (this file).
--   2. Verify `QEkr.Substrate` compiles cleanly.
--   3. Uncomment the `algcomb` require block below.
--   4. Run `lake update algcomb` and observe Mathlib pin compatibility.
--   5. If `algcomb` requires Mathlib v4.28.0 and that conflicts, invoke the
--      U-MISSION-2-I §5.2 fallback (pin mission repo to v4.28.0).
--
-- require algcomb from git
--   "https://github.com/facebookresearch/algebraic-combinatorics.git" @ "main"

@[default_target]
lean_lib QEkr where
  -- Tier 1 closed-proof track; mission-repo-internal.

lean_lib QBinomialClean where
  -- Path C parallel artifact (stretch); Apache-2.0; Mathlib4 PR candidate.
  -- ENFORCED INVARIANT: this library MUST NOT import from `algcomb`.
