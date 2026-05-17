# Capability: `algcomb` Lake dep activation — GAP

**Class:** `gap` — `facebookresearch/algebraic-combinatorics` is NOT usable as a Lake dependency in this mission's environment. Per K_0 §0.2 "no retrofit" clause, this gap is documented and surfaced rather than worked-around.

**Distinct from** `capability/q_binomial.available.md`, which is `available`. That capability (q-binomial substrate exists somewhere in the Lean 4 ecosystem) remains satisfied. The newly-surfaced gap is narrower: **the operationally-cheapest path to q-binomial substrate (algcomb as Lake dep, Path A / Path C fast track) is closed.** The Apache-2.0 substrate via clean re-implementation (Path B) remains available; the direct point-pencil counting method (M2.2 §3 fallback) remains available.

**Fire trigger:** M3.1 H10 sub-step 1, executed 2026-05-17, post-`6e16279`.

**Evidence record:** `harness/h10_dry_run_M3-1_algcomb.md`.

## H7 + H10 functional verification log

### Trial 1: v4.29.0 toolchain + algcomb HEAD `b6022318`

- `lake update` resolved (after re-ordering `require mathlib` LAST so Mathlib's transitive pins dominate; documented per Lake's own diagnostic).
- `lake build AlgebraicCombinatorics.QBinomialBasic`: **failed** in 1293s at `QBinomialBasic.lean:1336:14` with `unsolved goals ⊢ Fin.cast ⋯ i ≠ Fin.cast ⋯ j`. Plus 4 `push_neg` deprecation warnings on lines 909/925/1077/1085 (v4.28 → v4.29 API drift). 
- Verdict: algcomb's v4.28.0-vintage source does not compile against Mathlib v4.29.0. Patching algcomb is out of scope (we do not maintain it; one breaking diff is unlikely to be the only one in a 1500-line file).

### Trial 2: v4.28.0 toolchain downpin + algcomb HEAD `b6022318`

- `lake update` re-resolved to Mathlib v4.28.0 (`8f9d9cff6b`). Cache fetched (8010 oleans).
- `lake build QEkr.Substrate` at v4.28.0: **failed** in 54s on `proofwidgets/widgetJsAll` with Mathlib's `errorOnBuild`-configured `"ProofWidgets not up-to-date"` safeguard. Repeated remediation (re-`lake exe cache get`; delete build/+trace+tar.gz and force fresh fetch from v0.0.87 release) did not clear the trace-mismatch.
- Cross-check: `Mathlib.Logic.Basic` (no `Mathlib.Tactic.*` transitive imports) DID build cleanly at v4.28.0 (7.3s). The failure is specific to modules that pull `Mathlib.Tactic.*`, which includes `Mathlib.Combinatorics.SetFamily.Intersecting` — the mission's load-bearing substrate file.
- Node v24.14.0 + npm 11.9.0 are installed locally, but the `errorOnBuild` safeguard short-circuits before Lake invokes npm.
- Verdict: at v4.28.0 on this Windows host, the host-level ProofWidgets infrastructure stall blocks the mission's substrate independent of algcomb. The U-MISSION-2-I §5.2 fallback (downpin) is not effective in this environment.

### Combined verdict

algcomb is **not usable** as a Lake dep on this environment under either toolchain. Both directions of the operator's pre-framed substep-1 decision tree (outcome (a) v4.29.0-clean and outcome (b) v4.28.0-fallback) are empirically rejected. **Outcome (c) declared.**

## Outcome (c) implications for M3.1 strategy

Per the operator's substep-1 surface contract, the mission halts at this finding and surfaces for decision among three operator-held options:

