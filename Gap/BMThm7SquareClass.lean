/-
Gap/BMThm7SquareClass.lean -- square-class transfer to the multiquadratic
extension (2026-08-02; statements FROZEN by claude.ai, tactics delegated;
division of labour and responsibility: AI_PROVENANCE.md at the repository root)

Purpose: close the step identified by external review as the remaining hole
of Chapter 4: non-squareness in the base field K = ℚ(a,b) does not by
itself give non-squareness in the splitting extension
L = K(√Rq, √Sq).  The transfer principle proved here does:

  if x becomes a square in any field containing K together with square
  roots ρ, σ of r, s -- more precisely, if any element of the
  ιK-span of {1, ρ, σ, ρσ} squares to ιx -- then one of
  x, x·r, x·s, x·rs is already a square in K.

Since every element of the multiquadratic extension K(√r, √s) lies in
that span, and the eight kernel theorems of BMThm7FunctionField refute
squareness in K of exactly Q4·{1, Rq, Sq, RqSq} and (-2Q4)·{1, Rq, Sq,
RqSq}, the two application theorems below refute squareness of Q4 and
-2Q4 in every such extension -- in particular in any model of the
function field of the splitting surface.  The extension is quantified
(any field M with an embedding ι and the two square roots), so no choice
of model of ℚ(S) is presupposed.

Degenerate cases (r, s, or rs a square in K; ρ or σ already in ιK)
are not excluded by hypothesis: the case analysis absorbs them.
-/
import Mathlib
import Gap.BMThm7FunctionField

namespace BMThm7SquareClass

open Polynomial BMThm7FunctionField

/-- **One quadratic step.**  If σ² = ιs and (ιu + ιv·σ)² = ιx, then x or
x·s is a square in K.  No independence of {1, σ} is assumed: if the
step degenerates, σ falls into ιK and squareness lands in the first
branch. -/
theorem step {K M : Type*} [Field K] [Field M] [CharZero K]
    (ι : K →+* M) (σ : M) (s x u v : K)
    (hσ : σ ^ 2 = ι s) (h : (ι u + ι v * σ) ^ 2 = ι x) :
    (∃ w : K, w ^ 2 = x) ∨ (∃ w : K, w ^ 2 = x * s) := by
  have inj : Function.Injective ι := ι.injective
  by_cases hv : v = 0
  · subst hv
    left
    refine ⟨u, ?_⟩
    apply inj
    rw [map_pow]
    rw [map_zero, zero_mul, add_zero] at h
    exact h
  · by_cases hu : u = 0
    · subst hu
      right
      refine ⟨v * s, ?_⟩
      apply inj
      simp only [map_pow, map_mul]
      rw [map_zero, zero_add, mul_pow, hσ] at h
      linear_combination (ι s) * h
    · -- u ≠ 0, v ≠ 0 : solve for σ
      have h2uv : (2 * u * v) ≠ 0 :=
        mul_ne_zero (mul_ne_zero (by norm_num) hu) hv
      have hi2uv : ι (2 * u * v) ≠ 0 := fun hz => h2uv (inj (by rw [hz, map_zero]))
      have hexp : ι (2 * u * v) * σ = ι (x - u ^ 2 - v ^ 2 * s) := by
        simp only [map_mul, map_sub, map_pow, map_ofNat]
        linear_combination h - (ι v) ^ 2 * hσ
      set t := (x - u ^ 2 - v ^ 2 * s) / (2 * u * v) with ht
      have hσt : σ = ι t := by
        rw [ht, map_div₀, eq_div_iff hi2uv, mul_comm]
        exact hexp
      left
      refine ⟨u + v * t, ?_⟩
      apply inj
      rw [hσt] at h
      simp only [map_pow, map_add, map_mul]
      exact h

