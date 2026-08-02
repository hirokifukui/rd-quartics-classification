/-
Gap/BMThm7Terrain.lean -- the normalization bridge: Conjecture 1 in the
{0,1,a,b} normal form is equivalent to the nonexistence of nondegenerate
rational points on the splitting terrain (2026-08-02; statements FROZEN by
claude.ai, tactics delegated; division of labour and responsibility:
AI_PROVENANCE.md at the repository root)

The two coordinate systems of this repository:
  * Conjecture1_normal (Gap/BMThm7Transcript.lean): quartics x(x-1)(x-a)(x-b)
    -- a root at 0, a root at 1.
  * The terrain chart (Gap/BMThm7Boundary.lean, blueprint Ch. 4): roots
    {1,a,b,c} with sigma_3 = 0 (a critical point of f at the origin), so
    c = -ab/den, and splitting witnesses z, w for f', f''.
This file proves the equivalence, tracking every normalisation condition:
den /= 0 (automatic from nonzero roots), distinctness, nonzeroness of all
roots (a critical point of a squarefree quartic is not a root), the exact
correspondence of z, w with the split witnesses, and preservation of
K-derivedness under the affine changes (horizontal shift, scaling, unit
multiple).  Choices (of critical point, of scaling root) are immaterial:
only existence transfers, which is all the equivalence needs.
-/
import Mathlib
import Gap.BMThm7Transcript
import Gap.BMThm7Boundary

namespace BMThm7Terrain

open Polynomial BMThm7Transcript BMThm7Boundary

/-- The monic quartic with roots {1, a, b, c}. -/
noncomputable def rootQuartic (a b c : ℚ) : ℚ[X] :=
  (X - 1) * (X - C a) * (X - C b) * (X - C c)

/-- Nondegenerate rational point of the splitting terrain: chart data (a,b)
with den /= 0, splitting witnesses z, w, and the four roots {1, a, b, c},
c = -ab/den, pairwise distinct and nonzero. -/
def NondegTerrainPoint (a b z w : ℚ) : Prop :=
  den a b ≠ 0 ∧ z ^ 2 = Rq a b ∧ w ^ 2 = Sq a b ∧
  a ≠ 0 ∧ b ≠ 0 ∧ a ≠ 1 ∧ b ≠ 1 ∧ a ≠ b ∧
  -(a * b) / den a b ≠ 0 ∧ -(a * b) / den a b ≠ 1 ∧
  -(a * b) / den a b ≠ a ∧ -(a * b) / den a b ≠ b

/-- Expansion of the root quartic in elementary symmetric coordinates. -/
theorem rootQuartic_expand (a b c : ℚ) :
    rootQuartic a b c
      = X ^ 4 - C (1 + a + b + c) * X ^ 3 + C (a + b + c + a*b + a*c + b*c) * X ^ 2
        - C (a*b + a*c + b*c + a*b*c) * X + C (a*b*c) := by
  simp only [rootQuartic, map_add, map_mul, map_one]
  ring

/-- A monic rational quadratic with square discriminant splits. -/
theorem quadratic_splits_of_sq (p q d : ℚ) (h : d ^ 2 = p ^ 2 - 4 * q) :
    (X ^ 2 + C p * X + C q : ℚ[X]).Splits := by
  have h2 : ((-p+d)/2) * ((-p-d)/2) = q := by linear_combination (-1/4 : ℚ) * h
  have hfac : (X ^ 2 + C p * X + C q : ℚ[X])
      = (X - C ((-p+d)/2)) * (X - C ((-p-d)/2)) := by
    have e : (X - C ((-p+d)/2)) * (X - C ((-p-d)/2))
        = X ^ 2 - (C ((-p+d)/2) + C ((-p-d)/2)) * X
          + C ((-p+d)/2) * C ((-p-d)/2) := by ring
    rw [e, ← map_add, ← map_mul]
    have h1 : (-p+d)/2 + (-p-d)/2 = -p := by ring
    rw [h1, h2, map_neg]; ring
  rw [hfac]
  exact (Splits.X_sub_C _).mul (Splits.X_sub_C _)

