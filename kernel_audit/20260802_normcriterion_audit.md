# Kernel audit -- Gap/BMThm7NormCriterion.lean, claude.ai independent audit, logos, 2026-08-02
# toolchain: leanprover/lean4:v4.31.0-rc1 / mathlib pin: d568c8c
# Freeze: NormCriterion.STATEMENT_FREEZE_20260802.lean md5 52bfa4fe929caf35acca0676754626a9;
#   statement layer 9 segments verbatim in order; decl census 8 = 8; banned scan 0.
# CC job normcriterion_20260802 (single thread; no file deviations; correctly disclaimed
#   pre-existing lake-manifest/terrain changes as not its own).
# Content: review-6's two bridges. (a) C-pm: step_over_layer (layer Kummer step under
#   r-nonsquare, degenerate cases absorbed) + layer_square_norm (coordinate norm,
#   g0^2-g1^2 r = (p^2-q^2 r)^2, no Galois action) + gamma_not_square_multiquadratic
#   (both signs; consumes I2_R2 and n2Q4_not_square). (b) S-integrality Q-level:
#   Rq/Sq/RqSq_not_square by value specialisation (not_square_of_value; witnesses
#   2480/876/171696 -- negativity is impossible here: both discriminant-type forms are
#   PSD on the chart since the quartic has four real roots, so the eight-exclusion
#   technique of FunctionField does not apply and value-nonsquareness replaces it).
# lake build 8506; checkdecls 119/119.

## lake env lean Gap/BMThm7NormCriterion.lean (exit=0)
'BMThm7NormCriterion.I2_R2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7NormCriterion.not_square_of_value' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7NormCriterion.Rq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7NormCriterion.Sq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7NormCriterion.RqSq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7NormCriterion.step_over_layer' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7NormCriterion.layer_square_norm' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7NormCriterion.gamma_not_square_multiquadratic' depends on axioms: [propext, Classical.choice, Quot.sound]
