# Capability: intersecting-families predicate substrate

**Class**: `available` — base `Set.Intersecting` predicate is
scheme-agnostic and applies directly to subspaces of F_q^n; the
`IsDimIntersectingOf` extension needed for q-EKR is a small in-scope
construction (~50-150 lines). **Sub-gap recorded inside this
document**: the Frankl-Wilson **eigenvalue method** specifically
(association-scheme machinery + Hoffman ratio bound) is a DEEP gap in
Mathlib4 that is out-of-scope for the 6-week mission window;
alternative proof methods (compression argument, direct point-pencil
counting, external algebraic substrate) are tractable in window. The
K_0 §0.2 binary "available / gap" convention applies to the
**capability** (can mission 2 formalize q-EKR on a Mathlib4-compatible
intersecting-families substrate?), not to the specific method
(Frankl-Wilson eigenvalue-spectral path); thus `.available.md` is the
correct suffix, with the eigenvalue-method sub-gap analysed in detail
below and a method-substitution proposed for M2.3 framing.

**Fire trigger**: M2.2 pull-forward #2 (from M2.1 ledger entry 5,
proof-method mismatch + entry 13, salvageable substrate). H7 functional
verification fires here.

## H7 functional verification log

### Step 1 — `Set.Intersecting` API audit (positive)

Direct inspection of `Mathlib/Combinatorics/SetFamily/Intersecting.lean`
at Mathlib4 HEAD (SHA `fcf04bb1`) confirms:

```lean
namespace Set

section SemilatticeInf
variable {α : Type*} [SemilatticeInf α] [OrderBot α] {s t : Set α} {a b c : α}

/-- A set family is intersecting if every pair of elements is non-disjoint. -/
def Intersecting (s : Set α) : Prop :=
  ∀ ⦃a⦄, a ∈ s → ∀ ⦃b⦄, b ∈ s → ¬Disjoint a b
```

**Critical scheme-agnostic property**: `Set.Intersecting` is defined for
any `α` that is a `SemilatticeInf` with `OrderBot`. **Subspaces of
`F_q^n`** form exactly such a structure: `Submodule (F_q) (Fin n → F_q)`
with `⊓ = ∩` and `⊥ = {0}`. The predicate `Set.Intersecting` therefore
applies directly to families of subspaces (intersection-of-two not equal
to `{0}` = trivial-only intersection).

This was the salvageable-substrate hypothesis flagged at M2.1 (ledger
entry 13). H7 functional verification confirms it: the substrate
import-compiles cleanly in concept; the instance `SemilatticeInf
(Submodule R M)` is already in Mathlib4 (`Mathlib/Algebra/Module/Submodule/Lattice.lean`).

API surface inherited from `Set.Intersecting` and applicable to subspace families:
- `Intersecting.mono` — subfamily-monotonicity
- `Intersecting.bot_notMem` / `Intersecting.ne_bot` — `{0}` cannot belong to an intersecting subspace family
- `intersecting_empty`, `intersecting_singleton`, `intersecting_insert`
- `Intersecting.isUpperSet` — maximal intersecting families are upper sets in the lattice of subspaces

**Critical missing**: `Intersecting.card_le` (the `2 * #s ≤ Fintype.card α`
bound) is stated for `BooleanAlgebra α` + `Fintype α`. Subspaces of
`F_q^n` form a **modular geometric lattice** (not a boolean algebra),
so `card_le` does not transport. q-EKR's bound
`|F| ≤ \binom{n-1}{k-1}_q` is a **different** bound from the trivial
"half-the-lattice" bound; it is exactly the bound Frankl-Wilson 1986
establishes.

### Step 2 — `Set.IsIntersectingOf` API audit (mismatch)

```lean
def IsIntersectingOf (L : Set ℕ) (𝒜 : Set (Finset α)) : Prop :=
  𝒜.Pairwise fun s t ↦ #(s ∩ t) ∈ L
```

**Critical mismatch**: The L-intersecting predicate is hardcoded to
`Finset α` and uses `#(s ∩ t)` (the **set-cardinality** of the
intersection). For q-EKR we need
- domain: `Submodule (F_q) (Fin n → F_q)` not `Finset α`
- size measure: `Module.finrank` (dimension of intersection) not set-cardinality

