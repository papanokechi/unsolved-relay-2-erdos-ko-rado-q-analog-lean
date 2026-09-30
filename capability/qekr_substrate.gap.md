# Capability: q-EKR proof substrate (Mathlib v4.29.0) — GAP

**Class:** `gap` — the Mathlib v4.29.0 substrate required to **prove** the q-analog
Erdős–Ko–Rado theorem (`QEkr.q_ekr`) is **absent**. Per K_0 §0.2 "no retrofit" clause,
this gap is documented and surfaced rather than worked around. This is the M5 **Tier-2**
resolution per `targets/success_predicate.md` §2.2: the q-EKR **statement** is formalized
and type-checks; the **proof** is not, and its blocker is characterised here as a roadmap
for a future formalizer.

> **Honesty note (read first).** This is **not** a proof. `QEkr.q_ekr`
> (`QEkr/PointPencilCounting/Basic.lean`) has a deliberate `sorry` body marking this gap;
> `lake build` therefore emits exactly one `sorry` warning and `#print axioms QEkr.q_ekr`
> lists `sorryAx`. Those signals are intended and **must not** be suppressed (e.g. by
> swapping the `sorry` for an `axiom`, which would silently discharge the goal). The
> deliverable is a *formalized statement of q-EKR with an explicitly documented capability
> gap*.

**Class is FUNDAMENTAL, not budget-exhaustion.** The gap is the absence of upstream
mathematical substrate (multi-month formalizations), not a local time/effort shortfall on
an otherwise-available toolkit.

**Distinct from** `capability/q_binomial.available.md` (class `available`): that file
records that q-binomial substrate exists *somewhere in the Lean ecosystem*
(`facebookresearch/algebraic-combinatorics`, CC BY-NC 4.0; `xiangyazi24/AnalyticCombinatorics`,
Apache 2.0, minimal). This file records the narrower, binding fact for **this repo's actual
build**: with the CC-BY-NC Lake dep unusable on this host (`capability/algcomb_lakedep.gap.md`,
outcome (c)) and the Apache-2.0 clean re-implementation (`QBinomialClean`) **dropped** for this
mission (U-MISSION-2-J / CLI-default (4a)), the build runs on the **Mathlib-only substrate**,
and Mathlib v4.29.0 carries **none** of the machinery the proof needs.

**Fire trigger:** M5 Tier-2 resolution (q-EKR audit `qekr-state-audit` → `QEKR-FRAGILE`),
executed against HEAD `ab4c943`.

**Evidence record:** independent audit + build at HEAD `ab4c943`
(`lake exe cache get` exit 0 / 8058 oleans; `lake build QEkr.PointPencilCounting.Basic`
exit 0, 1514 jobs, exactly one `sorry` warning at `Basic.lean` `q_ekr`); Mathlib v4.29.0
source greps below.

---

## 1. What IS stated (the contribution)

A formalized Lean 4 **statement** of the q-EKR (t = 1) bound, building clean against
Mathlib v4.29.0 (toolchain + Mathlib SHA `8a178386ffc0`, SHA-pinned in `lake-manifest.json`):

* **Predicate** — `QEkr.IsDimIntersectingOf` (`QEkr/IsDimIntersectingOf.lean`, 143 lines,
  **no `sorry`**): the q-analog of Mathlib's `Set.IsIntersectingOf`, measuring pairwise
  intersection by `Module.finrank` instead of `Finset.card`:

  ```lean
  def IsDimIntersectingOf (L : Set ℕ) (𝒜 : Set (Submodule R M)) : Prop :=
    𝒜.Pairwise fun V W ↦ Module.finrank R ((V ⊓ W : Submodule R M)) ∈ L
  ```

  with API `mono`, `anti`, `empty`, `singleton`, `univ` (all proved).

* **Point-pencil + API** (`QEkr/PointPencilCounting/Basic.lean`): `pointPencil V₀ k`
  (all k-dim subspaces containing `V₀`) plus proved lemmas `mem_iff`, `uniform_dim`,
  `contains_centre`, `le_inf_of_mem_mem`, and `isDimIntersectingOf_ge`.

* **Statement** — `QEkr.q_ekr` (exact current signature; v1.1 replaced `_hk_le : k ≤ n`,
  under which the statement is false for `2k > n`, by `_h2k : 2 * k ≤ n`):

  ```lean
  theorem q_ekr {K : Type*} [Field K] [Fintype K]
      {n : ℕ} (k : ℕ) (_hk_pos : 1 ≤ k) (_h2k : 2 * k ≤ n)
      (𝒜 : Set (Submodule K (Fin n → K)))
      (_h_dim : ∀ V ∈ 𝒜, Module.finrank K V = k)
      (_h_int : IsDimIntersectingOf {d | 1 ≤ d} 𝒜)
      (V₀ : Submodule K (Fin n → K)) (_hV₀_dim : Module.finrank K V₀ = 1) :
      Set.ncard 𝒜 ≤ Set.ncard (pointPencil V₀ k) := by
    sorry
  ```

  i.e. *for `2k ≤ n`, every 1-intersecting family `𝒜` of k-dim subspaces of `𝔽_q^n` has
  cardinality at  most that of any point-pencil through a fixed line `V₀`.* The bound equals the Gaussian
  binomial `⟨n-1, k-1⟩_q`, stated here **set-theoretically** via `Set.ncard (pointPencil …)`.

