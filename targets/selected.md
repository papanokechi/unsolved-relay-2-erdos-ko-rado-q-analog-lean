# targets/selected.md — M1.3 Gold Freeze G1-2

**Mission:** unsolved-relay-2
**Milestone:** M1.3 (Open Target Triage close)
**Gold tag:** `gold/M1-2`
**Selection authority:** Operator (U-MISSION-2-F)
**Selection timestamp (JST):** 2026-05-17 ~13:47

---

## Selected target

**D-4 — Erdős–Ko–Rado q-analog Lean 4 formalization.**

Class: D (Lean 4 formalizable; formalization is the primary deliverable).
[NEW-CLASS] tag: **extremal set theory in Lean** — operator has not previously worked in this class.

## Bounded sub-question

Formalize the **q-analog of the Erdős–Ko–Rado theorem** in Lean 4 as a Mathlib4 contribution, building on the classical EKR formalization already in Mathlib4 ([`Finset.erdos_ko_rado`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Combinatorics/SetFamily/EKR.html), entry `Q718875` in `docs/1000.yaml`, authored by Mehta + Dillies, 2020). The bounded scope is a single q-EKR statement with **Frankl–Wilson method** proof; the success predicate is a **closed-proof Lean 4 file that compiles against Mathlib4 HEAD with all auxiliary lemmas either established or explicitly axiom-named per H9 verification class taxonomy** (`rigorous_theorem | proven_corollary | field_standard_practice | empirical_heuristic`).

## One-paragraph justification

D-4 maximizes the transferability test value (Tr = 10, Class D formalization-primary) while delivering a **closed-proof** rather than statement-shape-only contribution — a structural advantage over D-1 (Apéry ζ(3) Lean) once the pre-selection M2.2 pull-forward established that Mathlib4 already has `Finset.erdos_ko_rado` (collapsing D-4's scope to the q-analog only) and has only a stub entry for Apéry's theorem (collapsing D-1 to statement-shape grade in the 6-week window). D-4 lands at favorable Stream M coordination timing: Stream M is at outline-drafted but pre-Section-4-prose-drafting, so the M6-2 q-EKR worked example pairs with K_0 PSLQ at exactly the right moment to anchor the methodology paper's Section 4 worked-example structure (numerical-verification direction + formal-verification direction = AEAL's bidirectional-verification property). D-4 also produces a **concrete Mathlib4 PR deliverable independent of journal acceptance** — a citable artifact even if venue selection drifts.

## Six-axis score profile

| Axis | Score | Notes |
|---|---:|---|
| **T** — tractability within 6-week window | **8** | Classical EKR already in Mathlib4 (Mehta + Dillies 2020 `Finset.erdos_ko_rado`); q-analog scope is tight; q-binomial substrate present in Mathlib4; Frankl–Wilson algebraic method is well-developed in the literature |
| **MR** — machinery reuse from K_0 baseline | **6** | Lean 4 + Mathlib4 toolchain in K_0 baseline (statement-shape work at K_0 M5); q-analog substrate (q-binomials, Frankl–Wilson method) is new and will be exercised under H7 at M2.2 |
| **PP** — publishability of positive partial result | **8** | Closed-proof q-EKR Mathlib4 PR + paper note in Math.Comp. / ITP / CPP is a genuine and well-received contribution |
| **Ind** — independence from R1 / Painlevé III queue | **10** | Combinatorial extremal-set-theory; entirely orthogonal to the operator's active analytic-NT and special-function queues |
| **V** — venue_fit_within_6_weeks | **7** | ITP (Interactive Theorem Proving), CPP (Certified Programs and Proofs), Math.Comp.; six-week window aligns with ITP/CPP cycles for short-paper or tool-paper submissions |
| **Tr** — transferability_test_value | **10** | Maximum: tests AEAL on formal-verification work where K_0's PSLQ + mpmath numerical framework doesn't apply; Class D pure-formalization deliverable |

