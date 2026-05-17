# unsolved-relay-2-erdos-ko-rado-q-analog-lean

**Mission 2 of the AEAL-disciplined "unsolved-relay" series.**

This repository tracks an AEAL-disciplined 6-week investigation into the **q-analog of the Erdős–Ko–Rado theorem**, with the deliverable being a closed-proof Lean 4 / Mathlib4 contribution.

| Field | Value |
|---|---|
| **Target** | D-4 Erdős–Ko–Rado q-analog Lean 4 formalization |
| **Selected at** | M1.3 Gold Freeze G1-2 = `gold/M1-2` tag |
| **Companion mission (K_0)** | [papanokechi/khinchin-k0-bounded](https://github.com/papanokechi/khinchin-k0-bounded) @ `gold/M6` = `67655c0`, Zenodo [10.5281/zenodo.20246707](https://doi.org/10.5281/zenodo.20246707) |
| **Framework** | AEAL eleven-heuristic catalogue H1–H11, inherited from K_0 mission |
| **Duration** | 6 weeks, milestones M1-2 … M6-2 (one gold tag per milestone) |
| **Visibility** | **PRIVATE** during mission; flip to **PUBLIC** at `gold/M6-2` Zenodo deposit per U-MISSION-B precedent from K_0 |
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

## Status

Currently at **M1.3 Gold Freeze G1-2** with `targets/selected.md` ratified. Mutation budget for M1-2: **0/1**, unchanged through selection.

Next milestone: **M2.1 literature ledger drafting** (≥ 15 entries; H6 namespace audit + H8 paper-reads on load-bearing entries).