---

## 2. What is MISSING (the gap), in dependency order

The single `sorry` in `q_ekr` is **the entire mathematical content** — there is no proved
sub-scaffold beneath it. Discharging it needs three Mathlib substrates that do **not** exist
in v4.29.0. Each is a multi-month formalization, ordered by dependency:

### (a) q-binomial / Gaussian-binomial coefficients over 𝔽_q — **ABSENT**

* `grep` of Mathlib v4.29.0 source for `qBinomial`, `gaussBinomial`, `gaussianBinomial`,
  `Gaussian binomial`: **0 declarations** (only an out-of-scope passing mention in
  `RingTheory/Polynomial/Pochhammer.lean`). Confirms the M2.2 Fire 1 finding
  (`q_binomial.available.md` Step 1) at v4.29.0.
* Needed: `qBinomial`/`gaussBinomial` (as `ℕ` or `Polynomial ℤ`), the two q-Pascal
  recurrences, the quotient/product formula, q-symmetry. (~50–200 lines on their own; the
  *definitions* are the cheap part.)

### (b) Subspace counting over 𝔽_q (the Grassmannian enumeration) — **ABSENT**

* The load-bearing bridge: `#{ W : Submodule 𝔽_q (𝔽_q^n) | finrank W = k ∧ V₀ ≤ W } =`
  `⟨n-1, k-1⟩_q`, and the corollary that **all** point-pencils through a 1-dim centre are
  **equinumerous** (so `Set.ncard (pointPencil V₀ k)` is well-defined independent of `V₀`).
* Mathlib v4.29.0 has the linear-algebra primitives (`Module.finrank`, `Submodule`,
  `Basis`, `LinearMap`, finite-dimensional API) but **not** this enumeration nor any
  Grassmannian/quotient-space counting bijection. This is the highest-risk component
  (estimated ~400–800 lines; `q_binomial.available.md` Path B §"subspace-counting interpretation").

### (c) The q-analog Erdős–Ko–Rado extremal argument — **ABSENT**

* The actual theorem: for `n ≥ 2k`, an intersecting family of k-subspaces is no larger
  than a maximal  point-pencil. Mathlib's only EKR is the **classical, finset** version
  `theorem erdos_ko_rado` in `Mathlib/Combinatorics/SetFamily/KruskalKatona.lean`
  (authors Mehta–Dillies; `#𝒜 ≤ (n-1).choose (r-1)` over `Finset (Finset (Fin n))`). It
  **does not transfer** to subspaces of `𝔽_q^n`: subspaces are not a `Finset (Finset …)`
  family, and the q-analog requires its own proof (Frankl–Wilson 1986 eigenvalue/association-
  scheme method, or a q-shifting/compression argument, or Hsieh 1975). None of these — nor
  the supporting association-scheme / Hoffman-bound machinery — are in Mathlib (the
  eigenvalue method substrate is the "DEEP gap" flagged at
  `intersecting_substrate.available.md` Fire 2).

| Missing substrate | In Mathlib v4.29.0? | Nature |
|---|---|---|
| (a) q-binomial / Gaussian-binomial coefficients | No (0 decls) | substrate absence |
| (b) 𝔽_q subspace / Grassmannian counting | No | substrate absence (highest risk) |
| (c) q-analog EKR extremal argument | No (classical EKR is finset-only) | substrate absence |

---

## 3. Why the point-pencil reframing helped but did not close it

U-MISSION-2-J selected direct point-pencil counting (option (iii)) specifically to avoid the
q-binomial **definition** dependency: by stating the bound as `Set.ncard (pointPencil V₀ k)`
rather than `⟨n-1, k-1⟩_q`, the **statement** type-checks with **zero** q-binomial machinery —
which is why `IsDimIntersectingOf`, `pointPencil`, the API lemmas, and the `q_ekr` *signature*
all build clean. That reframing is genuinely load-bearing for the Tier-2 statement.

But it only moves the q-binomial out of the *statement*, not out of the *proof*. To discharge
`q_ekr` one still needs (b) the subspace counting that makes point-pencils equinumerous and
bounds `𝒜`, and (c) the extremal argument — both of which are the same absent substrate. The
reframing buys a clean **statement**, not a clean **proof**.

---

## 4. Roadmap for a future formalizer (dependency-ordered)

1. **q-binomial definitions + identities** (substrate (a)). Clean-room re-implement from a
   public source (Grinberg, *Algebraic Combinatorics*, `arXiv:2506.00738`; Apache-2.0
   `xiangyazi24/AnalyticCombinatorics` as a structural reference only). Apache-2.0-clean so
   it is Mathlib-PR-eligible. ~50–200 lines.
