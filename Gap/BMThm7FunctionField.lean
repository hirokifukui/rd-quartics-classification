/-
Gap/BMThm7FunctionField.lean -- function-field non-squareness, kernel form
(2026-08-02; statements FROZEN by claude.ai, tactics delegated;
division of labour and responsibility: AI_PROVENANCE.md at the repository root)

Purpose: close in the kernel the step that Chapter 4 previously scoped as
[MC]: the eight cover-nontriviality candidates are non-squares in the
function field ℚ(a,b) of the sigma3 = 0 chart (which IS the function field
of the terrain surface on that chart, c = -ab/den being rationally
determined by (a,b)).

Chain: (i) ℚ[a,b] modelled as R2 := Polynomial (Polynomial ℚ) with
a = C X (inner), b = X (outer); (ii) evaluation at a rational point is a
ring homomorphism, so a square evaluates to a square (specialisation
principle = map_pow + sq_nonneg); (iii) R2 is a UFD, hence integrally
closed, so a square in the fraction field descends to a square in R2;
(iv) the eight kernel negativity certificates of BMThm7Boundary then
refute squareness.  The two-system [MC] record remains as the discovery
artifact; this file is its kernel replacement at the chart level.
-/
import Mathlib
import Gap.BMThm7Boundary

namespace BMThm7FunctionField

noncomputable section

open Polynomial

/-- ℚ[a,b] as iterated polynomials: inner variable = a, outer = b. -/
abbrev R2 : Type := Polynomial (Polynomial ℚ)

/-- The chart coordinate a. -/
def A : R2 := C X

/-- The chart coordinate b. -/
def B : R2 := X

/-- Evaluation at the rational point (x, y) (a := x, b := y), as a ring
homomorphism -- the specialisation principle lives here. -/
def evalAB (x y : ℚ) : R2 →+* ℚ :=
  (evalRingHom y).comp (mapRingHom (evalRingHom x))

/-! ## 1. Polynomial mirrors of the Boundary chart data -/

/-- Mirror of `BMThm7Boundary.den`. -/
def den2 : R2 := A * B + A + B

/-- Mirror of `BMThm7Boundary.s1n`. -/
def s1n2 : R2 := (1 + A + B) * den2 - A * B

/-- Mirror of `BMThm7Boundary.s2n`. -/
def s2n2 : R2 := (A + B + A * B) * den2 - A * B * (1 + A + B)

/-- Mirror of `BMThm7Boundary.Rq`. -/
def Rq2 : R2 := 9 * s1n2 ^ 2 - 32 * s2n2 * den2

/-- Mirror of `BMThm7Boundary.Sq`. -/
def Sq2 : R2 := 9 * s1n2 ^ 2 - 24 * s2n2 * den2

/-- Mirror of `BMThm7Boundary.Q4` (the 1/18 is a scalar of ℚ, kept to
preserve the square class). -/
def Q42 : R2 := C (C ((18 : ℚ)⁻¹)) * (3 * Rq2 - Sq2)

/-! ## 2. Evaluation bridges (mirror = function, pointwise) -/

theorem evalAB_den2 (x y : ℚ) : evalAB x y den2 = BMThm7Boundary.den x y := by
  simp only [evalAB, den2, A, B, BMThm7Boundary.den,
    RingHom.comp_apply, coe_evalRingHom, coe_mapRingHom,
    Polynomial.map_add, Polynomial.map_mul,
    Polynomial.map_X, Polynomial.map_C,
    eval_add, eval_mul, eval_X, eval_C]

theorem evalAB_s1n2 (x y : ℚ) : evalAB x y s1n2 = BMThm7Boundary.s1n x y := by
  simp only [evalAB, s1n2, den2, A, B, BMThm7Boundary.s1n, BMThm7Boundary.den,
    RingHom.comp_apply, coe_evalRingHom, coe_mapRingHom,
    Polynomial.map_add, Polynomial.map_sub, Polynomial.map_mul, Polynomial.map_one,
    Polynomial.map_X, Polynomial.map_C,
    eval_add, eval_sub, eval_mul, eval_one, eval_X, eval_C]

theorem evalAB_s2n2 (x y : ℚ) : evalAB x y s2n2 = BMThm7Boundary.s2n x y := by
  simp only [evalAB, s2n2, den2, A, B, BMThm7Boundary.s2n, BMThm7Boundary.den,
    RingHom.comp_apply, coe_evalRingHom, coe_mapRingHom,
    Polynomial.map_add, Polynomial.map_sub, Polynomial.map_mul, Polynomial.map_one,
    Polynomial.map_X, Polynomial.map_C,
    eval_add, eval_sub, eval_mul, eval_one, eval_X, eval_C]

