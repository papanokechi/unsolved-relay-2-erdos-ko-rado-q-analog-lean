# M2.1 Literature ledger — Mission 2 (D-4 EKR q-analog Lean 4 formalization)

**Status**: in progress (half-way surface at 8 entries; target ≥15).
**Inheritance**: schema and discipline per K_0 mission Brief §M2.1.
**Frozen reference**: this ledger is mutable through M2.4 Gold Freeze G2-2.

## Schema

Each entry has:

- **author** — primary author(s)
- **year**
- **title**
- **venue** — journal / conference / repo / Zenodo / Mathlib4 module / etc.
- **claim_loaded_by_this_paper** — what mission 2 cites this for, and at which milestone (M2.3 predicate / M3.1 implementation / M5 formalization / M6 manuscript) the citation is load-bearing
- **verification_status** — one of: `paper-read` / `abstract-only` / `unread` / `partial` (with note on what is verified)
- **H8_fire_required** — `yes` / `no` / `pending-decision`, per Brief §M2.1 inheritance (H8 fires for any entry load-bearing on M2.3 / M3.1 / M6)
- **excerpts** — relevant passages once paper-read, otherwise blank

## H6 namespace audit (fired 2026-05-17 14:50 JST at M2.1 start)

Enumeration of `papanokechi/*` GitHub repos for prior-art overlap with q-EKR
scope:

| Repo | Mathematical scope | Overlap with q-EKR | Action |
|---|---|---|---|
| `unsolved-relay-2-erdos-ko-rado-q-analog-lean` | mission 2 itself (D-4) | n/a (self) | — |
| `khinchin-k0-bounded` | Khinchin K_0 algebraicity null (analytic NT) | none mathematically | methodological citation only (no "we extend K_0" framing per Brief §8) |
| `khinchin-signature-pslq` | PSLQ null on Khinchin signature statistic | none mathematically | methodological-only |
| `wallis-pcf-lean4` | Wallis PCF Lean 4 formalization (analytic NT) | **none mathematically; methodological prior art for operator's Lean 4 idioms** | reference for M5 Lean style only |
| `tunnell-cnp-lean4` | Tunnell congruent-number Lean 4 work | **none mathematically; methodological prior art for Lean 4 idioms** | reference for M5 Lean style only |
| `siarc-lean4` | SIARC Lean 4 namespace | none mathematically known | reference if needed; otherwise inert |
| `mathlib4` (papanokechi fork) | Mathlib4 fork | not the canonical Mathlib4 source for M3.1; canonical Mathlib4 is `leanprover-community/mathlib4` | use upstream as substrate |
| `pcf-research`, `pcf-spectral-classes`, `pcf-casoratian-identities`, `pcf-rational-contamination` | PCF analytic-NT family | none mathematically | methodologically AEAL-related; no citation needed in mission 2 manuscript |
| `siarc-relay-bridge`, `submitted-manuscripts`, `ai-behavior-science` | infra / non-math / behavioral | none | inert |

**H6 conclusion**: No prior-art overlap on q-EKR mathematical content. The
Lean-4-formalization repos in operator's namespace (`wallis-pcf-lean4`,
`tunnell-cnp-lean4`) are methodological reference points only — they
demonstrate operator's familiarity with Mathlib4 PR conventions and Lean 4
proof idioms, but their mathematical scope (analytic number theory) is disjoint
from algebraic combinatorics. Mission 2's manuscript should cite `khinchin-k0-bounded`
Zenodo deposit (10.5281/zenodo.20246707) as the methodological predecessor and
need not cite any other `papanokechi/*` repo unless an idiom is reused
verbatim in `Unsolved2/*.lean` files at M5.

## Ledger entries

### Entry 1 — Erdős & Ko & Rado 1961 (foundation)

- **author**: P. Erdős, Chao Ko, R. Rado
- **year**: 1961
- **title**: Intersection theorems for systems of finite sets
- **venue**: *Quart. J. Math. Oxford Ser. (2)* 12 (1961), 313–320
- **claim_loaded_by_this_paper**: original statement and proof of the
  classical Erdős–Ko–Rado theorem; load-bearing on **M2.3 success predicate**
  (q-analog target is defined relative to this classical statement) and on
  **M6 manuscript Introduction** (historical framing).
- **verification_status**: `unread` (mission 2 session)
- **H8_fire_required**: `yes` (load-bearing on M2.3 and M6)
- **excerpts**: pending H8 paper-read.

### Entry 2 — Frankl & Wilson 1986 (q-analog statement + algebraic method)

