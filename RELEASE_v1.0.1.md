# v1.0.1 — the fibre correspondence, closed (2026-08-02)

This release closes the one substantive gap disclosed in the v1.0.0 correction
note: the derivation from the three disjuncts of the terrain analysis to the
three double covers, previously stated as ordinary mathematics with a
"granted" step, is now a kernel theorem with an independent CAS certification.

## Added over v1.0.0

- **`Gap/BMThm7Fibre.lean`** (9 declarations, standard three axioms): the
  disjuncts `D0`, `Dplus`, `Dminus` are *defined* through the transcript's own
  vertical-translate operator (`bmTranslate`); `fibre_correspondence` proves
  that over `den != 0` with the splitting witness `z^2 = Rq`, each disjunct is
  equivalent to the rational-square condition of its cover — `Q4` for the
  cleared model (with `cleared_model_iff` the explicit `v = den*t` bijection
  separating the chart cover from the cleared model), and the actual radicands
  `gamma_pm = s1n(s1n -+ z)` for `C_pm` (factorization `(X-x0)^2(X^2+BX+C)`,
  discriminant `sigma1(sigma1 -+ rho)/4`, clearing by the nonzero square
  `4 den^2`).
- **CAS**: `terrain_crosscheck.sage` extended with the same identities as
  symbolic checks over `QQ[s1,s2,rho]/(rho^2-(9s1^2-32s2))`; 43 CHECK lines,
  all True-normative; log regenerated and re-diffed in CI.
- **CI hardening**: the Sage container is digest-pinned; any `CHECK ... False`
  fails the run; the CHECK count is gated; deploy failures are real failures.
- **Blueprint**: formal definitions of the disjuncts; the fibre-correspondence
  proposition rewritten over the kernel theorems; the must-lift and Hilbert
  statements bounded to exactly what is proved; geometric-integrality and
  base-change proofs tightened; T9 heading corrected to REFUTED over Q.
- **Provenance**: the v1.0.0 self-quotation of an external review score is
  withdrawn (reviewer scores are opinions, not evidence); v1.0.0 is annotated
  and left immutable.

Kernel: 137 blueprint declarations checked; the load-bearing theorems close on
exactly `[propext, Classical.choice, Quot.sound]`, asserted per-declaration by
CI.  Everything else is as in `RELEASE_v1.0.0.md`.

Known boundaries: Conjecture 1 itself remains open — this repository maps its
boundary, it does not resolve it.
