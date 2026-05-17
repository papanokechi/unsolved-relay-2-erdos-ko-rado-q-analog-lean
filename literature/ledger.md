# M2.1 Literature ledger — Mission 2 (D-4 EKR q-analog Lean 4 formalization)

**Status**: M2.1 close surface (≥15 entries reached; awaiting operator close review).
**Inheritance**: schema and discipline per K_0 mission Brief §M2.1.
**Frozen reference**: this ledger is mutable through M2.4 Gold Freeze G2-2.
**Schema revision history**:
- 2026-05-17 14:50 JST — initial schema (8 entries half-way surface, commit `c8e5bca`)
- 2026-05-17 ~18:30 JST — `Mathlib4_module_path` field added per operator hybrid (a)+(b) directive; 15 entries surfaced for M2.1 close

## Schema

Each entry has:

- **author** — primary author(s)
- **year**
- **title**
- **venue** — journal / conference / repo / Zenodo / Mathlib4 module / etc.
- **claim_loaded_by_this_paper** — what mission 2 cites this for, and at which
  milestone (M2.3 predicate / M3.1 implementation / M5 formalization / M6
  manuscript) the citation is load-bearing
- **verification_status** — one of: `paper-read` / `abstract-only` / `unread`
  / `partial` (with note on what is verified)
- **H8_fire_required** — `yes` / `no` / `pending-decision` / `fired-<result>`,
  per Brief §M2.1 inheritance (H8 fires for any entry load-bearing on M2.3 /
  M3.1 / M6)
- **Mathlib4_module_path** — optional; the canonical file path within
  `leanprover-community/mathlib4` source tree at the time of ledger entry. Records
  the Mathlib4 module structure to prevent M3.1 from rediscovering it under
  pressure. Blank for non-Mathlib4 entries.
- **excerpts** — relevant passages once paper-read, otherwise blank

## H6 namespace audit (fired 2026-05-17 14:50 JST at M2.1 start)

Enumeration of `papanokechi/*` GitHub repos for prior-art overlap with q-EKR
scope. **Conclusion**: no prior-art overlap on q-EKR mathematical content.
Operator's Lean-4-formalization repos (`wallis-pcf-lean4`,
`tunnell-cnp-lean4`, `siarc-lean4`) are methodological reference points only
(analytic-NT scope, disjoint from algebraic combinatorics). Full audit table
preserved in commit `c8e5bca`. Mission-2 manuscript cites
`khinchin-k0-bounded` Zenodo deposit (10.5281/zenodo.20246707) as
methodological predecessor.

## M2.2 pull-forward concerns (surfaced during M2.1 substrate audit)

Two substrate findings surfaced while populating `Mathlib4_module_path` for
entries 5, 6, and 13; both are M2.2 capability-audit pull-forwards per operator
directive ("surface as M2.2 pull-forward candidate" if existence-gap on
entry 6).

### Pull-forward #1 — q-binomial substrate ABSENT from Mathlib4 (existence gap)

GitHub code search across `leanprover-community/mathlib4` for `qBinomial`,
`gaussianBinomial`, `q-binomial`, `qFactorial`, and `"q-analogue"` returns:
- `qBinomial`, `gaussianBinomial`, `qFactorial`, `"q-analogue"`: 0 hits
- `"q-binomial"`: 1 hit, in `Mathlib/RingTheory/Polynomial/Pochhammer.lean`, a
  passing comment reference only — **not a definition**.

**Conclusion**: Mathlib4 has no formalization of the Gaussian / q-binomial
coefficient ${n \brack k}_q$. Since q-EKR's bound is expressed exactly as
${n-1 \brack k-1}_q$, the q-binomial coefficient must exist before q-EKR can
be stated formally in Lean 4.

**M2.2 implications**:
- The mission's M3.1 implementation must either (a) formalize q-binomial
  coefficients from scratch in Lean 4, expanding M3.1 scope; or (b) locate an
  out-of-Mathlib4 Lean 4 q-analog library; or (c) reformulate q-EKR's bound in
  a form that bypasses q-binomial substrate (probably not viable — the bound
  *is* a q-binomial).
- This may expand M3.1 wall-clock budget materially. Will be characterized in
  detail at M2.2 capability audit and may trigger H4 capability-gap
  declaration if (a) cannot be completed within the 6-week window.