**AEAL_compliance_risk:** LOW (per pre-selection M2.2 pull-forward: classical EKR is already in Mathlib4 and Lean 4 toolchain is well-vetted; H7 at M2.2 will functionally verify q-binomial and Frankl–Wilson substrate coverage).

## Transferability hypothesis

This mission's success **tests whether the AEAL framework operates on formal-verification work where K_0's PSLQ + mpmath numerical framework does not apply.** The K_0 mission validated AEAL on numerical-verification with two-tier reporting (rigorous theorem-grade bound + empirical community-standard bound). The q-EKR mission validates AEAL on formal-verification with single-tier theorem-grade reporting (Lean 4 closed-proof against Mathlib4 HEAD).

- **Positive evidence direction:** if mission completes with closed-proof q-EKR Mathlib4 PR ratified + paper note submitted within 6 weeks while H1–H11 fire cleanly throughout, AEAL has demonstrated **bidirectional verification generality** — the same eleven-heuristic discipline produced honest output across both numerical and formal modalities.
- **Negative evidence direction:** if mission surfaces a structural mismatch (e.g., M2.2 capability gap on Frankl–Wilson method, M5 formalization-stuck on a specific lemma class, M6 manuscript scope discipline violated), the gap classification provides **negative evidence on AEAL's generality** and informs the methodology paper's scope claims.

Either outcome anchors Stream M's Section 4 worked-example pair (K_0 PSLQ numerical-verification + q-EKR formal-verification). The mission is **bidirectionally publishable** in the AEAL sense: success and documented failure both produce methodology-paper substrate.

## Inheritance and prohibitions (from mission 2 brief §0, §8)

- **H1–H11 operative** from mission start; mutation budget initialized **0 / 1** at M1-2 and remains so through this freeze (selection is not mutation).
- **No K_0 re-derivation;** no "we extend our prior K_0 work to" framing in M6-2 manuscript unless mathematically true (it is not — K_0 and q-EKR are mathematically disjoint).
- **Appendix B AEAL methodology note ≤ 2 pages**; cites K_0 Zenodo (10.5281/zenodo.20246707) + Stream M methodology paper instead of re-introducing the framework.
- **Submission fire is inside M6-2** (not a separate post-mission stream as in K_0).
- **Blacklisted venues:** NNTDM (LLM ban), Experimental Mathematics (7 no-reason rejections). Acta Arithmetica unavailable while submission 260423 holds.

## Repo visibility

PRIVATE during mission per operator directive. Flip to PUBLIC at `gold/M6-2` Zenodo deposit per U-MISSION-B precedent from K_0 mission.

## Companion-stream coordination

Per mission 2 brief §9, this mission operates as a fourth concurrent work stream alongside:
- **K_0 Stream P** (housekeeping; mostly complete; open item: ORCID retroactive update on Items 5/13/28, operator-reserved).
- **K_0 Stream S** (Ramanujan Journal submission cycle; Snapp ID `d824d5ae-683f-4c50-98ec-3622c05fcfa0`; watching state).
- **K_0 Stream M** (methodology paper drafting; M.1 outline drafted in operator session-state; M.2 prose drafting awaits operator ratification).

## Next milestone

**M2.1 literature ledger drafting** (≥ 15 entries) and **M2.2 capability audit** (H7 functional verification of every claimed capability beyond K_0 baseline). Reading-list seed per operator directive:

1. Erdős–Ko–Rado (1961) — original
2. Frankl–Wilson (1986) — q-analog and algebraic method
3. Mehta + Dillies (2020) — Mathlib4 PR formalizing classical EKR (`Finset.erdos_ko_rado`)
4. Wilson (1984) — exact bound result on intersecting families
5. Mathlib4 `Mathlib/Combinatorics/SetFamily/` module documentation
6. Mathlib4 `Mathlib/RingTheory/Polynomial/Quotient` and q-binomial substrate inventory
7. Aaronson–Ng–Wilf (2024) if relevant to q-analog computational aspects
8. Additional entries surfaced by H6 namespace audit + H8 paper-reads at M2.1
