/-
Thm7Prime/Fidelity.lean -- kernel statement-fidelity for the gate form
(Option ii, 2026-08-02; statements FROZEN by claude.ai, tactics delegated)

Purpose: close in the kernel the two links previously held by the CAS
statement-fidelity gate (scripts/sage/wp1_fidelity.sage):
  (1) the expanded forms dq1/dq2 are the first and second derivatives of
      quartic211 (here: Polynomial.derivative on the polynomial Q);
  (2) splitting of each derivative is equivalent to its gate (disc-square form).
Main result: RD211 a <-> a /= 0 and a /= 1 and NaturalRD a, where NaturalRD
mirrors Gap/BMThm7Transcript.KDerived (one-argument Polynomial.Splits at this
pin: product of constants and monic linear factors over the base field).
Thm7Prime/Master.lean is untouched (FROZEN); this file imports it.
-/
import Thm7Prime.Master

namespace Thm7Fidelity

open Polynomial Thm7Statement

/-- The normalized p(2,1,1) quartic as a polynomial: `Q a = X^2 (X-1) (X - C a)`. -/
noncomputable def Q (a : ℚ) : ℚ[X] := X^2 * (X - 1) * (X - C a)

/-- Natural form of rational-derivedness: the quartic and its first three
derivatives split over ℚ (the fourth derivative is a constant), mirroring
`BMThm7Transcript.KDerived`. -/
def NaturalRD (a : ℚ) : Prop :=
  (Q a).Splits ∧ (derivative (Q a)).Splits ∧
  (derivative (derivative (Q a))).Splits ∧
  (derivative (derivative (derivative (Q a)))).Splits

/-! ## Link (1): the polynomial and its kernel derivatives -/

theorem Q_eval (a x : ℚ) : (Q a).eval x = quartic211 a x := by
  unfold Q quartic211
  simp only [eval_mul, eval_sub, eval_pow, eval_X, eval_C, eval_one]

theorem derivative_Q (a : ℚ) :
    derivative (Q a) = C 4 * X^3 - C (3*(1+a)) * X^2 + C (2*a) * X := by
  have hQ : Q a = X^4 - C (1+a) * X^3 + C a * X^2 := by
    unfold Q; rw [C_add, C_1]; ring
  rw [hQ]
  simp only [derivative_sub, derivative_add, derivative_mul, derivative_C,
    derivative_X_pow, derivative_X, mul_zero, zero_mul, add_zero, zero_add, mul_one]
  simp only [map_mul, map_add, map_one, map_ofNat, map_natCast]
  push_cast
  ring

/-- The first `Polynomial.derivative` of `Q` evaluates to Master's `dq1`. -/
theorem derivative_Q_eval (a x : ℚ) : (derivative (Q a)).eval x = dq1 a x := by
  rw [derivative_Q]
  simp only [eval_add, eval_sub, eval_mul, eval_pow, eval_X, eval_C]
  unfold dq1
  ring

theorem derivative2_Q (a : ℚ) :
    derivative (derivative (Q a)) = C 12 * X^2 - C (6*(1+a)) * X + C (2*a) := by
  rw [derivative_Q]
  simp only [derivative_sub, derivative_add, derivative_mul, derivative_C,
    derivative_X_pow, derivative_X, mul_zero, zero_mul, add_zero, zero_add, mul_one]
  simp only [map_mul, map_add, map_one, map_ofNat, map_natCast]
  push_cast
  ring

/-- The second `Polynomial.derivative` of `Q` evaluates to Master's `dq2`. -/
theorem derivative2_Q_eval (a x : ℚ) :
    (derivative (derivative (Q a))).eval x = dq2 a x := by
  rw [derivative2_Q]
  simp only [eval_add, eval_sub, eval_mul, eval_pow, eval_X, eval_C]
  unfold dq2
  ring

theorem derivative3_Q (a : ℚ) :
    derivative (derivative (derivative (Q a))) = C 24 * X - C (6*(1+a)) := by
  rw [derivative2_Q]
  simp only [derivative_sub, derivative_add, derivative_mul, derivative_C,
    derivative_X_pow, derivative_X, mul_zero, zero_mul, add_zero, zero_add, mul_one]
  simp only [map_mul, map_add, map_one, map_ofNat, map_natCast]
  push_cast
  ring

/-! ## Link (2), easy half: splitting under the gates -/

theorem Q_splits (a : ℚ) : (Q a).Splits := by
  unfold Q
  have hX2 : (X ^ 2 : ℚ[X]).Splits := by rw [pow_two]; exact Splits.X.mul Splits.X
  have hX1 : (X - 1 : ℚ[X]).Splits := by simpa using Splits.X_sub_C (1 : ℚ)
  exact (hX2.mul hX1).mul (Splits.X_sub_C a)

theorem derivative3_splits (a : ℚ) :
    (derivative (derivative (derivative (Q a)))).Splits := by
  have hfact : derivative (derivative (derivative (Q a)))
      = C 24 * (X - C ((6*(1+a))/24)) := by
    rw [derivative3_Q]
    apply Polynomial.funext; intro x
    simp only [eval_mul, eval_sub, eval_C, eval_X]
    ring
  rw [hfact]
  exact (Splits.C 24).mul (Splits.X_sub_C _)