/-- **Biquadratic square-class transfer.**  If ρ² = ιr, σ² = ιs and an
element of the ιK-span of {1, ρ, σ, ρσ} squares to ιx, then one of x,
x·r, x·s, x·rs is a square in K. -/
theorem biquadratic_transfer {K M : Type*} [Field K] [Field M] [CharZero K]
    (ι : K →+* M) (ρ σ : M) (r s x : K)
    (hρ : ρ ^ 2 = ι r) (hσ : σ ^ 2 = ι s)
    (e₀ e₁ e₂ e₃ : K)
    (h : (ι e₀ + ι e₁ * ρ + ι e₂ * σ + ι e₃ * (ρ * σ)) ^ 2 = ι x) :
    (∃ w : K, w ^ 2 = x) ∨ (∃ w : K, w ^ 2 = x * r) ∨
    (∃ w : K, w ^ 2 = x * s) ∨ (∃ w : K, w ^ 2 = x * (r * s)) := by
  have inj : Function.Injective ι := ι.injective
  have hi2 : (2 : M) = ι 2 := (map_ofNat ι 2).symm
  have h2M : (2 : M) ≠ 0 := by
    rw [hi2]; exact fun hz => (by norm_num : (2 : K) ≠ 0) (inj (by rw [hz, map_zero]))
  by_cases hr : ∃ t : K, t ^ 2 = r
  · -- CASE A: r is a square in K, so ρ ∈ ιK (up to sign)
    obtain ⟨tr, htr⟩ := hr
    have hfac : (ρ - ι tr) * (ρ + ι tr) = 0 := by
      have hh : ι r = (ι tr) ^ 2 := by rw [← htr, map_pow]
      linear_combination hρ + hh
    have caseA_step : ∀ c : K, ρ = ι c →
        (∃ w : K, w ^ 2 = x) ∨ (∃ w : K, w ^ 2 = x * r) ∨
        (∃ w : K, w ^ 2 = x * s) ∨ (∃ w : K, w ^ 2 = x * (r * s)) := by
      intro c hc
      have h' : (ι (e₀ + e₁ * c) + ι (e₂ + e₃ * c) * σ) ^ 2 = ι x := by
        rw [hc] at h
        simp only [map_add, map_mul]
        linear_combination h
      rcases step ι σ s x (e₀ + e₁ * c) (e₂ + e₃ * c) hσ h' with ⟨w, hw⟩ | ⟨w, hw⟩
      · exact Or.inl ⟨w, hw⟩
      · exact Or.inr (Or.inr (Or.inl ⟨w, hw⟩))
    rcases mul_eq_zero.mp hfac with h1 | h1
    · exact caseA_step tr (by linear_combination h1)
    · exact caseA_step (-tr) (by rw [map_neg]; linear_combination h1)
  · by_cases hs : ∃ t : K, t ^ 2 = s
    · -- CASE B: s is a square in K, so σ ∈ ιK (up to sign)
      obtain ⟨ts, hts⟩ := hs
      have hfac : (σ - ι ts) * (σ + ι ts) = 0 := by
        have hh : ι s = (ι ts) ^ 2 := by rw [← hts, map_pow]
        linear_combination hσ + hh
      have caseB_step : ∀ c : K, σ = ι c →
          (∃ w : K, w ^ 2 = x) ∨ (∃ w : K, w ^ 2 = x * r) ∨
          (∃ w : K, w ^ 2 = x * s) ∨ (∃ w : K, w ^ 2 = x * (r * s)) := by
        intro c hc
        have h' : (ι (e₀ + e₂ * c) + ι (e₁ + e₃ * c) * ρ) ^ 2 = ι x := by
          rw [hc] at h
          simp only [map_add, map_mul]
          linear_combination h
        rcases step ι ρ r x (e₀ + e₂ * c) (e₁ + e₃ * c) hρ h' with ⟨w, hw⟩ | ⟨w, hw⟩
        · exact Or.inl ⟨w, hw⟩
        · exact Or.inr (Or.inl ⟨w, hw⟩)
      rcases mul_eq_zero.mp hfac with h1 | h1
      · exact caseB_step ts (by linear_combination h1)
      · exact caseB_step (-ts) (by rw [map_neg]; linear_combination h1)
    · -- CASE C: r and s both non-squares in K
      have hs0 : s ≠ 0 := fun h0 => hs ⟨0, by rw [h0]; ring⟩
      -- independence of {1, ρ} over ιK
      have hindρ : ∀ a b : K, ι a + ι b * ρ = 0 → a = 0 ∧ b = 0 := by
        intro a b hab
        by_cases hb : b = 0
        · subst hb
          rw [map_zero, zero_mul, add_zero] at hab
          exact ⟨inj (by rw [hab, map_zero]), rfl⟩
        · exfalso
          apply hr
          refine ⟨-a / b, ?_⟩
          have hib : ι b ≠ 0 := fun hz => hb (inj (by rw [hz, map_zero]))
          have hρc : ρ = ι (-a / b) := by
            rw [map_div₀, map_neg, eq_div_iff hib]
            linear_combination hab
          apply inj
          rw [map_pow, ← hρc]
          exact hρ
      -- ιK(ρ)-span V = {ι a + ι b ρ} is closed under products, negation, inverses
      have hV_mul : ∀ z w : M, (∃ a b : K, z = ι a + ι b * ρ) →
          (∃ a b : K, w = ι a + ι b * ρ) → ∃ a b : K, z * w = ι a + ι b * ρ := by
        rintro z w ⟨a, b, rfl⟩ ⟨c, d, rfl⟩
        refine ⟨a * c + b * d * r, a * d + b * c, ?_⟩
        simp only [map_add, map_mul]
        linear_combination (ι b * ι d) * hρ
      have hV_neg : ∀ z : M, (∃ a b : K, z = ι a + ι b * ρ) →
          ∃ a b : K, -z = ι a + ι b * ρ := by
        rintro z ⟨a, b, rfl⟩
        refine ⟨-a, -b, ?_⟩
        simp only [map_neg]; ring
      have hV_inv : ∀ z : M, (∃ a b : K, z = ι a + ι b * ρ) → z ≠ 0 →
          ∃ a b : K, z⁻¹ = ι a + ι b * ρ := by
        rintro z ⟨a, b, rfl⟩ hz0
        have hN : a ^ 2 - b ^ 2 * r ≠ 0 := by
          intro hN0
          by_cases hb : b = 0
          · apply hz0
            have ha : a = 0 := by
              have h2 : a ^ 2 = 0 := by rw [hb] at hN0; linear_combination hN0
              exact (pow_eq_zero_iff (by norm_num : 2 ≠ 0)).mp h2
            rw [ha, hb]; simp
          · apply hr
            refine ⟨a / b, ?_⟩
            field_simp
            linear_combination hN0
        have hconj : (ι a + ι b * ρ) * (ι a - ι b * ρ) = ι (a ^ 2 - b ^ 2 * r) := by
          simp only [map_sub, map_mul, map_pow]
          linear_combination (-(ι b) ^ 2) * hρ
        have hiN : ι (a ^ 2 - b ^ 2 * r) ≠ 0 :=
          fun hzz => hN (inj (by rw [hzz, map_zero]))
        have hprod : (ι a + ι b * ρ) *
            ((ι a - ι b * ρ) * (ι (a ^ 2 - b ^ 2 * r))⁻¹) = 1 := by
          rw [← mul_assoc, hconj, mul_inv_cancel₀ hiN]
        refine ⟨a * (a ^ 2 - b ^ 2 * r)⁻¹, -(b * (a ^ 2 - b ^ 2 * r)⁻¹), ?_⟩
        rw [inv_eq_of_mul_eq_one_right hprod, ← map_inv₀]
        simp only [map_mul, map_neg]; ring
      by_cases hsV : ∃ a b : K, σ = ι a + ι b * ρ
      · -- C-i : σ lies in the ιK(ρ)-span
        obtain ⟨a, b, hab⟩ := hsV
        have hrel : ι (a ^ 2 + b ^ 2 * r - s) + ι (2 * a * b) * ρ = 0 := by
          have hs2 : (ι a + ι b * ρ) ^ 2 = ι s := by rw [← hab]; exact hσ
          simp only [map_sub, map_add, map_mul, map_pow, map_ofNat]
          linear_combination hs2 - (ι b) ^ 2 * hρ
        obtain ⟨hab1, hab2⟩ := hindρ _ _ hrel
        rcases mul_eq_zero.mp hab2 with h1 | hb0
        · rcases mul_eq_zero.mp h1 with hz | ha0
          · exact absurd hz (by norm_num)
          · -- a = 0 : σ = ι b · ρ
            rw [ha0, map_zero, zero_add] at hab
            have hbase : ι (e₀ + e₃ * b * r) + ι (e₁ + e₂ * b) * ρ
                = ι e₀ + ι e₁ * ρ + ι e₂ * (ι b * ρ) + ι e₃ * (ρ * (ι b * ρ)) := by
              simp only [map_add, map_mul]
              linear_combination (-(ι e₃ * ι b)) * hρ
            have h' : (ι (e₀ + e₃ * b * r) + ι (e₁ + e₂ * b) * ρ) ^ 2 = ι x := by
              rw [hbase, ← hab]; exact h
            rcases step ι ρ r x (e₀ + e₃ * b * r) (e₁ + e₂ * b) hρ h'
              with ⟨w, hw⟩ | ⟨w, hw⟩
            · exact Or.inl ⟨w, hw⟩
            · exact Or.inr (Or.inl ⟨w, hw⟩)
        · -- b = 0 : s = a², contradicting hs
          exact absurd ⟨a, by rw [hb0] at hab1; linear_combination hab1⟩ hs
      · -- C-ii : {1, σ} independent over V
        have hh : ((ι e₀ + ι e₁ * ρ) + (ι e₂ + ι e₃ * ρ) * σ) ^ 2 = ι x := by
          rw [← h]; ring
        set P : M := ι e₀ + ι e₁ * ρ with hPdef
        set Q : M := ι e₂ + ι e₃ * ρ with hQdef
        set A' : M := P ^ 2 + Q ^ 2 * ι s - ι x with hA'def
        set B' : M := 2 * P * Q with hB'def
        have hAB : A' + B' * σ = 0 := by
          rw [hA'def, hB'def]; linear_combination hh - Q ^ 2 * hσ
        have hVA' : ∃ a b : K, A' = ι a + ι b * ρ := by
          refine ⟨e₀ ^ 2 + e₁ ^ 2 * r + (e₂ ^ 2 + e₃ ^ 2 * r) * s - x,
            2 * e₀ * e₁ + 2 * e₂ * e₃ * s, ?_⟩
          rw [hA'def, hPdef, hQdef]
          simp only [map_add, map_mul, map_sub, map_pow, map_ofNat]
          linear_combination ((ι e₁) ^ 2 + (ι e₃) ^ 2 * ι s) * hρ
        have hVB' : ∃ a b : K, B' = ι a + ι b * ρ := by
          refine ⟨2 * (e₀ * e₂ + e₁ * e₃ * r), 2 * (e₀ * e₃ + e₁ * e₂), ?_⟩
          rw [hB'def, hPdef, hQdef]
          simp only [map_add, map_mul, map_ofNat]
          linear_combination (2 * ι e₁ * ι e₃) * hρ
        -- B' = 0 (else σ ∈ V, contradicting hsV)
        have hB0 : B' = 0 := by
          by_contra hB
          apply hsV
          have hBσ : B' * σ = -A' := by linear_combination hAB
          have hσeq : σ = (-A') * B'⁻¹ := by
            rw [← hBσ, mul_right_comm, mul_inv_cancel₀ hB, one_mul]
          rw [hσeq]
          exact hV_mul _ _ (hV_neg _ hVA') (hV_inv _ hVB' hB)
        have hA0 : A' = 0 := by rw [hB0, zero_mul, add_zero] at hAB; exact hAB
        rw [hB'def] at hB0
        have hPQ : P = 0 ∨ Q = 0 := by
          rcases mul_eq_zero.mp hB0 with h2P | hQ0
          · rcases mul_eq_zero.mp h2P with h2 | hP0
            · exact absurd h2 h2M
            · exact Or.inl hP0
          · exact Or.inr hQ0
        rcases hPQ with hP0 | hQ0
        · -- P = 0
          have hQx : Q ^ 2 * ι s = ι x := by
            rw [hA'def, hP0] at hA0; linear_combination hA0
          have hexp : ι ((e₂ ^ 2 + e₃ ^ 2 * r) * s - x) + ι (2 * e₂ * e₃ * s) * ρ = 0 := by
            rw [hQdef] at hQx
            simp only [map_sub, map_add, map_mul, map_pow, map_ofNat]
            linear_combination hQx - ((ι e₃) ^ 2 * ι s) * hρ
          obtain ⟨hc, hd⟩ := hindρ _ _ hexp
          rcases mul_eq_zero.mp hd with h1 | hsz
          · rcases mul_eq_zero.mp h1 with h2 | he3
            · rcases mul_eq_zero.mp h2 with hz | he2
              · exact absurd hz (by norm_num)
              · refine Or.inr (Or.inr (Or.inr ⟨e₃ * r * s, ?_⟩))
                have hx : x = e₃ ^ 2 * r * s := by rw [he2] at hc; linear_combination -hc
                rw [hx]; ring
            · refine Or.inr (Or.inr (Or.inl ⟨e₂ * s, ?_⟩))
              have hx : x = e₂ ^ 2 * s := by rw [he3] at hc; linear_combination -hc
              rw [hx]; ring
          · exact absurd hsz hs0
        · -- Q = 0
          have hPx : P ^ 2 = ι x := by
            rw [hA'def, hQ0] at hA0; linear_combination hA0
          have hexp : ι (e₀ ^ 2 + e₁ ^ 2 * r - x) + ι (2 * e₀ * e₁) * ρ = 0 := by
            rw [hPdef] at hPx
            simp only [map_sub, map_add, map_mul, map_pow, map_ofNat]
            linear_combination hPx - ((ι e₁) ^ 2) * hρ
          obtain ⟨hc, hd⟩ := hindρ _ _ hexp
          rcases mul_eq_zero.mp hd with h1 | he1
          · rcases mul_eq_zero.mp h1 with hz | he0
            · exact absurd hz (by norm_num)
            · refine Or.inr (Or.inl ⟨e₁ * r, ?_⟩)
              have hx : x = e₁ ^ 2 * r := by rw [he0] at hc; linear_combination -hc
              rw [hx]; ring
          · refine Or.inl ⟨e₀, ?_⟩
            have hx : x = e₀ ^ 2 := by rw [he1] at hc; linear_combination -hc
            rw [hx]

/-- **Q4 is not a square in the multiquadratic extension**: for any field M
containing K = ℚ(a,b) together with square roots of Rq and Sq, no element
of the span of {1, ρ, σ, ρσ} squares to Q4.  Consumes the four kernel
theorems Q4_not_square .. Q4RqSq_not_square. -/
theorem Q4_not_square_multiquadratic {M : Type*} [Field M]
    (ι : FractionRing R2 →+* M) (ρ σ : M)
    (hρ : ρ ^ 2 = ι (algebraMap R2 (FractionRing R2) Rq2))
    (hσ : σ ^ 2 = ι (algebraMap R2 (FractionRing R2) Sq2))
    (e₀ e₁ e₂ e₃ : FractionRing R2) :
    (ι e₀ + ι e₁ * ρ + ι e₂ * σ + ι e₃ * (ρ * σ)) ^ 2
      ≠ ι (algebraMap R2 (FractionRing R2) Q42) := by
  intro h
  haveI : CharZero (FractionRing R2) := inferInstance
  rcases biquadratic_transfer ι ρ σ
      (algebraMap R2 (FractionRing R2) Rq2)
      (algebraMap R2 (FractionRing R2) Sq2)
      (algebraMap R2 (FractionRing R2) Q42)
      hρ hσ e₀ e₁ e₂ e₃ h with
    ⟨w, hw⟩ | ⟨w, hw⟩ | ⟨w, hw⟩ | ⟨w, hw⟩
  · exact Q4_not_square ⟨w, hw⟩
  · exact Q4Rq_not_square ⟨w, by rw [map_mul]; exact hw⟩
  · exact Q4Sq_not_square ⟨w, by rw [map_mul]; exact hw⟩
  · exact Q4RqSq_not_square ⟨w, by rw [map_mul, map_mul]; exact hw⟩

/-- **-2·Q4 is not a square in the multiquadratic extension** (same span
form).  Consumes n2Q4_not_square .. n2Q4RqSq_not_square. -/
theorem n2Q4_not_square_multiquadratic {M : Type*} [Field M]
    (ι : FractionRing R2 →+* M) (ρ σ : M)
    (hρ : ρ ^ 2 = ι (algebraMap R2 (FractionRing R2) Rq2))
    (hσ : σ ^ 2 = ι (algebraMap R2 (FractionRing R2) Sq2))
    (e₀ e₁ e₂ e₃ : FractionRing R2) :
    (ι e₀ + ι e₁ * ρ + ι e₂ * σ + ι e₃ * (ρ * σ)) ^ 2
      ≠ ι (algebraMap R2 (FractionRing R2) (C (C (-2 : ℚ)) * Q42)) := by
  intro h
  haveI : CharZero (FractionRing R2) := inferInstance
  rcases biquadratic_transfer ι ρ σ
      (algebraMap R2 (FractionRing R2) Rq2)
      (algebraMap R2 (FractionRing R2) Sq2)
      (algebraMap R2 (FractionRing R2) (C (C (-2 : ℚ)) * Q42))
      hρ hσ e₀ e₁ e₂ e₃ h with
    ⟨w, hw⟩ | ⟨w, hw⟩ | ⟨w, hw⟩ | ⟨w, hw⟩
  · exact n2Q4_not_square ⟨w, hw⟩
  · exact n2Q4Rq_not_square ⟨w, by rw [map_mul]; exact hw⟩
  · exact n2Q4Sq_not_square ⟨w, by rw [map_mul]; exact hw⟩
  · exact n2Q4RqSq_not_square ⟨w, by
      rw [map_mul _ (C (C (-2 : ℚ)) * Q42) (Rq2 * Sq2), map_mul _ Rq2 Sq2]; exact hw⟩

end BMThm7SquareClass

#print axioms BMThm7SquareClass.step
#print axioms BMThm7SquareClass.biquadratic_transfer
#print axioms BMThm7SquareClass.Q4_not_square_multiquadratic
#print axioms BMThm7SquareClass.n2Q4_not_square_multiquadratic
