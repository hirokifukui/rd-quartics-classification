import Mathlib

/-!
# The K-analogue of BM2000 Theorem 7 is FALSE — on a published object  [std-3, unconditional]

Buchholz–MacDougall, J. Number Theory 81 (2000) 210–233, Theorem 7 / §2.2.4 claims: a
rational-derived p(1,1,1,1) quartic admits a vertical translate making a critical point a
double root while the OTHER TWO roots stay in the base field.

Every step of §2.2.4's argument is available over a real quadratic field K:
  (i)(ii)(iii) polynomial identities;  (iv) D6 >= 0 needs only K ⊂ ℝ;
  (vi) D6 = 0 ⟹ f' has a double root ⟹ contradicts four distinct roots — any field;
  (vii) Schulz's Theorem 4 is Galois theory (Gal ⊆ A₃) — any field of char 0.
The ONLY step that does not transport is (v), the `sym = 0` exclusion — and the witness
below has `sym ≠ 0`, so it does not need (v).

So if §2.2.4's argument proved its conclusion, the K-analogue would follow.  It does not:

**Witness (PUBLISHED).**  R. J. Stroeker, *On Q-Derived Polynomials*, Rocky Mountain J.
Math. 36(5) (2006) [preprint EI 2002-30, Erasmus], §5.2, D = 3·31·37 = 3441, t = −7/17,
roots `1, −51/13, −17/7, −3`.  Scaling by 91 (an element of BM's group ⟨X⟩) gives the
integral model used here: roots `91, −357, −221, −273`.

Magma [MC]: f, f′, f″ ALL split over K = ℚ(√3441); four roots distinct; non-symmetric;
sym ≠ 0.  So it is a genuine PROPER K-derived p(1,1,1,1) — the exact hypothesis.
And the conclusion FAILS at every one of the three critical points.

Independently: this quartic is the SAME object (cross-ratio 17/8, `S = −W/91 − 17/7`) as
the ℚ witness of `BMThm7Gap.lean`, which was found by exhaustive search over BM's own
coordinates.  Two unrelated searches, one stone.

WHAT THIS DOES NOT CLAIM.  Theorem 7 over ℚ is NOT refuted; a ℚ counterexample would be a
counterexample to BM's Conjecture 1, which is open.  The claim is: **§2.2.4's argument,
run in a setting where the objects exist, proves a false statement.**
-/

namespace BMThm7GapK

/-! ## 0. Squares in ℚ and in a real quadratic field -/

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

/-- `Nat.sqrt` decides perfect squares, so this discharges large `n` without `interval_cases`. -/
theorem no_int_sq_of_natSqrt (n : ℕ) (h : Nat.sqrt n * Nat.sqrt n ≠ n) :
    ∀ y : ℤ, y ^ 2 ≠ (n : ℤ) := by
  intro y hy
  have hnat : y.natAbs * y.natAbs = n := by
    have h1 : ((y.natAbs * y.natAbs : ℕ) : ℤ) = y * y := Int.natAbs_mul_self
    have h2 : y * y = (n : ℤ) := by rw [← pow_two]; exact hy
    rw [h2] at h1
    exact_mod_cast h1
  exact h ((Nat.exists_mul_self n).mp ⟨y.natAbs, hnat⟩)

theorem no_rat_sq_57      (u : ℚ) (h : u ^ 2 = 57)     : False :=
  no_rat_sq_of_no_int_sq 57 (no_int_sq_of_natSqrt 57 (by norm_num)) u (by exact_mod_cast h)
theorem no_rat_sq_209     (u : ℚ) (h : u ^ 2 = 209)    : False :=
  no_rat_sq_of_no_int_sq 209 (no_int_sq_of_natSqrt 209 (by norm_num)) u (by exact_mod_cast h)
theorem no_rat_sq_21793   (u : ℚ) (h : u ^ 2 = 21793)  : False :=
  no_rat_sq_of_no_int_sq 21793 (no_int_sq_of_natSqrt 21793 (by norm_num)) u (by exact_mod_cast h)
theorem no_rat_sq_719169  (u : ℚ) (h : u ^ 2 = 719169) : False :=
  no_rat_sq_of_no_int_sq 719169 (no_int_sq_of_natSqrt 719169 (by norm_num)) u (by exact_mod_cast h)
theorem no_rat_sq_3441    (u : ℚ) (h : u ^ 2 = 3441)   : False :=
  no_rat_sq_of_no_int_sq 3441 (no_int_sq_of_natSqrt 3441 (by norm_num)) u (by exact_mod_cast h)

/-- **The shape of a square in `K = ℚ(√3441)`.** `(p + q√3441)² = x` with `x` rational
forces `2pq√3441 ∈ ℚ`, hence `pq = 0` since `√3441` is irrational.  So a rational `x` is
a square in `K` iff `x = p²` or `x = 3441 q²` for some rational `p`, `q`. [std-3] -/
theorem sqrt3441_irrational : Irrational (Real.sqrt 3441) := by
  have h2 : (Real.sqrt 3441) ^ 2 = ((3441 : ℤ) : ℝ) := by
    rw [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 3441)]; norm_num
  refine irrational_nrt_of_notint_nrt 2 3441 h2 ?_ (by norm_num)
  rintro ⟨y, hy⟩
  have hy2 : ((y : ℝ)) ^ 2 = ((3441 : ℤ) : ℝ) := by rw [← hy]; exact h2
  have : (y : ℤ) ^ 2 = (3441 : ℤ) := by exact_mod_cast hy2
  exact no_int_sq_of_natSqrt 3441 (by norm_num) y this

