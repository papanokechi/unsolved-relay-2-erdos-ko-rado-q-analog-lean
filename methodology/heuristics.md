# methodology/heuristics.md — Inheritance Pointer

**Status.** This file is an **inheritance pointer**, not a duplicate of the AEAL framework. The authoritative 11-heuristic operational catalogue is maintained in the companion K_0 mission repository.

## Authority hierarchy (inherited from K_0)

Mission Brief §0–§9 (mission 2 brief, in operator session-state) > AEAL seven-field claim schema > Eleven-heuristic operational catalogue H1–H11.

## Authoritative source

**Canonical text:** [`papanokechi/khinchin-k0-bounded:methodology/heuristics.md`](https://github.com/papanokechi/khinchin-k0-bounded/blob/gold/M6/methodology/heuristics.md) at tag `gold/M6` (commit `67655c0`).

**Zenodo deposit:** concept-DOI [10.5281/zenodo.20246707](https://doi.org/10.5281/zenodo.20246707); version-DOI [10.5281/zenodo.20246708](https://doi.org/10.5281/zenodo.20246708).

## Inheritance scope for this mission

All eleven heuristics **H1–H11 are operative from mission start**. Specific bindings (per mission 2 brief §0):

| ID | Heuristic | Fires at |
|---|---|---|
| H1 | Mutation budget (1 per milestone) | any scope-change attempt |
| H2 | Anti-thrashing / no rollback before Gold Freeze | any retreat-from-progress attempt |
| H3 | Two-tier reporting (rigorous + empirical) where applicable | M2.3 predicate, M6 manuscript |
| H4 | Hard caps on wall-clock & iterations | M3.2 canonical execution |
| H5 | Capability-gap halt; no retrofit | M2.2 H7 verification, any later capability claim |
| H6 | Namespace audit | M1.2 selection step + any independence-scoring step + M2.1 start |
| H7 | Functional verification of capability claims | pre-M2 deep build + any later capability claim |
| H8 | Paper-read on load-bearing literature | any M2.3 / M3.1 / M6 load-bearing citation |
| H9 | Verification class taxonomy | all bound claims (preserving seven-field schema in `independent_verifier_result`) |
| H10 | Full-regime dry-run before canonical execution | any canonical sweep / artifact |
| H11 | Exhaustive propagation on class-of-error findings | any fix bundle with class-pattern statement |

## Heuristic extensions (H12+)

If a new heuristic surfaces during this mission, it gets installed per H11's proactive-or-halt-triggered pattern with **explicit mutation_log entry naming the installation reason**. Extensions are added to `methodology/heuristics_mission2_extensions.md` (created at first such installation), not back-propagated to K_0.

## Companion-stream coordination

Per mission 2 brief §9, this mission operates as a fourth concurrent work stream alongside K_0 Stream P (housekeeping), Stream S (Ramanujan Journal submission cycle), and Stream M (methodology paper drafting). Priority and capacity rules per brief §9 apply.
