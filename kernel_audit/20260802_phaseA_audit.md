# Kernel audit -- Phase A-1 independent re-audit (claude.ai, lake env lean on logos, 2026-08-02)
# toolchain: leanprover/lean4:v4.31.0-rc1 / mathlib pin: d568c8c / repo @ 43c9024 + Phase A fixes (uncommitted at audit time)
# Supersedes 20260801_merge_audit.md, which (i) predates the addition of BMThm7GapK/BMThm7Boundary
#   (commit 43c9024) and so contains no lines for them, and (ii) contains a truncated line at
#   'thm7prime_of_forward' hiding its rank_E576i2 dependency (recovered below: it does depend on it;
#   the final theorem thm7prime is std-3).
# Edits since 43c9024 covered by this audit: BMThm7Transcript.lean (two docstring line-anchor
#   corrections, comments only), BMThm7Boundary.lean (#print axioms completed to all 14 declarations).
#   Thm7Prime/Master.lean untouched (FROZEN header).
# sorry / native_decide / ofReduceBool / trustCompiler scan over all .lean: 0 matches
# custom axiom declarations: rank_E576i2 (Thm7Prime/Master.lean:316) only -- disclosed;
#   depended on by rankOneE_holds and thm7prime_of_forward only; thm7prime itself is std-3.

## Gap/BMThm7Gap.lean (exit=0)
'BMThm7Gap.fpoly_eval' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Gap.fp_is_deriv' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Gap.fp_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Gap.no_split_at_24' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Gap.no_split_at_104' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Gap.no_split_at_neg221' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Gap.BM_sec224_argument_invalid' depends on axioms: [propext, Classical.choice, Quot.sound]

## Gap/BMThm7GapK.lean (exit=0)
'BMThm7GapK.no_rat_sq_of_no_int_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.no_int_sq_of_natSqrt' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.sqrt3441_irrational' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.rat_sq_in_K' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.fp_is_deriv' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.sigma3_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.fp_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.translate_factors' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.disc_245_not_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.disc_325_not_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.discAt_not_sq_in_K' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.no_K_roots_at' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7GapK.K_analogue_of_thm7_is_false' depends on axioms: [propext, Classical.choice, Quot.sound]

## Gap/BMThm7Transcript.lean (exit=0)
'BMThm7Transcript.derivative_translate' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.bmTranslate_critical_double' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.KDerived_translate_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.T2_iff_conclusion' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.deltaF_eq_sym_mul_deltaFp_cubed' depends on axioms: [propext, Quot.sound]
'BMThm7Transcript.deltaFp_eq_zero_of_D6' depends on axioms: [propext, Quot.sound]
'BMThm7Transcript.discCubic_fp_eq_four_D6' depends on axioms: [propext, Quot.sound]
'BMThm7Transcript.bmQuartic_expand' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.derivative_bmQuartic' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.D6_eq_sq_of_vieta' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.D6_nonneg_of_vieta' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.deltaF_nonpos_of_vieta' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.T9_via_T2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.not_T9_bridge_Q' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.symF_zero_not_KDerived' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.sq_ne_three_mul_sq_add_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.not_T0_claim_K' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Transcript.thm7_of_conjecture1' depends on axioms: [propext, Classical.choice, Quot.sound]

## Gap/BMThm7Boundary.lean (exit=0)
'BMThm7Boundary.I1_cleared' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.I2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.Q4_factor' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.pairing1' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.pairing2' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.pairing3' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.Q4_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.Q4Rq_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.Q4Sq_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.Q4RqSq_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.n2Q4_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.n2Q4Rq_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.n2Q4Sq_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
'BMThm7Boundary.n2Q4RqSq_neg' depends on axioms: [propext, Classical.choice, Quot.sound]

## Thm7Prime/Master.lean (exit=0)
Thm7Prime/Master.lean:489:2: warning: `push_neg` has been deprecated. Prefer using `push Not` instead.
If you'd rather continue using `push_neg` in your project, you can implement it as follows:
```
open Lean.Parser.Tactic in
macro "push_neg" cfg:optConfig loc:(location)? : tactic =>
  `(tactic| push $cfg:optConfig Not $[$loc]?)
```
'Thm7Statement.quartic211_expand' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.dq1_factor' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.gate1_is_disc' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.gate2_is_disc' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.dq1_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.dq2_splits' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.D_reduce' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.gate1_cleared' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.gate2_cleared' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.combine_frac' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.gate1_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.gate2_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.hMside_factor' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.exceptional_points' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.exceptional_amap_54' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.exceptional_amap_9' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.gates_at_77_90' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.thm7_backward' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.OnE_iff_equation' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.E576i2_elliptic' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.rankOneE_holds' depends on axioms: [propext, Classical.choice, Quot.sound, Thm7Statement.rank_E576i2]
'Thm7Statement.thm7prime_of_forward' depends on axioms: [propext,
 Classical.choice,
 Quot.sound,
 Thm7Statement.rank_E576i2]
'Thm7Statement.caseA_scale' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.caseA_normalized' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.sq_ne_96' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.wD_ne' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.K1_ne' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.adP6_cover' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.curve_cleared' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.aden_cleared' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.forward_core' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.anchor_90_77' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.thm7_forward' depends on axioms: [propext, Classical.choice, Quot.sound]
'Thm7Statement.thm7prime' depends on axioms: [propext, Classical.choice, Quot.sound]