/-- A rational that is a square in `K = ℚ(√3441)` is `p²` or `3441·q²`. [std-3] -/
theorem rat_sq_in_K (x p q : ℚ) (h : ((p : ℝ) + (q : ℝ) * Real.sqrt 3441) ^ 2 = (x : ℝ)) :
    (∃ p' : ℚ, p' ^ 2 = x) ∨ (∃ q' : ℚ, 3441 * q' ^ 2 = x) := by
  have hs : (Real.sqrt 3441) ^ 2 = 3441 := by rw [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 3441)]
  have hexp : ((p : ℝ) ^ 2 + 3441 * (q : ℝ) ^ 2) + (2 * p * q) * Real.sqrt 3441 = (x : ℝ) := by
    rw [← h]; ring_nf; nlinarith [hs]
  by_cases hpq : (2 : ℚ) * p * q = 0
  · have h0 : p = 0 ∨ q = 0 := by
      rcases mul_eq_zero.mp hpq with h' | h'
      · rcases mul_eq_zero.mp h' with h'' | h''
        · norm_num at h''
        · left; exact h''
      · right; exact h'
    rcases h0 with rfl | rfl
    · right; exact ⟨q, by
        have : (3441 : ℝ) * (q : ℝ) ^ 2 = (x : ℝ) := by
          rw [← hexp]; push_cast; ring
        exact_mod_cast this⟩
    · left; exact ⟨p, by
        have : ((p : ℝ)) ^ 2 = (x : ℝ) := by
          rw [← hexp]; push_cast; ring
        exact_mod_cast this⟩
  · exfalso
    have hc : (2 * (p : ℝ) * (q : ℝ)) ≠ 0 := by
      intro hz; apply hpq; exact_mod_cast hz
    have hval : Real.sqrt 3441 = (((x - p ^ 2 - 3441 * q ^ 2) / (2 * p * q) : ℚ) : ℝ) := by
      push_cast
      rw [eq_div_iff hc]
      linarith [hexp]
    exact sqrt3441_irrational ⟨_, hval.symm⟩

/-! ## 1. The witness (Stroeker 2006 §5.2, D = 3441, t = −7/17, scaled by 91) -/

/-- Roots `91, −357, −221, −273`.  σ₁ = −760, σ₂ = 159250, **σ₃ = 0**, σ₄ = −1960038171. -/
def f (x : ℚ) : ℚ := (x - 91) * (x + 357) * (x + 221) * (x + 273)

def fp (x : ℚ) : ℚ := 4 * x ^ 3 + 2280 * x ^ 2 + 318500 * x

noncomputable def fpoly : Polynomial ℚ :=
  (Polynomial.X - Polynomial.C 91) * (Polynomial.X + Polynomial.C 357) *
    (Polynomial.X + Polynomial.C 221) * (Polynomial.X + Polynomial.C 273)