/-- Conversely, a split monic rational quadratic has square discriminant. -/
theorem exists_sq_of_quadratic_splits (p q : ℚ)
    (h : (X ^ 2 + C p * X + C q : ℚ[X]).Splits) :
    ∃ d : ℚ, d ^ 2 = p ^ 2 - 4 * q := by
  have hdeg : (X ^ 2 + C p * X + C q : ℚ[X]).degree = 2 := by
    have he : (X ^ 2 + C p * X + C q : ℚ[X]) = C 1 * X ^ 2 + C p * X + C q := by
      rw [C_1, one_mul]
    rw [he]; exact degree_quadratic (by norm_num)
  obtain ⟨r, hr⟩ := h.exists_eval_eq_zero (by rw [hdeg]; decide)
  simp only [eval_add, eval_mul, eval_pow, eval_X, eval_C] at hr
  exact ⟨2 * r + p, by linear_combination 4 * hr⟩

/-- K-derivedness is invariant under nonzero constant multiples. -/
theorem KDerived_C_mul_iff (p : ℚ[X]) (c : ℚ) (hc : c ≠ 0) :
    KDerived (C c * p) ↔ KDerived p := by
  have hSC : ∀ g : ℚ[X], Splits (C c * g) ↔ Splits g := by
    intro g
    refine ⟨fun h => ?_, fun h => h.C_mul c⟩
    have := h.C_mul c⁻¹
    rwa [← mul_assoc, ← C_mul, inv_mul_cancel₀ hc, C_1, one_mul] at this
  have hDC : ∀ g : ℚ[X], derivative (C c * g) = C c * derivative g := by
    intro g; simp [derivative_mul, derivative_C]
  simp only [KDerived, hDC, hSC]

/-- K-derivedness is invariant under horizontal shift. -/
theorem KDerived_shift_iff (p : ℚ[X]) (t : ℚ) :
    KDerived (p.comp (X + C t)) ↔ KDerived p := by
  have hder : ∀ q : ℚ[X], derivative (q.comp (X + C t)) = (derivative q).comp (X + C t) := by
    intro q; rw [derivative_comp]; simp [derivative_add, derivative_X, derivative_C]
  have hnd : (X + C t : ℚ[X]).natDegree = 1 := by
    rw [natDegree_add_C]; exact natDegree_X
  have hcomp : ∀ q : ℚ[X], Splits (q.comp (X + C t)) ↔ Splits q := by
    intro q; exact (splits_iff_comp_splits_of_natDegree_eq_one hnd).symm
  simp only [KDerived, hder, hcomp]

/-- K-derivedness is invariant under nonzero scaling of the variable. -/
theorem KDerived_scale_iff (p : ℚ[X]) (l : ℚ) (hl : l ≠ 0) :
    KDerived (p.comp (C l * X)) ↔ KDerived p := by
  have hSC : ∀ g : ℚ[X], Splits (C l * g) ↔ Splits g := by
    intro g
    refine ⟨fun h => ?_, fun h => h.C_mul l⟩
    have := h.C_mul l⁻¹
    rwa [← mul_assoc, ← C_mul, inv_mul_cancel₀ hl, C_1, one_mul] at this
  have hDC : ∀ g : ℚ[X], derivative (C l * g) = C l * derivative g := by
    intro g; simp [derivative_mul, derivative_C]
  have hderX : derivative (C l * X : ℚ[X]) = C l := by
    simp [derivative_mul, derivative_C, derivative_X]
  have hder : ∀ q : ℚ[X], derivative (q.comp (C l * X)) = C l * (derivative q).comp (C l * X) := by
    intro q; rw [derivative_comp, hderX, mul_comm]
  have hnd : (C l * X : ℚ[X]).natDegree = 1 := by
    rw [natDegree_C_mul hl, natDegree_X]
  have hcomp : ∀ q : ℚ[X], Splits (q.comp (C l * X)) ↔ Splits q := by
    intro q; exact (splits_iff_comp_splits_of_natDegree_eq_one hnd).symm
  simp only [KDerived, hder, hDC, hSC, hcomp]