- **author**: P. Frankl, R. M. Wilson
- **year**: 1986
- **title**: The Erdős–Ko–Rado theorem for vector spaces
- **venue**: *J. Combin. Theory Ser. A* 43 (1986), 228–236
- **claim_loaded_by_this_paper**: q-analog statement and Frankl–Wilson
  algebraic / eigenvalue-bound proof method; **directly load-bearing on M3.1
  implementation** (the proof method this mission formalizes) and on **M2.3
  success predicate** (closed-proof scope = Frankl–Wilson method in Lean 4).
- **verification_status**: `unread`
- **H8_fire_required**: `yes` (most heavily load-bearing entry in ledger)
- **excerpts**: pending H8 paper-read.

### Entry 3 — Hsieh 1975 (earlier q-analog work)

- **author**: W. N. Hsieh
- **year**: 1975
- **title**: Intersection theorems for systems of finite vector spaces
- **venue**: *Discrete Math.* 12 (1975), 1–16
- **claim_loaded_by_this_paper**: priority chain — Hsieh's q-analog
  intersection result predates Frankl–Wilson 1986; H6 priority-audit fires to
  confirm whether the *statement* mission 2 formalizes is Hsieh's or
  Frankl–Wilson's, and whether the *method* mission 2 formalizes is uniquely
  attributable to Frankl–Wilson. Load-bearing on **M6 manuscript attribution**;
  potentially also on M2.3 predicate naming.
- **verification_status**: `unread`
- **H8_fire_required**: `yes` (priority chain affects manuscript framing)
- **excerpts**: pending H8 paper-read.

### Entry 4 — Newman 1978 (subspace intersection theorem)

- **author**: D. J. Newman (verify; operator-seed wording is "Newman, *J. Algebra* 52")
- **year**: 1978
- **title**: TBD — operator seed gave venue but not exact title; H8 fire includes title verification
- **venue**: *J. Algebra* 52 (1978) (per operator seed; venue assignment to be
  verified at H8)
- **claim_loaded_by_this_paper**: an earlier q-analog vector-space intersection
  theorem cited as part of the priority chain; if Newman's result is exactly
  the q-EKR statement, this may displace Hsieh / Frankl–Wilson in attribution.
  Load-bearing on **M6 manuscript attribution** if priority chain shifts.
- **verification_status**: `unread`
- **H8_fire_required**: `pending-decision` (fire only if entry 3 / entry 2
  attribution survey indicates Newman is in the load-bearing chain;
  otherwise downgrade to `abstract-only`)
- **excerpts**: pending H8 decision.

### Entry 5 — Mehta + Dillies 2020 (Mathlib4 classical EKR)

- **author**: Bhavik Mehta, Yaël Dillies
- **year**: 2020 (verify exact merge date; entry pulled forward from
  pre-selection M2.2 check)
- **title**: `Mathlib.Combinatorics.SetFamily.IntersectingFamily` (or analogous
  module name containing `Finset.erdos_ko_rado`)
- **venue**: Mathlib4 (`leanprover-community/mathlib4`); referenced via
  `docs/1000.yaml` entry Q718875
- **claim_loaded_by_this_paper**: existing formalization of classical EKR in
  Lean 4 / Mathlib4. **Substrate-critical for M3.1**: mission 2's q-EKR
  formalization will import / build on this module's set-family definitions,
  intersecting-family predicates, and any auxiliary lemmas (e.g., shifting
  arguments) that survive into the q-analog proof.
- **verification_status**: `partial` (existence of `decl: Finset.erdos_ko_rado`
  confirmed via Mathlib4 `docs/1000.yaml` Q718875 entry during pre-selection;
  module-level paper-read of proof structure pending H8)
- **H8_fire_required**: `yes` (load-bearing on M3.1)
- **excerpts**: from Mathlib4 docs/1000.yaml:
  > `Q718875: Erdős–Ko–Rado theorem`
  > `decl: Finset.erdos_ko_rado`
  > (attribution and PR context: Mehta + Dillies 2020)

### Entry 6 — Mathlib4 q-binomial module documentation

- **author**: Mathlib4 contributors (TBD: identify primary author of
  `Mathlib.Combinatorics.Enumerative.GaussianBinomial` or analogous q-binomial
  module)
- **year**: TBD (verify earliest merge of q-binomial substrate)
- **title**: Mathlib4 q-binomial / Gaussian binomial coefficient module
  documentation
- **venue**: Mathlib4 (`leanprover-community/mathlib4`)
- **claim_loaded_by_this_paper**: existing Lean 4 formalization of Gaussian
  binomial coefficients ${n \brack k}_q$, which appear in the q-EKR
  bound. **Substrate-critical for M3.1**: if the q-binomial coefficient is
  already in Mathlib4, mission 2 imports it; if not, mission 2 must formalize
  it (potentially expanding M3.1 scope).
- **verification_status**: `unread` (M2.2 capability audit will paper-read this
  module; until then, status of q-binomial in Mathlib4 is **unconfirmed**)
