# Kernel audit -- Gap/BMThm7FunctionField.lean, claude.ai independent audit, logos, 2026-08-02
# toolchain: leanprover/lean4:v4.31.0-rc1 / mathlib pin: d568c8c
# Provenance: statements FROZEN by claude.ai pre-delegation (reference: kinko submission_regs_AFM_20260801/
#   FunctionField.STATEMENT_FREEZE_20260802.lean, md5 f90b27e6ef40787092f79d9c24a31028); tactics by
#   Claude Code job functionfield_20260802 (single-thread, ~7m, exit 0).
# Freeze verification: statement layer -- all 17 segments verbatim in order; decl census 26 = 26.
# Content: kernel replacement of the Ch4 [MC] function-field step at the sigma3=0 chart level:
#   specialisation principle (sq_eval_nonneg), UFD/integrally-closed square descent (square_descent),
#   eight non-squareness verdicts in Q(a,b) consuming BMThm7Boundary negativity certificates.
# Related comment-only edit: BMThm7Boundary.lean header 'remains [MC]' -> 'kernel-proved in
#   BMThm7FunctionField.lean' (same adjudicated category as the Master amendments; md5 -> 2f94c36c...;
#   re-audit: 14 decls, 0 outside std-3, footprints unchanged).
# git tripwire: only intended files. banned-token scan: 0. lake build: 8504 jobs. checkdecls: 106/106.

## lake env lean Gap/BMThm7FunctionField.lean (exit=0)
'BMThm7FunctionField.evalAB_den2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.evalAB_s1n2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.evalAB_s2n2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.evalAB_Rq2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.evalAB_Sq2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.evalAB_Q42' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.sq_eval_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.square_descent' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.Q4_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.Q4Rq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.Q4Sq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.Q4RqSq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.n2Q4_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.n2Q4Rq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.n2Q4Sq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7FunctionField.n2Q4RqSq_not_square' depends on axioms: [propext, Classical.choice, Quot.sound]
