# v1.0.4 — first archival release (2026-08-03 JST)

No changes to the Lean theorem statements or kernel proofs relative to v1.0.3.
This release exists to be the first Zenodo-archived version of the repository:
the GitHub integration was enabled after v1.0.3, and archival applies only to
releases published thereafter.

- `.zenodo.json` supplies the archival metadata (title, creator with ORCID,
  Apache-2.0, keywords, the public blueprint as a related identifier).
- A version DOI and a concept DOI are minted by Zenodo on publication of this
  release; `CITATION.cff` and the README badge are updated with the DOI in the
  immediately following commit.
- Everything else is as in `RELEASE_v1.0.3.md`: fail-closed tag-content
  line-pin audit (verified on the tag's own build), digest-pinned CAS
  re-execution, per-declaration axiom assertion over 137 checked declarations.

Conjecture 1 itself remains open --- this repository maps its boundary, it
does not resolve it.
