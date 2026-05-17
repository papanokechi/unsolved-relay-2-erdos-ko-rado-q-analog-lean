# Capability: q-binomial / Gaussian-binomial substrate

**Class**: `available` — substrate is achievable for mission 2's
formalization goal via external-Lean-4 reference libraries; the
primary CAPABILITY (build q-EKR on top of q-binomial substrate) is
satisfied. **Sub-gap recorded inside this document**: a clean
Mathlib4-PR-eligible substrate (Apache 2.0, in-repo) does NOT exist
and would require ~1-2 weeks of M3.1 in-mission re-implementation.
The K_0 §0.2 binary "available / gap" convention applies to the
**capability** (does substrate exist anywhere?), not to the
**Mathlib4-PR sub-deliverable** (is substrate also licensed for
upstream contribution?); thus `.available.md` is the correct file
suffix, with the licensing sub-gap analysed in detail below.

**Fire trigger**: M2.2 pull-forward #1 (from M2.1 ledger entry 6,
commit `741bb58`). H7 functional verification fires here.

## H7 functional verification log (verification class: `field_standard_practice` for absence claims; `proven_corollary` for external library existence)

### Step 1 — Mathlib4-HEAD existence check (negative)

- `GET /repos/leanprover-community/mathlib4/contents/Mathlib/Combinatorics/QBinomial.lean` → **HTTP 404**.
- `search_code` scope `repo:leanprover-community/mathlib4` for `gaussianBinomial`, `qBinomial`, `q-binomial`, `qChoose`, `qPascal` → **0 hits**.
- The only Mathlib4 mention is one passing reference in
  `Mathlib/RingTheory/Polynomial/Pochhammer.lean` (out of scope).

Conclusion: **Mathlib4 HEAD has zero q-binomial / Gaussian-binomial
declarations.** M2.1 finding confirmed at H7 grade.

### Step 2 — External Lean 4 ecosystem enumeration

Three candidate libraries surfaced via GitHub code search
(`extension:lean` constrained):

| Candidate | Lean version | Mathlib pin | License | Substrate depth | Verdict |
|---|---|---|---|---|---|
| `hdamron17/Lean-q-binomial` | Lean 3.28.0 | mathlib3 `58e990d` | (none stated) | Pascal recurrence only (~4 KB) | **NOT VIABLE** — Lean 3, not portable to mission 2 without re-formalization |
| `xiangyazi24/AnalyticCombinatorics` (`AnalyticCombinatorics/PartA/Ch1/QAnalogs.lean`) | Lean 4.29.0 | implied via `import Mathlib.Tactic` | **Apache 2.0** (Mathlib4-compatible) | `qNumber`, `qFactorial`, `gaussianBinomial` (q : ℕ); Pascal recurrence + `native_decide` sanity checks | **VIABLE as reference** for Apache-2.0-compatible re-implementation; substrate is narrow |
| `facebookresearch/algebraic-combinatorics` (`AlgebraicCombinatorics/QBinomialBasic.lean` + `AlgebraicCombinatorics/Partitions/QBinomialFormulas.lean`) | Lean 4.28.0 | Mathlib4 `v4.28.0` | **CC BY-NC 4.0** (NON-COMMERCIAL — incompatible with Mathlib4 Apache 2.0) | Canonical `qInt`, `qFactorial`, `qBinomial`, `qBinomialPoly` (as `Polynomial ℤ`); both q-Pascal recurrences; quotient formula; symmetry; q-Vandermonde; **subspace counting** (directly relevant to q-EKR); ~10 + ~8 target theorems proved | **VIABLE as research dependency** (Lake `require`) in mission 2 repo; **NOT mergeable** into Mathlib4 |

### Step 3 — License-compatibility analysis (Mathlib4 contribution path)

Mathlib4 is licensed under **Apache 2.0**. PR submissions must be
copyright-compatible. The CC BY-NC 4.0 non-commercial restriction in
`facebookresearch/algebraic-combinatorics` means code there **cannot
be copy-ported** into Mathlib4 even with attribution. Permitted reuse
forms:

1. **Treat as black-box dependency** within the mission-2 working repo
   (which is operator-private; no public-distribution license
   imposed). Lake `require` from `facebookresearch/algebraic-combinatorics`
   works for in-mission q-EKR formalization.
2. **Treat as independent-verification reference** when re-implementing
   the q-binomial substrate from first principles for Mathlib4 PR.
   Reading the file informs the proof structure; the actual Lean code
   for the PR must be **clean-room re-implemented** from the public
   mathematical source (Grinberg's *Algebraic Combinatorics* textbook,
   `arXiv:2506.00738`, which is also CC-BY but the **mathematics** in
   the textbook is public-domain in the sense that mathematical
   theorems aren't copyrightable; only the **specific Lean encoding**
   of the proof is).

Apache 2.0 candidate (`xiangyazi24/AnalyticCombinatorics`) can be:
1. Used as **reference implementation** for q-Pascal-recurrence
   approach.
2. Code reuse permitted with attribution per Apache 2.0 §4 (retain
   copyright notice, retain license, mark modifications).

## Implications for M3.1 implementation strategy

Three strategy paths emerge from the substrate audit:

### Path A — In-mission only (uses facebookresearch as Lake dependency)

- Mission 2 working repo `unsolved-relay-2-erdos-ko-rado-q-analog-lean`
  adds `require algcomb from git ...` to its lakefile.
- q-EKR proven on top of facebookresearch's `qBinomial` substrate.
- **Deliverable**: closed-proof Lean 4 file in mission repo,
  journal manuscript at M6.
- **Lost**: Mathlib4 PR is not feasible (CC BY-NC dependency would
  taint the PR). Mission 2's "Mathlib4 PR as concrete artifact"
  promise (per `targets/selected.md`) would be **dropped**.