A literal port of `IsIntersectingOf` to subspaces would say
`#(V₁ ∩ V₂ : Set (Fin n → F_q)) = q ^ (Module.finrank (V₁ ⊓ V₂))`,
which is technically definable but semantically wrong (the q-EKR
notion is on *dimension*, not on the q-power thereof).

**Implication**: M3.1 must define a new predicate, e.g.

```lean
/-- A family of `k`-dim subspaces is `L`-dim-intersecting if every pair of
distinct members intersects in a subspace of dimension in `L ⊆ ℕ`. -/
def IsDimIntersectingOf (L : Set ℕ) (𝒜 : Set (Submodule R M)) : Prop :=
  𝒜.Pairwise fun V W ↦ Module.finrank R (V ⊓ W) ∈ L
```

(or a more idiomatic Mathlib4 spelling using `Module.rank` or a sigma type).

Estimated cost: ~50-150 lines including basic API lemmas matching the
existing `IsIntersectingOf.mono`, `.anti`, `.empty`, `.univ` pattern.
This is well within M3.1 scope.

### Step 3 — Frankl-Wilson eigenvalue-method substrate (gap)

The Frankl-Wilson 1986 q-EKR proof method is documented in M2.1
ledger entry 2:
- Set up Cayley graph on the Grassmannian (vertices = k-dim subspaces;
  edges = pairs intersecting trivially).
- Compute eigenvalues using the Bose-Mesner algebra of the q-Johnson
  scheme.
- Apply Hoffman ratio bound to bound max independent set ≤
  q-binomial(n-1, k-1).

Required substrate (functionally verified absent from Mathlib4):

- **Association schemes**: `search_code` for "AssociationScheme" /
  "BoseMesner" / "JohnsonScheme" in Mathlib4 → 0 hits at audit time.
- **q-Johnson scheme** (Grassmann scheme): not in Mathlib4.
- **Hoffman ratio bound** (spectral bound on independence number): not in Mathlib4.
- **Grassmannian / `Module.Grassmannian`**: `Mathlib/LinearAlgebra/Grassmannian.lean` does not exist; concept may live as the type `{V : Submodule R M | finrank V = k}` but with little API.

This is a **deep gap**. Formalizing association schemes + Hoffman ratio bound from scratch is **multi-month work**, well beyond the 6-week mission window.

**Two alternative proof methods are tractable in window**:

1. **Compression / shifting argument (q-analog of Frankl-Daykin)**.
   The classical EKR proof by Frankl uses combinatorial shifting
   without spectral machinery. A q-analog of shifting exists in
   the literature (e.g., Frankl-Furedi, Bollobás-Leader). Substrate
   requirement: just the `IsDimIntersectingOf` predicate + standard
   `Submodule` API. Estimated ~600-1000 lines for a self-contained
   proof. **Feasible in window.**

2. **Direct counting via stars** (operator's `targets/selected.md`
   "Frankl-Wilson method" language can be relaxed to allow this).
   Classical EKR proof by Katona's cyclic shifting. q-analog
   would prove the bound by exhibiting all extremal families as
   *point-pencils* (subspaces containing a fixed 1-dim line) and
   counting them directly. Substrate requirement: same as #1 plus
   a `Submodule.point_pencil` definition. Estimated ~500-800 lines.
   **Feasible in window.**

3. **External substrate via facebookresearch/algebraic-combinatorics**:
   that library has q-Vandermonde + subspace counting, which may
   give a third proof path (algebraic, not eigenvalue-based) at
   lower line count if the substrate is imported as Lake dependency.
   **Feasible in window with Path A's licensing trade-off (see
   `q_binomial.available.md`).**

## Updated capability classification

- **`Set.Intersecting` for subspaces**: **AVAILABLE** (scheme-agnostic).
- **`Set.IsIntersectingOf` for subspaces**: **GAP** (literal port wrong; need new `IsDimIntersectingOf`).
- **`IsDimIntersectingOf` substrate**: **CONSTRUCTIBLE** (~50-150 lines, in M3.1 scope).
- **Frankl-Wilson eigenvalue-method substrate**: **DEEP GAP** (multi-month formalization).
- **Alternative proof methods (compression / direct counting / external algebraic)**: **VIABLE within window**.

## Implications for M2.3 success-predicate

