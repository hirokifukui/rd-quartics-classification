# REVIEW_HISTORY — external AI review rounds (2026-08-01 .. 2026-08-03)

Seventeen external AI review rounds were conducted on this repository between
2026-08-01 and 2026-08-03.  Scores assigned by reviewers are external opinions
and are not recorded here or anywhere in this repository as evidence; what
follows is the substantive arc.

- **Rounds 1–5**: structural review of the resubmission repository — evidence
  management for Chapter 4 (certificates, claim map, SHA-256 inventory),
  fidelity and classification kernel files, terrain scripts made public.
- **Round 6**: two mathematical bridges demanded — the biquadratic square-class
  transfer does not apply to layer elements, and the splitting cover's own
  integrality was uncertified.  Closed by `BMThm7SquareClass` and
  `BMThm7NormCriterion` (layer step, coordinate norm, value-specialisation
  nonsquareness).
- **Round 7**: the square-class table's radicand column was literally false
  (conjugate radicands vs. their norm class): corrected and withdrawn.  The
  normalization bridge (Conjecture 1 vs. terrain points) demanded: closed by
  `BMThm7Terrain.conjecture1_iff_terrain`.
- **Rounds 8–9**: fibre-correspondence formalisation, geometric-integrality
  statement alignment, biquadratic criterion lemma, CAS re-execution CI.
- **Round 10**: reviewer reported the site live; direct measurement showed
  Pages had never been enabled (the second reviewer misreading of live state;
  cf. round 6's stale-revision misreading).  Enabled and verified directly.
- **Rounds 11–12**: the radicand derivation (disjuncts to covers) identified
  as stated-but-unproved ("granted"), and the v1.0.0 release found to quote an
  external score as if it were evidence.  Closed by `BMThm7Fibre`
  (`fibre_correspondence` and the D-predicates defined through the
  transcript's own translate operator), plus symbolic CAS certification;
  the release self-quotation withdrawn, v1.0.0 annotated and left immutable,
  v1.0.1 released.
- **Round 13**: mathematics assessed as closed; remaining findings were
  release-identity synchronisation, audit-document hygiene (this file is part
  of the response), and prose precision in Chapter 4 — all addressed.

- **Round 14**: the release-provenance split was correctly identified (the
  v1.0.1 tag predates the round-13 fixes): resolved by v1.0.2, with all
  references re-synchronised.  The round's table of "wrong" line-pinned
  numbers was refuted by direct measurement against the tag content (all ten
  pins exact; e.g. `Master.lean` has 656 lines, not 604) --- the fourth
  reviewer misreading of artifact state; a line-pin audit was added to CI so
  that this class of dispute is settled mechanically.  The splitting surface
  received an explicit scheme model and a generic-to-global integrality
  argument; the review-response manifest entries were archived.

- **Round 15**: the line-number table was repeated against v1.0.2 and a
  retraction of the round-14 record demanded.  Adjudicated against the public
  artifact itself: for the immutable v1.0.2 tag, the local objects and the
  files served by GitHub raw are byte-identical (matching SHA-256), with
  `Master.lean` at 656 lines (`theorem thm7prime` beginning exactly at L619),
  `fibre_correspondence` at L293 and `not_T9_bridge_Q` at L489 --- exactly the
  pinned values; the round's table matches a much older revision of the files.
  Anyone may verify in one click:
  `https://raw.githubusercontent.com/hirokifukui/rd-quartics-classification/v1.0.2/<path>`.
  The round's valid finding is credited and fixed: the pin-audit CI had a
  fail-open path (SKIP when a tag was unfetchable) and no tag trigger; it now
  checks the working tree fail-closed on every branch and tag build.  The
  branch-divisor phrasing was corrected to odd-valuation ramification, and the
  release wording to "no changes to Lean statements or kernel proofs".

- **Round 16**: the round-15 line-number critique was retracted by the
  reviewer after re-reading the tag-pinned sources (656 lines, `thm7prime` at
  L619 confirmed), closing that dispute in agreement with the raw/SHA-256
  adjudication.  The round's remaining findings were release engineering, two
  of them valid and fixed: the round-15 audit and exposition corrections
  postdated the v1.0.2 tag (resolved by v1.0.3), and the pin audit did not use
  the extracted tag on branch builds --- it now verifies each link against its
  tag's actual content via `git show`, fail-closed, with the atomic
  commit-plus-tag push making the tag visible to its own release build.

- **Round 17 (closure)**: the reviewer confirmed that every substantive
  finding of the arc is closed at v1.0.3 --- the fail-closed tag-content pin
  audit succeeding on the tag's own push, the hardened CAS gates, and the
  identity synchronisation --- and assessed the release at the top of its own
  declared scope, with the limitation stated exactly as this repository states
  it: the score concerns the mathematical, formal and computational claims
  actually made, together with their audit, reproducibility and release
  integrity; it does not mean Conjecture 1 is resolved, which the release
  itself declares open.

Reviewer misreadings corrected along the way (stale revision, live-state
claims, two rounds of line-number claims) are recorded in `TRANSFER_MANIFEST.md`; the
standing rule is that deployment and artifact state are established only by
direct measurement.
