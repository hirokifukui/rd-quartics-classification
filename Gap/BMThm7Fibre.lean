/-
Gap/BMThm7Fibre.lean -- the fibre correspondence: the three disjuncts of the
terrain analysis, formally defined via the transcript's own vertical-translate
operator, are equivalent to the square conditions of the three covers
(2026-08-02; statements FROZEN by claude.ai, tactics delegated; division of
labour and responsibility: AI_PROVENANCE.md at the repository root)

The disjunct at a critical point x0 of the chart quartic q (roots {1,a,b,c},
sigma_3 = 0) is: the vertical translate q - q(x0) -- the transcript's
`bmTranslate` -- splits over Q.  The three critical points are 0 and
(3*sigma_1 +- rho)/8 with rho = z/den.  This file proves, with every
denominator tracked:
  * D0  <-> sigma_1^2 - 4 sigma_2 is a rational square  (and, cleared by the
    nonzero square den^2, <-> Q4 is a rational square -- the isomorphism of the
    chart cover C0 with the cleared model),
  * D+- <-> gamma_+- = s1n (s1n -+ z) is a rational square,
via the factorisation q - q(x0) = (X - x0)^2 (X^2 + B X + C),
B = 2 x0 - sigma_1, C = sigma_2 + 3 x0^2 - 2 sigma_1 x0, whose linear-coefficient
consistency is exactly q'(x0) = 0, and the discriminant identity
B^2 - 4C = -8 x0^2 + 4 sigma_1 x0 + sigma_1^2 - 4 sigma_2
         = sigma_1 (sigma_1 -+ rho) / 4   at   x0 = (3 sigma_1 +- rho)/8,
so that den^2 * (B^2 - 4C) * 4 = gamma_+-.
-/
import Mathlib
import Gap.BMThm7Transcript
import Gap.BMThm7Boundary
import Gap.BMThm7Terrain

namespace BMThm7Fibre

open Polynomial BMThm7Transcript BMThm7Boundary BMThm7Terrain

/-- The chart quartic: roots {1, a, b, c} with c = -ab/den (the sigma_3 = 0
chart). -/
noncomputable def chartQuartic (a b : ℚ) : ℚ[X] :=
  rootQuartic a b (-(a * b) / den a b)

/-- **D0**: the disjunct at the critical point 0 --- the vertical translate of
the chart quartic at 0 splits over ℚ. -/
def D0 (a b : ℚ) : Prop := (bmTranslate (chartQuartic a b) 0).Splits

/-- **D+**: the disjunct at the critical point (3 sigma_1 + rho)/8, written with
cleared denominators as (3 s1n + z)/(8 den). -/
def Dplus (a b z : ℚ) : Prop :=
  (bmTranslate (chartQuartic a b) ((3 * s1n a b + z) / (8 * den a b))).Splits

/-- **D-**: the disjunct at the critical point (3 sigma_1 - rho)/8. -/
def Dminus (a b z : ℚ) : Prop :=
  (bmTranslate (chartQuartic a b) ((3 * s1n a b - z) / (8 * den a b))).Splits

