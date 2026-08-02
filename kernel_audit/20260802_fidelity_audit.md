# Kernel audit -- Thm7Prime/Fidelity.lean (Option ii), claude.ai independent audit, logos, 2026-08-02
# toolchain: leanprover/lean4:v4.31.0-rc1 / mathlib pin: d568c8c
# Provenance: statements FROZEN by claude.ai pre-delegation (reference: kinko submission_regs_AFM_20260801/
#   Fidelity.STATEMENT_FREEZE_20260802.lean, md5 24b2d98d777cb3c0fe644f36c29fd317); tactic filling by
#   Claude Code job fidelity_20260802 (single-thread, 28m28s, exit 0); freeze verified post-hoc:
#   all 15 inter-sorry segments of the frozen reference appear verbatim and in order in the final file.
# git tripwire at audit: only Thm7Prime/Fidelity.lean new; Master.lean md5 unchanged (a1b1d545...).
# banned-token scan (sorry/native_decide/ofReduceBool/trustCompiler/unsafe): 0 matches.
# lake build Thm7Prime: success (8496 jobs); checkdecls blueprint/lean_decls: 77/77 pass.
# Note: 7 non-fatal linter.unusedSimpArgs warnings (over-inclusive simp sets); kernel-irrelevant, retained.

## lake env lean Thm7Prime/Fidelity.lean (exit=0)
'Thm7Fidelity.Q_eval' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.derivative_Q' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.derivative_Q_eval' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.derivative2_Q' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.derivative2_Q_eval' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.derivative3_Q' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.Q_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.derivative3_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.derivative_splits_of_gate1' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.derivative2_splits_of_gate2' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.disc_sq_of_quadratic_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.gate1_of_derivative_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.gate2_of_derivative2_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Fidelity.rd211_iff_natural' depends on axioms: [propext, Classical.choice, Quot.sound]
