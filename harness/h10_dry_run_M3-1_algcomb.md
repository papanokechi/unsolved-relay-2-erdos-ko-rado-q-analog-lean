# H10 sub-step dry-run: `algcomb` Lake dep activation (toolchain-skew)

**Milestone:** M3.1 (substrate setup, post-`6e16279` baseline)
**Sub-step:** algcomb Lake dep activation (queued at `harness/h10_dry_run_M3-1.md` §4.4)
**Date (JST):** 2026-05-17, ~21:00–23:30
**Authority:** AEAL Brief §0 H10 + operator U-MISSION-2-substep-1 fire directive
**Outcome:** **(c) — neither toolchain configuration yielded a usable algcomb Lake dep on this Windows environment.** Mission held at v4.29.0 + Mathlib-only-substrate baseline; operator surface required for option (i)/(ii)/(iii) decision per the substep-1 surface contract.

This file is the H10 evidence record for the algcomb activation attempt. It supersedes the "algcomb deferred" note in `harness/h10_dry_run_M3-1.md` §4.4 with concrete empirical findings.

## 1. Test plan

The operator's substep-1 framing enumerated three discrete outcomes:

| Outcome | Description |
|---|---|
| (a) | `algcomb` activates cleanly at v4.29.0 → uncomment, commit, proceed |
| (b) | `algcomb` requires v4.28.0; v4.29.0 incompatible → trigger §5.2 fallback; downpin mission; rebuild; proceed |
| (c) | Neither toolchain compatible → halt-class; algcomb unusable; pivot to Path B-only; operator surface required |

The test plan was a two-toolchain trial:

1. **Trial 1:** Pin `algcomb` at HEAD (`b6022318e986a0c20764569208ba8ebbe1c04dbf`); keep mission at v4.29.0. Resolve any `lake update` manifest conflicts. Verify a single algcomb file compiles against Mathlib v4.29.0. If clean, declare outcome (a).
2. **Trial 2 (only if Trial 1 fails):** Downpin mission to v4.28.0 (Lean toolchain + Mathlib pin). Re-resolve manifest. Verify QEkr.Substrate still builds at the new toolchain (regression). Verify algcomb file compiles at v4.28.0. If both clean, declare outcome (b).
3. **If both trials fail:** declare outcome (c); revert baseline; surface to operator.

## 2. Trial 1: v4.29.0 toolchain + algcomb HEAD

### 2.1 algcomb upstream state

- HEAD on `main`: SHA `b6022318e986a0c20764569208ba8ebbe1c04dbf`
- `lean-toolchain`: `leanprover/lean4:v4.28.0`
- `lakefile.lean` pins: `mathlib @ v4.28.0`, `REPL @ v4.28.0-rc1`, `checkdecls @ main`
- License: CC BY-NC 4.0 (per `LICENSE` blob; per `capability/q_binomial.available.md` Step 3)

### 2.2 First `lake update algcomb` attempt (manifest collision)

- Uncommented the `require algcomb` block in our `lakefile.lean`; left `require mathlib` BEFORE `require algcomb`.
- Ran `lake update algcomb` at the v4.29.0 toolchain.
- **Result:** `error: mathlib: failed to fetch cache`. Lake reported transitive-dep SHA collisions on 7 packages (`plausible`, `importGraph`, `proofwidgets`, `aesop`, `Qq`, `batteries`, `Cli`). algcomb's pins won over Mathlib v4.29.0's pins because of declaration ordering; `lake exe cache get` rejected the manifest because Mathlib's olean caches are keyed to Mathlib's transitive SHAs.
- Lake's own diagnostic recommended putting `require mathlib` LAST so Mathlib's pins dominate.

### 2.3 Second attempt with `require mathlib` placed LAST

- Re-ordered `lakefile.lean`: `require algcomb` first, `require mathlib` last.
- Ran `lake update`.
- **Result:** `lake update` exit 0 in ~10 minutes. Manifest resolved correctly: all transitive deps pinned to Mathlib v4.29.0's SHAs (plausible `83e90935`, importGraph `48d5698b`, proofwidgets `3c52dee1`, aesop `7152850e`, Qq `707efb56`, batteries `756e3321`, Cli `7802da01`). `lake exe cache get` decompressed 8232 Mathlib v4.29.0 olean files.
- Regression check: `lake build QEkr.Substrate` exit 0 in 79s, 1499 jobs. Mission's own substrate still elaborates cleanly.

### 2.4 Critical test: `lake build AlgebraicCombinatorics.QBinomialBasic`

