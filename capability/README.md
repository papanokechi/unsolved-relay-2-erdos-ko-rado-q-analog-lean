# Capability audit — M2.2 outputs

This directory holds the M2.2 capability-audit artifacts from mission 2
(D-4 EKR q-analog Lean 4 formalization). Per K_0 §0.2 "no retrofit"
clause, each H7 fire produces either `<capability>.available.md` or
`<capability>.gap.md`. M2.2 fired two H7-class audits (per operator
directive 2026-05-17) addressing the two pull-forward concerns from
M2.1 ledger entries 5 and 6.

## Index

| File | H7 fire | Headline finding |
|---|---|---|
| [`q_binomial.available.md`](./q_binomial.available.md) | Fire 1: q-binomial substrate verification | Mathlib4 has zero q-binomial declarations (H7 confirmed). External Lean 4 substrate exists: one CC BY-NC 4.0 (`facebookresearch/algebraic-combinatorics`, full substrate) and one Apache 2.0 (`xiangyazi24/AnalyticCombinatorics`, minimal substrate). Three implementation strategy paths (A/B/C) characterised with feasibility + license-compatibility analysis. Mathlib4-PR-eligible clean substrate remains a sub-gap requiring ~1-2 weeks of in-mission re-implementation. |
| [`intersecting_substrate.available.md`](./intersecting_substrate.available.md) | Fire 2: proof-strategy substrate assessment | `Set.Intersecting` is scheme-agnostic (works on `SemilatticeInf + OrderBot`) and applies directly to subspaces of F_q^n. `Set.IsIntersectingOf` is `Finset`+cardinality-locked and requires a new `IsDimIntersectingOf` predicate (~50-150 lines, in M3.1 scope). **Frankl-Wilson eigenvalue method substrate is a DEEP gap** (association schemes + Hoffman bound out-of-window). Method substitution to compression argument / direct point-pencil counting / external algebraic substrate is tractable in window. Two-tier success-predicate framing proposed for M2.3. |

## Cross-cutting findings

1. **Method substitution required** (Frankl-Wilson eigenvalue method
   not in scope). The `targets/selected.md` language "Frankl-Wilson
   method" is interpreted via the literature priority chain (Hsieh
   1975 statement, Frankl-Wilson 1986 eigenvalue method, plus the
   broader family of subsequent proofs) as referring to the
   **method family** that proves q-EKR with sharp bound, not strictly
   the eigenvalue-spectral proof. CLI recommendation: M2.3
   success-predicate adopts **compression-argument** as primary
   method, with eigenvalue method retained as a stretch / Stream M
   follow-up post-mission.

2. **Licensing-driven strategy split**. The Mathlib4 PR deliverable
   promise from `targets/selected.md` ("concrete Mathlib4 PR
   contribution as citable deliverable") is affected by the most
   substantial external substrate being CC BY-NC 4.0. Three paths
   identified in `q_binomial.available.md`:
   - Path A: in-mission proof using CC-BY-NC dep → drops Mathlib4 PR promise
   - Path B: clean re-implementation → preserves Mathlib4 PR but adds ~1-2 weeks scope to M3
   - Path C: hybrid (A first for fast closed-proof; B in parallel as stretch)

   CLI recommends Path C; operator decides at M2.3.

3. **Mutation budget unchanged at 0/1**. All M2.2 findings are
   refinements within original mission scope:
   - q-binomial substrate question (M2.1 already flagged as substrate-absent; M2.2 sharpens to external-available-but-license-constrained)
   - Proof method family (M2.1 already flagged as proof-method mismatch with Kruskal-Katona; M2.2 sharpens to "Frankl-Wilson method family, with eigenvalue-spectral path substrate-blocked")
   - M2.3 success-predicate Tier framing is M2.3's own output, not a strategy mutation.

## Open questions for operator decision at M2.3

1. Path A vs B vs C (recommended: C)
2. Compression argument vs direct pencil-counting vs external algebraic substrate as primary proof method (recommended: compression, for substrate-minimality and Apache-2.0-friendliness)
3. Tier 1 (closed-proof) as the success predicate, with Tier 0/2 as documented fallbacks? Or commit harder to Tier 1 and treat fallback as mission-failure deliverable?
4. Lean toolchain version pinning for the mission 2 repo (recommended: `leanprover/lean4:v4.29.0` to align with `xiangyazi24/AnalyticCombinatorics` and current Mathlib4; downgrade to `v4.28.0` only if Path A's `facebookresearch/algebraic-combinatorics` Lake dep requires it)

## Mathlib4 version pin proposal

For the mission 2 working repo's `lakefile.lean` (will be created at
M3.1 start), CLI proposes pinning `mathlib4 @ v4.29.0` (latest stable
matching `xiangyazi24/AnalyticCombinatorics`). This may need adjustment
if operator selects Path A or Path C and `facebookresearch/algebraic-combinatorics`
is added as Lake dep (it pins `v4.28.0`). Operator decides at M2.3 /
M3.1 setup.

## H7 verification-class summary

Both fires produced **`field_standard_practice`**-grade or
**`proven_corollary`**-grade evidence per H9 verification class
taxonomy. Specific assignments are inside each fire's document.

## Cross-references

- M2.1 literature ledger entries 5, 6, 12, 13 are load-bearing on
  these capability findings; see `literature/ledger.md` for citations.
- M1.3 target `targets/selected.md` defines the original
  proof-method language; this audit recommends method-family
  reinterpretation rather than strategy mutation.
- M2.3 success predicate (next milestone) will incorporate the
  two-tier Tier 0/1/2 framing detailed in `intersecting_substrate.available.md`.
