# Kernel audit -- Gap/BMThm7SquareClass.lean, claude.ai independent audit, logos, 2026-08-02
# toolchain: leanprover/lean4:v4.31.0-rc1 / mathlib pin: d568c8c
# Provenance: statements FROZEN by claude.ai pre-delegation (reference: kinko submission_regs_AFM_20260801/
#   SquareClass.STATEMENT_FREEZE_20260802.lean, md5 d743c7150df55ad51df7f4ae2130fb52); tactics by
#   Claude Code job squareclass_20260802 (single-thread, ~35m; biquadratic_transfer was the heavy piece).
# Freeze verification: statement layer -- all 5 segments verbatim in order; decl census 4 = 4.
# Content: the square-class transfer demanded by external review 4 -- one quadratic step (step),
#   the biquadratic master case split (biquadratic_transfer, degenerate cases absorbed), and the two
#   application theorems consuming the eight BMThm7FunctionField exclusions: Q4 and -2Q4 are not
#   squares of any span element in ANY field containing Q(a,b) with sqrt(Rq), sqrt(Sq).
# NOTED DEVIATION (accepted, self-reported by CC): a scratch file Gap/zzTestCZ.lean was created to
#   test the CharZero instance and deleted within the session; absent from git status. No other file
#   touched. (Letter-level deviation from 'touch no other file'; transparently flagged in CC's report.)
# banned-token scan: 0. lake build: 8505 jobs. checkdecls: 111/111.

## lake env lean Gap/BMThm7SquareClass.lean (exit=0)
'BMThm7SquareClass.step' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7SquareClass.biquadratic_transfer' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7SquareClass.Q4_not_square_multiquadratic' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7SquareClass.n2Q4_not_square_multiquadratic' depends on axioms: [propext, Classical.choice, Quot.sound]