/-- The first disjunct is the square condition of the chart cover C0. -/
theorem D0_iff_disc (a b : ℚ) (hden : den a b ≠ 0) :
    D0 a b ↔ ∃ t : ℚ, t ^ 2 = (s1n a b / den a b) ^ 2 - 4 * (s2n a b / den a b) := by
  set c : ℚ := -(a * b) / den a b with hc
  have hchart : chartQuartic a b = rootQuartic a b c := by rw [chartQuartic, ← hc]
  have hcd : c * den a b = -(a * b) := by rw [hc]; exact div_mul_cancel₀ _ hden
  have hc_den : c * (a * b + a + b) = -(a * b) := by simpa only [den] using hcd
  have he3 : a * b + a * c + b * c + a * b * c = 0 := by linear_combination hc_den
  have hs1 : s1n a b = (1 + a + b + c) * den a b := by
    simp only [s1n, den]; linear_combination -hc_den
  have hs2 : s2n a b = (a + b + c + a * b + a * c + b * c) * den a b := by
    simp only [s2n, den]; linear_combination -(1 + a + b) * hc_den
  have hσ1 : s1n a b / den a b = 1 + a + b + c := by
    rw [hs1, mul_div_assoc, div_self hden, mul_one]
  have hσ2 : s2n a b / den a b = a + b + c + a * b + a * c + b * c := by
    rw [hs2, mul_div_assoc, div_self hden, mul_one]
  have hfac : bmTranslate (chartQuartic a b) 0
      = X ^ 2 * (X ^ 2 + C (-(1 + a + b + c)) * X + C (a + b + c + a * b + a * c + b * c)) := by
    rw [bmTranslate, BMThm7Transcript.translate, hchart]
    have heval0 : eval 0 (rootQuartic a b c) = a * b * c := by
      simp only [rootQuartic, eval_mul, eval_sub, eval_X, eval_C, eval_one]; ring
    rw [heval0]
    apply Polynomial.funext; intro x
    simp only [rootQuartic, eval_add, eval_mul, eval_sub, eval_pow, eval_X, eval_C, eval_one]
    linear_combination (-x) * he3
  have hQne : (X ^ 2 + C (-(1 + a + b + c)) * X + C (a + b + c + a * b + a * c + b * c) : ℚ[X])
      ≠ 0 := by
    intro h0
    have hd : (X ^ 2 + C (-(1 + a + b + c)) * X + C (a + b + c + a * b + a * c + b * c) : ℚ[X]).degree
        = 2 := by
      rw [show (X ^ 2 + C (-(1 + a + b + c)) * X + C (a + b + c + a * b + a * c + b * c) : ℚ[X])
          = C 1 * X ^ 2 + C (-(1 + a + b + c)) * X + C (a + b + c + a * b + a * c + b * c) by
        rw [C_1, one_mul]]
      exact degree_quadratic (by norm_num)
    rw [h0, degree_zero] at hd; exact absurd hd (by decide)
  simp only [D0]
  rw [hσ1, hσ2, hfac]
  constructor
  · intro hD
    obtain ⟨d, hd⟩ := exists_sq_of_quadratic_splits _ _
      ((splits_mul_iff (pow_ne_zero 2 X_ne_zero) hQne).mp hD).2
    exact ⟨d, by rw [hd]; ring⟩
  · rintro ⟨t, ht⟩
    exact (Splits.X_pow 2).mul (quadratic_splits_of_sq _ _ t (by rw [ht]; ring))

/-- Clearing the denominator (multiplication by the nonzero square den^2) is a
bijection on solutions: the chart cover C0 and the cleared model
Ctilde0 : v^2 = Q4 have the same rational fibres over den ≠ 0. -/
theorem cleared_model_iff (a b : ℚ) (hden : den a b ≠ 0) :
    (∃ t : ℚ, t ^ 2 = (s1n a b / den a b) ^ 2 - 4 * (s2n a b / den a b)) ↔
      ∃ v : ℚ, v ^ 2 = Q4 a b := by
  have hQ4 : Q4 a b = s1n a b ^ 2 - 4 * s2n a b * den a b := by
    simp only [Q4, Rq, Sq]; ring
  constructor
  · rintro ⟨t, ht⟩
    refine ⟨den a b * t, ?_⟩
    rw [hQ4, mul_pow, ht]
    field_simp
  · rintro ⟨v, hv⟩
    rw [hQ4] at hv
    refine ⟨v / den a b, ?_⟩
    rw [div_pow, hv]
    field_simp