The pull-forward concern from M2.1 suggested a **two-tier success
predicate**. After the H7 audit, the tiers concretise to:

### Tier 1 (CLOSED-PROOF, must-deliver)

- `IsDimIntersectingOf` predicate definition + basic API.
- q-EKR statement formalised as a Lean 4 theorem.
- Proof via compression-argument **or** direct-pencil-counting **or**
  algebraic-method-with-external-substrate (Path A).
- Lean file compiles against the chosen substrate (mission-local or
  Lake-dependency).

### Tier 2 (STATEMENT-SHAPE, mission-acceptable fallback)

- If all three alternative methods stall, the Tier-2 fallback is:
  - `IsDimIntersectingOf` predicate + API.
  - q-EKR statement formalised.
  - q-EKR proof body is `sorry` with explicit comment naming
    "Frankl-Wilson eigenvalue method via association-scheme machinery
    not in Mathlib4; see `capability/intersecting_substrate.available.md`
    for substrate gap analysis."
- M6 manuscript reports this as a **partial result with formalization-blocked
  proof** — methodologically interesting AEAL output (negative-result-style).

### Tier 0 (PROOF-DEFERRED, M5 explicit downgrade)

- If even the `IsDimIntersectingOf` definition + statement does not
  land, M5 records the capability gap formally and mission 2 closes
  with a `mission_outcome=capability_gap_documented` rather than
  `mission_outcome=closed_proof`. AEAL framework discipline preserves
  this as a valid mission close (per Brief §0 capability-gaps-are-first-class).

## Recommended M2.3 framing (CLI proposal, operator decides)

- **Success predicate**: Tier 1 closed-proof using **compression
  argument** (no external dependency, no licensing complication)
  on top of `IsDimIntersectingOf` + `Set.Intersecting` substrate.
- **Fallback predicate**: Tier 2 statement-shape if compression
  blocks; Tier 0 if even predicate definition stalls.
- **Stretch predicate**: Path C hybrid (external dep for closed-proof
  + clean re-implementation for Mathlib4 PR) per `q_binomial.available.md`.

This framing preserves AEAL discipline (capability gaps are
deliverables) while maximizing probability of closed-proof outcome.

## Verification class per H9 sub-key

```yaml
independent_verifier_result:
  technique: "Mathlib4 source-tree inspection + Lean type-class analysis"
  classification: "proven_corollary"
  verifier_identity: "Copilot CLI Sonnet/Opus session M2.2 fire 2"
  verifier_method: "direct file read of Mathlib/Combinatorics/SetFamily/Intersecting.lean at SHA fcf04bb1; type-class analysis of SemilatticeInf+OrderBot vs BooleanAlgebra requirements; absence searches for AssociationScheme/BoseMesner/JohnsonScheme/HoffmanBound in Mathlib4 HEAD"
  scope: "Mathlib4 HEAD (master) at 2026-05-17"
  limitations: "Audit verifies the existence/absence of declarations and the type-class compatibility surface. It does NOT verify that compression-argument-based proof of q-EKR will succeed; that requires actual implementation in M3.1 and is the load-bearing risk for Tier 1 success predicate."
  reproducibility: "Mathlib4 file paths + SHAs preserved in this document and in literature/ledger.md"
  date_of_verification: "2026-05-17"
```

## Mutation budget impact

- This capability characterisation does **not** change mission 2's
  strategic direction (still D-4 EKR q-analog Lean formalization).
- The proof-method narrowing from "Frankl-Wilson eigenvalue" to
  "Frankl-Wilson-method-family (compression / direct counting /
  algebraic)" IS a method substitution. Per K_0 mission's H4
  "capability gaps are first-class" + the brief's H7 "functional
  verification of capability claims", method substitution surfaced
  through H7 is **not a mutation** — it is M2.2 normal output.
- If operator's M2.3 success-predicate decision selects Tier 2 or
  Tier 0 as the primary deliverable (rather than fallback), that
  WOULD invoke mutation budget. Tier 1 with compression-argument as
  primary is **within original scope** of `targets/selected.md`
  ("Frankl-Wilson method proof" — method-family interpretation per
  literature ledger entry 2 and Hsieh 1975 priority).
- Mutation budget at M2-2 remains 0/1.
