/-
thm7_repair WP2 — BM2000 Theorem 7 の a-map gate 恒等式。
曲線 E: z^2 = w^3+12w^2-108w (= z^2 = w(w-6)(w+18)、Cremona 576i2)。
恒等式・λ は 2026-07-21 に Sage で厳密検証済(DEPENDENCY_MAP addendum A2)。
本ファイルは Sage で厳密検証済みの数学を Lean 4 へ転記したもの。
-/
import Mathlib.Tactic

namespace Thm7RepairGates

theorem D_reduce (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w) :
    (z - w - 18)*(8*w + z) = (7*w - 18)*z + (w^3 + 4*w^2 - 252*w) := by
  linear_combination hE

theorem gate1_cleared (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w) :
    (9*(9*(2*w + z - 12)*(w + 2))^2
      - 14*(9*(2*w + z - 12)*(w + 2))*((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))
      + 9*((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))^2)
      * (w*(w + 18)*(w^2 - 63*w + 486))^2
    = (3*(w - 18)*(w + 6)*w*(w + 18) + (-21*w^2 + 108*w - 2916)*z)^2
      * ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))^2 := by
  linear_combination ((-21609*w^6 + 333396*w^5 - 7858620*w^4 + 66134880*w^3 - 618833520*w^2 + 2346843456*w - 2754990144)*z^2 + (28224*w^7 - 1487808*w^6 - 4199040*w^5 + 184757760*w^4 - 4232632320*w^3 + 44079842304*w^2 - 88159684608*w)*z + 1170*w^10 - 44361*w^9 - 239256*w^8 + 21638016*w^7 - 61515936*w^6 - 3111698592*w^5 + 4406472576*w^4 + 209787397632*w^3 - 352638738432*w^2 + 297538935552*w) * hE

theorem gate2_cleared (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w) :
    (9*(9*(2*w + z - 12)*(w + 2))^2
      - 6*(9*(2*w + z - 12)*(w + 2))*((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))
      + 9*((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))^2)
      * (w*(w + 18)*(w^2 - 63*w + 486))^2
    = (3*(w - 18)*(w + 6)*w*(w + 18) + (-9*w^2 - 648*w + 2916)*z)^2
      * ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))^2 := by
  linear_combination ((-3969*w^6 - 551124*w^5 - 15090300*w^4 + 273987360*w^3 - 1488034800*w^2 + 3367210176*w - 2754990144)*z^2 + (1512*w^8 + 27864*w^7 - 6695136*w^6 + 19945440*w^5 + 1473863040*w^4 - 15713647488*w^3 + 56324242944*w^2 - 66119763456*w)*z + 1026*w^10 - 29673*w^9 - 495720*w^8 + 11617344*w^7 + 125341344*w^6 - 1808316576*w^5 - 27685950336*w^4 + 296314495488*w^3 - 44079842304*w^2 + 297538935552*w) * hE

theorem anchor :
    ((36:ℚ))^2 = (-12:ℚ)^3 + 12*(-12:ℚ)^2 - 108*(-12:ℚ)
    ∧ (((-299376:ℚ))/((-99792:ℚ)))^2 = 9
    ∧ (((299376:ℚ))/((-99792:ℚ)))^2 = 9 := by
  norm_num

/-- 補助恒等式(展開形の除算を単一分数へ整理する純代数恒等式)。
    gate1 は c = 14、gate2 は c = 6 に対応する。 -/
theorem combine_frac (N D c : ℚ) (hD : D ≠ 0) :
    9*(N/D)^2 - c*(N/D) + 9 = (9*N^2 - c*N*D + 9*D^2)/D^2 := by
  field_simp

theorem gate1_sq (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w)
    (hM : w*(w + 18)*(w^2 - 63*w + 486) ≠ 0)
    (hD : (7*w - 18)*z + (w^3 + 4*w^2 - 252*w) ≠ 0) :
    ∃ r : ℚ, 9*((9*(2*w + z - 12)*(w + 2)) / ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w)))^2
        - 14*((9*(2*w + z - 12)*(w + 2)) / ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w)))
        + 9 = r^2 := by
  refine ⟨(3*(w - 18)*(w + 6)*w*(w + 18) + (-21*w^2 + 108*w - 2916)*z) / (w*(w + 18)*(w^2 - 63*w + 486)), ?_⟩
  rw [combine_frac _ _ _ hD, div_pow,
      div_eq_div_iff (pow_ne_zero 2 hD) (pow_ne_zero 2 hM)]
  linear_combination gate1_cleared w z hE

theorem gate2_sq (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w)
    (hM : w*(w + 18)*(w^2 - 63*w + 486) ≠ 0)
    (hD : (7*w - 18)*z + (w^3 + 4*w^2 - 252*w) ≠ 0) :
    ∃ r : ℚ, 9*((9*(2*w + z - 12)*(w + 2)) / ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w)))^2
        - 6*((9*(2*w + z - 12)*(w + 2)) / ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w)))
        + 9 = r^2 := by
  refine ⟨(3*(w - 18)*(w + 6)*w*(w + 18) + (-9*w^2 - 648*w + 2916)*z) / (w*(w + 18)*(w^2 - 63*w + 486)), ?_⟩
  rw [combine_frac _ _ _ hD, div_pow,
      div_eq_div_iff (pow_ne_zero 2 hD) (pow_ne_zero 2 hM)]
  linear_combination gate2_cleared w z hE

end Thm7RepairGates

#print axioms Thm7RepairGates.D_reduce
#print axioms Thm7RepairGates.gate1_cleared
#print axioms Thm7RepairGates.gate2_cleared
#print axioms Thm7RepairGates.anchor
#print axioms Thm7RepairGates.combine_frac
#print axioms Thm7RepairGates.gate1_sq
#print axioms Thm7RepairGates.gate2_sq
