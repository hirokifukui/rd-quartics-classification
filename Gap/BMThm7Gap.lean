import Mathlib

/-!
# BM2000 Theorem 7 §2.2.4 — the published argument is invalid  [std-3, unconditional]

Buchholz–MacDougall, *When Newton met Diophantus*, J. Number Theory 81 (2000) 210–233.
§2.2.4 promises (verbatim, l.529-536):
  "the remaining two roots, r and s say, of the quartic could possibly lie in a quadratic
   extension of Q. ... None-the-less, in this section we show that the latter is precisely
   the case."
i.e. for a rational-derived p(1,1,1,1) quartic, the vertical translate that turns a critical
point into a double root leaves the OTHER TWO roots rational.

The argument of §2.2.4 uses exactly three things about f:
  (H1) f has four distinct roots        (used only to exclude D6 = 0)
  (H2) f' has three rational roots      (used via Theorem 4 / Delta(f') = -square)
  (H3) sym := (a-b-1)^2 (a-b+1)^2 (a+b-1)^2  != 0   (the excluded symmetric cases)
The splitting of f'' is a hypothesis of the theorem but is NEVER used: a grep of §2.2.4
finds no occurrence of "second derivative" or f''.

This file exhibits an explicit rational quartic satisfying (H1)(H2)(H3) for which the
conclusion FAILS at every critical point.  Hence (H1)(H2)(H3) do not imply the conclusion,
so the argument of §2.2.4 cannot establish it.

WHAT THIS DOES NOT CLAIM.  Theorem 7 is not refuted.  A genuine counterexample to
Theorem 7 would be a rational-derived p(1,1,1,1) quartic, i.e. a counterexample to BM's
Conjecture 1, which is open.  The witness below has f'' NOT splitting, consistent with
Conjecture 1.  The claim is exactly: **the stated argument does not prove the stated
conclusion.**
-/

namespace BMThm7Gap

/-! ## 0. Arithmetic helpers -/

/-- If no integer squares to `n`, no rational does. [std-3] -/
theorem no_rat_sq_of_no_int_sq (n : ℤ) (hn : ∀ y : ℤ, y ^ 2 ≠ n) (u : ℚ)
    (h : u ^ 2 = (n : ℚ)) : False := by
  have hr : ((u : ℝ)) ^ 2 = ((n : ℤ) : ℝ) := by exact_mod_cast h
  have hv : ¬ ∃ y : ℤ, ((u : ℝ)) = (y : ℝ) := by
    rintro ⟨y, hy⟩
    have hu : u = (y : ℚ) := by exact_mod_cast hy
    refine hn y ?_
    rw [hu] at h
    exact_mod_cast h
  exact (Rat.not_irrational u) (irrational_nrt_of_notint_nrt 2 n hr hv (by norm_num))

theorem no_int_sq_57 : ∀ y : ℤ, y ^ 2 ≠ 57 := by
  intro y h
  have h1 : y ≤ 7 := by nlinarith [sq_nonneg (y - 8), sq_nonneg (y + 8)]
  have h2 : -7 ≤ y := by nlinarith [sq_nonneg (y - 8), sq_nonneg (y + 8)]
  interval_cases y <;> omega

theorem no_int_sq_209 : ∀ y : ℤ, y ^ 2 ≠ 209 := by
  intro y h
  have h1 : y ≤ 14 := by nlinarith [sq_nonneg (y - 15), sq_nonneg (y + 15)]
  have h2 : -14 ≤ y := by nlinarith [sq_nonneg (y - 15), sq_nonneg (y + 15)]
  interval_cases y <;> omega

theorem no_rat_sq_57 (u : ℚ) (h : u ^ 2 = 57) : False :=
  no_rat_sq_of_no_int_sq 57 no_int_sq_57 u (by exact_mod_cast h)

theorem no_rat_sq_209 (u : ℚ) (h : u ^ 2 = 209) : False :=
  no_rat_sq_of_no_int_sq 209 no_int_sq_209 u (by exact_mod_cast h)

