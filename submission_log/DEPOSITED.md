# DEPOSITED — q-EKR Tier-2 Zenodo record

**Minted 2026-06-07.** The q-EKR Tier-2 artifact (formalized **statement** + documented
capability gap — **NOT a proof**) is live on Zenodo.

| Field | Value |
|-------|-------|
| Record (version) DOI | **10.5281/zenodo.20575745** — <https://doi.org/10.5281/zenodo.20575745> |
| Concept DOI | **10.5281/zenodo.20575744** — <https://doi.org/10.5281/zenodo.20575744> |
| Record page | <https://zenodo.org/records/20575745> |
| Resource type | Preprint (publication/preprint) |
| License | CC-BY-4.0 |
| Creator | Papanokechi · Independent Researcher · ORCID 0009-0000-6192-8273 |
| Version | 1.0 |
| Repo snapshot | commit `5b1e47d` (branch main), repo now PUBLIC |

## Files on the record (integrity-verified against DEPOSIT_MANIFEST.md)
| File | Size | MD5 | Manifest match |
|------|------|-----|----------------|
| `qekr_substrate.gap.md` | 13216 | `4f509c65c426dc7c5917738b4d77de4a` | ✅ matches manifest |
| `qekr-tier2-source.zip` | 105659 | `8e5e41ca1cb691b1d772deed1b6abb69` | clean `git archive HEAD` (no `.lake`) |
| `DEPOSIT_MANIFEST.md` | 4567 | `821da9feadddf2bf820f6e61abf2d1ba` | self |

## Metadata verification (post-mint, walkthrough §C.6)
- ✅ Title states "…statement … with a documented Mathlib substrate gap" — no "proof of…".
- ✅ Description carries the 3 missing substrates, the `sorryAx` honesty signal, and the venue-reset note.
- ✅ related_identifiers: GitHub repo (isSupplementTo) + K_0 concept DOI 10.5281/zenodo.20246707 (references).
- ✅ Creator `Papanokechi`, ORCID, Preprint, CC-BY-4.0 — all as drafted.
- ✅ Public GitHub repo resolves (HTTP 200), so the supplement link is live.

## Errata flag (operator may fix via Zenodo "Edit" — metadata-only, DOI preserved)
- ⚠ `custom.code:programmingLanguage` published as **"Python"**; the artifact is **Lean 4**.
  The metadata draft requested Lean; the live record shows Python (Zenodo form default).
  This is cosmetic and does not affect the DOI or the honesty framing. To correct: open the
  record → **Edit** → set Programming language to **Lean** → **Save/Publish** (no new
  version, DOI unchanged).

> Recorded post-deposit; commit + push this file and the README DOI lines as the C.5
> "record the DOI" follow-up. The deposited source zip reflects the pre-mint snapshot
> (`5b1e47d`) — it cannot contain its own DOI (chicken-and-egg); this file is the
> authoritative in-repo DOI record.

---

**Added to the repository in v1.1 (2026-09-30).** This file was written on 2026-06-07,
after the v1.0 mint, but was never committed; v1.1 adds it unchanged above this line.
The programming-language erratum above has since been corrected on the record: it reads
**Lean** (Zenodo API, checked 2026-09-30). The v1.0 statement described here lacked the
hypothesis `2 * k ≤ n`; see `CHANGES_v1.1.md`.
