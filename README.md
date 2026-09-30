# unsolved-relay-2-erdos-ko-rado-q-analog-lean

> **v1.1 correction (2026-09-30).** v1.0 stated `q_ekr` under `1 ≤ k ≤ n`. That statement
> is false: for `2k > n` every two k-subspaces meet, so all of them form an intersecting
> family larger than a point-pencil. v1.1 assumes `2 * k ≤ n` (the Frankl–Wilson range).
> The proof is still a `sorry`, now on a true statement. See `CHANGES_v1.1.md`.

**Mission 2 of the AEAL-disciplined "unsolved-relay" series.**

This repository tracks an AEAL-disciplined 6-week investigation into the **q-analog of the Erdős–Ko–Rado theorem**, with the deliverable being a closed-proof Lean 4 / Mathlib4 contribution.

| Field | Value |
|---|---|
| **Target** | D-4 Erdős–Ko–Rado q-analog Lean 4 formalization |
| **Selected at** | M1.3 Gold Freeze G1-2 = `gold/M1-2` tag |
| **Companion mission (K_0)** | [papanokechi/khinchin-k0-bounded](https://github.com/papanokechi/khinchin-k0-bounded) @ `gold/M6` = `67655c0`, Zenodo [10.5281/zenodo.20246707](https://doi.org/10.5281/zenodo.20246707) |
| **Framework** | AEAL eleven-heuristic catalogue H1–H11, inherited from K_0 mission |
| **Duration** | 6 weeks, milestones M1-2 … M6-2 (one gold tag per milestone) |
| **Visibility** | **PUBLIC** (flipped at the Tier-2 deposit, 2026-06-07) |
| **Zenodo deposit** | v1.0 [10.5281/zenodo.20575745](https://doi.org/10.5281/zenodo.20575745) (concept [10.5281/zenodo.20575744](https://doi.org/10.5281/zenodo.20575744), which resolves to the latest version) — formalized **statement** + documented gap, **not a proof** |
| **Reference list source** | https://en.wikipedia.org/wiki/List_of_unsolved_problems_in_mathematics |

## Mission discipline

H1–H11 are operative as **practice, not compliance**. Specific bindings inherited from K_0:

- **H1** mutation budget: 1 per milestone, no rollback before last Gold Freeze
- **H6** namespace audit fires at any selection step + independence-scoring step
- **H7** functional verification of every capability claim (minimal working example, not name-resolution-only)
- **H8** paper-read on any literature claim load-bearing on M2.3 / M3.1 / M6
- **H9** verification class taxonomy: `rigorous_theorem | proven_corollary | field_standard_practice | empirical_heuristic`
- **H10** full-regime dry-run before any canonical execution
- **H11** exhaustive propagation on any class-of-error finding

See [`methodology/heuristics.md`](methodology/heuristics.md) for the inheritance pointer to the authoritative K_0 catalog.

## Repository layout

| Path | Purpose |
|---|---|
| `targets/` | M1 target selection (this milestone) |
| `literature/` | M2.1 literature ledger (≥ 15 entries) |
| `capability/` | M2.2 H7 functional-verification artifacts (one file per capability) |
| `env/` | M2 environment locks (Lean toolchain, Mathlib4 commit SHA) |
| `harness/` | M3 numerical / symbolic / formal sprint substrate |
| `m5/` | **M5 LOAD-BEARING for this mission** — Lean 4 formalization skeleton (statement + Frankl–Wilson method proof of q-EKR) |
| `paper/` | M6 manuscript (with ≤ 2-page Appendix B AEAL methodology note) |
| `submission_log/` | M6.3 submission cycle artifacts |
| `handoff/` | M6.3 handoff packet (post-deposit) |
| `methodology/` | Inheritance pointer to K_0 AEAL framework |
| `mutation_log/` | H1 mutation budget ledger |
| `seeds/` | Reproducibility seeds (random seeds, search starts, etc.) |

## Status — M5 Tier-2 close (formalized statement + documented capability gap; **NOT a proof**)

**Outcome: Tier-2** per [`targets/success_predicate.md`](targets/success_predicate.md) §2.2.
This repository delivers a **formalized Lean 4 statement** of the q-EKR (t = 1) theorem
together with a **rigorous, documented capability gap** — it is **not** a formalized proof.

- **Formalized statement** (`QEkr/`, builds clean against Mathlib v4.29.0):
  - `QEkr.IsDimIntersectingOf` — q-analog intersecting-families predicate (no `sorry`).
  - `QEkr.q_ekr` — the q-EKR (t = 1) bound, fully stated and type-checked.
- **Documented gap** ([`capability/qekr_substrate.gap.md`](capability/qekr_substrate.gap.md)):
  the `q_ekr` proof body is a deliberate `sorry` marking an **AEAL CAPABILITY GAP** — the
  Mathlib v4.29.0 substrate needed to prove it (q-binomial / Gaussian-binomial subspace
  counting + the q-analog EKR extremal argument) is **absent**. The gap doc names the exact
  missing substrate and gives a dependency-ordered roadmap.
- **Build:** `lake build` succeeds **modulo exactly one intended `sorry` warning** on
  `q_ekr`; `lake env lean check_axioms.lean` shows that `#print axioms QEkr.q_ekr` lists
  `sorryAx`. (v1.1. In v1.0 the default target did not import `q_ekr`, so `lake build`
  emitted no warning at all, and no axiom-check file was included.) These signals are the honest
  statement-not-proof indicator and are **intentionally retained** (not suppressed, not
  swapped for an `axiom`).
- **Method-substitution record:** Frankl–Wilson eigenvalue → compression → direct
  point-pencil counting, each substituted on a substrate failure (see the gap doc §5).
- Mutation budget M3-2: **0/1**, unchanged (Tier-2 is the M2.4-ratified cascade-fallback).

> This is an honest partial result — a **statement + documented gap**, suitable as a short
> note / Mathlib-statement contribution — **not** the closed-proof Mathlib4 PR originally
> targeted. Deposit-ready artifacts are under [`submission_log/`](submission_log/).

**Deposited** (2026-06-07): Zenodo [10.5281/zenodo.20575745](https://doi.org/10.5281/zenodo.20575745)
(concept DOI [10.5281/zenodo.20575744](https://doi.org/10.5281/zenodo.20575744)), resource
type **Preprint**, license **CC-BY-4.0**. See [`submission_log/DEPOSITED.md`](submission_log/DEPOSITED.md).

**v1.1** (2026-09-30): corrected statement (`2 * k ≤ n`); see [`CHANGES_v1.1.md`](CHANGES_v1.1.md).