/-! ## 1. The witness -/

/-- The witness quartic.  Roots `0, 136, 52, -312` — four DISTINCT rationals.
Provenance: BM's own §2.2 coordinates `y = x(x-4a)(x-4b)(x-4c)` at `(A,B,C) = (-99,-57,125)`,
found by exhaustive search over `|A|,|B|,|C| <= 260` (5,724,160 triples); machine-verified
independently in Wolfram and Magma. -/
def f (x : ℚ) : ℚ := x * (x - 136) * (x - 52) * (x + 312)

/-- Its derivative, in expanded Vieta form. -/
def fp (x : ℚ) : ℚ := 4 * x ^ 3 + 372 * x ^ 2 - 103168 * x + 2206464

/-- **Anchor [std-3].** `fp` really is the derivative of `f`, via mathlib's
`Polynomial.derivative` — not a hand-written formula. -/
noncomputable def fpoly : Polynomial ℚ :=
  Polynomial.X * (Polynomial.X - Polynomial.C 136) * (Polynomial.X - Polynomial.C 52) *
    (Polynomial.X + Polynomial.C 312)

theorem fpoly_eval (x : ℚ) : fpoly.eval x = f x := by
  unfold fpoly f; simp

theorem fp_is_deriv (x : ℚ) : (Polynomial.derivative fpoly).eval x = fp x := by
  unfold fpoly fp; simp [Polynomial.derivative_mul]; ring

/-- **(H2) f' splits over ℚ** — three rational roots `-221, 24, 104`. [std-3] -/
theorem fp_splits (x : ℚ) : fp x = 4 * (x + 221) * (x - 24) * (x - 104) := by
  unfold fp; ring

/-- **(H1) four distinct rational roots.** [std-3] -/
theorem roots_distinct :
    (0 : ℚ) ≠ 136 ∧ (0 : ℚ) ≠ 52 ∧ (0 : ℚ) ≠ -312 ∧
    (136 : ℚ) ≠ 52 ∧ (136 : ℚ) ≠ -312 ∧ (52 : ℚ) ≠ -312 := by
  norm_num

/-- **(H3) sym ≠ 0.** Normalising the roots to `0, 1, a, b` (divide by 136) gives
`a = 13/34`, `b = -39/17`; BM's excluded factors are `57/34`, `125/34`, `-99/34`,
all nonzero.  (Their numerators are `|A|,|B|,|C| = 57,125,99` — sym = 0 ⟺ ABC = 0.) [std-3] -/
theorem sym_ne_zero :
    ((13/34 : ℚ) - (-39/17) - 1) ^ 2 * ((13/34 : ℚ) - (-39/17) + 1) ^ 2 *
      ((13/34 : ℚ) + (-39/17) - 1) ^ 2 ≠ 0 := by
  norm_num

/-! ## 2. The conclusion of §2.2.4 fails at every critical point -/

/-- The critical points of `f` are exactly `-221, 24, 104`. [std-3] -/
theorem critical_points (x₀ : ℚ) (h : fp x₀ = 0) : x₀ = -221 ∨ x₀ = 24 ∨ x₀ = 104 := by
  rw [fp_splits] at h
  have h4 : (x₀ + 221) * (x₀ - 24) * (x₀ - 104) = 0 := by linarith
  rcases mul_eq_zero.mp h4 with h' | h'
  · rcases mul_eq_zero.mp h' with h'' | h''
    · left; linarith
    · right; left; linarith
  · right; right; linarith