- **H8_fire_required**: `yes` (load-bearing on M3.1 and capability audit
  outcome)
- **excerpts**: pending M2.2 capability-audit module inspection.

### Entry 7 — K_0 mission Zenodo deposit (methodological predecessor)

- **author**: Papanokechi
- **year**: 2026
- **title**: Bounded sub-question on Khinchin's constant K_0 algebraicity
  under AEAL v1 discipline (and associated AEAL framework documentation)
- **venue**: Zenodo, DOI 10.5281/zenodo.20246707 (concept DOI)
- **claim_loaded_by_this_paper**: AEAL eleven-heuristic framework (H1–H11),
  bidirectional verification property, mutation-budget discipline, gold-tag
  convention. **Load-bearing on M6 manuscript Appendix B** (methodology
  citation; framework is *not* re-introduced in mission 2 manuscript per Brief
  §M6.2 hard cap).
- **verification_status**: `partial` (deposit existence + `handoff/summary.md`
  §1, §3, §7 verified via K_0 repo at HEAD 102cff9 during pre-M1.2 check;
  Zenodo record content not separately paper-read)
- **H8_fire_required**: `yes` (load-bearing on M6 Appendix B framing)
- **excerpts**: from K_0 repo `handoff/summary.md` §1 (operator-finalized):
  > "[K_0 mission produced a precision-controlled PSLQ null result on the
  > Khinchin signature statistic under AEAL v1 discipline…]" (verbatim quote
  > to be retrieved at M6 manuscript drafting; bracketed paraphrase is
  > placeholder)

### Entry 8 — Wilson 1984 (exact classical EKR bound)

- **author**: R. M. Wilson
- **year**: 1984
- **title**: The exact bound in the Erdős–Ko–Rado theorem
- **venue**: *Combinatorica* 4 (1984), 247–257
- **claim_loaded_by_this_paper**: tight bound for classical EKR; cited for
  completeness in the classical-EKR background section of mission 2
  manuscript. **Not load-bearing on M2.3 / M3.1 / M6** unless the manuscript
  argues a tight-bound comparison between classical and q-analog cases.
- **verification_status**: `unread`
- **H8_fire_required**: `no` (background citation only; downgrade to
  abstract-only at M2.4 freeze if no load-bearing role surfaces)
- **excerpts**: n/a until paper-read.

---

## Pending entries (slots 9–15, to be drafted next)

Operator-seeded plus H6/H8-surfaced additions queued for the second half of
M2.1:

9. Godsil 1993, *Algebraic Combinatorics* — Hoffman / Delsarte LP method as
   Frankl–Wilson method substrate (background; H8 fire pending decision)
10. Engel 1997, *Sperner Theory* — broader intersecting-family literature
    (background)
11. Tanaka 2006, survey on q-analog intersection theorems in
    association-scheme framework (background; potentially load-bearing on
    M5 Lean-formalization scope if Tanaka's framing simplifies the Lean
    statement)
12. Aaronson + Ng + Wilf 2024 — operator seed; H8 relevance check required
    (currently `pending-decision`)
13. Mathlib4 PR contribution guidelines (process, load-bearing on M6
    submission packet preparation)
14. ITP / CPP / Math.Comp 2024–2025 worked-example formalization paper
    (venue-template precedent for M6 manuscript structure; one or two
    recent papers to be selected)
15. Mathlib4 `Mathlib.Combinatorics.SetFamily.Intersecting` module
    documentation — substrate inspection paired with entry 5

Plus open question: whether Goresky + MacPherson or other higher-perspective
q-EKR proofs (e.g., representation-theoretic proofs via the unitary group)
deserve a ledger entry as alternative method candidates. Decision at M2.2
capability audit close: if the operator's Lean 4 baseline cannot support
Frankl–Wilson eigenvalue arguments, alternative-method literature becomes
load-bearing on M3.1.

## Operator surface point

This is the M2.1 half-way surface (entries 1–8 plus H6 audit). Operator review
options:

- **(a)** Approve schema and entries 1–8; CLI proceeds to entries 9–15 plus
  any operator-added entries.
- **(b)** Adjust schema (e.g., add a `Mathlib4_module_path` field for entries
  5/6/15) before CLI continues.
- **(c)** Add or substitute entries before CLI continues (e.g., specific
  Aaronson–Ng–Wilf paper, alternative venue-template paper, additional q-EKR
  proof method literature).
- **(d)** Reject and return to ledger restart with refined scope.

H8 paper-read fire queue at half-way close: entries 1, 2, 3, 5, 6, 7
(load-bearing); entry 4 pending-decision; entry 8 background only.
M2.1 close target: end of week 2 (~2026-05-24).
