# targets/success_predicate.md — M2.3 Success Predicate (DRAFT for operator review)

**Mission:** unsolved-relay-2 (D-4 EKR q-analog Lean 4 formalization)
**Milestone:** M2.3 (Success-predicate construction)
**Status:** DRAFT — awaiting operator ratification prior to M2.4 Gold Freeze G2-2
**Selection authority:** Operator U-MISSION-2-H (2026-05-17)
**Drafted:** 2026-05-17 JST
**Companion artifacts:** `targets/selected.md` (M1.3), `capability/q_binomial.available.md` + `capability/intersecting_substrate.available.md` + `capability/README.md` (M2.2), `literature/ledger.md` (M2.1, 16 entries).

---

## 1. Operator decision package (U-MISSION-2-H)

| # | Decision | Operator selection |
|---|---|---|
| 1 | Strategy path | **Path C (hybrid)** — facebookresearch as Lake dep for fast Tier-1 closed-proof + clean Apache-2.0 re-implementation in parallel as Mathlib4 PR candidate |
| 2 | Primary proof method | **Compression argument (q-analog Frankl–Daykin)** — ~600–1000 lines self-contained Lean 4 |
| 3 | Success-predicate tier semantics | **Cascade-fallback**: Tier 1 primary; Tier 2 on proof-stall; Tier 0 on predicate-stall. Differs from K_0 H9 two-tier (simultaneous reporting) — flagged for M6-2 §Appendix B as tier-application variant. |
| 4 | Lean toolchain pin | **`leanprover/lean4:v4.29.0`** (matches `xiangyazi24/AnalyticCombinatorics`; Mathlib4 HEAD-compatible) |

Operator-acknowledged: decision (3) is **NOT** a mutation per Brief §7 (same H9 taxonomy, different tier-application semantics); budget remains **0 / 1** at M2-2.

---

## 2. Success predicate (cascade-fallback structure)

### 2.1 Tier 1 — Closed-proof q-EKR (must-deliver primary)

**Predicate body:**

A single Lean 4 source file (`lean/QEkr.lean` or analogous path under the mission repo) **compiles cleanly** against the mission-repo toolchain (`leanprover/lean4:v4.29.0` + Mathlib4 + Lake deps per §5 below) and contains:

1. **Predicate definition** — `IsDimIntersectingOf` (or operator-blessed equivalent name) on subspaces of a finite-dimensional vector space, e.g.

   ```lean
   /-- A family of subspaces is `L`-dim-intersecting if every pair of distinct
   members intersects in a subspace of dimension in `L ⊆ ℕ`. -/
   def IsDimIntersectingOf {R : Type*} [Field R] {M : Type*} [AddCommGroup M] [Module R M]
       (L : Set ℕ) (𝒜 : Set (Submodule R M)) : Prop :=
     𝒜.Pairwise fun V W ↦ Module.finrank R (V ⊓ W) ∈ L
   ```

   plus minimal API (`mono`, `anti`, `empty`, `subset`-style lemmas matching the
   pattern of `Set.IsIntersectingOf` in `Mathlib/Combinatorics/SetFamily/Intersecting.lean`).
   Estimated scope: **~50–150 lines** including API surface.

2. **q-EKR statement** — a Lean 4 `theorem` whose informal content is

   > For `1 ≤ k ≤ n/2`, every intersecting family of `k`-dimensional subspaces of `F_q^n`
   > (i.e., `IsDimIntersectingOf {d : ℕ | d ≥ 1} 𝒜` restricted to `k`-dim members)
   > satisfies `#𝒜 ≤ q-binomial(n-1, k-1)`.

   Concrete Lean encoding to be finalised at M3.1; the encoding choice will use either
   the in-repo clean re-implementation of `qBinomial` (Path B fork) or
   `facebookresearch/algebraic-combinatorics`'s `qBinomial` (Path A fork) depending on
   the proof file selected — see §3 for parallel-artifact handling.

3. **Closed proof** via **compression argument (q-analog Frankl–Daykin)**.
   The proof body has **no `sorry`** and **no `axiom`-introduced lemma beyond
   the standard Mathlib4 axiom set** (`Classical.choice`, `propext`, `Quot.sound`).
   If any auxiliary lemma is `axiom`-named, it must be flagged with H9 verification
   class `field_standard_practice` and a comment naming the published reference
   (per `targets/selected.md` original predicate language).