1. **(i)** Extend mission 2 by ≤ 1 week to accommodate Path B-only scope. Mission's primary substrate becomes the clean Apache-2.0 q-binomial re-implementation in `QBinomialClean`; q-EKR is proved on top of this self-contained substrate. Estimated: 1-2 weeks of Lean (~600-800 lines for `QBinomialClean` substrate; ~600-1000 lines for q-EKR compression-argument). Mission gains: the Mathlib4-PR-eligible artifact becomes the primary deliverable (not a stretch). Mission loses: Path A's fast-path closed-proof headstart (no algcomb-backed early proof).
2. **(ii)** Accept Tier 2 fallback (statement-shape only, body = `sorry`, substrate gap documented). Documents the algcomb-gap as part of the AEAL framework outcome per `targets/success_predicate.md` §3.2.
3. **(iii)** Escalate to a different proof method that does not require q-binomial substrate. Direct point-pencil counting via projective subspaces (per `capability/q_binomial.available.md` §3 / M2.2 §3 documented option); ~500-800 lines of Lean built directly on `Mathlib.LinearAlgebra` + `Mathlib.Combinatorics.SetFamily.Intersecting`. This option drops the q-binomial substrate question entirely.

The mission's `lakefile.lean` is held at v4.29.0 + Mathlib-only-substrate baseline (algcomb commented out / `QBinomialClean` library scaffold retained but empty pending option (i) or (iii) ratification). No code commits are needed for option (ii); options (i) and (iii) reorient M3.1 substrate work.

## Updated capability classification

- **Mathlib4 q-binomial**: **GAP** (unchanged; M2.2 Fire 1 finding).
- **External Lean 4 + Mathlib4 q-binomial (algcomb as Lake dep)**: **GAP** (this file; was `PARTIAL_AVAILABLE` at M2.2 audit; downgraded to GAP at M3.1 H10 sub-step 1).
- **External Lean 4 + Mathlib4 q-binomial (xiangyazi24/AnalyticCombinatorics as reference for Apache-2.0 clean re-implementation)**: **AVAILABLE-AS-REFERENCE** (unchanged from M2.2; this is the substrate path for option (i)).
- **Direct point-pencil counting without q-binomial substrate**: **AVAILABLE** (unchanged; M2.2 §3 documented option; this is the substrate path for option (iii)).
- **Mathlib4-PR-eligible clean substrate**: **GAP** (unchanged; requires in-mission re-implementation, which is exactly what option (i) commits to).

## Verification class per H9 sub-key

```yaml
independent_verifier_result:
  technique: "two-toolchain empirical Lake dep activation trial"
  classification: "field_standard_practice"
  verifier_identity: "Copilot CLI Sonnet/Opus session M3.1 H10 sub-step 1"
  verifier_method: "see `harness/h10_dry_run_M3-1_algcomb.md` §6"
  scope: "algcomb HEAD b6022318 (latest as of 2026-05-17) as a Lake dep candidate for mission 2's Tier 1 closed-proof track on operator's Windows host."
  limitations: "Outcome (c) is environment-conditional: the v4.28.0-toolchain leg of the trial failed on ProofWidgets/Windows infrastructure, which may not reproduce on Linux or with different Lake/Windows mtime semantics. The v4.29.0-toolchain leg's failure (algcomb-source not compiling) is environment-independent and reflects real v4.28 → v4.29 Mathlib API drift on the load-bearing q-binomial file."
  reproducibility: "test states preserved in git history of this mission repo + algcomb HEAD SHA + Mathlib SHAs at both pins."
  date_of_verification: "2026-05-17"
```

## Mutation budget impact

- Documented as legitimate AEAL framework outcome per Brief §0.
- `mutation_log/M3-2.md` entry 2 records the finding; budget 0/1 unchanged.
- The decision among options (i)/(ii)/(iii) MAY require a mutation log entry IF the chosen option modifies the mission's strategic direction beyond what was pre-enumerated at M2.4. Pre-enumeration coverage:
  - Option (ii) is the M2.4 Tier 2 fallback already ratified → not a mutation.
  - Option (iii) is the M2.2 §3 documented fallback proof method → not a mutation if the proof method change is documented as the M2.2-anticipated escalation, but the operator may classify this as a mutation depending on framing.
  - Option (i) reorients Path A/B/C from "hybrid" to "Path B-only" and promotes the Mathlib4 PR from "stretch" to "primary." This is closer to mutation territory; operator decision at the substep-1 surface may invoke the M3-2 mutation budget for this option.