theorem evalAB_Rq2 (x y : ℚ) : evalAB x y Rq2 = BMThm7Boundary.Rq x y := by
  simp only [Rq2, BMThm7Boundary.Rq, map_sub, map_mul, map_pow, map_ofNat,
    evalAB_s1n2, evalAB_s2n2, evalAB_den2]

theorem evalAB_Sq2 (x y : ℚ) : evalAB x y Sq2 = BMThm7Boundary.Sq x y := by
  simp only [Sq2, BMThm7Boundary.Sq, map_sub, map_mul, map_pow, map_ofNat,
    evalAB_s1n2, evalAB_s2n2, evalAB_den2]

theorem evalAB_Q42 (x y : ℚ) : evalAB x y Q42 = BMThm7Boundary.Q4 x y := by
  have hc : evalAB x y (C (C ((18 : ℚ)⁻¹))) = (18 : ℚ)⁻¹ := by
    simp only [evalAB, RingHom.comp_apply, coe_evalRingHom, coe_mapRingHom,
      Polynomial.map_C, eval_C]
  simp only [Q42, BMThm7Boundary.Q4, map_mul, map_sub, map_ofNat, hc,
    evalAB_Rq2, evalAB_Sq2]
  ring

/-! ## 3. The two general lemmas -/

/-- Specialisation principle: a square in ℚ[a,b] is non-negative at every
rational point. -/
theorem sq_eval_nonneg (F : R2) (hF : ∃ G : R2, F = G ^ 2) (x y : ℚ) :
    0 ≤ evalAB x y F := by
  obtain ⟨G, rfl⟩ := hF
  rw [map_pow]
  exact sq_nonneg _

/-- Square descent: ℚ[a,b] is a UFD, hence integrally closed, so an element
that becomes a square in the fraction field ℚ(a,b) is a square already in
ℚ[a,b]. -/
theorem square_descent (F : R2) (g : FractionRing R2)
    (hg : g ^ 2 = algebraMap R2 (FractionRing R2) F) :
    ∃ G : R2, F = G ^ 2 := by
  have hint : IsIntegral R2 g := by
    refine ⟨Polynomial.X ^ 2 - Polynomial.C F,
      Polynomial.monic_X_pow_sub_C F (by norm_num), ?_⟩
    rw [← Polynomial.aeval_def, map_sub, map_pow, Polynomial.aeval_X,
      Polynomial.aeval_C, hg, sub_self]
  obtain ⟨G, hG⟩ := IsIntegrallyClosed.isIntegral_iff.mp hint
  refine ⟨G, ?_⟩
  have h2 : algebraMap R2 (FractionRing R2) (G ^ 2)
      = algebraMap R2 (FractionRing R2) F := by
    rw [map_pow, hG, hg]
  exact (IsFractionRing.injective R2 (FractionRing R2) h2).symm

/-! ## 4. The eight non-squareness verdicts in ℚ(a,b) -/

theorem Q4_not_square :
    ¬ ∃ g : FractionRing R2, g ^ 2 = algebraMap R2 (FractionRing R2) Q42 := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent _ g hg
  have h0 := sq_eval_nonneg _ ⟨G, hG⟩ (-51/13) (-17/7)
  rw [evalAB_Q42] at h0
  exact absurd h0 (not_le.mpr BMThm7Boundary.Q4_neg)

theorem Q4Rq_not_square :
    ¬ ∃ g : FractionRing R2,
      g ^ 2 = algebraMap R2 (FractionRing R2) (Q42 * Rq2) := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent _ g hg
  have h0 := sq_eval_nonneg _ ⟨G, hG⟩ (-51/13) (-17/7)
  rw [map_mul, evalAB_Q42, evalAB_Rq2] at h0
  exact absurd h0 (not_le.mpr BMThm7Boundary.Q4Rq_neg)

theorem Q4Sq_not_square :
    ¬ ∃ g : FractionRing R2,
      g ^ 2 = algebraMap R2 (FractionRing R2) (Q42 * Sq2) := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent _ g hg
  have h0 := sq_eval_nonneg _ ⟨G, hG⟩ (-51/13) (-17/7)
  rw [map_mul, evalAB_Q42, evalAB_Sq2] at h0
  exact absurd h0 (not_le.mpr BMThm7Boundary.Q4Sq_neg)