/-- **Terrain point to normal form**: a nondegenerate terrain point produces a
K-derived quartic with four distinct rational roots in the {0,1,a,b} normal
form. -/
theorem kderived_of_terrain {a b z w : ℚ} (h : NondegTerrainPoint a b z w) :
    ∃ A B : ℚ, DistinctRoots A B ∧ KDerived (bmQuartic A B) := by
  obtain ⟨hden, hz, hw, ha0, hb0, ha1, hb1, hab, hc0, hc1, hca, hcb⟩ := h
  set c : ℚ := -(a * b) / den a b with hc
  -- the defining relation of the critical funnel coordinate
  have hden0 : a * b + a + b ≠ 0 := by simpa only [den] using hden
  have hcd : c * den a b = -(a * b) := by rw [hc]; exact div_mul_cancel₀ _ hden
  have hc_den : c * (a * b + a + b) = -(a * b) := by simpa only [den] using hcd
  -- sigma_3 = 0
  have he3 : a * b + a * c + b * c + a * b * c = 0 := by linear_combination hc_den
  -- cleared elementary-symmetric identities
  have hs1 : s1n a b = (1 + a + b + c) * den a b := by
    simp only [s1n, den]; linear_combination -hc_den
  have hs2 : s2n a b = (a + b + c + a * b + a * c + b * c) * den a b := by
    simp only [s2n, den]; linear_combination -(1 + a + b) * hc_den
  have hRq : Rq a b
      = (den a b) ^ 2 * (9 * (1 + a + b + c) ^ 2 - 32 * (a + b + c + a * b + a * c + b * c)) := by
    simp only [Rq]; rw [hs1, hs2]; ring
  have hSq : Sq a b
      = (den a b) ^ 2 * (9 * (1 + a + b + c) ^ 2 - 24 * (a + b + c + a * b + a * c + b * c)) := by
    simp only [Sq]; rw [hs1, hs2]; ring
  -- discriminant square witnesses for f' and f''
  have hd1 : (z / (4 * den a b)) ^ 2
      = (-(3 * (1 + a + b + c)) / 4) ^ 2 - 4 * ((a + b + c + a * b + a * c + b * c) / 2) := by
    rw [div_pow, hz, hRq]; field_simp; ring
  have hd2 : (w / (6 * den a b)) ^ 2
      = (-(1 + a + b + c) / 2) ^ 2 - 4 * ((a + b + c + a * b + a * c + b * c) / 6) := by
    rw [div_pow, hw, hSq]; field_simp; ring
  -- f splits (four linear factors)
  have hfsplit : (rootQuartic a b c).Splits := by
    rw [rootQuartic, show (X - 1 : ℚ[X]) = X - C 1 by rw [C_1]]
    exact (((Splits.X_sub_C 1).mul (Splits.X_sub_C a)).mul (Splits.X_sub_C b)).mul
      (Splits.X_sub_C c)
  -- the derivative factorisations
  have hD1 : derivative (rootQuartic a b c)
      = C 4 * X * (X ^ 2 + C (-(3 * (1 + a + b + c)) / 4) * X
        + C ((a + b + c + a * b + a * c + b * c) / 2)) := by
    rw [rootQuartic_expand, he3]
    simp only [C_0, zero_mul, sub_zero]
    apply Polynomial.funext; intro x
    simp only [derivative_sub, derivative_add, derivative_mul, derivative_C, derivative_X_pow,
      zero_mul, add_zero, zero_add,
      eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C,
      Nat.cast_ofNat, map_ofNat, eval_ofNat]
    ring
  have hf'split : (derivative (rootQuartic a b c)).Splits := by
    rw [hD1]
    exact ((Splits.C 4).mul Splits.X).mul (quadratic_splits_of_sq _ _ _ hd1)
  have hD2 : derivative (derivative (rootQuartic a b c))
      = C 12 * (X ^ 2 + C (-(1 + a + b + c) / 2) * X
        + C ((a + b + c + a * b + a * c + b * c) / 6)) := by
    rw [rootQuartic_expand]
    apply Polynomial.funext; intro x
    simp only [derivative_sub, derivative_add, derivative_mul, derivative_C, derivative_X_pow,
      derivative_X, derivative_ofNat, zero_mul, add_zero, zero_add, mul_one,
      eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C, eval_zero,
      Nat.cast_ofNat, map_ofNat, eval_ofNat]
    ring
  have hf''split : (derivative (derivative (rootQuartic a b c))).Splits := by
    rw [hD2]
    exact (quadratic_splits_of_sq _ _ _ hd2).C_mul 12
  have hD3 : derivative (derivative (derivative (rootQuartic a b c)))
      = C 24 * (X - C ((1 + a + b + c) / 4)) := by
    rw [rootQuartic_expand]
    apply Polynomial.funext; intro x
    simp only [derivative_sub, derivative_add, derivative_mul, derivative_C, derivative_X_pow,
      derivative_X, derivative_ofNat, derivative_zero, zero_mul, add_zero, zero_add, mul_one,
      eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C, eval_zero,
      Nat.cast_ofNat, map_ofNat, eval_ofNat]
    ring
  have hf'''split : (derivative (derivative (derivative (rootQuartic a b c)))).Splits := by
    rw [hD3]
    exact (Splits.X_sub_C _).C_mul 24
  have hKf : KDerived (rootQuartic a b c) := ⟨hfsplit, hf'split, hf''split, hf'''split⟩
  -- transport to the {0,1,a,b} normal form by shift (root 1 -> 0) then scaling (root a-1 -> 1)
  have hane : a - 1 ≠ 0 := sub_ne_zero.mpr ha1
  refine ⟨(b - 1) / (a - 1), (c - 1) / (a - 1), ?_, ?_⟩
  · -- DistinctRoots
    refine ⟨div_ne_zero (sub_ne_zero.mpr hb1) hane, ?_,
      div_ne_zero (sub_ne_zero.mpr hc1) hane, ?_, ?_⟩
    · intro heq; apply hab; field_simp [hane] at heq; linarith
    · intro heq; apply hca; field_simp [hane] at heq; linarith
    · intro heq; apply hcb; field_simp [hane] at heq; linarith
  · -- KDerived (bmQuartic A B)
    have htrans : ((rootQuartic a b c).comp (X + C 1)).comp (C (a - 1) * X)
        = C ((a - 1) ^ 4) * bmQuartic ((b - 1) / (a - 1)) ((c - 1) / (a - 1)) := by
      apply Polynomial.funext; intro x
      simp only [rootQuartic, bmQuartic, eval_comp, eval_mul, eval_sub, eval_add, eval_C, eval_X,
        eval_one]
      field_simp
      ring
    have hK1 := (KDerived_shift_iff (rootQuartic a b c) 1).mpr hKf
    have hK2 := (KDerived_scale_iff ((rootQuartic a b c).comp (X + C 1)) (a - 1) hane).mpr hK1
    rw [htrans] at hK2
    exact (KDerived_C_mul_iff _ ((a - 1) ^ 4) (pow_ne_zero 4 hane)).mp hK2