**Success indicators (machine-checkable at M5 close):**
- `lake build` succeeds with exit code 0 against pinned toolchain.
- `#print axioms theorem_qEKR` outputs the standard Mathlib4 axiom set, no `sorry`.
- File diff is clean (no committed `.olean` or build artifacts; CI-reproducible).

**Estimated total scope**: ~800–1200 lines for the mission-repo proof file
(Path A fork: ~50–150 predicate + ~600–1000 compression-argument proof body
on top of facebookresearch's substrate).

### 2.2 Tier 2 — Statement-shape with substrate-gap comment (M5 fallback)

**Triggered if**: compression-argument proof attempt stalls at M5 with a clearly
characterised substrate or technique gap; AEAL discipline preserves this as a
**legitimate mission outcome** per Brief §0 ("capability gaps are first-class
deliverables").

**Predicate body:**

A Lean 4 source file containing:

1. `IsDimIntersectingOf` predicate definition + API (as in Tier 1, §2.1 item 1).
2. q-EKR theorem statement (as in Tier 1, §2.1 item 2).
3. Proof body = `sorry` with **explicit comment** naming the specific blocker, e.g.

   ```lean
   theorem qEKR ... := by
     -- AEAL CAPABILITY GAP: compression-argument step <step-name>
     -- requires <specific lemma / API / type-class> not available in
     -- Mathlib4 v4.29.0 or in the mission-repo substrate. See
     -- capability/<gap-name>.gap.md (filed at M5) for the formal gap analysis.
     sorry
   ```

4. A companion **`capability/<gap-name>.gap.md`** file filed at M5 documenting the
   specific blocker per K_0 §0.2 binary "available / gap" convention.

**Success indicators**: file compiles (predicate + statement are well-typed and the
file `lake build`-succeeds), `#print axioms` includes `sorryAx` but no other
unexpected axiom, gap document filed and committed before M5 close.

**M6-2 manuscript framing**: Tier 2 close is reported as a **partial result** with
the formalization-blocked proof characterised as evidence on AEAL's generality
(negative-evidence direction per `targets/selected.md` transferability hypothesis).

### 2.3 Tier 0 — Predicate-deferred (M5 fallback if even definition stalls)

**Triggered if**: even the `IsDimIntersectingOf` definition + q-EKR statement do not
land at M5 — i.e., M3.1 / M4 substrate stuck below the predicate-definition floor.

**Predicate body:** No Lean source. Mission close records `mission_outcome =
capability_gap_documented` with:

1. `capability/dim_intersecting_predicate.gap.md` — formal documentation of
   why even the predicate could not be defined within window (e.g., type-class
   subtleties on `Submodule R M` for finite fields, missing `Module.finrank` API
   for the specific subspace family, etc.).
2. M6-2 manuscript reframed as **methodology-paper case study** rather than
   formalization paper. Submission target reverts to Stream M companion artifact.

**AEAL framework note**: Tier 0 is the **deepest negative-evidence outcome** and is
the most informative for Stream M's methodology-paper Section 4 worked-example
pairing — it directly tests AEAL's bidirectional-verification claim on the
extreme failure-mode direction.

### 2.4 Cascade-fallback tier-application semantics (variant note)

K_0 mission's H9 two-tier predicate reported **both tiers simultaneously** for one
mathematical result (rigorous_theorem bound + empirical_heuristic bound). Mission 2
applies the same H9 verification-class taxonomy but with **cascade-fallback semantics**:
- Mission 2 reports the **highest tier achieved** at M5 close, not all three.
- Tier 1 is the target; Tier 2 / Tier 0 are deferred-fallbacks invoked only on
  proof / predicate stall.

This is a legitimate H9-taxonomy use within AEAL discipline (no new tier was invented;
all three tiers map onto existing H9 classes per §6 below). The variant **must be flagged
in M6-2 §Appendix B** so the methodology paper's H9 application table records both
mission's tier-application semantics for Stream M Section 4.

**Not a mutation.** Operator-acknowledged in U-MISSION-2-H. Mutation budget 0/1 unchanged.

---

## 3. Parallel artifact — clean q-binomial re-implementation (Path C stretch deliverable)

Per Path C: in parallel with the Tier-1 closed-proof track (using facebookresearch
substrate, CC BY-NC 4.0), a **clean Apache-2.0-compatible re-implementation** of
the minimal q-binomial substrate is developed in the mission repo under
`lean/QBinomialClean/` (or analogous path). This artifact is the **Mathlib4 PR
candidate**.

### 3.1 Parallel-artifact scope

Minimum substrate per `capability/q_binomial.available.md` §Path B:

| Component | Estimated lines | Risk |
|---|---:|---|
| `qBinomial : ℕ → ℕ → ℕ → ℕ` (or `Polynomial ℤ`) via Pascal recurrence | ~50 | LOW |
| `qBinomial_succ_succ`, `qBinomial_zero_*`, `qBinomial_n_zero`, `qBinomial_symm` | ~150 | LOW |
| Subspace-counting bijection `qBinomial q n k = #{V : Subspace (F_q^n) ∣ finrank V = k}` | ~400–800 | **HIGH** (load-bearing for q-EKR if Path B is to also yield a self-contained proof) |
| Optional: q-Vandermonde identity | ~150 | MEDIUM |

**Reference**: `xiangyazi24/AnalyticCombinatorics` (Apache 2.0) for the Pascal-recurrence
spelling; Grinberg textbook `arXiv:2506.00738` (CC BY) for the underlying mathematics.
Both are read-as-reference, not copy-ported.

### 3.2 Parallel-artifact deliverable

The clean substrate file(s) + appropriate Lean docstrings + a Mathlib4-PR-style
header comment (copyright = mission operator, license = Apache 2.0, author and
acknowledgements per Mathlib4 convention).

**Submission timing**: Mathlib4 PR opens after the substrate file passes local
`lake build` against the Mathlib4 contributor toolchain. PR submission **may or
may not occur within the 6-week mission window** — see §4 venue analysis. The
**artifact** is the M6-2 deliverable; the **PR review process** is post-mission
follow-up.

### 3.3 Decoupling from Tier 1 success predicate

Path C explicitly **decouples** the Tier-1 closed-proof deliverable (Path A fork
on facebookresearch substrate) from the parallel artifact (Path B fork on clean
substrate). The Tier-1 success predicate **does not depend** on Path B work
landing. If Path B's subspace-counting bijection stalls (the high-risk component),
the Tier-1 closed-proof remains intact; the parallel artifact is filed as
**partial** with the stalled component flagged.

### 3.4 Parallel-artifact predicate body

**Stretch deliverable (not mission-failing if it stalls)**:

> One or more Apache-2.0-licensed Lean 4 source files in the mission repo under
> a clearly named path (e.g., `lean/QBinomialClean/Basic.lean`) which define
> q-binomial coefficients via Pascal recurrence, prove the standard identities
> (`succ_succ`, `zero_*`, `symm`), and (best-effort) prove the subspace-counting
> bijection. The file(s) compile cleanly against Mathlib4 v4.29.0 with **no
> external CC-BY-NC dependencies** in the import graph.

**Success indicators**: `lake build` succeeds; substrate file's import graph
contains only `Mathlib` + (optionally) other Apache-2.0 / MIT / BSD-licensed
dependencies; `#print axioms` outputs only standard Mathlib4 axiom set per
basic-API lemma.

**Stretch indicator**: subspace-counting bijection lands without `sorry`. If it
does not land by M5 close, the parallel artifact is filed as `lean/QBinomialClean/
README.md` documenting what landed + what didn't, and the Mathlib4 PR is deferred.

---

## 4. Submission target — venue analysis

Per Brief §M2.3 / §M6.3, submission fire is **inside M6-2** (within the 6-week
window closing ~2026-06-28). The CLI surfaces the following venue landscape with
**critical timing constraint flags**:

### 4.1 Conference targets — both candidates BLOCKED in window

| Venue | Last call | Verdict |
|---|---|---|
| **ITP 2026** (Lisbon, July 26–29, 2026) | Abstract Feb 12, 2026 / Full paper Feb 19, 2026 | **BLOCKED** — deadline passed by ~3 months before mission 2 started |
| **CPP 2027** (Mexico City, co-located POPL 2027) | Expected ~September 2026 (TBA) | **Out-of-window** — deadline falls 2–3 months after mission close |

ITP 2026 was the operator's preferred conference per U-MISSION-2-H; CLI flags that
its deadline is **past** at mission start. CPP 2027 is the next viable conference
but its deadline is **post-mission**, so submission fire would happen as Stream
M follow-up, not within M6-2 itself.

### 4.2 Journal targets — Math.Comp viable as primary

| Venue | Style | Verdict |
|---|---|---|
| **Mathematics of Computation (Math.Comp.)** — AMS journal | Rolling submission; accepts formalization papers with mathematical content | **PRIMARY recommended** within M6-2 window |
| **Journal of Automated Reasoning (JAR)** — Springer | Rolling submission; formalization-paper-friendly | **ALTERNATIVE** within M6-2 window |
| **Logical Methods in Computer Science (LMCS)** — open-access | Rolling submission; broad scope | **ALTERNATIVE**, less specific to formalization |
| **arXiv preprint** (`math.CO` cross-list `cs.LO`) | Rolling deposit | Always-available **complement** to journal submission |

### 4.3 Recommended M6-2 submission package

CLI proposal:

1. **Primary journal submission**: Math.Comp formalization paper (~10–18 pages)
   built around the Tier-1 closed-proof file + the parallel-artifact substrate
   (if landed) + AEAL methodology Appendix B (≤ 2 pages per Brief §0).
2. **arXiv preprint**: deposit simultaneously with journal submission.
3. **Mathlib4 PR**: open at M6 if parallel-artifact has compiled cleanly; PR
   review proceeds post-mission. Mathlib4 PR is a **deliverable artifact**
   (citable as a GitHub PR URL even before merge) independent of journal
   acceptance.
4. **CPP 2027 / ITP 2027** (post-mission Stream M follow-up): the same paper or
   an extended/revised version can target one of these venues outside the
   6-week window if operator wishes a conference proceedings appearance.

### 4.4 Operator override option

If operator prefers **conference proceedings within M6-2**, the only available
candidates are workshop venues with rolling submission (e.g., **Lean Together**
talks, **Mathlib monthly** community presentations) which are not refereed
proceedings in the traditional sense. CLI flags this as a venue-degradation
trade-off if operator pushes for in-window conference fire.

**Default in absence of operator override**: Math.Comp + arXiv + Mathlib4 PR
package per §4.3.

---

## 5. Lake / toolchain pinning

Per U-MISSION-2-H decision (4): **`leanprover/lean4:v4.29.0`**.

### 5.1 `lakefile.lean` pin proposal (drafted for M3.1, not yet committed)

```lean
import Lake
open Lake DSL

package qEkr where
  leanOptions := #[`pp.unicode.fun, true]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.0"

-- Path A / Path C fork only — CC BY-NC 4.0; mission-repo-internal use, not
-- copy-ported to clean substrate fork or to any Apache-2.0 PR.
require algcomb from git
  "https://github.com/facebookresearch/algebraic-combinatorics.git" @ "main"

@[default_target]
lean_lib QEkr where
  -- Tier 1 closed-proof file lives here.

lean_lib QBinomialClean where
  -- Path C clean re-implementation; Apache-2.0; Mathlib4 PR candidate.
  -- MUST NOT import from `algcomb` namespace.
```

### 5.2 Toolchain pin caveat

`facebookresearch/algebraic-combinatorics` pins **Lean 4.28.0** + **Mathlib v4.28.0**.
Lean toolchain version skew between facebookresearch (4.28.0) and the mission repo
(4.29.0) may require:

- **Option (i)**: pin mission repo to `v4.28.0` to match facebookresearch dep
  (preferred for first-build cleanness, costs the newer Mathlib4 features).
- **Option (ii)**: pin to `v4.29.0` and accept that facebookresearch dep may need
  a fork or update PR to compile against the newer toolchain.
- **Option (iii)**: defer the toolchain pin to M3.1 first-build and decide based
  on empirical build results.

**CLI recommendation**: option (iii) — defer to M3.1 build evidence. Toolchain
choice does not load-bear on M2.3 / M2.4; it's an M3.1 implementation detail.

---

## 6. H9 verification class assignments

Per Brief §0 (H9 inheritance from K_0): each tier of the cascade carries an
explicit H9 verification class.

| Tier | Lean artifact at M5 close | H9 verification class |
|---|---|---|
| **Tier 1** | Closed-proof file: predicate + statement + body, no `sorry`, no non-standard axioms | **`proven_corollary`** (Lean 4 closed proof against Mathlib4 kernel; verifier = Lean elaborator on pinned toolchain) |
| **Tier 1, axiom-named auxiliary lemmas** | Any `axiom`-introduced step beyond Mathlib4 standard axiom set | **`field_standard_practice`** with cited published reference (per `targets/selected.md` original predicate language) |
| **Tier 2** | Predicate + statement, body = `sorry` with substrate-gap comment | **`rigorous_theorem`** (statement-grade; theorem-statement is mathematically well-defined and well-typed) plus **`field_standard_practice`** for the named-but-unproven body |
| **Tier 0** | No Lean artifact; capability gap document | **No verification class** (treated as outcome documentation per Brief §0; H9 does not apply since no claim is being verified) |

### 6.1 H9 sub-key population template (for M5 close)

Each tier's predicate body, if landed, will populate the `independent_verifier_result`
seven-field schema (inherited from K_0 mission):

```yaml
independent_verifier_result:
  technique: "Lean 4 elaboration + Mathlib4 kernel typecheck (Tier 1) | mathematical statement well-typedness (Tier 2)"
  classification: "<H9 class per table above>"
  verifier_identity: "<Lean toolchain SHA + Mathlib4 SHA + mission repo SHA>"
  verifier_method: "lake build && lean --version && #print axioms <theorem_name>"
  scope: "<file path + Lean theorem name + Mathlib4 module dependency closure>"
  limitations: "<any axiom-named auxiliary lemmas; any out-of-scope simplifications; any compression-step shortcuts>"
  reproducibility: "<git SHA + lakefile pin + reproducer command>"
  date_of_verification: "<JST timestamp at M5 close>"
```

Sub-key population happens at **M5 close**, not at M2.3 / M2.4 freeze.

---

## 7. M3 / M4 / M5 / M6 implications

### 7.1 M3.1 substrate work (week 3–4)

- Lake project setup with the lakefile per §5.1.
- `IsDimIntersectingOf` predicate + API (~50–150 lines).
- Compression-argument harness scaffolding (key lemmas declared with `sorry`
  bodies for top-down development).
- Parallel `lean/QBinomialClean/` directory creation with the basic Pascal-recurrence
  q-binomial definition + first identity proofs.

### 7.2 M3.2 canonical proof execution (end of week 4 / start of week 5)

- Compression-argument main body filled in, leaning on facebookresearch's q-binomial
  + subspace-counting where Path A fork applies.
- Mid-point M3.2 surface to operator with first compiling closed-proof file.

### 7.3 M4 dry-run / verification (week 5)

- Full `lake build` reproducible from fresh clone.
- `#print axioms qEKR` audited to confirm only standard Mathlib4 axiom set is in use.
- Independent verification step (per H7): rebuild from clean container or VM if available.

### 7.4 M5 ratification / fallback decision (week 5)

- If Tier 1 closed-proof landed: ratify; proceed to M6 manuscript.
- If proof stalled at a characterised step: switch to Tier 2; file capability gap
  doc; proceed to M6 manuscript with partial-result framing.
- If predicate or statement did not land: switch to Tier 0; close mission with
  `capability_gap_documented` outcome.

### 7.5 M6 manuscript + submission (week 6)

- Math.Comp submission + arXiv deposit per §4.3.
- Mathlib4 PR opened if Path C parallel artifact landed.
- Stream M coordination: M6-2 worked example pair-anchors Section 4 with K_0
  PSLQ-class numerical-verification example.

---

## 8. Mutation budget statement

- **Budget at M2-2: 0 / 1, unchanged through this freeze.**
- The M2.3 success-predicate construction is **M2.3's own output**, not a strategy
  mutation. The Tier 0/1/2 cascade-fallback structure operationalises the
  `targets/selected.md` "closed-proof Lean 4 file ... with all auxiliary lemmas
  either established or explicitly axiom-named per H9 verification class taxonomy"
  language without changing the underlying scope.
- The method-family reinterpretation (eigenvalue → compression) is **M2.2 normal
  output** per H7 functional-verification discipline, not a mutation (per
  `capability/intersecting_substrate.available.md` §Mutation-budget-impact).
- Cascade-fallback tier semantics differing from K_0's simultaneous-reporting tier
  semantics is **operator-acknowledged as not-a-mutation** (same H9 taxonomy,
  different tier-application); flag in M6-2 §Appendix B.

### 8.1 Mutation-budget invocation contingencies (informational)

The mutation budget **WOULD** invoke if any of the following occurred between
this freeze and M5:

- Operator downgrades the Mathlib4 PR promise from "stretch deliverable" to
  "explicitly out of scope" (would mutate `targets/selected.md` "concrete Mathlib4
  PR contribution as citable deliverable").
- Operator switches primary proof method away from compression-argument after
  M3.1 has committed to it (method-family is fine; switching methods mid-mission
  would mutate).
- Operator changes the strategic direction away from D-4 q-EKR formalization
  (would mutate the M1.3 selection itself; this is the maximum-impact mutation).

None of these are currently planned. Surfaced informationally so the budget-invocation
trigger conditions are explicit.

---

## 9. Companion-stream coordination (current state)

| Stream | Phase at M2.3 surface | Coordination at M6-2 close |
|---|---|---|
| **Stream S** (K_0 Snapp submission) | Watching — Technical Check / editor / referee pending | Stream S priority override applies if referee response arrives during M3–M6 |
| **Stream P** (K_0 housekeeping) | Mostly complete; ORCID retro update on Zenodo Items 5/13/28 operator-reserved | Non-blocking; operator-handled at convenience |
| **Mission 2** (this) | **M2.3 success predicate drafted; awaiting operator ratification → M2.4 Gold Freeze G2-2** | M6-2 deliverable package per §4.3 |
| **Stream M** (methodology paper) | M.1 outline drafted; M.2 prose drafting NOT YET STARTED (gated on operator ratification) | M6-2 closure provides Section 4 q-EKR worked example pairing with K_0 PSLQ |

---

## 10. Inheritance and prohibitions (from mission 2 brief §0, §8 — restated)

- H1–H11 operative.
- No K_0 re-derivation; no "we extend our prior K_0 work to ..." framing.
- Appendix B AEAL methodology note ≤ 2 pages in M6-2 manuscript.
- Submission fire inside M6-2 (per §4.3 above).
- Blacklisted venues: NNTDM (LLM ban), Experimental Mathematics (7 no-reason rejections),
  Acta Arithmetica (unavailable while K_0 submission 260423 holds), Ramanujan Journal
  allowable but not preferred (K_0 manuscript in review).
- Repo visibility: PRIVATE during mission; flip to PUBLIC at `gold/M6-2` Zenodo deposit.

---

## 11. Outstanding open questions (for operator confirmation before M2.4 fire)

1. **Venue confirmation**: Math.Comp as primary M6-2 journal target acceptable, given ITP 2026 and CPP 2027 timing constraints in §4.1–4.3? Alternative: operator selects JAR / LMCS / other.
2. **Toolchain pin firm at v4.29.0, or defer to M3.1 first-build evidence per §5.2 option (iii)?**
3. **Parallel artifact (Path B) priority**: is the subspace-counting bijection a "stretch" component (CLI default) or "must-have" (would elevate M3.1 risk)?
4. **Mathlib4 PR open timing**: at M5 ratification (CLI default; only if file passes local `lake build`) or held until M6-2 close to bundle with manuscript announcement?

CLI recommends defaults across all four; operator overrides at will.

---

## 12. Next milestone

**M2.4 Gold Freeze G2-2**:

- After operator ratifies this draft (with any amendments), CLI commits the final
  version, then tags `gold/M2-2` at the freeze commit per Brief §M2.4.
- Tag-applying mechanism: GitHub REST API (Workaround B) per tooling doc, since
  annotated tags trigger the PowerShell harness crash on `git tag -a -m`.

After `gold/M2-2`: **M3.1 substrate work begins** per §7.1.

---

## Appendix A — Cross-reference index

| Topic | Authoritative document |
|---|---|
| Target selection rationale | `targets/selected.md` (M1.3 freeze) |
| q-binomial substrate audit | `capability/q_binomial.available.md` |
| Proof-strategy substrate audit | `capability/intersecting_substrate.available.md` |
| Cross-cutting M2.2 findings | `capability/README.md` |
| Literature ledger | `literature/ledger.md` (16 entries) |
| Heuristics catalogue | `methodology/heuristics.md` |
| Mutation log | `mutation_log/M1-2.md` (M1), `mutation_log/M2-2.md` (M2, filed alongside this draft) |
| Tooling workarounds | `tooling/git_multi_line_input_workaround.md` |