theorem fpoly_eval (x : ℚ) : fpoly.eval x = f x := by unfold fpoly f; simp

/-- **Anchor [std-3].** `fp` is mathlib's `Polynomial.derivative` of `fpoly`. -/
theorem fp_is_deriv (x : ℚ) : (Polynomial.derivative fpoly).eval x = fp x := by
  unfold fpoly fp; simp [Polynomial.derivative_mul]; ring

/-- **σ₃ = 0** — the x-coefficient of `f` vanishes, so `x = 0` IS a critical point.
This is exactly BM §2.2.3's / Stroeker §2's normalisation `f'(0) = 0`. [std-3] -/
theorem sigma3_zero (x : ℚ) :
    f x = x ^ 4 + 760 * x ^ 3 + 159250 * x ^ 2 + 0 * x - 1960038171 := by
  unfold f; ring

/-- **f′ splits over ℚ** — critical points `0, −245, −325`. [std-3] -/
theorem fp_splits (x : ℚ) : fp x = 4 * x * (x + 245) * (x + 325) := by unfold fp; ring

/-- **f″ splits over K = ℚ(√3441) but NOT over ℚ**: its discriminant is
`4560² − 4·12·318500 = 5505600 = 40²·3441`. [std-3] -/
theorem fpp_disc : (4560 : ℚ) ^ 2 - 4 * 12 * 318500 = 40 ^ 2 * 3441 := by norm_num

theorem fpp_not_split_over_Q : ¬ ∃ x : ℚ, 12 * x ^ 2 + 4560 * x + 318500 = 0 := by
  rintro ⟨x, hx⟩
  have h : ((6 * x + 1140) / 10) ^ 2 = 3441 := by
    field_simp
    nlinarith [hx]
  exact no_rat_sq_3441 _ h

/-- Four distinct roots. [std-3] -/
theorem roots_distinct :
    (91 : ℚ) ≠ -357 ∧ (91 : ℚ) ≠ -221 ∧ (91 : ℚ) ≠ -273 ∧
    (-357 : ℚ) ≠ -221 ∧ (-357 : ℚ) ≠ -273 ∧ (-221 : ℚ) ≠ -273 := by norm_num

/-- Non-symmetric (`sym ≠ 0`): the outer and inner root-sums differ. [std-3] -/
theorem not_symmetric : (-357 : ℚ) + 91 ≠ (-273 : ℚ) + (-221) := by norm_num

/-! ## 2. The vertical translate, and its residual discriminant -/

/-- The residual discriminant `σ₁² − 4σ₂ + 4σ₁x₀ − 8x₀²` with σ₁ = −760, σ₂ = 159250. -/
def discAt (x₀ : ℚ) : ℚ := -59400 - 3040 * x₀ - 8 * x₀ ^ 2

/-- **[std-3]** At a critical point, `f − f(x₀)` really does have a double root there, and
the residual quadratic is `x² + (2x₀+760)x + (3x₀²+1520x₀+159250)`.  (Off a critical point
the remainder is `f′(x₀)(x−x₀)`, which is exactly what `h` kills.) -/
theorem translate_factors (x₀ : ℚ) (h : fp x₀ = 0) (x : ℚ) :
    f x - f x₀
      = (x - x₀) ^ 2 * (x ^ 2 + (2 * x₀ + 760) * x + (3 * x₀ ^ 2 + 1520 * x₀ + 159250)) := by
  unfold f fp at *
  linear_combination (x - x₀) * h

/-- **[std-3]** The residual quadratic's discriminant is `discAt x₀`. -/
theorem residual_disc (x₀ : ℚ) :
    (2 * x₀ + 760) ^ 2 - 4 * (3 * x₀ ^ 2 + 1520 * x₀ + 159250) = discAt x₀ := by
  unfold discAt; ring

theorem critical_points (x₀ : ℚ) (h : fp x₀ = 0) : x₀ = 0 ∨ x₀ = -245 ∨ x₀ = -325 := by
  rw [fp_splits] at h
  have h4 : x₀ * (x₀ + 245) * (x₀ + 325) = 0 := by linarith
  rcases mul_eq_zero.mp h4 with h' | h'
  · rcases mul_eq_zero.mp h' with h'' | h''
    · left; exact h''
    · right; left; linarith
  · right; right; linarith