2. **𝔽_q subspace counting** (substrate (b)). Prove
   `#{ k-subspaces of 𝔽_q^n } = ⟨n, k⟩_q` and the relativised
   `#{ k-subspaces ⊇ V₀ } = ⟨n - dim V₀, k - dim V₀ ⟩_q` via a quotient-space bijection
   (`(𝔽_q^n)/V₀`), yielding point-pencil equinumerosity. Highest-risk; ~400–800 lines. Depends on 1.
3. **q-EKR extremal argument** (substrate (c)). Either (i) a q-analog shifting/compression
   on `IsDimIntersectingOf` families, or (ii) the Frankl–Wilson eigenvalue method (needs an
   association-scheme + Hoffman/ratio-bound substrate first — the deepest sub-gap). ~200–800
   lines. Depends on 2.
4. **Discharge `q_ekr`**: combine 2 (counting/equinumerosity) and 3 (extremal bound); remove
   the `sorry`. Then `#print axioms QEkr.q_ekr` should reduce to the standard set
   `{propext, Classical.choice, Quot.sound}` with **no** `sorryAx` — the Tier-1 condition.

Until step 4 lands, this remains a Tier-2 statement + gap, never a proof.

---

## 5. Method-substitution history (why this substrate is the binding constraint)

The q-EKR proof method was substituted twice, each time on a substrate failure — the record
of *why* substrate (a)/(b)/(c) is the constraint, not a tactic-skill gap:

1. **Frankl–Wilson eigenvalue method** (the literature-priority method, `targets/selected.md`)
   → **substrate-blocked**: association schemes + Hoffman bound are a DEEP Mathlib gap,
   out-of-window (`intersecting_substrate.available.md` Fire 2).
2. **Compression argument** (selected primary at M2.3/M2.4) → **substrate-blocked**: relies on
   q-binomial substrate via the `algcomb` Lake dep, which is **unusable** on this host under
   both v4.29.0 (algcomb source fails to compile — real v4.28→v4.29 API drift) and v4.28.0
   (ProofWidgets `widgetJsAll` trace-mismatch); outcome (c), `algcomb_lakedep.gap.md`.
3. **Direct point-pencil counting** (U-MISSION-2-J option (iii), current method) → statement
   builds clean, but the **proof** still needs substrate (b)+(c), absent from Mathlib.

The constant across all three is the **absent upstream substrate**, not the proof technique.
That is the finding this Tier-2 deposit records.

---

## 6. Verification class per H9 sub-key

```yaml
independent_verifier_result:
  technique: "Mathlib-only build at pinned toolchain + Mathlib v4.29.0 source grep + statement type-check"
  classification: "field_standard_practice"   # for the substrate-absence claims
  secondary_classification: "rigorous_theorem" # the q_ekr STATEMENT is well-typed/well-defined; body unproved (sorryAx)
  verifier_identity: "Copilot CLI session; q-EKR Tier-2 close at repo HEAD ab4c943"
  verifier_method: "lake exe cache get (exit 0, 8058 oleans); lake build QEkr.PointPencilCounting.Basic (exit 0, 1514 jobs, one sorry warning); #print axioms QEkr.q_ekr -> includes sorryAx; grep Mathlib v4.29.0 for qBinomial/gaussBinomial (0) and erdos_ko_rado (finset-only at KruskalKatona.lean)"
  scope: "Mathlib v4.29.0 (SHA 8a178386ffc0) as the build substrate; CC-BY-NC algcomb Lake dep held out (host-unusable); QBinomialClean dropped (U-MISSION-2-J 4a)."
  limitations: "Absence claims are accurate for Mathlib v4.29.0 at this SHA; a future Mathlib could add q-binomial / subspace-counting / q-EKR substrate and reopen the Tier-1 path. This file is a STATEMENT + documented gap, NOT a proof."
  reproducibility: "lean-toolchain + lake-manifest.json pin the substrate; QEkr/ files preserve the statement; rerun the build to reproduce the single sorry warning."
  date_of_verification: "2026-06-07"
```

---

## 7. Mutation budget impact

* Documented as a legitimate AEAL framework outcome per Brief §0 ("capability gaps are
  first-class deliverables"); the Tier-2 fallback was pre-ratified at M2.4
  (`success_predicate.md` §2.2) and is the M2.4 cascade-fallback, **not** a mutation.
* Mutation budget **0 / 1** at M3-2 unchanged.

## 8. Cross-references

* `QEkr/PointPencilCounting/Basic.lean` — `q_ekr` statement + the in-line AEAL CAPABILITY-GAP
  marker pointing here.
* `capability/q_binomial.available.md` — substrate (a) ecosystem audit (Mathlib zero; external
  CC-BY-NC full / Apache-2.0 minimal).
* `capability/algcomb_lakedep.gap.md` — why the operationally-cheapest q-binomial path (algcomb
  Lake dep) is closed on this host (outcome (c)).
* `capability/intersecting_substrate.available.md` — `Set.Intersecting` available; Frankl–Wilson
  eigenvalue substrate the DEEP gap; method-substitution rationale.
* `targets/success_predicate.md` §2.1 (Tier 1 closed proof, blocked) / §2.2 (Tier 2 statement +
  gap, realized here) / §6 (H9 verification-class table).
* `mutation_log/M3-2.md` entry 3 — U-MISSION-2-J option (iii) selection.