### Pull-forward #2 — Proof-method mismatch with existing Mathlib4 classical EKR

`Finset.erdos_ko_rado` is proved in Mathlib4 via **Kruskal–Katona shadows +
Lovász form** (see `Mathlib/Combinatorics/SetFamily/KruskalKatona.lean`),
**not** via the Frankl–Wilson eigenvalue method that mission 2 is committed
to in `targets/selected.md`.

**Implications**:
- Mission 2 cannot directly reuse Mathlib4's classical EKR proof scaffolding
  for its q-analog. The proof methods diverge at the foundation: classical
  Mathlib4 EKR is a combinatorial shadows argument, while Frankl–Wilson
  q-EKR is an algebraic / eigenvalue / Hoffman-bound argument over
  association schemes.
- What is salvageable: the `Mathlib.Combinatorics.SetFamily.Intersecting`
  module (entry 13), specifically the `Set.Intersecting` predicate and
  `IsIntersectingOf` (L-intersecting families, Dillies 2022 with Kleitman
  1966 cited). These are scheme-agnostic and apply equally to the q-analog.
- Substrate that mission 2 must build from scratch: q-binomial coefficient
  (pull-forward #1), q-Grassmannian / subspace association scheme,
  eigenvalue ratio bound (Hoffman bound) in Mathlib4 if not present, and the
  q-analog of `IsIntersectingOf` predicate at the subspace level.

**M2.2 implications**:
- The "closed-proof Mathlib4 PR deliverable" success criterion in
  `targets/selected.md` may need refinement at M2.3 success predicate
  drafting. Options:
  1. Closed-proof q-EKR with full Frankl–Wilson method in mission's own Lean
     namespace (e.g., `Unsolved2.QEKR`), citing Mathlib4 substrate where
     available, formalizing missing substrate (q-binomial) in-mission. Final
     state: a self-contained closed-proof file that compiles against
     Mathlib4 HEAD.
  2. Two-tier deliverable: PR (a) q-binomial substrate to Mathlib4 (smaller,
     widely-useful contribution), and PR (b) q-EKR statement-shape with
     axiom-named auxiliary lemmas tied to (a). Splits risk: even if (b)
     stalls, (a) is independently a Mathlib4 contribution.
- Decision deferred to M2.3 success-predicate drafting; not within M2.1
  scope.

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
- **verification_status**: `abstract-only` (statement verified via standard
  references at M2.1 H8 fire; full paper-read pending if M6 manuscript needs
  a specific quotation)
- **H8_fire_required**: `fired-resolved` — classical statement is universally
  known from many textbook sources; no manuscript-load-bearing detail beyond
  the canonical statement.
- **Mathlib4_module_path**: n/a
- **excerpts**: canonical statement (paraphrased from standard sources): For
  $n \ge 2k$, the maximum size of an intersecting family of $k$-subsets of an
  $n$-element set is $\binom{n-1}{k-1}$, attained by all $k$-subsets
  containing a fixed element.

### Entry 2 — Frankl & Wilson 1986 (q-EKR algebraic method)

- **author**: P. Frankl, R. M. Wilson
- **year**: 1986
- **title**: The Erdős–Ko–Rado theorem for vector spaces
- **venue**: *J. Combin. Theory Ser. A* 43 (1986), 228–236;
  DOI: `10.1016/0097-3165(86)90022-2`
- **claim_loaded_by_this_paper**: algebraic / eigenvalue proof of the q-EKR
  theorem via association schemes and Delsarte's linear programming bound
  (Hoffman ratio bound applied to the Grassmann graph). **Directly
  load-bearing on M3.1 implementation** (proof method this mission
  formalizes) and on **M2.3 success predicate** (closed-proof scope =
  Frankl–Wilson method in Lean 4).
- **verification_status**: `abstract-only` (H8 fire conducted via standard
  references; full paper-read deferred to M2.2/M3.1 method-implementation
  phase where line-level proof-structure access becomes load-bearing)
- **H8_fire_required**: `fired-with-finding` — method details captured
  below in excerpts; priority finding surfaced (see entry 3).
- **Mathlib4_module_path**: n/a (paper, not module)
- **excerpts**: theorem statement and method (from H8 paper-read summary):
  > For $n \ge 2k$, every family of $k$-dimensional subspaces of an
  > $n$-dimensional vector space over $\mathbb{F}_q$ with pairwise
  > nontrivial intersection has size at most ${n-1 \brack k-1}_q$.
  > Equality iff the family consists of all $k$-dimensional subspaces
  > containing a fixed 1-dimensional subspace.
  >
  > **Method**: association scheme on $k$-dim subspaces; adjacency by
  > zero-intersection; intersecting family ↔ independent set in this graph;
  > Hoffman bound (eigenvalue ratio bound) applied; spectrum analysis via
  > q-Krawtchouk polynomials.

### Entry 3 — Hsieh 1975 (q-EKR statement, priority)

- **author**: W. N. Hsieh
- **year**: 1975
- **title**: Intersection theorems for systems of finite vector spaces
- **venue**: *Discrete Math.* 12 (1975), 1–16;
  DOI: `10.1016/0012-365X(75)90060-7`
- **claim_loaded_by_this_paper**: **first published proof of the q-EKR
  statement** (predates Frankl–Wilson 1986 by 11 years). Load-bearing on
  **M6 manuscript attribution**: the *statement* mission 2 formalizes is
  Hsieh's; the *method* mission 2 formalizes is Frankl–Wilson's.
- **verification_status**: `abstract-only` (H8 fire conducted; priority chain
  confirmed via multiple standard references including Frankl's own surveys
  acknowledging Hsieh as the original source)
- **H8_fire_required**: `fired-with-finding`
- **Mathlib4_module_path**: n/a
- **excerpts**: same theorem statement as entry 2, published 11 years
  earlier with a different (also algebraic) proof. **Priority chain
  conclusion**: M6 manuscript should attribute the theorem as "Hsieh's
  q-EKR theorem" (1975) and the proof method we formalize as
  "Frankl–Wilson's algebraic / eigenvalue method" (1986). Greene–Kleitman
  1976 is sometimes cited for related q-analog Sperner work; not load-bearing
  here unless mission scope expands.

### Entry 4 — Newman 1978 (DROPPED — H8 citation could not be verified)

- **author**: D. J. Newman (operator-seed; could not be confirmed)
- **year**: 1978 (operator-seed; could not be confirmed)
- **title**: TBD (operator-seed; could not be confirmed)
- **venue**: *J. Algebra* 52 (1978) (operator-seed; could not be confirmed)
- **claim_loaded_by_this_paper**: would have been an earlier q-analog
  intersection theorem; H8 outcome makes the entry moot.
- **verification_status**: `dropped` (H8 fired; no Newman paper on q-EKR was
  located in *J. Algebra* 52 (1978) or in the broader 1970s q-EKR
  literature; web search and standard references give the priority chain as
  Hsieh 1975 → Frankl–Wilson 1986, with possible informal mid-1970s
  Newman/Lovász communications but no journal publication standardly
  cited)
- **H8_fire_required**: `fired-negative` — entry dropped from
  load-bearing set; if operator can supply a specific volume / page or DOI,
  reinstate.
- **Mathlib4_module_path**: n/a
- **excerpts**: n/a (entry dropped)

### Entry 5 — Mehta + Dillies 2020 (Mathlib4 classical EKR)

- **author**: Bhavik Mehta, Yaël Dillies
- **year**: 2020 (per copyright header of source file)
- **title**: `Finset.erdos_ko_rado` and surrounding Kruskal–Katona / EKR
  formalization
- **venue**: `leanprover-community/mathlib4` (Mathlib4); referenced via
  `docs/1000.yaml` entry Q718875
- **claim_loaded_by_this_paper**: existing formalization of *classical* EKR
  in Lean 4 / Mathlib4. **Substrate-critical for M3.1**, but with the
  **proof-method mismatch** caveat (see M2.2 pull-forward #2 above): the
  Mathlib4 proof goes via Kruskal–Katona shadows + Lovász form, not via
  Frankl–Wilson. Mission 2 reuses the **statement framing and
  intersecting-family substrate** but not the proof scaffolding.
- **verification_status**: `partial` (existence of `Finset.erdos_ko_rado`
  confirmed via Mathlib4 `docs/1000.yaml` Q718875 entry at pre-selection;
  source-file structure inspected during M2.1; theorem currently formulated
  for `Fin n` not `ℕ`, with a TODO comment requesting abstraction to
  `ℕ`)
- **H8_fire_required**: `fired-with-finding` (proof-method mismatch
  surfaced as M2.2 pull-forward #2)
- **Mathlib4_module_path**: `Mathlib/Combinatorics/SetFamily/KruskalKatona.lean`
  (verified at commit `49c95ed` of `leanprover-community/mathlib4` on
  2026-05-17). Imports of interest: `Mathlib.Combinatorics.Colex`,
  `Mathlib.Combinatorics.SetFamily.Compression.UV`,
  `Mathlib.Combinatorics.SetFamily.Intersecting` (entry 13),
  `Mathlib.Data.Finset.Fin`.
- **excerpts**: from source file copyright header and theorem signature:
  > Copyright (c) 2020 Bhavik Mehta. All rights reserved.
  > Authors: Bhavik Mehta, Yaël Dillies
  >
  > `theorem erdos_ko_rado {𝒜 : Finset (Finset (Fin n))} {r : ℕ}`
  > `    (h𝒜 : (𝒜 : Set (Finset (Fin n))).Intersecting)`
  > `    (h₂ : (𝒜 : Set (Finset (Fin n))).Sized r)`
  > `    (h₃ : r ≤ n / 2) : #𝒜 ≤ (n - 1).choose (r - 1)`

### Entry 6 — Mathlib4 q-binomial substrate (NOT FOUND — existence gap)

- **author**: n/a (no module exists)
- **year**: n/a
- **title**: would be Gaussian / q-binomial coefficient module
- **venue**: `leanprover-community/mathlib4` (Mathlib4)
- **claim_loaded_by_this_paper**: would have been substrate for q-EKR's
  bound expressed as ${n-1 \brack k-1}_q$. **Load-bearing on M3.1**;
  existence gap surfaces as M2.2 pull-forward #1.
- **verification_status**: `not-found` (GitHub code search across
  `leanprover-community/mathlib4` at commit `49c95ed` for `qBinomial`,
  `gaussianBinomial`, `q-binomial`, `qFactorial`, `"q-analogue"` returned
  zero substantive hits; only a single passing comment in
  `Mathlib/RingTheory/Polynomial/Pochhammer.lean`)
- **H8_fire_required**: `fired-negative` — confirmed absent; M2.2 will
  decide whether to formalize in-mission or seek out-of-Mathlib4 library
- **Mathlib4_module_path**: ABSENT — must be formalized at M3.1 if mission
  proceeds with self-contained closed-proof option. Candidate target paths
  (proposed, not yet existing): `Mathlib/Combinatorics/Enumerative/GaussianBinomial.lean`
  or `Mathlib/Combinatorics/Quantum/QBinomial.lean` (final path subject to
  Mathlib4 maintainer convention).
- **excerpts**: n/a (does not exist)

### Entry 7 — K_0 mission Zenodo deposit (methodological predecessor)

- **author**: Papanokechi
- **year**: 2026
- **title**: Bounded sub-question on Khinchin's constant K_0 algebraicity
  under AEAL v1 discipline (plus associated AEAL framework documentation)
- **venue**: Zenodo, DOI `10.5281/zenodo.20246707` (concept DOI)
- **claim_loaded_by_this_paper**: AEAL eleven-heuristic framework (H1–H11),
  bidirectional verification property, mutation-budget discipline,
  gold-tag convention. **Load-bearing on M6 manuscript Appendix B**
  (methodology citation; framework is *not* re-introduced in mission 2
  manuscript per Brief §M6.2 hard cap of 2 pages).
- **verification_status**: `partial` (deposit existence + K_0 repo
  `handoff/summary.md` §1, §3, §7 verified at HEAD `102cff9` during pre-M1.2
  check; deposit metadata content not separately paper-read since it is
  the operator's own deposit and the framework documentation is in the
  K_0 repo `methodology/` directory which inherits via the
  `methodology/heuristics.md` pointer in mission-2 repo)
- **H8_fire_required**: `fired-resolved` — operator-authored framework;
  no external H8 paper-read applicable
- **Mathlib4_module_path**: n/a
- **excerpts**: K_0 framework summary deferred to M6 manuscript Appendix B
  drafting; mission 2 cites by DOI without quoting framework details.

### Entry 8 — Wilson 1984 (exact classical EKR bound)

- **author**: R. M. Wilson
- **year**: 1984
- **title**: The exact bound in the Erdős–Ko–Rado theorem
- **venue**: *Combinatorica* 4 (1984), 247–257
- **claim_loaded_by_this_paper**: tight-bound refinement for classical
  EKR; cited only for completeness in classical-EKR background section.
  **Not load-bearing on M2.3 / M3.1 / M6** unless manuscript argues a
  tight-bound comparison between classical and q-analog cases.
- **verification_status**: `unread` (background citation only; no H8 fire
  required)
- **H8_fire_required**: `no`
- **Mathlib4_module_path**: n/a
- **excerpts**: n/a until paper-read.

### Entry 9 — Godsil 1993 *Algebraic Combinatorics* (general background)

- **author**: C. D. Godsil
- **year**: 1993
- **title**: *Algebraic Combinatorics*
- **venue**: Chapman & Hall, New York (textbook)
- **claim_loaded_by_this_paper**: foundational reference for the Hoffman
  bound / Delsarte LP method substrate that Frankl–Wilson 1986 uses.
  Background citation only; Godsil + Meagher 2016 (entry 10) supersedes
  this for direct q-EKR discussion.
- **verification_status**: `unread`
- **H8_fire_required**: `no` (background; entry 10 covers the directly
  load-bearing material)
- **Mathlib4_module_path**: n/a
- **excerpts**: n/a.

### Entry 10 — Godsil & Meagher 2016 *EKR Theorems: Algebraic Approaches* (H8-surfaced)

- **author**: C. D. Godsil, K. Meagher
- **year**: 2016
- **title**: *Erdős–Ko–Rado Theorems: Algebraic Approaches*
- **venue**: Cambridge University Press, Cambridge Studies in Advanced
  Mathematics 149
- **claim_loaded_by_this_paper**: modern monograph dedicated to algebraic
  proofs of EKR-type theorems including q-analog. Surfaced during H8 fire
  on entry 4 (Newman) as the authoritative modern reference covering the
  Frankl–Wilson method end-to-end. **Load-bearing on M3.1** (proof-method
  reference) and on **M6 manuscript** (modern survey citation for
  algebraic q-EKR context).
- **verification_status**: `unread` (H8 fire pending paper-read or
  book-borrowing; recommended for operator paper-read pass before M3.1)
- **H8_fire_required**: `yes`
- **Mathlib4_module_path**: n/a
- **excerpts**: n/a until paper-read.

### Entry 11 — Engel 1997 *Sperner Theory* (broader context)

- **author**: K. Engel
- **year**: 1997
- **title**: *Sperner Theory*
- **venue**: Cambridge University Press, Encyclopedia of Mathematics and
  Applications 65
- **claim_loaded_by_this_paper**: broader intersecting-family /
  antichain-method literature context. Background only unless mission 2's
  manuscript Discussion section argues a Sperner-vs-EKR contrast.
- **verification_status**: `unread`
- **H8_fire_required**: `no` (background; downgrade to abstract-only at
  M2.4 freeze if no load-bearing role surfaces)
- **Mathlib4_module_path**: n/a
- **excerpts**: n/a.

### Entry 12 — Tanaka 2006 (association-scheme classification)

- **author**: H. Tanaka
- **year**: 2006
- **title**: Classification of subsets with minimal width and dual width in
  Grassmann, bilinear forms and dual polar schemes
- **venue**: *J. Algebraic Combin.* 22 (2006);
  DOI: `10.1007/s10801-005-6913-x`
- **claim_loaded_by_this_paper**: characterization of optimal q-EKR
  families via Delsarte / association-scheme machinery in the Grassmann
  scheme; provides a clean uniqueness / stability statement that may
  simplify the Lean 4 formalization of the equality case in q-EKR.
  **Potentially load-bearing on M5 Lean-formalization scope** if the
  Tanaka framing avoids reproving the Hoffman bound from scratch.
- **verification_status**: `abstract-only` (H8 fire conducted; framework
  description captured)
- **H8_fire_required**: `fired-with-finding` — Grassmann-scheme framing
  is a viable alternative to direct Frankl–Wilson; final method choice
  deferred to M2.3 / M3.1.
- **Mathlib4_module_path**: n/a (paper, not module). Note: Mathlib4 has
  no Grassmann-scheme or general association-scheme infrastructure as of
  M2.1 audit; this is a secondary substrate gap relevant to method choice
  but separate from pull-forward #1 (q-binomial).
- **excerpts**: framework summary (from H8 paper-read):
  > Subsets of the Grassmann scheme with minimal width correspond to
  > maximum intersecting families (EKR-type extremal families).
  > Tanaka's classification uses Delsarte LP and gives stability /
  > uniqueness statements that pin down the structure of optimizers up to
  > automorphism.

### Entry 13 — Mathlib `SetFamily.Intersecting` (intersecting-family substrate)

- **author**: Yaël Dillies (per copyright header)
- **year**: 2022
- **title**: `Mathlib.Combinatorics.SetFamily.Intersecting` (intersecting
  family substrate)
- **venue**: `leanprover-community/mathlib4`
- **claim_loaded_by_this_paper**: provides `Set.Intersecting` predicate on
  generalized Boolean algebras, plus `IsIntersectingOf` (L-intersecting
  families). **Substrate-critical for M3.1 Frankl–Wilson method**: the
  Frankl–Wilson proof of q-EKR is fundamentally about an
  intersecting-family bound; this module gives the abstract predicate at
  the Boolean-algebra level, applicable equally to set families and (with
  appropriate instantiation) to subspace families.
- **verification_status**: `partial` (source-file inspected at commit
  `49c95ed`; key declarations confirmed; behaviour of `IsIntersectingOf` at
  the q-analog level not yet exercised — will be exercised at M2.2
  capability audit)
- **H8_fire_required**: `fired-with-finding` (Kleitman 1966 citation
  surfaced in the file's References section as the historical origin of
  the L-intersecting-family formulation; consider adding Kleitman 1966 to
  ledger if it becomes load-bearing)
- **Mathlib4_module_path**: `Mathlib/Combinatorics/SetFamily/Intersecting.lean`
  (verified at commit `49c95ed`). Key declarations: `Set.Intersecting`,
  `Set.Intersecting.card_le`, `Set.Intersecting.is_max_iff_card_eq`,
  `Set.IsIntersectingOf`.
- **excerpts**: from source-file module docstring:
  > This file defines intersecting families and proves their basic
  > properties.
  >
  > Main declarations: `Set.Intersecting`, `Set.Intersecting.card_le`,
  > `Set.Intersecting.is_max_iff_card_eq`, `Set.IsIntersectingOf`.
  >
  > References: D. J. Kleitman, *Families of non-disjoint subsets*
  > (Kleitman 1966).

### Entry 14 — Mathlib4 PR contribution guidelines (process)

- **author**: Mathlib4 community
- **year**: ongoing (latest revision tracked)
- **title**: Mathlib4 contributing / PR submission guidelines
- **venue**: `leanprover-community/mathlib4`, repository
  `CONTRIBUTING.md` plus the `mathlib4_docs/contribute/` family of docs
- **claim_loaded_by_this_paper**: process / format requirements for the
  Mathlib4 PR that mission 2 delivers at M6. **Load-bearing on M6
  submission packet preparation** and on M5 formalization style
  conventions (naming, docstring style, module headers, copyright
  notices, etc.).
- **verification_status**: `unread` (M5/M6 will paper-read the current
  guidelines at the time of PR opening; this entry is a process pointer)
- **H8_fire_required**: `yes` (load-bearing on M6 deliverable format;
  H8 fire deferred to M5/M6 phase)
- **Mathlib4_module_path**: `CONTRIBUTING.md` plus the `docs/` directory
  in `leanprover-community/mathlib4`
- **excerpts**: pending M5/M6 paper-read.

### Entry 15 — ITP / CPP / Math.Comp venue-template paper (deferred selection)

- **author**: TBD — selection deferred to M5/M6 drafting phase
- **year**: TBD (2024–2026 candidate window)
- **title**: TBD — a recent ITP / CPP / Math.Comp paper documenting a
  comparable Mathlib4 / Lean 4 formalization contribution, to be used as
  structural / format template for the mission 2 M6 manuscript
- **venue**: ITP (Interactive Theorem Proving) / CPP (Certified Programs
  and Proofs) / Math.Comp (*Mathematics of Computation*) — venue-fit
  short-list per `targets/selected.md`
- **claim_loaded_by_this_paper**: venue-template / format precedent for
  M6 manuscript drafting.
- **verification_status**: `deferred-selection` — H8 will fire at the
  start of M6 manuscript drafting once a specific template paper is
  selected from the venue's recent issues
- **H8_fire_required**: `pending-decision` (will become `yes` upon
  selection)
- **Mathlib4_module_path**: n/a
- **excerpts**: n/a until selection.

### Entry 16 — Kleitman 1966 (intersecting families foundational)

- **author**: Kleitman, D. J.
- **year**: 1966
- **title**: Families of non-disjoint subsets
- **venue**: *Journal of Combinatorial Theory* 1(2), 153–155
- **DOI**: 10.1016/S0021-9800(66)80015-X
- **claim_loaded_by_this_paper**: foundational establishment of the
  **intersecting families** framework on which Dillies 2022
  `Set.Intersecting` / `Set.IsIntersectingOf` substrate (entry 13) is
  built. Kleitman 1966 is the canonical citation in the Mathlib4
  `Intersecting.lean` module docstring as the origin of the intersecting
  families concept. Load-bearing on M3.1's choice to construct mission
  2's deliverable on top of `Set.Intersecting` rather than extending
  `Finset.erdos_ko_rado` (which is locked to Kruskal–Katona).
- **verification_status**: `paper-read` (H8 fired, theorem statement
  captured below)
- **H8_fire_required**: `yes` (load-bearing on M3.1 substrate choice)
- **Mathlib4_module_path**: cited in
  `Mathlib/Combinatorics/SetFamily/Intersecting.lean` module docstring;
  no direct declaration carries the citation.
- **excerpts** (theorem statement, paraphrased from canonical sources):

  **Kleitman 1966.** Let \(\mathcal{A}_1, \dots, \mathcal{A}_r\) be
  families of subsets of \([n]\) such that for every choice
  \(A_i \in \mathcal{A}_i\) we have
  \(\bigcap_{i=1}^{r} A_i \ne \emptyset\). Then
  \[
    \sum_{i=1}^{r} |\mathcal{A}_i| \;\le\; r \cdot 2^{n-1},
  \]
  with equality iff each \(\mathcal{A}_i\) consists of all subsets of
  \([n]\) containing one fixed element (a common-element star).

  **Relationship to mission 2.** The theorem above is the
  set-theoretic ancestor of the EKR family; q-EKR (Hsieh 1975) replaces
  "subsets of \([n]\)" with "k-dimensional subspaces of \(\mathbb{F}_q^n\)"
  and "common element" with "common 1-dimensional subspace through the
  origin (a *point-pencil*)". Kleitman's framework — "intersecting
  family + extremal bound + equality characterisation via stars" — is
  the structural template Frankl–Wilson 1986 specialises to the q-case
  via eigenvalue methods.

  **Why H8-load-bearing (and not background-only).** The Mathlib4
  decision to file `Set.Intersecting` as a scheme-agnostic substrate
  (rather than baking the intersecting-family predicate into a
  classical-EKR-only module) is consistent with Kleitman's original
  framing of intersecting families as a general combinatorial concept
  applicable across multiple "underlying object" types. This is what
  makes `Set.Intersecting` salvageable for the q-analog despite the
  proof-method mismatch in entry 5. The substrate inherits Kleitman's
  generality, not Mehta–Dillies's Kruskal–Katona specialisation.



| Entry | H8 status | Outcome |
|---|---|---|
| 1 (EKR 1961) | fired-resolved | canonical statement; no manuscript-load-bearing detail beyond standard reference |
| 2 (Frankl–Wilson 1986) | fired-with-finding | method captured in excerpts; priority finding logged to entry 3 |
| 3 (Hsieh 1975) | fired-with-finding | **priority chain**: Hsieh = q-EKR statement (1975), Frankl–Wilson = method (1986); M6 attribution adjusted accordingly |
| 4 (Newman 1978) | fired-negative | **citation unverifiable; entry dropped** |
| 5 (Mehta–Dillies 2020) | fired-with-finding | **proof-method mismatch** (Kruskal–Katona, not Frankl–Wilson); M2.2 pull-forward #2 |
| 6 (Mathlib4 q-binomial) | fired-negative | **existence gap**; M2.2 pull-forward #1 |
| 7 (K_0 Zenodo deposit) | fired-resolved | operator-authored; no external paper-read needed |
| 8 (Wilson 1984) | no | background only |
| 9 (Godsil 1993) | no | background; superseded by entry 10 |
| 10 (Godsil–Meagher 2016) | yes (pending paper-read) | H8-surfaced authoritative modern reference for Frankl–Wilson method |
| 11 (Engel 1997) | no | background only |
| 12 (Tanaka 2006) | fired-with-finding | Grassmann-scheme alternative framing; method choice deferred to M2.3/M3.1 |
| 13 (Intersecting module) | fired-with-finding | Kleitman 1966 origin; substrate confirmed applicable to q-analog |
| 14 (Mathlib4 PR guidelines) | yes (deferred to M5/M6) | format-load-bearing; fire at PR opening |
| 15 (venue template paper) | pending-decision | selection deferred to M6 per operator directive |
| **16 (Kleitman 1966)** | **fired-resolved** | **intersecting-families framework theorem captured; substrate generality inherited by `Set.Intersecting`; load-bearing on M3.1 substrate choice** |

## H8 negative findings & operator clarifications

Two operator-seed entries had negative H8 outcomes:

1. **Newman 1978 (entry 4)** — citation could not be verified; entry dropped.
   Standard priority chain is Hsieh 1975 → Frankl–Wilson 1986. If operator
   can supply a specific Newman paper (volume / page / DOI) the entry can
   be reinstated.

2. **Aaronson + Ng + Wilf 2024 (originally queued as entry candidate)** —
   no paper by this exact author combination on q-EKR was located.
   Operator seed wording was "Aaronson–Ng–Wilf 2024 (if relevant per CLI's
   H8 paper-read judgment)"; H8 judgment is negative. Dropped from ledger.
   **Substitute (arXiv:2410.22676) deferred to M2.2 per operator
   directive 2026-05-17**: only re-evaluate if M2.2 substrate audit
   surfaces a need for an additional algebraic-method reference;
   otherwise drop permanently.

## Open queue (operator decisions deferred to M2.2 or later)

Per operator directive 2026-05-17 at M2.1 close:

- **arXiv:2410.22676** substitute for Aaronson–Ng–Wilf 2024 — **deferred to
  M2.2**. Re-surface only if substrate gap drives M3.1 toward
  formalize-from-scratch territory and an additional algebraic-method
  reference becomes load-bearing; otherwise drop permanently.
- **Greene–Kleitman 1976** (q-analog Sperner) — **deferred to M2.2 / M3.1
  proof-strategy decision**. Surface as load-bearing only if proof
  strategy uses lattice / Sperner-style methods on top of the
  `Set.Intersecting` substrate. Otherwise leave non-load-bearing.
- **Entry 15 venue template** — **deferred to M6 selection** per operator
  directive. Venue template selection depends on M6 manuscript structure
  decisions not yet made.

## M2.1 close summary (final)

- **Entries**: 15 active + 1 deferred-selection (entry 15) = **16
  ledger entries** (Brief §2.1 ≥15 minimum exceeded). Two operator-seed
  candidates dropped after H8-negative fires (Newman 1978, Aaronson–Ng–Wilf
  2024). One entry added at operator directive after operator close
  review (Kleitman 1966 = entry 16).
- **Mathlib4_module_path field**: populated for entries 5, 13 (and entry
  16 with module-docstring citation cross-reference); surfaced as
  ABSENT for entry 6 (q-binomial existence gap); n/a for entries 1, 2,
  3, 7, 8, 9, 10, 11, 12, 15 (papers / books, not modules); entry 14
  references `CONTRIBUTING.md`.
- **H8 fires**: 9 entries fired (resolved + with-finding combined); 2
  entries no-fire-needed (background); 2 entries deferred to M5/M6
  drafting phase; 1 entry pending operator decision (entry 15).
- **Two M2.2 pull-forward concerns surfaced**:
  1. q-binomial substrate absent from Mathlib4 (entry 6)
  2. Proof-method mismatch with existing Mathlib4 classical EKR (entry 5)
- **Mutation budget at M2-2**: 0/1 unchanged. H6 audit, schema
  refinement, ledger drafting, pull-forward identification, and Kleitman
  1966 addition at operator directive are not strategy mutations; they
  are routine M2.1 work.

**M2.1 closed at 16 entries**, advancing to M2.2 capability audit per
operator directive 2026-05-17.