/-- **The radicand derivation, plus sign**: the disjunct at
x0 = (3 sigma_1 + rho)/8 is equivalent to gamma_+ = s1n (s1n - z) being a
rational square. -/
theorem Dplus_iff (a b z : ℚ) (hden : den a b ≠ 0) (hz : z ^ 2 = Rq a b) :
    Dplus a b z ↔ ∃ v : ℚ, v ^ 2 = s1n a b * (s1n a b - z) := by
  simp only [Dplus]
  set x0 : ℚ := (3 * s1n a b + z) / (8 * den a b) with hx0
  set c : ℚ := -(a * b) / den a b with hc
  set σ1 : ℚ := s1n a b / den a b with hσ1
  set σ2 : ℚ := s2n a b / den a b with hσ2
  have hchart : chartQuartic a b = rootQuartic a b c := by rw [chartQuartic, ← hc]
  have hcd : c * den a b = -(a * b) := by rw [hc]; exact div_mul_cancel₀ _ hden
  have hc_den : c * (a * b + a + b) = -(a * b) := by simpa only [den] using hcd
  have he3 : a * b + a * c + b * c + a * b * c = 0 := by linear_combination hc_den
  have hs1 : s1n a b = (1 + a + b + c) * den a b := by
    simp only [s1n, den]; linear_combination -hc_den
  have hs2 : s2n a b = (a + b + c + a * b + a * c + b * c) * den a b := by
    simp only [s2n, den]; linear_combination -(1 + a + b) * hc_den
  have hσ1v : σ1 = 1 + a + b + c := by rw [hσ1, hs1, mul_div_assoc, div_self hden, mul_one]
  have hσ2v : σ2 = a + b + c + a * b + a * c + b * c := by
    rw [hσ2, hs2, mul_div_assoc, div_self hden, mul_one]
  have hz2 : z ^ 2 = 9 * s1n a b ^ 2 - 32 * s2n a b * den a b := by rw [hz]; simp only [Rq]
  -- the critical-point relation at x0
  have hcrit2 : 4 * x0 ^ 2 - 3 * σ1 * x0 + 2 * σ2 = 0 := by
    have expand : 4 * x0 ^ 2 - 3 * σ1 * x0 + 2 * σ2
        = (z ^ 2 - 9 * s1n a b ^ 2 + 32 * s2n a b * den a b) / (16 * den a b ^ 2) := by
      rw [hx0, hσ1, hσ2]; field_simp; ring
    have hnum0 : z ^ 2 - 9 * s1n a b ^ 2 + 32 * s2n a b * den a b = 0 := by
      linear_combination hz2
    rw [expand, hnum0, zero_div]
  have hcrit : 4 * x0 ^ 3 - 3 * σ1 * x0 ^ 2 + 2 * σ2 * x0 = 0 := by
    have h : 4 * x0 ^ 3 - 3 * σ1 * x0 ^ 2 + 2 * σ2 * x0
        = x0 * (4 * x0 ^ 2 - 3 * σ1 * x0 + 2 * σ2) := by ring
    rw [h, hcrit2, mul_zero]
  -- expansion of the vertical translate
  have hbmT : bmTranslate (chartQuartic a b) x0
      = X ^ 4 - C σ1 * X ^ 3 + C σ2 * X ^ 2 - C (x0 ^ 4 - σ1 * x0 ^ 3 + σ2 * x0 ^ 2) := by
    rw [bmTranslate, BMThm7Transcript.translate, hchart, hσ1v, hσ2v]
    apply Polynomial.funext; intro y
    simp only [rootQuartic, eval_add, eval_mul, eval_sub, eval_pow, eval_X, eval_C, eval_one]
    linear_combination (x0 - y) * he3
  -- the factorisation into a squared linear times a monic quadratic
  have hfacP : bmTranslate (chartQuartic a b) x0
      = (X - C x0) ^ 2 * (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0)) := by
    rw [hbmT]
    apply Polynomial.funext; intro y
    simp only [eval_mul, eval_add, eval_sub, eval_pow, eval_X, eval_C]
    linear_combination (y - x0) * hcrit
  have hQuadne :
      (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X]) ≠ 0 := by
    intro h0
    have hd :
        (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X]).degree = 2 := by
      rw [show (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X])
          = C 1 * X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) by rw [C_1, one_mul]]
      exact degree_quadratic (by norm_num)
    rw [h0, degree_zero] at hd; exact absurd hd (by decide)
  have hsqne : ((X - C x0) ^ 2 : ℚ[X]) ≠ 0 := pow_ne_zero 2 (X_sub_C_ne_zero x0)
  -- strip the square of the linear factor
  have hstrip :
      ((X - C x0) ^ 2 * (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0))
        : ℚ[X]).Splits
      ↔ (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X]).Splits := by
    rw [splits_mul_iff hsqne hQuadne]
    exact ⟨fun h => h.2, fun h => ⟨(Splits.X_sub_C x0).pow 2, h⟩⟩
  -- the quadratic splits iff its discriminant is a square
  have hquaddisc :
      (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X]).Splits
      ↔ ∃ d : ℚ, d ^ 2 = (2 * x0 - σ1) ^ 2 - 4 * (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) :=
    ⟨fun h => exists_sq_of_quadratic_splits _ _ h,
      fun ⟨d, hd⟩ => quadratic_splits_of_sq _ _ d hd⟩
  -- the discriminant identity
  have halg : (2 * x0 - σ1) ^ 2 - 4 * (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0)
      = (11 * s1n a b ^ 2 - 2 * s1n a b * z - z ^ 2 - 32 * s2n a b * den a b) / (8 * den a b ^ 2) := by
    rw [hx0, hσ1, hσ2]; field_simp; ring
  have hdisc : (2 * x0 - σ1) ^ 2 - 4 * (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0)
      = s1n a b * (s1n a b - z) / (4 * den a b ^ 2) := by
    rw [halg, div_eq_div_iff (mul_ne_zero (by norm_num) (pow_ne_zero 2 hden))
      (mul_ne_zero (by norm_num) (pow_ne_zero 2 hden))]
    linear_combination (-4 * den a b ^ 2) * hz2
  rw [hfacP, hstrip, hquaddisc, hdisc]
  constructor
  · rintro ⟨d, hd⟩
    exact ⟨2 * den a b * d, by
      rw [show (2 * den a b * d) ^ 2 = 4 * den a b ^ 2 * d ^ 2 from by ring, hd]; field_simp⟩
  · rintro ⟨v, hv⟩
    exact ⟨v / (2 * den a b), by
      rw [div_pow, hv, show ((2 * den a b) ^ 2 : ℚ) = 4 * den a b ^ 2 from by ring]⟩

