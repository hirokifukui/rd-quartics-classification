/-
Gap/BMThm7NormCriterion.lean -- the C± covers: layer step and coordinate norm
(2026-08-02; statements FROZEN by claude.ai, tactics delegated;
division of labour and responsibility: AI_PROVENANCE.md at the repository root)

Purpose: close the second bridge identified by external review. The C±
radicands γ± = s1n·(s1n ∓ ζ) live in the LAYER K(ζ), not in the base field
K = ℚ(a,b), so the biquadratic transfer of BMThm7SquareClass does not apply
to them directly. The correct chain, proved here in the kernel:

  (1) step_over_layer: if a span element of {1,ζ,σ,ζσ} squares to a layer
      element g₀ + g₁ζ, then that element or its s-multiple is a square
      already in the layer (r nonsquare in K is a hypothesis; the degenerate
      σ-in-layer cases are absorbed by the case analysis);
  (2) layer_square_norm: a layer square with coordinates (g₀,g₁) forces
      g₀² - g₁² r to be a square in K -- the norm, computed purely in
      coordinates, no Galois action needed;
  (3) for γ±: g₀ = s1n², g₁ = ∓s1n, so g₀² - g₁² Rq =
      s1n²(s1n² - Rq) = -8 s1n² Q4 by the identity (I2) -- hence -2Q4
      would be a square in ℚ(a,b), contradicting n2Q4_not_square.

The file also proves, by value specialization (a square in Frac R2 evaluates
to a rational square wherever defined), that Rq, Sq and Rq·Sq are nonsquares
in ℚ(a,b): the ℚ-level input for the geometric integrality of the splitting
cover S itself, and the hypothesis hr consumed by (1). Witness values:
Rq(2,3) = 2480, Sq(1,2) = 876, (Rq·Sq)(1,2) = 171696 -- none a rational
square.
-/
import Mathlib
import Gap.BMThm7FunctionField

namespace BMThm7NormCriterion

open Polynomial BMThm7FunctionField

/-- R2-level (I2): s1n2² - Rq2 = -8·Q42. The C± obstruction funnels through
Q4. (ℚ-point version: `BMThm7Boundary.I2`.) -/
theorem I2_R2 : s1n2 ^ 2 - Rq2 = C (C (-8 : ℚ)) * Q42 := by
  have hQ : C (C (18 : ℚ)) * Q42 = 3 * Rq2 - Sq2 := by
    rw [Q42, ← mul_assoc, ← C_mul, ← C_mul]
    norm_num
  have hne : (C (C (18 : ℚ)) : R2) ≠ 0 := by
    simp only [ne_eq]; norm_num
  apply mul_left_cancel₀ hne
  rw [mul_left_comm (C (C (18 : ℚ))) (C (C (-8 : ℚ))) Q42, hQ]
  simp only [Rq2, Sq2, s1n2, s2n2, den2, A, B, map_neg, map_ofNat]
  ring

/-- Value specialization: if P is a square in Frac R2 then its value at any
rational point is a rational square; contrapositively, one nonsquare value
refutes squareness. -/
theorem not_square_of_value {P : R2} {x y : ℚ}
    (h : ¬ IsSquare (evalAB x y P)) :
    ¬ ∃ g : FractionRing R2, g ^ 2 = algebraMap R2 (FractionRing R2) P := by
  rintro ⟨g, hg⟩
  obtain ⟨G, hG⟩ := square_descent P g hg
  exact h ⟨evalAB x y G, by rw [hG, map_pow, sq]⟩

/-- Rq is not a square in ℚ(a,b) (witness value Rq(2,3) = 2480). -/
theorem Rq_not_square :
    ¬ ∃ g : FractionRing R2, g ^ 2 = algebraMap R2 (FractionRing R2) Rq2 := by
  apply not_square_of_value (x := 2) (y := 3)
  rw [evalAB_Rq2]
  norm_num [BMThm7Boundary.Rq, BMThm7Boundary.s1n, BMThm7Boundary.s2n, BMThm7Boundary.den]

