# Kernel audit -- Thm7Prime/Classification.lean (Option ii, 2nd installment), claude.ai independent audit, logos, 2026-08-02
# toolchain: leanprover/lean4:v4.31.0-rc1 / mathlib pin: d568c8c
# Provenance: statements FROZEN by claude.ai pre-delegation (reference: kinko submission_regs_AFM_20260801/
#   Classification.STATEMENT_FREEZE_20260802.lean, md5 24da89e181542aa80fc7ee1c2afdebb8); tactics by
#   Claude Code job classification_20260802 (single-thread, ~11m, exit 0).
# Freeze verification (refined): statement layer -- all 13 segments (defs, docstrings, statements,
#   #print block) verbatim and in order; declaration census 15 = 15, none added or removed.
# NOTED DEVIATION (accepted): two proofs written in term mode (':=' without 'by'), replacing the frozen
#   ':= by sorry' sites -- a letter-level deviation from 'proof bodies after := by only'; the mathematical
#   statements are byte-identical. CC's own report did not flag this; caught by the refined checker.
# git tripwire: only Thm7Prime/Classification.lean new; Master md5 4966eaaf..., Fidelity md5 a4a2244f... unchanged.
# banned-token scan: 0 matches. lake build: success (8497 jobs). checkdecls: 89/89 pass.

## lake env lean Thm7Prime/Classification.lean (exit=0)
'Thm7Classification.affineEquiv_refl' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.affineEquiv_symm' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.derivative_comp_linear' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.splits_comp_linear' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.splits_C_mul' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.rdpoly_of_affineEquiv' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.isP211_Q' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.affineEquiv_normalize' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.classify_forward' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.classify_backward' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.classification' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Classification.classification_by_curve' depends on axioms: [propext, Classical.choice, Quot.sound]
