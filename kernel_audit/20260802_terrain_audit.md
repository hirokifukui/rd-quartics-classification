# Kernel audit -- Gap/BMThm7Terrain.lean, claude.ai independent audit, logos, 2026-08-02
# toolchain: leanprover/lean4:v4.31.0-rc1 / mathlib pin: d568c8c
# Freeze: Terrain.STATEMENT_FREEZE_20260802.lean md5 6ac28097a863c7ecad34b0626b5b6eca;
#   statement layer 10 segments verbatim in order; decl census 10 = 10; banned scan 0.
# CC job terrain_20260802 (single thread, ~100m, the largest delegation of the series;
#   log buffered to zero bytes during the run -- the artifact, not the log, tracked progress).
# Content: the normalization bridge demanded by external review 7. rootQuartic_expand
#   (symmetric-coordinate expansion), quadratic splitting criteria in both directions,
#   three K-derivedness transports (C-multiple, horizontal shift, variable scaling),
#   kderived_of_terrain (terrain point -> {0,1,a,b} normal form; explicit split roots
#   from z, w via Rq/den^2 and Sq/den^2), terrain_of_kderived (normal form -> terrain:
#   rational critical point, four-case non-root argument via distinctness, shift/scale,
#   e3-extraction, den != 0 automatic from nonzero roots, z/w reconstruction from root
#   differences), and conjecture1_iff_terrain: Conjecture1_normal <-> no nondegenerate
#   terrain point. Residual compiler output: unused-simp-arg lints only (shared simp sets
#   across six proofs, deliberate per CC's report; no correctness content).
# lake build 8507; checkdecls 128/128.

## lake env lean Gap/BMThm7Terrain.lean (exit=0; axiom lines)
'BMThm7Terrain.rootQuartic_expand' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Terrain.quadratic_splits_of_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Terrain.exists_sq_of_quadratic_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Terrain.KDerived_C_mul_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Terrain.KDerived_shift_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Terrain.KDerived_scale_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Terrain.kderived_of_terrain' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Terrain.terrain_of_kderived' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Terrain.conjecture1_iff_terrain' depends on axioms: [propext, Classical.choice, Quot.sound]