/-- **The radicand derivation, minus sign**. -/
theorem Dminus_iff (a b z : ℚ) (hden : den a b ≠ 0) (hz : z ^ 2 = Rq a b) :
    Dminus a b z ↔ ∃ v : ℚ, v ^ 2 = s1n a b * (s1n a b + z) := by
  simp only [Dminus]
  set x0 : ℚ := (3 * s1n a b - z) / (8 * den a b) with hx0
  set c : ℚ := -(a * b) / den a b with hc
  set σ1 : ℚ := s1n a b / den a b with hσ1
  set σ2 : ℚ := s2n a b / den a b with hσ2
  have hchart : chartQuartic a b = rootQuartic a b c := by rw [chartQuartic, ← hc]
  have hcd : c * den a b = -(a * b) := by rw [hc]; exact div_mul_cancel₀ _ hden
  have hc_den : c * (a * b + a + b) = -(a * b) := by simpa only [den] using hcd
  have he3 : a * b + a * c + b * c + a * b * c = 0 := by linear_combination hc_den
  have hs1 : s1n a b = (1 + a + b + c) * den a b := by
    simp only [s1n, den]; linear_combination -hc_den
  have hs2 : s2n a b = (a + b + c + a * b + a * c + b * c) * den a b := by
    simp only [s2n, den]; linear_combination -(1 + a + b) * hc_den
  have hσ1v : σ1 = 1 + a + b + c := by rw [hσ1, hs1, mul_div_assoc, div_self hden, mul_one]
  have hσ2v : σ2 = a + b + c + a * b + a * c + b * c := by
    rw [hσ2, hs2, mul_div_assoc, div_self hden, mul_one]
  have hz2 : z ^ 2 = 9 * s1n a b ^ 2 - 32 * s2n a b * den a b := by rw [hz]; simp only [Rq]
  -- the critical-point relation at x0
  have hcrit2 : 4 * x0 ^ 2 - 3 * σ1 * x0 + 2 * σ2 = 0 := by
    have expand : 4 * x0 ^ 2 - 3 * σ1 * x0 + 2 * σ2
        = (z ^ 2 - 9 * s1n a b ^ 2 + 32 * s2n a b * den a b) / (16 * den a b ^ 2) := by
      rw [hx0, hσ1, hσ2]; field_simp; ring
    have hnum0 : z ^ 2 - 9 * s1n a b ^ 2 + 32 * s2n a b * den a b = 0 := by
      linear_combination hz2
    rw [expand, hnum0, zero_div]
  have hcrit : 4 * x0 ^ 3 - 3 * σ1 * x0 ^ 2 + 2 * σ2 * x0 = 0 := by
    have h : 4 * x0 ^ 3 - 3 * σ1 * x0 ^ 2 + 2 * σ2 * x0
        = x0 * (4 * x0 ^ 2 - 3 * σ1 * x0 + 2 * σ2) := by ring
    rw [h, hcrit2, mul_zero]
  -- expansion of the vertical translate
  have hbmT : bmTranslate (chartQuartic a b) x0
      = X ^ 4 - C σ1 * X ^ 3 + C σ2 * X ^ 2 - C (x0 ^ 4 - σ1 * x0 ^ 3 + σ2 * x0 ^ 2) := by
    rw [bmTranslate, BMThm7Transcript.translate, hchart, hσ1v, hσ2v]
    apply Polynomial.funext; intro y
    simp only [rootQuartic, eval_add, eval_mul, eval_sub, eval_pow, eval_X, eval_C, eval_one]
    linear_combination (x0 - y) * he3
  -- the factorisation into a squared linear times a monic quadratic
  have hfacP : bmTranslate (chartQuartic a b) x0
      = (X - C x0) ^ 2 * (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0)) := by
    rw [hbmT]
    apply Polynomial.funext; intro y
    simp only [eval_mul, eval_add, eval_sub, eval_pow, eval_X, eval_C]
    linear_combination (y - x0) * hcrit
  have hQuadne :
      (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X]) ≠ 0 := by
    intro h0
    have hd :
        (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X]).degree = 2 := by
      rw [show (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X])
          = C 1 * X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) by rw [C_1, one_mul]]
      exact degree_quadratic (by norm_num)
    rw [h0, degree_zero] at hd; exact absurd hd (by decide)
  have hsqne : ((X - C x0) ^ 2 : ℚ[X]) ≠ 0 := pow_ne_zero 2 (X_sub_C_ne_zero x0)
  -- strip the square of the linear factor
  have hstrip :
      ((X - C x0) ^ 2 * (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0))
        : ℚ[X]).Splits
      ↔ (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X]).Splits := by
    rw [splits_mul_iff hsqne hQuadne]
    exact ⟨fun h => h.2, fun h => ⟨(Splits.X_sub_C x0).pow 2, h⟩⟩
  -- the quadratic splits iff its discriminant is a square
  have hquaddisc :
      (X ^ 2 + C (2 * x0 - σ1) * X + C (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) : ℚ[X]).Splits
      ↔ ∃ d : ℚ, d ^ 2 = (2 * x0 - σ1) ^ 2 - 4 * (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0) :=
    ⟨fun h => exists_sq_of_quadratic_splits _ _ h,
      fun ⟨d, hd⟩ => quadratic_splits_of_sq _ _ d hd⟩
  -- the discriminant identity
  have halg : (2 * x0 - σ1) ^ 2 - 4 * (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0)
      = (11 * s1n a b ^ 2 + 2 * s1n a b * z - z ^ 2 - 32 * s2n a b * den a b) / (8 * den a b ^ 2) := by
    rw [hx0, hσ1, hσ2]; field_simp; ring
  have hdisc : (2 * x0 - σ1) ^ 2 - 4 * (σ2 + 3 * x0 ^ 2 - 2 * σ1 * x0)
      = s1n a b * (s1n a b + z) / (4 * den a b ^ 2) := by
    rw [halg, div_eq_div_iff (mul_ne_zero (by norm_num) (pow_ne_zero 2 hden))
      (mul_ne_zero (by norm_num) (pow_ne_zero 2 hden))]
    linear_combination (-4 * den a b ^ 2) * hz2
  rw [hfacP, hstrip, hquaddisc, hdisc]
  constructor
  · rintro ⟨d, hd⟩
    exact ⟨2 * den a b * d, by
      rw [show (2 * den a b * d) ^ 2 = 4 * den a b ^ 2 * d ^ 2 from by ring, hd]; field_simp⟩
  · rintro ⟨v, hv⟩
    exact ⟨v / (2 * den a b), by
      rw [div_pow, hv, show ((2 * den a b) ^ 2 : ℚ) = 4 * den a b ^ 2 from by ring]⟩

/-- **Fibre correspondence**: on den ≠ 0 with the splitting witness z, the
three disjuncts are exactly the rational-square conditions of the three covers
--- C0 in cleared form, and C+- with their actual radicands gamma_+-. -/
theorem fibre_correspondence (a b z : ℚ) (hden : den a b ≠ 0) (hz : z ^ 2 = Rq a b) :
    (D0 a b ↔ ∃ v : ℚ, v ^ 2 = Q4 a b) ∧
    (Dplus a b z ↔ ∃ v : ℚ, v ^ 2 = s1n a b * (s1n a b - z)) ∧
    (Dminus a b z ↔ ∃ v : ℚ, v ^ 2 = s1n a b * (s1n a b + z)) := by
  exact ⟨(D0_iff_disc a b hden).trans (cleared_model_iff a b hden),
    Dplus_iff a b z hden hz, Dminus_iff a b z hden hz⟩

end BMThm7Fibre

#print axioms BMThm7Fibre.D0_iff_disc
#print axioms BMThm7Fibre.cleared_model_iff
#print axioms BMThm7Fibre.Dplus_iff
#print axioms BMThm7Fibre.Dminus_iff
#print axioms BMThm7Fibre.fibre_correspondence
