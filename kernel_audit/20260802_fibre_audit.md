# Kernel audit -- Gap/BMThm7Fibre.lean, claude.ai independent audit, logos, 2026-08-02
# toolchain: leanprover/lean4:v4.31.0-rc1 / mathlib pin: d568c8c
# Freeze: Fibre.STATEMENT_FREEZE_20260802.lean md5 0d1cd18c4ecd695f1d353a16c79842b8;
#   statement layer 6 segments verbatim in order; decl census 8 = 8; banned scan 0.
# CC jobs: fibre_20260802 (killed by the 64k output-token cap, file untouched) and
#   fibre2_20260802 (relaunched with incremental-edit output discipline; single thread;
#   honest deviation note: namespace qualification BMThm7Transcript.translate in rw only).
# Content: review-12's central demand -- the fibre correspondence, closed in the kernel.
#   D0/Dplus/Dminus defined via the transcript's own bmTranslate (the disjunct at a
#   critical point = the vertical translate splits). D0_iff_disc: q-q(0) = X^2*(monic
#   quadratic), disc = sigma1^2-4*sigma2. cleared_model_iff: v = den*t bijection between
#   the chart cover and vtilde^2 = Q4 (the C0 / cleared-model separation). Dplus/Dminus_iff
#   (the radicand derivation): (X-x0)^2-factorization whose linear-coefficient match is
#   q'(x0)=0, disc = sigma1(sigma1 -+ rho)/4, clearing 4*den^2*disc = gamma_pm; signs,
#   denominators, and both clearing directions inside the kernel statements.
#   fibre_correspondence bundles the three equivalences. Independent CAS certification:
#   terrain_crosscheck CHECKs Dplus/Dminus_critical_point/_factorization/_disc_identity,
#   Dpm_gamma_clearing (43 CHECKs all True).
# lake build 8508; checkdecls 137/137.

## lake env lean Gap/BMThm7Fibre.lean (exit=0)
'BMThm7Fibre.D0_iff_disc' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Fibre.cleared_model_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Fibre.Dplus_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Fibre.Dminus_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Fibre.fibre_correspondence' depends on axioms: [propext, Classical.choice, Quot.sound]