/-! ## 3. None of the three discriminants is a square in K = ℚ(√3441) -/

theorem disc_0_not_sq   : ¬ ∃ p q : ℚ, ((p : ℝ) + (q : ℝ) * Real.sqrt 3441) ^ 2 = ((-59400 : ℚ) : ℝ) := by
  rintro ⟨p, q, h⟩
  have := sq_nonneg ((p : ℝ) + (q : ℝ) * Real.sqrt 3441)
  rw [h] at this
  norm_num at this

theorem disc_245_not_sq : ¬ ∃ p q : ℚ, ((p : ℝ) + (q : ℝ) * Real.sqrt 3441) ^ 2 = ((205200 : ℚ) : ℝ) := by
  rintro ⟨p, q, h⟩
  rcases rat_sq_in_K 205200 p q h with ⟨p', hp'⟩ | ⟨q', hq'⟩
  · exact no_rat_sq_57 (p' / 60) (by field_simp; nlinarith [hp'])
  · exact no_rat_sq_21793 (1147 * q' / 60) (by field_simp; nlinarith [hq'])

theorem disc_325_not_sq : ¬ ∃ p q : ℚ, ((p : ℝ) + (q : ℝ) * Real.sqrt 3441) ^ 2 = ((83600 : ℚ) : ℝ) := by
  rintro ⟨p, q, h⟩
  rcases rat_sq_in_K 83600 p q h with ⟨p', hp'⟩ | ⟨q', hq'⟩
  · exact no_rat_sq_209 (p' / 20) (by field_simp; nlinarith [hp'])
  · exact no_rat_sq_719169 (3441 * q' / 20) (by field_simp; nlinarith [hq'])

/-- **[std-3]** At EVERY critical point, the residual discriminant is not a square in K. -/
theorem discAt_not_sq_in_K (x₀ : ℚ) (h : fp x₀ = 0) :
    ¬ ∃ p q : ℚ, ((p : ℝ) + (q : ℝ) * Real.sqrt 3441) ^ 2 = ((discAt x₀ : ℚ) : ℝ) := by
  rcases critical_points x₀ h with rfl | rfl | rfl
  · have e : discAt 0 = -59400 := by norm_num [discAt]
    rw [e]; exact disc_0_not_sq
  · have e : discAt (-245) = 205200 := by norm_num [discAt]
    rw [e]; exact disc_245_not_sq
  · have e : discAt (-325) = 83600 := by norm_num [discAt]
    rw [e]; exact disc_325_not_sq

/-! ## 4. Hence the two remaining roots do NOT lie in K -/

/-- **[std-3] The conclusion of BM §2.2.4 fails over K at every critical point.**
If the residual quadratic factored with both roots in `K = ℚ(√3441)`, their difference
would lie in `K` and its square would be `discAt x₀` — impossible by `discAt_not_sq_in_K`. -/
theorem no_K_roots_at (x₀ : ℚ) (h : fp x₀ = 0)
    (pr qr ps qs : ℚ)
    (hfac : ∀ z : ℝ,
      z ^ 2 + ((2 * x₀ + 760 : ℚ) : ℝ) * z + ((3 * x₀ ^ 2 + 1520 * x₀ + 159250 : ℚ) : ℝ)
        = (z - ((pr : ℝ) + (qr : ℝ) * Real.sqrt 3441)) *
          (z - ((ps : ℝ) + (qs : ℝ) * Real.sqrt 3441))) : False := by
  set r : ℝ := (pr : ℝ) + (qr : ℝ) * Real.sqrt 3441 with hrdef
  set t : ℝ := (ps : ℝ) + (qs : ℝ) * Real.sqrt 3441 with htdef
  have h0 := hfac 0
  have h1 := hfac 1
  have hP : r * t = ((3 * x₀ ^ 2 + 1520 * x₀ + 159250 : ℚ) : ℝ) := by nlinarith [h0]
  have hS : r + t = -((2 * x₀ + 760 : ℚ) : ℝ) := by nlinarith [h0, h1]
  refine discAt_not_sq_in_K x₀ h ⟨pr - ps, qr - qs, ?_⟩
  have hdiff : ((pr - ps : ℚ) : ℝ) + ((qr - qs : ℚ) : ℝ) * Real.sqrt 3441 = r - t := by
    rw [hrdef, htdef]; push_cast; ring
  rw [hdiff]
  have hsq : (r - t) ^ 2 = (r + t) ^ 2 - 4 * (r * t) := by ring
  rw [hsq, hP, hS]
  simp only [discAt]
  push_cast
  ring