/-- At `x₀ = 24` the vertical translate does NOT leave the other two roots rational. [std-3] -/
theorem no_split_at_24 :
    ¬ ∃ r s : ℚ, ∀ x : ℚ, f x - f 24 = (x - 24) ^ 2 * (x - r) * (x - s) := by
  rintro ⟨r, s, h⟩
  have h0 := h 0
  have h1 := h 1
  unfold f at h0 h1
  norm_num at h0 h1
  have hP : r * s = -43904 := by nlinarith [h0]
  have hS : r + s = -172 := by nlinarith [h0, h1]
  have hq : ((r - s) / 60) ^ 2 = 57 := by
    field_simp
    nlinarith [hP, hS]
  exact no_rat_sq_57 _ hq

/-- At `x₀ = 104` likewise. [std-3] -/
theorem no_split_at_104 :
    ¬ ∃ r s : ℚ, ∀ x : ℚ, f x - f 104 = (x - 104) ^ 2 * (x - r) * (x - s) := by
  rintro ⟨r, s, h⟩
  have h0 := h 0
  have h1 := h 1
  unfold f at h0 h1
  norm_num at h0 h1
  have hP : r * s = 6656 := by nlinarith [h0]
  have hS : r + s = -332 := by nlinarith [h0, h1]
  have hq : ((r - s) / 20) ^ 2 = 209 := by
    field_simp
    nlinarith [hP, hS]
  exact no_rat_sq_209 _ hq

/-- At `x₀ = -221` the residual discriminant is NEGATIVE (`-59400`), so the two extra roots
are not even real. [std-3] -/
theorem no_split_at_neg221 :
    ¬ ∃ r s : ℚ, ∀ x : ℚ, f x - f (-221) = (x - (-221)) ^ 2 * (x - r) * (x - s) := by
  rintro ⟨r, s, h⟩
  have h0 := h 0
  have h1 := h 1
  unfold f at h0 h1
  norm_num at h0 h1
  have hP : r * s = 40131 := by nlinarith [h0]
  have hS : r + s = 318 := by nlinarith [h0, h1]
  nlinarith [sq_nonneg (r - s), hP, hS]

/-! ## 3. Main theorem -/

/-- **[std-3, unconditional] The argument of BM2000 §2.2.4 is invalid.**

There is a rational quartic with
  (H1) four distinct rational roots,
  (H2) first derivative splitting over ℚ,
  (H3) `sym ≠ 0` (not one of BM's excluded symmetric cases),
such that at EVERY critical point the vertical translate making that point a double root
leaves the remaining two roots irrational.

Since (H1)(H2)(H3) are exactly the properties of `f` that §2.2.4's argument invokes — it
never mentions `f''` — the argument cannot establish its stated conclusion. -/
theorem BM_sec224_argument_invalid :
    (∀ x : ℚ, (Polynomial.derivative fpoly).eval x = fp x) ∧
    ((0 : ℚ) ≠ 136 ∧ (0 : ℚ) ≠ 52 ∧ (0 : ℚ) ≠ -312 ∧
      (136 : ℚ) ≠ 52 ∧ (136 : ℚ) ≠ -312 ∧ (52 : ℚ) ≠ -312) ∧
    (∀ x : ℚ, fp x = 4 * (x + 221) * (x - 24) * (x - 104)) ∧
    (∀ x₀ : ℚ, fp x₀ = 0 →
      ¬ ∃ r s : ℚ, ∀ x : ℚ, f x - f x₀ = (x - x₀) ^ 2 * (x - r) * (x - s)) := by
  refine ⟨fp_is_deriv, roots_distinct, fp_splits, ?_⟩
  intro x₀ h
  rcases critical_points x₀ h with rfl | rfl | rfl
  · exact no_split_at_neg221
  · exact no_split_at_24
  · exact no_split_at_104

end BMThm7Gap

#print axioms BMThm7Gap.fpoly_eval
#print axioms BMThm7Gap.fp_is_deriv
#print axioms BMThm7Gap.fp_splits
#print axioms BMThm7Gap.no_split_at_24
#print axioms BMThm7Gap.no_split_at_104
#print axioms BMThm7Gap.no_split_at_neg221
#print axioms BMThm7Gap.BM_sec224_argument_invalid