theorem derivative_splits_of_gate1 (a : ℚ) (h : Gate1 a) :
    (derivative (Q a)).Splits := by
  obtain ⟨r, hr⟩ := h
  have hfact : derivative (Q a)
      = C 4 * (X * ((X - C ((3*(1+a)+r)/8)) * (X - C ((3*(1+a)-r)/8)))) := by
    rw [derivative_Q]
    apply Polynomial.funext; intro x
    simp only [eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C]
    linear_combination (-(x/16)) * hr
  rw [hfact]
  exact (Splits.C 4).mul (Splits.X.mul ((Splits.X_sub_C _).mul (Splits.X_sub_C _)))

theorem derivative2_splits_of_gate2 (a : ℚ) (h : Gate2 a) :
    (derivative (derivative (Q a))).Splits := by
  obtain ⟨s, hs⟩ := h
  have hfact : derivative (derivative (Q a))
      = C 12 * ((X - C ((1+a)/4 + s/12)) * (X - C ((1+a)/4 - s/12))) := by
    rw [derivative2_Q]
    apply Polynomial.funext; intro x
    simp only [eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C]
    linear_combination (-(1/12)) * hs
  rw [hfact]
  exact (Splits.C 12).mul ((Splits.X_sub_C _).mul (Splits.X_sub_C _))

/-! ## Link (2), converse half: gates from splitting -/

/-- Over ℚ, a quadratic with nonzero leading coefficient that splits has
square discriminant. -/
theorem disc_sq_of_quadratic_splits (p q r : ℚ) (hp : p ≠ 0)
    (h : (C p * X^2 + C q * X + C r).Splits) :
    ∃ t : ℚ, q^2 - 4*p*r = t^2 := by
  obtain ⟨u, hu⟩ := h.exists_eval_eq_zero (by rw [degree_quadratic hp]; decide)
  simp only [eval_add, eval_mul, eval_pow, eval_X, eval_C] at hu
  exact ⟨q + 2*p*u, by linear_combination (-4*p) * hu⟩

theorem gate1_of_derivative_splits (a : ℚ)
    (h : (derivative (Q a)).Splits) : Gate1 a := by
  rw [derivative_Q] at h
  have hfact : C 4 * X^3 - C (3*(1+a)) * X^2 + C (2*a) * X
      = X * (C 4 * X^2 + C (-(3*(1+a))) * X + C (2*a)) := by
    apply Polynomial.funext; intro x
    simp only [eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C]
    ring
  rw [hfact] at h
  have hquad_ne : (C 4 * X^2 + C (-(3*(1+a))) * X + C (2*a) : ℚ[X]) ≠ 0 := by
    intro hz
    have hd : (C 4 * X^2 + C (-(3*(1+a))) * X + C (2*a)).degree = 2 :=
      degree_quadratic (by norm_num)
    rw [hz] at hd; simp at hd
  have hbig_ne : (X * (C 4 * X^2 + C (-(3*(1+a))) * X + C (2*a)) : ℚ[X]) ≠ 0 :=
    mul_ne_zero X_ne_zero hquad_ne
  have hq := h.of_dvd hbig_ne (dvd_mul_left _ X)
  obtain ⟨t, ht⟩ := disc_sq_of_quadratic_splits 4 (-(3*(1+a))) (2*a) (by norm_num) hq
  refine ⟨t, ?_⟩
  rw [← ht]; ring

theorem gate2_of_derivative2_splits (a : ℚ)
    (h : (derivative (derivative (Q a))).Splits) : Gate2 a := by
  rw [derivative2_Q] at h
  have hfact : C 12 * X^2 - C (6*(1+a)) * X + C (2*a)
      = C 12 * X^2 + C (-(6*(1+a))) * X + C (2*a) := by
    rw [map_neg]; ring
  rw [hfact] at h
  obtain ⟨t, ht⟩ := disc_sq_of_quadratic_splits 12 (-(6*(1+a))) (2*a) (by norm_num) h
  refine ⟨t/2, ?_⟩
  linear_combination (1/4) * ht

/-! ## Main equivalence -/

/-- **Statement fidelity, kernel form**: the frozen gate form `RD211` is
equivalent to the natural `Polynomial.Splits` form of rational-derivedness
together with the shape conditions. -/
theorem rd211_iff_natural (a : ℚ) :
    RD211 a ↔ (a ≠ 0 ∧ a ≠ 1 ∧ NaturalRD a) := by
  constructor
  · intro h
    obtain ⟨h0, h1, hg1, hg2⟩ := h
    exact ⟨h0, h1, Q_splits a, derivative_splits_of_gate1 a hg1,
      derivative2_splits_of_gate2 a hg2, derivative3_splits a⟩
  · intro h
    obtain ⟨h0, h1, _, hs1, hs2, _⟩ := h
    exact ⟨h0, h1, gate1_of_derivative_splits a hs1,
      gate2_of_derivative2_splits a hs2⟩

end Thm7Fidelity

#print axioms Thm7Fidelity.Q_eval
#print axioms Thm7Fidelity.derivative_Q
#print axioms Thm7Fidelity.derivative_Q_eval
#print axioms Thm7Fidelity.derivative2_Q
#print axioms Thm7Fidelity.derivative2_Q_eval
#print axioms Thm7Fidelity.derivative3_Q
#print axioms Thm7Fidelity.Q_splits
#print axioms Thm7Fidelity.derivative3_splits
#print axioms Thm7Fidelity.derivative_splits_of_gate1
#print axioms Thm7Fidelity.derivative2_splits_of_gate2
#print axioms Thm7Fidelity.disc_sq_of_quadratic_splits
#print axioms Thm7Fidelity.gate1_of_derivative_splits
#print axioms Thm7Fidelity.gate2_of_derivative2_splits
#print axioms Thm7Fidelity.rd211_iff_natural