/-- **Normal form to terrain point**: a K-derived quartic with four distinct
rational roots in the {0,1,a,b} normal form produces a nondegenerate terrain
point. -/
theorem terrain_of_kderived {a b : ℚ} (hd : DistinctRoots a b)
    (hk : KDerived (bmQuartic a b)) :
    ∃ A B z w : ℚ, NondegTerrainPoint A B z w := by
  obtain ⟨ha0, ha1, hb0, hb1, hab⟩ := hd
  -- Step 1: a rational critical point x0 of f = bmQuartic a b
  have hev : ∀ y : ℚ, eval y (derivative (bmQuartic a b))
      = 4 * y ^ 3 - 3 * (a + b + 1) * y ^ 2 + 2 * (a * b + a + b) * y - a * b := by
    intro y; rw [derivative_bmQuartic]
    simp only [eval_sub, eval_add, eval_mul, eval_pow, eval_X, eval_C, eval_one, eval_ofNat]
  have hdeg3 : (derivative (bmQuartic a b)).degree = 3 := by
    rw [derivative_bmQuartic]; compute_degree!
  obtain ⟨x0, hx0⟩ := hk.2.1.exists_eval_eq_zero (by rw [hdeg3]; decide)
  -- Step 2: x0 is not a root of f (a critical point of a squarefree quartic is not a root)
  have ev0 : eval 0 (derivative (bmQuartic a b)) = -(a * b) := by rw [hev]; ring
  have ev1 : eval 1 (derivative (bmQuartic a b)) = (1 - a) * (1 - b) := by rw [hev]; ring
  have eva : eval a (derivative (bmQuartic a b)) = a * (a - 1) * (a - b) := by rw [hev]; ring
  have evb : eval b (derivative (bmQuartic a b)) = b * (b - 1) * (b - a) := by rw [hev]; ring
  have hx0ne0 : x0 ≠ 0 := by
    intro h; rw [h, ev0] at hx0; exact (mul_ne_zero ha0 hb0) (by linarith)
  have hx0ne1 : x0 ≠ 1 := by
    intro h; rw [h, ev1] at hx0
    rcases mul_eq_zero.1 hx0 with h' | h'
    · exact ha1 (by linarith)
    · exact hb1 (by linarith)
  have hx0nea : x0 ≠ a := by
    intro h; rw [h, eva] at hx0
    exact (mul_ne_zero (mul_ne_zero ha0 (sub_ne_zero.mpr ha1)) (sub_ne_zero.mpr hab)) hx0
  have hx0neb : x0 ≠ b := by
    intro h; rw [h, evb] at hx0
    exact (mul_ne_zero (mul_ne_zero hb0 (sub_ne_zero.mpr hb1)) (sub_ne_zero.mpr (Ne.symm hab))) hx0
  have hlne : (-x0 : ℚ) ≠ 0 := neg_ne_zero.mpr hx0ne0
  -- Step 3: shift by x0, scale by -x0; the {1,A,B,Cc} chart
  set A : ℚ := (1 - x0) / (-x0) with hAdef
  set B : ℚ := (a - x0) / (-x0) with hBdef
  set Cc : ℚ := (b - x0) / (-x0) with hCcdef
  have hAne0 : A ≠ 0 := by rw [hAdef]; exact div_ne_zero (sub_ne_zero.mpr hx0ne1.symm) hlne
  have hBne0 : B ≠ 0 := by rw [hBdef]; exact div_ne_zero (sub_ne_zero.mpr hx0nea.symm) hlne
  have hCcne0 : Cc ≠ 0 := by rw [hCcdef]; exact div_ne_zero (sub_ne_zero.mpr hx0neb.symm) hlne
  have hAne1 : A ≠ 1 := by rw [hAdef]; intro heq; field_simp [hlne] at heq; linarith
  have hBne1 : B ≠ 1 := by
    rw [hBdef]; intro heq; field_simp [hlne] at heq; exact ha0 (by linarith)
  have hCcne1 : Cc ≠ 1 := by
    rw [hCcdef]; intro heq; field_simp [hlne] at heq; exact hb0 (by linarith)
  have hABne : A ≠ B := by
    rw [hAdef, hBdef]; intro heq; field_simp [hlne] at heq; exact ha1 (by linarith)
  have hCcneA : Cc ≠ A := by
    rw [hCcdef, hAdef]; intro heq; field_simp [hlne] at heq; exact hb1 (by linarith)
  have hCcneB : Cc ≠ B := by
    rw [hCcdef, hBdef]; intro heq; field_simp [hlne] at heq; exact hab (by linarith)
  have htrans : ((bmQuartic a b).comp (X + C x0)).comp (C (-x0) * X)
      = C ((-x0) ^ 4) * rootQuartic A B Cc := by
    apply Polynomial.funext; intro x
    simp only [bmQuartic, rootQuartic, eval_comp, eval_mul, eval_sub, eval_add, eval_C, eval_X,
      eval_one]
    rw [hAdef, hBdef, hCcdef]
    field_simp
    ring
  -- Step 4: rootQuartic A B Cc is K-derived
  have hK1 := (KDerived_shift_iff (bmQuartic a b) x0).mpr hk
  have hK2 := (KDerived_scale_iff ((bmQuartic a b).comp (X + C x0)) (-x0) hlne).mpr hK1
  rw [htrans] at hK2
  have hKq := (KDerived_C_mul_iff _ ((-x0) ^ 4) (pow_ne_zero 4 hlne)).mp hK2
  -- 0 is a critical point of the chart quartic: sigma_3 = 0
  have hshiftder : ∀ (p : ℚ[X]) (t : ℚ),
      derivative (p.comp (X + C t)) = (derivative p).comp (X + C t) := by
    intro p t; rw [derivative_comp]; simp [derivative_add, derivative_X, derivative_C]
  have hscaleder : ∀ (p : ℚ[X]) (k : ℚ),
      derivative (p.comp (C k * X)) = C k * (derivative p).comp (C k * X) := by
    intro p k
    rw [derivative_comp,
      show derivative (C k * X : ℚ[X]) = C k by simp [derivative_mul, derivative_C, derivative_X],
      mul_comm]
  have hcrit0 : eval 0 (derivative (rootQuartic A B Cc)) = 0 := by
    have key : derivative (((bmQuartic a b).comp (X + C x0)).comp (C (-x0) * X))
        = C ((-x0) ^ 4) * derivative (rootQuartic A B Cc) := by
      rw [htrans]; simp only [derivative_mul, derivative_C, zero_mul, zero_add]
    rw [hscaleder, hshiftder] at key
    have e := congrArg (eval 0) key
    simp only [eval_mul, eval_comp, eval_C, eval_add, eval_X, mul_zero, zero_add] at e
    rw [hx0, mul_zero] at e
    rcases mul_eq_zero.1 e.symm with h | h
    · exact absurd h (pow_ne_zero 4 hlne)
    · exact h
  have hqder : ∀ y : ℚ, eval y (derivative (rootQuartic A B Cc))
      = 4 * y ^ 3 - 3 * (1 + A + B + Cc) * y ^ 2
        + 2 * (A + B + Cc + A * B + A * Cc + B * Cc) * y - (A * B + A * Cc + B * Cc + A * B * Cc) := by
    intro y; rw [rootQuartic_expand]
    simp only [derivative_sub, derivative_add, derivative_mul, derivative_C, derivative_X_pow,
      derivative_X, zero_mul, add_zero,
      zero_add, mul_one, eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C,
      Nat.cast_ofNat, map_ofNat, eval_ofNat]
    ring
  have hE3zero : A * B + A * Cc + B * Cc + A * B * Cc = 0 := by
    have h := hqder 0; rw [hcrit0] at h; linear_combination h
  have hCcden : Cc * den A B = -(A * B) := by simp only [den]; linear_combination hE3zero
  have hCcden' : Cc * (A * B + A + B) = -(A * B) := by simpa only [den] using hCcden
  have hdenAB : den A B ≠ 0 := by
    intro h0; rw [h0, mul_zero] at hCcden
    rcases mul_eq_zero.1 (by linarith : A * B = 0) with h | h
    · exact hAne0 h
    · exact hBne0 h
  have hCceq : Cc = -(A * B) / den A B := (eq_div_iff hdenAB).mpr hCcden
  -- Step 5: the split witnesses z, w
  have hs1AB : s1n A B = (1 + A + B + Cc) * den A B := by
    simp only [s1n, den]; linear_combination -hCcden'
  have hs2AB : s2n A B = (A + B + Cc + A * B + A * Cc + B * Cc) * den A B := by
    simp only [s2n, den]; linear_combination -(1 + A + B) * hCcden'
  have hRqAB : Rq A B
      = (den A B) ^ 2 * (9 * (1 + A + B + Cc) ^ 2 - 32 * (A + B + Cc + A * B + A * Cc + B * Cc)) := by
    simp only [Rq]; rw [hs1AB, hs2AB]; ring
  have hSqAB : Sq A B
      = (den A B) ^ 2 * (9 * (1 + A + B + Cc) ^ 2 - 24 * (A + B + Cc + A * B + A * Cc + B * Cc)) := by
    simp only [Sq]; rw [hs1AB, hs2AB]; ring
  have hf'fac : derivative (rootQuartic A B Cc)
      = C 4 * X * (X ^ 2 + C (-(3 * (1 + A + B + Cc)) / 4) * X
        + C ((A + B + Cc + A * B + A * Cc + B * Cc) / 2)) := by
    rw [rootQuartic_expand, hE3zero]
    simp only [C_0, zero_mul, sub_zero]
    apply Polynomial.funext; intro x
    simp only [derivative_sub, derivative_add, derivative_mul, derivative_C, derivative_X_pow,
      zero_mul, add_zero,
      zero_add, eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C,
      Nat.cast_ofNat, map_ofNat, eval_ofNat]
    ring
  have hf''fac : derivative (derivative (rootQuartic A B Cc))
      = C 12 * (X ^ 2 + C (-(1 + A + B + Cc) / 2) * X
        + C ((A + B + Cc + A * B + A * Cc + B * Cc) / 6)) := by
    rw [rootQuartic_expand]
    apply Polynomial.funext; intro x
    simp only [derivative_sub, derivative_add, derivative_mul, derivative_C, derivative_X_pow,
      derivative_X, derivative_ofNat, zero_mul, add_zero,
      zero_add, mul_one, eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C,
      eval_zero, Nat.cast_ofNat, map_ofNat, eval_ofNat]
    ring
  have hqne : ∀ (P Q : ℚ), (X ^ 2 + C P * X + C Q : ℚ[X]) ≠ 0 := by
    intro P Q hcon
    have hdd : (X ^ 2 + C P * X + C Q : ℚ[X]).degree = 2 := by
      rw [show (X ^ 2 + C P * X + C Q : ℚ[X]) = C 1 * X ^ 2 + C P * X + C Q by rw [C_1, one_mul]]
      exact degree_quadratic (by norm_num)
    rw [hcon, degree_zero] at hdd; exact absurd hdd (by decide)
  have hQ1 : (X ^ 2 + C (-(3 * (1 + A + B + Cc)) / 4) * X
      + C ((A + B + Cc + A * B + A * Cc + B * Cc) / 2) : ℚ[X]).Splits := by
    have hgs : (C 4 * X * (X ^ 2 + C (-(3 * (1 + A + B + Cc)) / 4) * X
        + C ((A + B + Cc + A * B + A * Cc + B * Cc) / 2))).Splits := hf'fac ▸ hKq.2.1
    rw [mul_assoc] at hgs
    have h1 : (X * (X ^ 2 + C (-(3 * (1 + A + B + Cc)) / 4) * X
        + C ((A + B + Cc + A * B + A * Cc + B * Cc) / 2))).Splits := by
      have h2 := hgs.C_mul (4 : ℚ)⁻¹
      rwa [← mul_assoc, ← C_mul, inv_mul_cancel₀ (by norm_num : (4 : ℚ) ≠ 0), C_1, one_mul] at h2
    exact ((splits_mul_iff X_ne_zero (hqne _ _)).mp h1).2
  have hQ2 : (X ^ 2 + C (-(1 + A + B + Cc) / 2) * X
      + C ((A + B + Cc + A * B + A * Cc + B * Cc) / 6) : ℚ[X]).Splits := by
    have hgs : (C 12 * (X ^ 2 + C (-(1 + A + B + Cc) / 2) * X
        + C ((A + B + Cc + A * B + A * Cc + B * Cc) / 6))).Splits := hf''fac ▸ hKq.2.2.1
    have h2 := hgs.C_mul (12 : ℚ)⁻¹
    rwa [← mul_assoc, ← C_mul, inv_mul_cancel₀ (by norm_num : (12 : ℚ) ≠ 0), C_1, one_mul] at h2
  obtain ⟨d, hdsq⟩ := exists_sq_of_quadratic_splits _ _ hQ1
  obtain ⟨d2, hd2sq⟩ := exists_sq_of_quadratic_splits _ _ hQ2
  have hzsq : (4 * den A B * d) ^ 2 = Rq A B := by
    rw [hRqAB, show (4 * den A B * d) ^ 2 = 16 * (den A B) ^ 2 * d ^ 2 by ring, hdsq]; ring
  have hwsq : (6 * den A B * d2) ^ 2 = Sq A B := by
    rw [hSqAB, show (6 * den A B * d2) ^ 2 = 36 * (den A B) ^ 2 * d2 ^ 2 by ring, hd2sq]; ring
  refine ⟨A, B, 4 * den A B * d, 6 * den A B * d2,
    hdenAB, hzsq, hwsq, hAne0, hBne0, hAne1, hBne1, hABne, ?_, ?_, ?_, ?_⟩
  · rw [← hCceq]; exact hCcne0
  · rw [← hCceq]; exact hCcne1
  · rw [← hCceq]; exact hCcneA
  · rw [← hCceq]; exact hCcneB

/-- **The normalization bridge**: Conjecture 1 (normal form) holds iff the
splitting terrain has no nondegenerate rational point. -/
theorem conjecture1_iff_terrain :
    Conjecture1_normal ℚ ↔ ∀ a b z w : ℚ, ¬ NondegTerrainPoint a b z w := by
  constructor
  · intro hc a b z w hpt
    obtain ⟨A, B, hd, hk⟩ := kderived_of_terrain hpt
    exact hc A B hd hk
  · intro hno a b hd hk
    obtain ⟨A, B, z, w, hpt⟩ := terrain_of_kderived hd hk
    exact hno A B z w hpt

end BMThm7Terrain

#print axioms BMThm7Terrain.rootQuartic_expand
#print axioms BMThm7Terrain.quadratic_splits_of_sq
#print axioms BMThm7Terrain.exists_sq_of_quadratic_splits
#print axioms BMThm7Terrain.KDerived_C_mul_iff
#print axioms BMThm7Terrain.KDerived_shift_iff
#print axioms BMThm7Terrain.KDerived_scale_iff
#print axioms BMThm7Terrain.kderived_of_terrain
#print axioms BMThm7Terrain.terrain_of_kderived
#print axioms BMThm7Terrain.conjecture1_iff_terrain