theorem Q4RqSq_not_square :
    ¬ ∃ g : FractionRing R2,
      g ^ 2 = algebraMap R2 (FractionRing R2) (Q42 * (Rq2 * Sq2)) := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent _ g hg
  have h0 := sq_eval_nonneg _ ⟨G, hG⟩ (-51/13) (-17/7)
  rw [map_mul, map_mul, evalAB_Q42, evalAB_Rq2, evalAB_Sq2] at h0
  exact absurd h0 (not_le.mpr BMThm7Boundary.Q4RqSq_neg)

theorem n2Q4_not_square :
    ¬ ∃ g : FractionRing R2,
      g ^ 2 = algebraMap R2 (FractionRing R2) (C (C (-2 : ℚ)) * Q42) := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent _ g hg
  have h0 := sq_eval_nonneg _ ⟨G, hG⟩ 1 3
  have hc : evalAB 1 3 (C (C (-2 : ℚ))) = -2 := by
    simp only [evalAB, RingHom.comp_apply, coe_evalRingHom, coe_mapRingHom,
      Polynomial.map_C, eval_C]
  rw [map_mul, hc, evalAB_Q42] at h0
  exact absurd h0 (not_le.mpr BMThm7Boundary.n2Q4_neg)

theorem n2Q4Rq_not_square :
    ¬ ∃ g : FractionRing R2,
      g ^ 2 = algebraMap R2 (FractionRing R2) (C (C (-2 : ℚ)) * Q42 * Rq2) := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent _ g hg
  have h0 := sq_eval_nonneg _ ⟨G, hG⟩ 1 3
  have hc : evalAB 1 3 (C (C (-2 : ℚ))) = -2 := by
    simp only [evalAB, RingHom.comp_apply, coe_evalRingHom, coe_mapRingHom,
      Polynomial.map_C, eval_C]
  rw [map_mul, map_mul, hc, evalAB_Q42, evalAB_Rq2] at h0
  exact absurd h0 (not_le.mpr BMThm7Boundary.n2Q4Rq_neg)

theorem n2Q4Sq_not_square :
    ¬ ∃ g : FractionRing R2,
      g ^ 2 = algebraMap R2 (FractionRing R2) (C (C (-2 : ℚ)) * Q42 * Sq2) := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent _ g hg
  have h0 := sq_eval_nonneg _ ⟨G, hG⟩ 1 3
  have hc : evalAB 1 3 (C (C (-2 : ℚ))) = -2 := by
    simp only [evalAB, RingHom.comp_apply, coe_evalRingHom, coe_mapRingHom,
      Polynomial.map_C, eval_C]
  rw [map_mul, map_mul, hc, evalAB_Q42, evalAB_Sq2] at h0
  exact absurd h0 (not_le.mpr BMThm7Boundary.n2Q4Sq_neg)

theorem n2Q4RqSq_not_square :
    ¬ ∃ g : FractionRing R2,
      g ^ 2 = algebraMap R2 (FractionRing R2)
        (C (C (-2 : ℚ)) * Q42 * (Rq2 * Sq2)) := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent _ g hg
  have h0 := sq_eval_nonneg _ ⟨G, hG⟩ 1 3
  have hc : evalAB 1 3 (C (C (-2 : ℚ))) = -2 := by
    simp only [evalAB, RingHom.comp_apply, coe_evalRingHom, coe_mapRingHom,
      Polynomial.map_C, eval_C]
  rw [map_mul, map_mul, map_mul, hc, evalAB_Q42, evalAB_Rq2, evalAB_Sq2] at h0
  exact absurd h0 (not_le.mpr BMThm7Boundary.n2Q4RqSq_neg)

end

end BMThm7FunctionField

#print axioms BMThm7FunctionField.evalAB_den2
#print axioms BMThm7FunctionField.evalAB_s1n2
#print axioms BMThm7FunctionField.evalAB_s2n2
#print axioms BMThm7FunctionField.evalAB_Rq2
#print axioms BMThm7FunctionField.evalAB_Sq2
#print axioms BMThm7FunctionField.evalAB_Q42
#print axioms BMThm7FunctionField.sq_eval_nonneg
#print axioms BMThm7FunctionField.square_descent
#print axioms BMThm7FunctionField.Q4_not_square
#print axioms BMThm7FunctionField.Q4Rq_not_square
#print axioms BMThm7FunctionField.Q4Sq_not_square
#print axioms BMThm7FunctionField.Q4RqSq_not_square
#print axioms BMThm7FunctionField.n2Q4_not_square
#print axioms BMThm7FunctionField.n2Q4Rq_not_square
#print axioms BMThm7FunctionField.n2Q4Sq_not_square
#print axioms BMThm7FunctionField.n2Q4RqSq_not_square