- Selected the q-binomial canonical-definition file (which the q-EKR Tier 1 proof would depend on).
- Build wall-clock: 1293 seconds (~22 minutes); 8248 jobs queued in build plan.
- **Result:** **`error: Lean exited with code 1`** at `AlgebraicCombinatorics/QBinomialBasic.lean:1336:14`:

  ```
  error: AlgebraicCombinatorics/QBinomialBasic.lean:1336:14: unsolved goals
    k l : ℕ
    s : Sym (Fin (l + 1)) k
    sorted : List (Fin (l + 1)) := (↑s).sort fun x1 x2 => x1 ≤ x2
    hlen : sorted.length = k
    i j : Fin k
    hij : i ≠ j
    ⊢ Fin.cast ⋯ i ≠ Fin.cast ⋯ j
  ```

  Plus 4 `push_neg` deprecation warnings (lines 909, 925, 1077, 1085) and 2 simp-arg linter warnings (lines 1343, 1346) — collectively showing real v4.28 → v4.29 API drift on the load-bearing q-binomial file.

### 2.5 Trial 1 verdict

algcomb's v4.28.0-vintage source does **not** compile cleanly against Mathlib v4.29.0. The `Fin.cast` injectivity proof at line 1336 was implicitly closed by a simp lemma in v4.28.0 Mathlib that has been renamed, removed, or signature-changed in v4.29.0. Patching algcomb's source is out of scope (we don't maintain it; v4.28→v4.29 drift likely affects many proofs beyond line 1336). Trial 1 → outcome (a) **rejected**.

## 3. Trial 2: v4.28.0 toolchain downpin

### 3.1 Downpin operation

- Edited `lean-toolchain`: `leanprover/lean4:v4.28.0`. Elan auto-installed v4.28.0 toolchain (~120s).
- Edited `lakefile.lean` `mathlib` pin: `v4.28.0`. Kept `require algcomb` active; kept `require mathlib` last for hygiene.
- Ran `lake update`. Lake re-checked out Mathlib at `8f9d9cff6bd728b17a24e163c9402775d9e6a365` (Mathlib v4.28.0 tag commit). Transitive deps resolved at v4.28.0-compatible SHAs (these coincide with algcomb's own pins, since algcomb was developed against this exact set).
- Mathlib v4.28.0 cache fetched: 8010/8010 olean files downloaded, 8007 decompressed. `lake update` exit 0 in 1404s.

### 3.2 Critical test: `lake build QEkr.Substrate` at v4.28.0

- **Result:** **`error: ProofWidgets not up-to-date`** at `proofwidgets/widgetJsAll`.
- Diagnostic: Mathlib v4.28.0's lakefile sets `NameMap.empty.insert ` `errorOnBuild` `"ProofWidgets not up-to-date. Please run `lake exe cache get` to fetch the latest ProofWidgets. ..."` on its `require proofwidgets @ git "v0.0.87"` clause. This safeguard fires whenever Lake decides the `widgetJsAll` target needs to be rebuilt (instead of being satisfied by the pre-built release archive).
- Repeated remediation attempts:
  1. Re-ran `lake exe cache get`: exit 0; 8010 files already decompressed; **no effect on the widgetJsAll trace**.
  2. Deleted `.lake/packages/proofwidgets/.lake/build` and the `ProofWidgets4.tar.gz.trace` file to force re-extraction: **same error**.
  3. Deleted the `ProofWidgets4.tar.gz` archive entirely and forced re-fetch from the `v0.0.87` GitHub release: archive re-downloaded fresh (13.7 MB; correct version tag); build dir re-populated with 540 artifacts including 19 widget `.js` files; **same error**.
  4. Verified `node v24.14.0` + `npm 11.9.0` are installed and `npm install` in `widget/` succeeds. The safeguard short-circuits before Lake invokes npm, so node availability does not unblock the build.
- Cross-check: a Mathlib module that does NOT transitively pull `Mathlib.Tactic.*` does build at v4.28.0 — `lake build Mathlib.Logic.Basic` exit 0 in 7.3s (61 jobs). But `Mathlib.Combinatorics.SetFamily.Intersecting` (mission's substrate from M2.2 Fire 2) DOES pull `Mathlib.Tactic.*` → triggers widgetJsAll → fails identically.

### 3.3 Trial 2 verdict

At v4.28.0, the mission's load-bearing substrate file (`Mathlib.Combinatorics.SetFamily.Intersecting`) cannot be built on this Windows environment because of the ProofWidgets release-archive trace check, irrespective of algcomb. The downpin is operationally infeasible on this host **independent of** the algcomb compatibility question. Trial 2 → outcome (b) **rejected**.

The proofwidgets v0.0.87 issue appears to be a known Windows-specific ecosystem stall: the release tar.gz extraction produces file mtimes "today", Lake's trace mechanism recomputes the current trace from these mtimes, finds it different from the trace recorded inside the bundled `lake.trace`, decides a rebuild is needed, and the Mathlib safeguard then short-circuits. Multiple Mathlib GitHub issues are consistent with this symptom (not separately filed by us, as it is not the mission's primary concern).

## 4. Outcome (c) declared

**Combined verdict: algcomb is not usable as a Lake dep in this mission's environment** under either v4.29.0 (algcomb-source incompatible with Mathlib v4.29.0 API) or v4.28.0 (host-level ProofWidgets infrastructure stall on Mathlib v4.28.0). Per the operator's substep-1 outcome (c) framing, this is a halt-class capability finding. The mission cannot proceed on Path C (hybrid with algcomb as fast-path Lake dep) and must surface to operator for a decision among:

- **(i)** Extend mission 2 by ≤ 1 week to accommodate Path B-only scope (clean q-binomial re-implementation in `QBinomialClean` as the primary substrate; ~1-2 weeks per `capability/q_binomial.available.md` §Path-B; mission gains the Mathlib4-PR-eligible artifact but loses Path A's fast-path closed-proof headstart).
- **(ii)** Accept Tier 2 fallback as the mission target (statement-shape only with `sorry` body; documents the substrate gap as part of the AEAL framework outcome per `targets/success_predicate.md` §3.2).
- **(iii)** Escalate to a different proof method that does not require a q-binomial substrate (direct point-pencil counting per `capability/q_binomial.available.md` §3 fallback / M2.2 §3 documented option; ~500-800 lines of Lean over `Set.Intersecting` substrate directly, without algcomb or QBinomialClean as intermediate).

## 5. Baseline restoration (post-outcome-(c))

- Reverted `lean-toolchain` to `leanprover/lean4:v4.29.0`.
- Reverted `lakefile.lean`: `mathlib` pin back to `v4.29.0` (first/only require); `algcomb` block removed and replaced by a comment block summarizing the H10 outcome with cross-references to this file and to `capability/algcomb_lakedep.gap.md`.
- Ran `lake update` to re-resolve manifest at v4.29.0; transitive deps back to Mathlib v4.29.0 pins; Mathlib v4.29.0 cache restored (7928 oleans re-decompressed; 304 already cached). Exit 0 in 984s.
- Regression: `lake build QEkr.Substrate` at restored baseline: exit 0 in 49s (1499 jobs). **Mission baseline at v4.29.0 + Mathlib-only-substrate verified working again.**

## 6. Verification class per H9 sub-key

```yaml
independent_verifier_result:
  technique: "two-toolchain empirical Lake dep activation trial"
  classification: "field_standard_practice"
  verifier_identity: "Copilot CLI Sonnet/Opus session M3.1 H10 sub-step 1"
  verifier_method: "edit lakefile.lean + lean-toolchain; lake update; lake exe cache get; lake build of canonical algcomb q-binomial file (Trial 1) and mission's substrate file (Trial 2). Trial 1 ran at Lean v4.29.0 + Mathlib v4.29.0 SHA 8a178386; Trial 2 ran at Lean v4.28.0 + Mathlib v4.28.0 SHA 8f9d9cff; exit codes, build logs, and elapsed times captured per §2 and §3 above."
  scope: "algcomb HEAD b6022318 (latest as of audit time) as a Lake dep candidate for mission 2's Tier 1 closed-proof track."
  limitations: "Empirical at one Windows host (operator's machine); operating environment (Lake v4.29 / Windows mtime semantics / npm/node v24 availability) is part of the negative finding. A different host with Lake's mtime semantics fixed or with npm-built-from-source proofwidgets pre-installed might pass Trial 2; surfacing this as a host-specific gap is more honest than asserting algcomb is universally unusable."
  reproducibility: "lakefile.lean and lean-toolchain content at the two tested states preserved in git history of this mission repo (this file is committed alongside the restoration commit); Mathlib SHAs and algcomb SHA are immutable references."
  date_of_verification: "2026-05-17 (JST ~23:30)"
```

## 7. Cross-references

- `capability/q_binomial.available.md` — original M2.2 Fire 1 audit; the Path A/B/C strategy taxonomy that outcome (c) now mandates Path B-only.
- `capability/algcomb_lakedep.gap.md` — capability classification of the algcomb Lake dep as a GAP per K_0 §0.2 "no retrofit" clause (companion to this evidence file).
- `targets/success_predicate.md` §3 — Tier 1/2/0 cascade-fallback definitions; outcome (c) decision tree options (i)/(ii)/(iii) map to predicate tier choices.
- `targets/success_predicate.md` §5.2 — U-MISSION-2-I §5.2 fallback (downpin to v4.28.0) was attempted in Trial 2 and rejected on host-level grounds; the U-MISSION-2-I §5.2 fallback was not effective in this environment.
- `mutation_log/M3-2.md` entry 2 — algcomb-gap finding logged; budget 0/1 unchanged (outcome (c) is documented as legitimate framework outcome, not a mutation).
- `harness/h10_dry_run_M3-1.md` §4.4 — original "algcomb activation deferred to separate H10 sub-step" note, now superseded by this file.