- **6-week feasibility**: HIGH. Substrate is fully available; only
  q-EKR theorem itself remains.

### Path B — Clean re-implementation for Mathlib4 PR

- Mission 2 working repo formalizes minimal q-binomial substrate from
  scratch (Grinberg textbook + `xiangyazi24/AnalyticCombinatorics` as
  Apache-2.0 reference for the Pascal-recurrence approach).
- Minimal substrate scope (estimated):
  - `qBinomial : ℕ → ℕ → ℕ → ℕ` (or `Polynomial ℤ`) via Pascal recurrence — ~50 lines
  - `qBinomial_succ_succ`, `qBinomial_zero_*`, `qBinomial_n_zero`, `qBinomial_symm` — ~150 lines
  - Subspace-counting interpretation `qBinomial q n k = #{V : Subspace (F_q^n) | finrank V = k}` — **~400-800 lines** (this is the load-bearing lemma for q-EKR; requires Mathlib4's `Module.finrank` + `Submodule` infrastructure)
  - q-EKR theorem itself — ~200-400 lines on top of subspace counting + `Set.Intersecting` substrate
- **Deliverable**: Mathlib4 PR (q-binomial substrate + q-EKR) + journal manuscript at M6.
- **6-week feasibility**: MEDIUM. Substrate from scratch is ~1-2 weeks; subspace-counting bijection (q-binomial ↔ Grassmannian) is the highest-risk component. q-EKR theorem on top is ~1 week if substrate lands.

### Path C — Hybrid (recommended for resilience)

- Mission 2 working repo proves q-EKR using **Path A's external
  dependency** first (fast path; produces closed-proof deliverable
  within ~2 weeks of M3.1 start).
- After closed-proof lands, the **Apache-2.0 re-implementation**
  begins as a Mathlib4 PR track (Path B). This work runs in parallel
  with M5 (PR submission) and M6 (manuscript drafting).
- **Deliverable**: closed-proof in mission repo + journal manuscript +
  attempted Mathlib4 PR. If the PR track stalls past mission close,
  it can continue as Stream M follow-up without blocking M6 submission.
- **6-week feasibility**: HIGH for primary deliverable (Path A's closed-proof in mission repo + manuscript); MEDIUM for Mathlib4 PR (Path B's clean re-implementation). Hybrid is the resilient choice.
- Methodology-paper benefit: Path C produces **two worked
  formalization artifacts** for Stream M Section 4 — one with external
  substrate, one self-contained — which sharpens the AEAL
  generalisation argument.

## Updated capability classification

- **Mathlib4 q-binomial**: **GAP** (verified at H7 grade).
- **External Lean 4 + Mathlib4 q-binomial**: **PARTIAL_AVAILABLE**
  (one CC-BY-NC-4.0 substrate of full depth; one Apache-2.0 substrate
  of minimal depth).
- **Mathlib4-PR-eligible clean substrate**: **GAP** (requires
  in-mission re-implementation; estimated ~1-2 weeks of M3.1 budget).

## Verification class per H9 sub-key

```yaml
independent_verifier_result:
  technique: "ecosystem-level absence audit + external substrate enumeration"
  classification: "field_standard_practice"
  verifier_identity: "Copilot CLI Sonnet/Opus session M2.2 fire 1"
  verifier_method: "GitHub API code search (repo-scoped + extension-scoped) + direct file existence probes (404 on Combinatorics/QBinomial.lean) + license-text inspection on candidate repositories"
  scope: "Mathlib4 HEAD (master branch as of 2026-05-17) + GitHub-indexed Lean 4 ecosystem (search:extension:lean)"
  limitations: "negative absence claims about Mathlib4 HEAD are accurate at audit time; ecosystem search may miss unindexed or recently-pushed repositories. Operator may rerun candidate enumeration at any time and surface additional libraries."
  reproducibility: "search queries and file URLs preserved in mission-2 session-state files/ folder; can be re-run via gh CLI"
  date_of_verification: "2026-05-17"
```

## Recommendation to operator

**Path C (Hybrid)** is the recommended strategy. Reasons:

1. **Primary mission deliverable lands fast** (Path A's closed-proof path with external dep).
2. **Methodology paper Section 4 worked-example pairing is preserved** (Path C produces both the external-dep proof AND the self-contained proof, providing two AEAL-discipline data points instead of one).
3. **Mathlib4 PR ambition is preserved without blocking M6 submission** (Path B work runs in parallel as a stretch deliverable).
4. **Risk-balanced**: if Path B re-implementation stalls (e.g., subspace-counting bijection harder than expected), Path A's closed-proof remains the M6 deliverable.

If operator wants only single-path commitment for M2.3 success-predicate,
**Path A is the lower-risk choice** but loses the Mathlib4 PR promise.
**Path B is higher-risk** but preserves the dual-artifact ambition.

## Mutation budget impact

- Capability classification refinement from "ABSENT" (M2.1) to
  "PARTIAL_AVAILABLE_EXTERNAL_REQUIRES_CLEAN_REIMPLEMENTATION_FOR_MATHLIB4_PR"
  is a **refinement-not-mutation**: it does not change mission 2's
  strategic direction (still D-4 EKR q-analog Lean formalization on
  the Frankl-Wilson method substrate); it sharpens what M3.1's
  implementation will entail.
- Mutation budget 0/1 at M2-2 unchanged.
- M2.3 success-predicate framing may invoke mutation budget if the
  predicate explicitly downgrades the Mathlib4-PR promise from "MUST"
  to "STRETCH" deliverable. That decision is operator-held; this
  capability doc surfaces the trade-off without pre-empting it.
