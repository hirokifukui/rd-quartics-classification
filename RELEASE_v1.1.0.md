# v1.1.0 — companion-manuscript release (2026-08-04 JST)

No changes to the Lean theorem statements or kernel proofs relative to v1.0.4;
all line pins remain valid (no .lean diff, line numbers unchanged).  This
release accompanies the manuscript submitted to the Annals of Formalized
Mathematics and adds its remaining computational certificates:

- `scripts/rank/m33_saturation.{sage,captured.log}`: saturation of (-35,240)
  on the E_33 minimal model, index 1 (generator claim of Theorem ranks(a)).
- `scripts/rank/s21_e0_saturation.{sage,captured.log}`: rank bounds (1,1) and
  saturation of (-8,36) on E_0, index 1 (Theorem ranks(b)).
- `scripts/sage/guy_multiples.{sage,captured.log}`: a(2P)–a(5P), both gates at
  each multiple, identification of the four printed Guy (1989) pairs (the
  fourth via the a <-> 1/a exchange), and the Klamkin translate check.
- `scripts/sage/bk_errata_576i3.{sage,captured.log}`: the internal
  inconsistency of rows n=2,3 of the Buchholz--Kelly (1995) table (printed
  points = -2Q,-3Q against printed a-values = +2Q,+3Q), at the true printed
  values, orientation-independently.
- `scripts/CERTIFICATES.md`: index rows for the four scripts; the
  terrain-crosscheck row corrected to the measured 42 CHECK lines.
- `Gap/PROVENANCE.md`: the working layout is now explicitly attributed to the
  authors' revised version dated June 21, 2009 (Section 2.2.4 typographically
  identical to the published version; quotations remain in the published
  wording).
- `README.md`: scope note updated (the Guy/BK/saturation scripts are now in
  scope); pins retargeted to v1.1.0.

A version DOI is minted by Zenodo on publication of this release;
`CITATION.cff` (currently carrying the concept DOI) is updated in the
immediately following commit.  Fail-closed tag-content line-pin audit,
digest-pinned CAS re-execution, and the per-declaration axiom assertion over
137 checked declarations are as in `RELEASE_v1.0.4.md`.

Conjecture 1 itself remains open --- this repository maps its boundary, it
does not resolve it.
