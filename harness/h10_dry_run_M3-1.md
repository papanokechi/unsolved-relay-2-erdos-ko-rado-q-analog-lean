# H10 full-regime dry-run record — M3.1 substrate first-build

**Milestone:** M3.1 (substrate setup, post-`gold/M2-2` freeze)
**Date (JST):** 2026-05-17 ~20:30
**Authority:** AEAL Brief §0 H10 (full-regime dry-run before canonical execution)
**Status:** PASS — `lake build QEkr.Substrate` exit 0

This file is the H10 evidence record for the M3.1 substrate first-build.
It is the analogue, for mission 2's formalization-primary deliverable, of K_0
mission's H10 numerical-harness dry-run record at K_0 §M3.1.

## 1. Environment

| Component | Pinned value | Mechanism |
|---|---|---|
| Lean toolchain | `leanprover/lean4:v4.29.0` | `lean-toolchain` file |
| Mathlib4 | `v4.29.0` → SHA `8a178386ffc0f5fef0b77738bb5449d50efeea95` | `lake-manifest.json` rev pin |
| `plausible` | rev `83e90935a17ca19ebe4b7893c7f7066e266f50d3` | inherited via Mathlib4 |
| `LeanSearchClient` | rev `c5d5b8fe6e5158def25cd28eb94e4141ad97c843` | inherited via Mathlib4 |
| `importGraph` | rev `48d5698bc464786347c1b0d859b18f938420f060` | inherited via Mathlib4 |
| `proofwidgets` | rev `3c52dee17f0cd89c1ec14de78920d1bdaa3d26b3` | inherited via Mathlib4 |
| `aesop` | rev `7152850e7b216a0d409701617721b6e469d34bf6` | inherited via Mathlib4 |
| `Qq` (quote4) | rev `707efb56d0696634e9e965523a1bbe9ac6ce141d` | inherited via Mathlib4 |
| `batteries` | rev `756e3321fd3b02a85ffda19fef789916223e578c` | inherited via Mathlib4 |
| `Cli` (lean4-cli) | rev `7802da01beb530bf051ab657443f9cd9bc3e1a29` | inherited via Mathlib4 |
| `algcomb` (CC BY-NC) | NOT YET ENABLED at M3.1 first-build | commented in `lakefile.lean`; activation gated by H10 next sub-step |
| `xiangyazi24/AnalyticCombinatorics` (Apache 2.0) | NOT a Lake dep; reference-only for Path B re-implementation | reference per `capability/q_binomial.available.md` |

## 2. Dry-run commands and results

### 2.1 `lake update`

- Outcome: SUCCESS. `lake-manifest.json` created (3099 bytes) capturing nine package revisions.
- All Mathlib4 transitive deps cloned and checked out at the pinned revisions.
- `mathlib: running post-update hooks` completed; `cache:exe` built (22 jobs).

### 2.2 `lake exe cache get`

- Outcome: SUCCESS. 7875 `.olean` files extracted under
  `.lake/packages/mathlib/.lake/build/lib/` (gitignored).
- Network/decode phase: PowerShell harness showed output buffer stall mid-stream
  (one of the documented intermittent crash modes per
  `tooling/git_multi_line_input_workaround.md`); the underlying `lake` process
  completed correctly on disk despite the visible stream not advancing.
  Process completion verified by olean count.

### 2.3 `lake build QEkr.Substrate`

- Outcome: SUCCESS. **Exit code 0**, 1499/1499 jobs built, wall-clock 417s.
- Last terminal job: `[1499/1499] Built QEkr.Substrate (215s)`.
- Note: 1499 jobs is higher than the pure-cache scenario (would expect
  ~20-50 incremental jobs); cache miss on a portion of Mathlib4's olean
  set caused additional local compilation. **Not a correctness concern** —
  cache miss is operationally benign (the same content compiles to the
  same olean from source) and the build completed cleanly.

### 2.4 Smoke-test claims verified by build success

The build succeeded with `QEkr.Substrate` elaborated cleanly, which functionally
verifies:

1. **`Submodule R M` has `SemilatticeInf` instance**
   (Mathlib4 v4.29.0 — `Mathlib.Algebra.Module.Submodule.Lattice`).

2. **`Submodule R M` has `OrderBot` instance** (same source).

3. **`Set.Intersecting` is reachable** in the type
   `SemilatticeInf α → OrderBot α → Set α → Prop`
   and applies to a `Set (Submodule R M)` family without issue.

These three claims are the substrate-generality claims from
`capability/intersecting_substrate.available.md` Fire 2. They are now
**verified at functional H7 + H10 grade**, not just at H7-source-read grade.

## 3. Outcome classification per H9

```yaml
independent_verifier_result:
  technique: "lake build with toolchain pin + Mathlib4 cache + olean kernel typecheck"
  classification: "proven_corollary"
  verifier_identity: "Lean 4.29.0 + Mathlib4 SHA 8a178386ffc0; mission-repo HEAD at this commit"
  verifier_method: "lake update + lake exe cache get + lake build QEkr.Substrate; exit code 0; 1499/1499 jobs successful"
  scope: "QEkr/Substrate.lean import-and-elaboration chain at the pinned Mathlib4 revision"
  limitations: "Smoke-test only; the three example declarations verify substrate reachability but do not prove the q-EKR theorem. Compression-argument proof body is the M3.1 / M3.2 deliverable."
  reproducibility: "lake-manifest.json + lean-toolchain + QEkr/Substrate.lean preserve the exact build chain; can be reproduced from any commit at or after this one."
  date_of_verification: "2026-05-17 (JST ~20:30)"
```

## 4. Next M3.1 steps (gated by this H10 PASS)

H10 PASS at this dry-run grants forward authorization for:

1. **Replace `QEkr/Substrate.lean` smoke tests with `QEkr/IsDimIntersectingOf.lean`** — the actual L-dim-intersecting predicate definition + basic API (~50-150 lines).
2. **Begin compression-argument proof scaffold under `QEkr/Compression/`** — staged top-down with `sorry` placeholders for individual lemmas until each lemma is proved (~600-1000 lines anticipated, multi-session).
3. **Path B parallel artifact**: develop `QBinomialClean/Basic.lean` with the real q-binomial Pascal-recurrence definition + small identity proofs. Stretch deliverable per U-MISSION-2-I decision 3.
4. **`algcomb` Lake dep activation** is held as a SEPARATE H10 sub-step (next session): uncomment the `require algcomb` block in `lakefile.lean`, run `lake update algcomb`, observe whether v4.28.0 dep skew triggers the U-MISSION-2-I §5.2 fallback (pin mission to v4.28.0).

## 5. Cross-references

- `targets/success_predicate.md` §5.1 (`lakefile.lean` pin proposal) — concretised in this build's actual `lakefile.lean`.
- `targets/success_predicate.md` §5.2 (toolchain firm at v4.29.0) — confirmed pinned via `lean-toolchain`.
- `capability/intersecting_substrate.available.md` Fire 2 — three substrate-generality claims now functionally verified.
- `capability/q_binomial.available.md` Path C — Lake project structure prepared with two-library separation (`QEkr` and `QBinomialClean`) preserving the license-compatibility invariant.
