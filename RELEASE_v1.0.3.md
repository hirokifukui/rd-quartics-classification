# v1.0.3 — the audit closes over itself (2026-08-03 JST)

No changes to the Lean theorem statements or kernel proofs relative to v1.0.2;
this release brings the final audit-mechanism and exposition corrections of
review rounds 15--16 inside the frozen artifact, ending the tag/main divergence.

- **Line-pin audit, completed**: the audit now fetches each pinned link's tag
  and verifies the pinned line inside that tag's actual content (`git show`),
  failing closed when a tag is unresolvable --- on branch builds and tag builds
  alike.  (The previous working-tree variant did not use the extracted tag, as
  round 16 correctly observed.)  The workflow triggers on tag pushes, and the
  release flow pushes commit and tag atomically so the audit can see the tag of
  its own release commit.
- Round 15's line-number critique was retracted by the reviewer in round 16
  after re-reading the tag-pinned sources (`Master.lean`: 656 lines,
  `thm7prime` at L619) --- consistent with the byte-level raw/SHA-256
  adjudication recorded in `REVIEW_HISTORY.md`.
- Blueprint: the branch locus of each cover is supported on the zero locus of
  its radicand, with ramification exactly at the codimension-one points of odd
  radicand valuation (correcting the earlier zero-divisor phrasing).
- Release wording standard: "no changes to Lean statements or kernel proofs",
  never "no mathematical content changes", when exposition is strengthened.

Kernel: 137 declarations checked, load-bearing theorems on the standard three
axioms, per-declaration CI assertion; two-system CAS with digest-pinned
re-execution; known upstream node20 warning documented.  Conjecture 1 itself
remains open --- this repository maps its boundary, it does not resolve it.