/-! ## 5. Main theorem -/

/-- **[std-3, unconditional] The K-analogue of BM2000 Theorem 7 is FALSE.**

`f` is Stroeker (2006) §5.2's published proper K-derived p(1,1,1,1) quartic for
`D = 3·31·37 = 3441`, `t = −7/17`, in an integral model (roots scaled by 91).  It has:
  * four distinct rational roots (hence in `K`);
  * `σ₃ = 0` — BM §2.2.3 / Stroeker §2's own normalisation, so `x = 0` is a critical point;
  * `f′` splitting over `ℚ` (a fortiori over `K`), roots `0, −245, −325`;
  * `f″` splitting over `K` but NOT over `ℚ` (its discriminant is `40²·3441`);
  * `sym ≠ 0` (non-symmetric), so it is outside BM's excluded case.
So `f` satisfies the FULL hypothesis of the K-analogue of Theorem 7 — a genuine proper
K-derived p(1,1,1,1).  Yet at every critical point the residual discriminant is not a
square in `K`, so the remaining two roots are NOT in `K`.

Since every step of §2.2.4's argument transports to a real quadratic field except the
`sym = 0` exclusion — which this witness does not need — the argument, run where the
objects exist, proves a false statement.  It has no proving power. -/
theorem K_analogue_of_thm7_is_false :
    (∀ x : ℚ, (Polynomial.derivative fpoly).eval x = fp x) ∧
    (∀ x : ℚ, f x = x ^ 4 + 760 * x ^ 3 + 159250 * x ^ 2 + 0 * x - 1960038171) ∧
    (∀ x : ℚ, fp x = 4 * x * (x + 245) * (x + 325)) ∧
    (¬ ∃ x : ℚ, 12 * x ^ 2 + 4560 * x + 318500 = 0) ∧
    ((4560 : ℚ) ^ 2 - 4 * 12 * 318500 = 40 ^ 2 * 3441) ∧
    ((-357 : ℚ) + 91 ≠ (-273 : ℚ) + (-221)) ∧
    (∀ x₀ : ℚ, fp x₀ = 0 → ∀ pr qr ps qs : ℚ,
      ¬ ∀ z : ℝ,
        z ^ 2 + ((2 * x₀ + 760 : ℚ) : ℝ) * z + ((3 * x₀ ^ 2 + 1520 * x₀ + 159250 : ℚ) : ℝ)
          = (z - ((pr : ℝ) + (qr : ℝ) * Real.sqrt 3441)) *
            (z - ((ps : ℝ) + (qs : ℝ) * Real.sqrt 3441))) :=
  ⟨fp_is_deriv, sigma3_zero, fp_splits, fpp_not_split_over_Q, fpp_disc, not_symmetric,
   fun x₀ h pr qr ps qs hfac => no_K_roots_at x₀ h pr qr ps qs hfac⟩

end BMThm7GapK

#print axioms BMThm7GapK.no_rat_sq_of_no_int_sq
#print axioms BMThm7GapK.no_int_sq_of_natSqrt
#print axioms BMThm7GapK.sqrt3441_irrational
#print axioms BMThm7GapK.rat_sq_in_K
#print axioms BMThm7GapK.fp_is_deriv
#print axioms BMThm7GapK.sigma3_zero
#print axioms BMThm7GapK.fp_splits
#print axioms BMThm7GapK.translate_factors
#print axioms BMThm7GapK.disc_245_not_sq
#print axioms BMThm7GapK.disc_325_not_sq
#print axioms BMThm7GapK.discAt_not_sq_in_K
#print axioms BMThm7GapK.no_K_roots_at
#print axioms BMThm7GapK.K_analogue_of_thm7_is_false
