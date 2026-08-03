# REVIEW_HISTORY — external AI review rounds (2026-08-01 .. 2026-08-03)

Thirteen external AI review rounds were conducted on this repository between
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

Reviewer misreadings corrected along the way (stale revision, live-state
claims, one line-number claim) are recorded in `TRANSFER_MANIFEST.md`; the
standing rule is that deployment and artifact state are established only by
direct measurement.