/-- Sq is not a square in ℚ(a,b) (witness value Sq(1,2) = 876). -/
theorem Sq_not_square :
    ¬ ∃ g : FractionRing R2, g ^ 2 = algebraMap R2 (FractionRing R2) Sq2 := by
  apply not_square_of_value (x := 1) (y := 2)
  rw [evalAB_Sq2]
  norm_num [BMThm7Boundary.Sq, BMThm7Boundary.s1n, BMThm7Boundary.s2n, BMThm7Boundary.den]

/-- Rq·Sq is not a square in ℚ(a,b) (witness value 171696). Together with the
two preceding theorems: the ℚ-level nontriviality of all three quadratic
subextensions of K(S)/K(B). -/
theorem RqSq_not_square :
    ¬ ∃ g : FractionRing R2,
      g ^ 2 = algebraMap R2 (FractionRing R2) (Rq2 * Sq2) := by
  apply not_square_of_value (x := 1) (y := 2)
  rw [map_mul, evalAB_Rq2, evalAB_Sq2]
  norm_num [BMThm7Boundary.Rq, BMThm7Boundary.Sq, BMThm7Boundary.s1n,
    BMThm7Boundary.s2n, BMThm7Boundary.den]

/-- **Layer quadratic step.** With r a nonsquare in K: if a span element of
{1,ζ,σ,ζσ} squares to the layer element g₀ + g₁ζ, then that element or its
s-multiple is a square already in the layer. -/
theorem step_over_layer {K M : Type*} [Field K] [Field M] [CharZero K]
    (ι : K →+* M) (ζ σ : M) (r s : K)
    (hζ : ζ ^ 2 = ι r) (hσ : σ ^ 2 = ι s)
    (hr : ¬ ∃ t : K, t ^ 2 = r)
    (g₀ g₁ e₀ e₁ e₂ e₃ : K)
    (h : (ι e₀ + ι e₁ * ζ + ι e₂ * σ + ι e₃ * (ζ * σ)) ^ 2 = ι g₀ + ι g₁ * ζ) :
    (∃ p q : K, (ι p + ι q * ζ) ^ 2 = ι g₀ + ι g₁ * ζ) ∨
    (∃ p q : K, (ι p + ι q * ζ) ^ 2 = (ι g₀ + ι g₁ * ζ) * ι s) := by
  have inj : Function.Injective ι := ι.injective
  have hi2 : (2 : M) = ι 2 := (map_ofNat ι 2).symm
  have h2M : (2 : M) ≠ 0 := by
    rw [hi2]; exact fun hz => (by norm_num : (2 : K) ≠ 0) (inj (by rw [hz, map_zero]))
  -- independence of {1, ζ} over ιK
  have hindζ : ∀ a b : K, ι a + ι b * ζ = 0 → a = 0 ∧ b = 0 := by
    intro a b hab
    by_cases hb : b = 0
    · subst hb
      rw [map_zero, zero_mul, add_zero] at hab
      exact ⟨inj (by rw [hab, map_zero]), rfl⟩
    · exfalso
      apply hr
      refine ⟨-a / b, ?_⟩
      have hib : ι b ≠ 0 := fun hz => hb (inj (by rw [hz, map_zero]))
      have hζc : ζ = ι (-a / b) := by
        rw [map_div₀, map_neg, eq_div_iff hib]
        linear_combination hab
      apply inj
      rw [map_pow, ← hζc]
      exact hζ
  -- V = ιK-span of {1, ζ}: closed under products, negation, inverses
  have hV_mul : ∀ z w : M, (∃ a b : K, z = ι a + ι b * ζ) →
      (∃ a b : K, w = ι a + ι b * ζ) → ∃ a b : K, z * w = ι a + ι b * ζ := by
    rintro z w ⟨a, b, rfl⟩ ⟨c, d, rfl⟩
    refine ⟨a * c + b * d * r, a * d + b * c, ?_⟩
    simp only [map_add, map_mul]
    linear_combination (ι b * ι d) * hζ
  have hV_neg : ∀ z : M, (∃ a b : K, z = ι a + ι b * ζ) →
      ∃ a b : K, -z = ι a + ι b * ζ := by
    rintro z ⟨a, b, rfl⟩
    refine ⟨-a, -b, ?_⟩
    simp only [map_neg]; ring
  have hV_inv : ∀ z : M, (∃ a b : K, z = ι a + ι b * ζ) → z ≠ 0 →
      ∃ a b : K, z⁻¹ = ι a + ι b * ζ := by
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
    have hconj : (ι a + ι b * ζ) * (ι a - ι b * ζ) = ι (a ^ 2 - b ^ 2 * r) := by
      simp only [map_sub, map_mul, map_pow]
      linear_combination (-(ι b) ^ 2) * hζ
    have hiN : ι (a ^ 2 - b ^ 2 * r) ≠ 0 :=
      fun hzz => hN (inj (by rw [hzz, map_zero]))
    have hprod : (ι a + ι b * ζ) *
        ((ι a - ι b * ζ) * (ι (a ^ 2 - b ^ 2 * r))⁻¹) = 1 := by
      rw [← mul_assoc, hconj, mul_inv_cancel₀ hiN]
    refine ⟨a * (a ^ 2 - b ^ 2 * r)⁻¹, -(b * (a ^ 2 - b ^ 2 * r)⁻¹), ?_⟩
    rw [inv_eq_of_mul_eq_one_right hprod, ← map_inv₀]
    simp only [map_mul, map_neg]; ring
  by_cases hσV : ∃ p q : K, σ = ι p + ι q * ζ
  · -- σ lies in the layer V
    obtain ⟨p, q, hpq⟩ := hσV
    have hrel : ι (p ^ 2 + q ^ 2 * r - s) + ι (2 * p * q) * ζ = 0 := by
      have hs2 : (ι p + ι q * ζ) ^ 2 = ι s := by rw [← hpq]; exact hσ
      simp only [map_sub, map_add, map_mul, map_pow, map_ofNat]
      linear_combination hs2 - (ι q) ^ 2 * hζ
    obtain ⟨_, hd⟩ := hindζ _ _ hrel
    rcases mul_eq_zero.mp hd with h1 | hq0
    · rcases mul_eq_zero.mp h1 with hz | hp0
      · exact absurd hz (by norm_num)
      · -- p = 0 : σ = ι q · ζ
        rw [hp0, map_zero, zero_add] at hpq
        left
        have hbase : ι (e₀ + e₃ * q * r) + ι (e₁ + e₂ * q) * ζ
            = ι e₀ + ι e₁ * ζ + ι e₂ * (ι q * ζ) + ι e₃ * (ζ * (ι q * ζ)) := by
          simp only [map_add, map_mul]
          linear_combination (-(ι e₃ * ι q)) * hζ
        refine ⟨e₀ + e₃ * q * r, e₁ + e₂ * q, ?_⟩
        rw [hbase, ← hpq]; exact h
    · -- q = 0 : σ = ι p ∈ ιK
      rw [hq0, map_zero, zero_mul, add_zero] at hpq
      left
      refine ⟨e₀ + e₂ * p, e₁ + e₃ * p, ?_⟩
      rw [← h, hpq]
      simp only [map_add, map_mul]; ring
  · -- {1, σ} independent over V
    have hh : ((ι e₀ + ι e₁ * ζ) + (ι e₂ + ι e₃ * ζ) * σ) ^ 2 = ι g₀ + ι g₁ * ζ := by
      rw [← h]; ring
    set P : M := ι e₀ + ι e₁ * ζ with hPdef
    set Q : M := ι e₂ + ι e₃ * ζ with hQdef
    set A' : M := P ^ 2 + Q ^ 2 * ι s - (ι g₀ + ι g₁ * ζ) with hA'def
    set B' : M := 2 * P * Q with hB'def
    have hAB : A' + B' * σ = 0 := by
      rw [hA'def, hB'def]; linear_combination hh - Q ^ 2 * hσ
    have hVA' : ∃ a b : K, A' = ι a + ι b * ζ := by
      refine ⟨e₀ ^ 2 + e₁ ^ 2 * r + (e₂ ^ 2 + e₃ ^ 2 * r) * s - g₀,
        2 * e₀ * e₁ + 2 * e₂ * e₃ * s - g₁, ?_⟩
      rw [hA'def, hPdef, hQdef]
      simp only [map_add, map_mul, map_sub, map_pow, map_ofNat]
      linear_combination ((ι e₁) ^ 2 + (ι e₃) ^ 2 * ι s) * hζ
    have hVB' : ∃ a b : K, B' = ι a + ι b * ζ := by
      refine ⟨2 * (e₀ * e₂ + e₁ * e₃ * r), 2 * (e₀ * e₃ + e₁ * e₂), ?_⟩
      rw [hB'def, hPdef, hQdef]
      simp only [map_add, map_mul, map_ofNat]
      linear_combination (2 * ι e₁ * ι e₃) * hζ
    have hB0 : B' = 0 := by
      by_contra hB
      apply hσV
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
    · -- P = 0 : the s-multiple lands in the layer (right branch)
      have hQx : Q ^ 2 * ι s = ι g₀ + ι g₁ * ζ := by
        rw [hA'def, hP0] at hA0; linear_combination hA0
      right
      refine ⟨e₂ * s, e₃ * s, ?_⟩
      have hQs : ι (e₂ * s) + ι (e₃ * s) * ζ = Q * ι s := by
        rw [hQdef]; simp only [map_mul]; ring
      rw [hQs]
      linear_combination (ι s) * hQx
    · -- Q = 0 : the layer element itself is a square (left branch)
      have hPx : P ^ 2 = ι g₀ + ι g₁ * ζ := by
        rw [hA'def, hQ0] at hA0; linear_combination hA0
      left
      refine ⟨e₀, e₁, ?_⟩
      rw [← hPdef]; exact hPx

/-- **Coordinate norm passage.** A layer square with layer coordinates
(g₀,g₁) forces g₀² - g₁² r to be a square in K: from p² + q²r = g₀ and
2pq = g₁ (independence of {1,ζ}), g₀² - g₁² r = (p² - q²r)². -/
theorem layer_square_norm {K M : Type*} [Field K] [Field M] [CharZero K]
    (ι : K →+* M) (ζ : M) (r : K) (hζ : ζ ^ 2 = ι r)
    (hr : ¬ ∃ t : K, t ^ 2 = r)
    (g₀ g₁ p q : K) (h : (ι p + ι q * ζ) ^ 2 = ι g₀ + ι g₁ * ζ) :
    ∃ w : K, w ^ 2 = g₀ ^ 2 - g₁ ^ 2 * r := by
  have inj : Function.Injective ι := ι.injective
  have hind : ∀ a b : K, ι a + ι b * ζ = 0 → a = 0 ∧ b = 0 := by
    intro a b hab
    by_cases hb : b = 0
    · subst hb
      rw [map_zero, zero_mul, add_zero] at hab
      exact ⟨inj (by rw [hab, map_zero]), rfl⟩
    · exfalso
      apply hr
      refine ⟨-a / b, ?_⟩
      have hib : ι b ≠ 0 := fun hz => hb (inj (by rw [hz, map_zero]))
      have hζc : ζ = ι (-a / b) := by
        rw [map_div₀, map_neg, eq_div_iff hib]
        linear_combination hab
      apply inj
      rw [map_pow, ← hζc]
      exact hζ
  have hrel : ι (p ^ 2 + q ^ 2 * r - g₀) + ι (2 * p * q - g₁) * ζ = 0 := by
    simp only [map_sub, map_add, map_mul, map_pow, map_ofNat]
    linear_combination h - (ι q) ^ 2 * hζ
  obtain ⟨h0, h1⟩ := hind _ _ hrel
  refine ⟨p ^ 2 - q ^ 2 * r, ?_⟩
  have hg0 : g₀ = p ^ 2 + q ^ 2 * r := by linear_combination -h0
  have hg1 : g₁ = 2 * p * q := by linear_combination -h1
  rw [hg0, hg1]; ring

/-- **C±-exclusion.** For either sign ε = ±1, the radicand
γ = s1n² - ε·s1n·ζ (an element of the layer K(ζ), not of the base field) is
not the square of any element of the span of {1,ζ,σ,ζσ}: through
`step_over_layer`, `layer_square_norm` and (I2), a square root would force
-2Q4 to be a square in ℚ(a,b), contradicting `n2Q4_not_square`. -/
theorem gamma_not_square_multiquadratic {M : Type*} [Field M]
    (ι : FractionRing R2 →+* M) (ζ σ : M)
    (hζ : ζ ^ 2 = ι (algebraMap R2 (FractionRing R2) Rq2))
    (hσ : σ ^ 2 = ι (algebraMap R2 (FractionRing R2) Sq2))
    (ε : FractionRing R2) (hε : ε = 1 ∨ ε = -1)
    (e₀ e₁ e₂ e₃ : FractionRing R2) :
    (ι e₀ + ι e₁ * ζ + ι e₂ * σ + ι e₃ * (ζ * σ)) ^ 2
      ≠ ι ((algebraMap R2 (FractionRing R2) s1n2) ^ 2)
        - ι (algebraMap R2 (FractionRing R2) s1n2 * ε) * ζ := by
  intro h
  haveI : CharZero (FractionRing R2) := inferInstance
  set am := algebraMap R2 (FractionRing R2) with ham
  have hε2 : ε ^ 2 = 1 := by rcases hε with h1 | h1 <;> rw [h1] <;> ring
  have aminj : Function.Injective am := IsFractionRing.injective R2 (FractionRing R2)
  have hs1n2_R2 : s1n2 ≠ (0 : R2) := by
    intro hz
    have hval := evalAB_s1n2 1 1
    rw [hz, map_zero] at hval
    norm_num [BMThm7Boundary.s1n, BMThm7Boundary.den] at hval
  have hs1n2_ne : am s1n2 ≠ 0 := fun hz => hs1n2_R2 (aminj (by rw [hz, map_zero]))
  have hSq2_R2 : Sq2 ≠ (0 : R2) := by
    intro hz
    have hval := evalAB_Sq2 1 2
    rw [hz, map_zero] at hval
    norm_num [BMThm7Boundary.Sq, BMThm7Boundary.s1n, BMThm7Boundary.s2n,
      BMThm7Boundary.den] at hval
  have hSq2_ne : am Sq2 ≠ 0 := fun hz => hSq2_R2 (aminj (by rw [hz, map_zero]))
  have hC2_R2 : (C (C (2 : ℚ)) : R2) ≠ 0 := by simp only [ne_eq]; norm_num
  have hC2_ne : am (C (C (2 : ℚ))) ≠ 0 := fun hz => hC2_R2 (aminj (by rw [hz, map_zero]))
  have hD : am s1n2 * am (C (C (2 : ℚ))) ≠ 0 := mul_ne_zero hs1n2_ne hC2_ne
  have hconst : (C (C (2 : ℚ)) : R2) ^ 2 * C (C (-2 : ℚ)) = C (C (-8 : ℚ)) := by
    have e : ((2 : ℚ) ^ 2 * -2) = -8 := by norm_num
    rw [← map_pow, ← map_pow, ← map_mul, ← map_mul, e]
  have keyR2 : (s1n2 ^ 2 - Rq2 : R2)
      = (C (C (2 : ℚ))) ^ 2 * (C (C (-2 : ℚ)) * Q42) := by
    rw [I2_R2, ← hconst]; ring
  have ht2 : (am s1n2) ^ 2 - am Rq2
      = (am (C (C (2 : ℚ)))) ^ 2 * am (C (C (-2 : ℚ)) * Q42) := by
    rw [← map_pow, ← map_sub, keyR2, map_mul, map_pow]
  have hnorm : (am s1n2 ^ 2) ^ 2 - (-(am s1n2 * ε)) ^ 2 * am Rq2
      = (am s1n2 * am (C (C (2 : ℚ)))) ^ 2 * am (C (C (-2 : ℚ)) * Q42) := by
    linear_combination (am s1n2) ^ 2 * ht2 - (am s1n2) ^ 2 * am Rq2 * hε2
  have hnorm' : (am s1n2 ^ 2 * am Sq2) ^ 2 - (-(am s1n2 * ε) * am Sq2) ^ 2 * am Rq2
      = (am Sq2 * (am s1n2 * am (C (C (2 : ℚ))))) ^ 2 * am (C (C (-2 : ℚ)) * Q42) := by
    have expand : (am s1n2 ^ 2 * am Sq2) ^ 2 - (-(am s1n2 * ε) * am Sq2) ^ 2 * am Rq2
        = (am Sq2) ^ 2 * ((am s1n2 ^ 2) ^ 2 - (-(am s1n2 * ε)) ^ 2 * am Rq2) := by ring
    rw [expand, hnorm]; ring
  have hh : (ι e₀ + ι e₁ * ζ + ι e₂ * σ + ι e₃ * (ζ * σ)) ^ 2
      = ι (am s1n2 ^ 2) + ι (-(am s1n2 * ε)) * ζ := by
    rw [h, map_neg, neg_mul, sub_eq_add_neg]
  rcases step_over_layer ι ζ σ (am Rq2) (am Sq2) hζ hσ Rq_not_square
      (am s1n2 ^ 2) (-(am s1n2 * ε)) e₀ e₁ e₂ e₃ hh with
    ⟨p, q, hpq⟩ | ⟨p, q, hpq⟩
  · obtain ⟨w, hw⟩ := layer_square_norm ι ζ (am Rq2) hζ Rq_not_square
      (am s1n2 ^ 2) (-(am s1n2 * ε)) p q hpq
    rw [hnorm] at hw
    refine n2Q4_not_square ⟨w / (am s1n2 * am (C (C (2 : ℚ)))), ?_⟩
    rw [← ham, div_pow, hw]
    field_simp
  · have hpq' : (ι p + ι q * ζ) ^ 2
        = ι (am s1n2 ^ 2 * am Sq2) + ι (-(am s1n2 * ε) * am Sq2) * ζ := by
      rw [hpq, map_mul, map_mul]; ring
    obtain ⟨w, hw⟩ := layer_square_norm ι ζ (am Rq2) hζ Rq_not_square
      (am s1n2 ^ 2 * am Sq2) (-(am s1n2 * ε) * am Sq2) p q hpq'
    rw [hnorm'] at hw
    have hD' : am Sq2 * (am s1n2 * am (C (C (2 : ℚ)))) ≠ 0 := mul_ne_zero hSq2_ne hD
    refine n2Q4_not_square ⟨w / (am Sq2 * (am s1n2 * am (C (C (2 : ℚ))))), ?_⟩
    rw [← ham, div_pow, hw]
    field_simp

end BMThm7NormCriterion

#print axioms BMThm7NormCriterion.I2_R2
#print axioms BMThm7NormCriterion.not_square_of_value
#print axioms BMThm7NormCriterion.Rq_not_square
#print axioms BMThm7NormCriterion.Sq_not_square
#print axioms BMThm7NormCriterion.RqSq_not_square
#print axioms BMThm7NormCriterion.step_over_layer
#print axioms BMThm7NormCriterion.layer_square_norm
#print axioms BMThm7NormCriterion.gamma_not_square_multiquadratic
