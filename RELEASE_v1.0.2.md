# v1.0.2 — identity synchronisation and audit hygiene (2026-08-03 JST)

No changes to the Lean theorem statements or kernel proofs relative to v1.0.1
(whose kernel closure of the fibre correspondence stands); the ordinary
mathematical exposition was strengthened, and this release makes the frozen
artifact and its own self-description agree.

- README, `CITATION.cff` (version 1.0.2), release notes and all line-pinned
  theorem references now point at **this** tag; the v1.0.1 tag's internal
  README/CITATION still described v1.0.0 --- that provenance split is resolved
  here.  Dates are JST (UTC+9).
- **Line-pin audit in CI**: every line-pinned reference in the README is now
  mechanically verified against the pinned tag's file content on every build
  (the pinned line must begin the named declaration).  Direct measurement also
  re-confirmed that all ten v1.0.1 pins were exact against the v1.0.1 content.
- Audit-document hygiene: reviewer scores, self-assessments and credential
  information removed from the public manifest; the review narrative lives in
  `REVIEW_HISTORY.md`; the detailed response records are archived verbatim in
  `archive/MANIFEST_REVIEW_RESPONSES_202608.md`; `TRANSFER_MANIFEST.md` now
  records migrations, hashes and the currently authoritative state.
- Chapter 4: explicit scheme model for the splitting surface
  ($S_{U}=\mathrm{Spec}\,\mathcal O(U_B)[z,w]/(z^2-R_q,w^2-S_q)$) with a
  generic-to-global integrality argument (free module, torsion-free, embeds in
  the generic degree-four field); cover models, self-contained base-change
  proof, and exact-hypothesis proposition titles per reviews 13--14.

Kernel: 137 declarations checked, load-bearing theorems on the standard three
axioms, per-declaration CI assertion; two-system CAS with digest-pinned
re-execution.  Conjecture 1 itself remains open --- this repository maps its
boundary, it does not resolve it.
