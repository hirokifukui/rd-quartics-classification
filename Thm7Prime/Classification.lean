/-
Thm7Prime/Classification.lean -- the global affine classification bridge
(Option ii, second installment, 2026-08-02; statements FROZEN by claude.ai,
tactics delegated)

Purpose: close in the kernel the bridge from an arbitrary split quartic with
root profile (2,1,1) to the normalised family of Theorem 7', answering the
reviewer demand for a packaged classification theorem:
  * `AffineEquiv` = BM's group <X*> (variable scaling+translation, nonzero
    scalar multiple of the polynomial);
  * `IsP211` = split quartic with root profile (2,1,1);
  * `RDPoly` = natural rational-derivedness of an arbitrary polynomial
    (same four-conjunct shape as `NaturalRD` / `KDerived`);
  * `classification`: for `IsP211 f`, `RDPoly f` iff `f` is affine-equivalent
    to `Q a` for some gate parameter `a` with `RD211 a`;
  * `classification_by_curve`: the same with the parameter realised as
    `aMap` of a rational point of 576i2 (via `thm7prime`).
Master.lean and Fidelity.lean are imported, not modified.
-/
import Thm7Prime.Master
import Thm7Prime.Fidelity

namespace Thm7Classification

open Polynomial Thm7Statement Thm7Fidelity

/-- BM's affine group `<X*>`: `g = nu * f(lam*X + mu)` with `lam, nu` nonzero. -/
def AffineEquiv (f g : ℚ[X]) : Prop :=
  ∃ lam mu nu : ℚ, lam ≠ 0 ∧ nu ≠ 0 ∧ g = C nu * f.comp (C lam * X + C mu)

/-- Split quartic with root profile (2,1,1): a double root `c` and two simple
roots `r1, r2`, all rational, pairwise distinct, nonzero leading coefficient. -/
def IsP211 (f : ℚ[X]) : Prop :=
  ∃ lam c r1 r2 : ℚ, lam ≠ 0 ∧ c ≠ r1 ∧ c ≠ r2 ∧ r1 ≠ r2 ∧
    f = C lam * (X - C c)^2 * ((X - C r1) * (X - C r2))

/-- Natural rational-derivedness of an arbitrary polynomial: it and its first
three derivatives split (same shape as `NaturalRD` / `KDerived`). -/
def RDPoly (f : ℚ[X]) : Prop :=
  f.Splits ∧ (derivative f).Splits ∧
  (derivative (derivative f)).Splits ∧
  (derivative (derivative (derivative f))).Splits

/-! ## 1. The affine group -/

theorem affineEquiv_refl (f : ℚ[X]) : AffineEquiv f f := by
  refine ⟨1, 0, 1, one_ne_zero, one_ne_zero, ?_⟩
  simp

theorem affineEquiv_symm {f g : ℚ[X]} (h : AffineEquiv f g) : AffineEquiv g f := by
  obtain ⟨lam, mu, nu, hlam, hnu, hg⟩ := h
  refine ⟨lam⁻¹, -mu/lam, nu⁻¹, inv_ne_zero hlam, inv_ne_zero hnu, ?_⟩
  have hcomp : (C lam * X + C mu).comp (C lam⁻¹ * X + C (-mu/lam)) = X := by
    apply Polynomial.funext; intro x
    simp only [eval_comp, eval_add, eval_mul, eval_C, eval_X]
    field_simp
    ring
  rw [hg, mul_comp, C_comp, comp_assoc, hcomp, comp_X, ← mul_assoc, ← C_mul,
    inv_mul_cancel₀ hnu, C_1, one_mul]

/-! ## 2. Transport of splitting and derivatives -/

theorem derivative_comp_linear (f : ℚ[X]) (lam mu : ℚ) :
    derivative (f.comp (C lam * X + C mu))
      = C lam * (derivative f).comp (C lam * X + C mu) := by
  rw [derivative_comp]
  congr 1
  simp only [derivative_add, derivative_mul, derivative_C, derivative_X, zero_mul,
    mul_one, add_zero, zero_add]

theorem splits_comp_linear {f : ℚ[X]} (hf : f.Splits) (lam mu : ℚ) :
    (f.comp (C lam * X + C mu)).Splits :=
  hf.comp_of_natDegree_le_one natDegree_linear_le

theorem splits_C_mul (nu : ℚ) {f : ℚ[X]} (hf : f.Splits) : (C nu * f).Splits :=
  hf.C_mul nu

/-- Rational-derivedness is invariant along the affine group (one direction;
the other follows by symmetry). -/
theorem rdpoly_of_affineEquiv {f g : ℚ[X]} (h : AffineEquiv f g)
    (hf : RDPoly f) : RDPoly g := by
  obtain ⟨lam, mu, nu, hlam, hnu, hg⟩ := h
  obtain ⟨hf0, hf1, hf2, hf3⟩ := hf
  subst hg
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact splits_C_mul nu (splits_comp_linear hf0 lam mu)
  · simp only [derivative_C_mul, derivative_comp_linear]
    exact splits_C_mul nu (splits_C_mul lam (splits_comp_linear hf1 lam mu))
  · simp only [derivative_C_mul, derivative_comp_linear]
    exact splits_C_mul nu (splits_C_mul lam (splits_C_mul lam
      (splits_comp_linear hf2 lam mu)))
  · simp only [derivative_C_mul, derivative_comp_linear]
    exact splits_C_mul nu (splits_C_mul lam (splits_C_mul lam (splits_C_mul lam
      (splits_comp_linear hf3 lam mu))))

/-! ## 3. Normalisation into the family -/

/-- The normalised quartic is itself a (2,1,1) quartic when `a` avoids `{0,1}`. -/
theorem isP211_Q (a : ℚ) (h0 : a ≠ 0) (h1 : a ≠ 1) : IsP211 (Q a) := by
  refine ⟨1, 0, 1, a, one_ne_zero, zero_ne_one, h0.symm, h1.symm, ?_⟩
  unfold Q
  simp only [C_0, C_1]
  ring

/-- Every (2,1,1) shape is affine-equivalent to the normalised quartic at the
cross-ratio parameter `a = (r2-c)/(r1-c)` (the kernel form of
`caseA_scale` / `caseA_normalized`). -/
theorem affineEquiv_normalize (lam c r1 r2 : ℚ) (hlam : lam ≠ 0)
    (h1 : c ≠ r1) :
    AffineEquiv (C lam * (X - C c)^2 * ((X - C r1) * (X - C r2)))
      (Q ((r2 - c)/(r1 - c))) := by
  have hrc : r1 - c ≠ 0 := sub_ne_zero.mpr (Ne.symm h1)
  refine ⟨r1 - c, c, (lam * (r1 - c)^4)⁻¹, hrc,
    inv_ne_zero (mul_ne_zero hlam (pow_ne_zero 4 hrc)), ?_⟩
  apply Polynomial.funext; intro x
  rw [Q_eval]
  unfold quartic211
  simp only [eval_mul, eval_comp, eval_pow, eval_sub, eval_add, eval_C, eval_X]
  field_simp
  ring

/-! ## 4. The classification -/

theorem classify_forward (f : ℚ[X]) (hf : IsP211 f) (hrd : RDPoly f) :
    ∃ a : ℚ, RD211 a ∧ AffineEquiv f (Q a) := by
  obtain ⟨lam, c, r1, r2, hlam, hcr1, hcr2, hr1r2, hfeq⟩ := hf
  have hrc : r1 - c ≠ 0 := sub_ne_zero.mpr (Ne.symm hcr1)
  set a := (r2 - c)/(r1 - c) with ha_def
  have hnorm : AffineEquiv f (Q a) := by
    rw [hfeq]; exact affineEquiv_normalize lam c r1 r2 hlam hcr1
  have hrd_Q : RDPoly (Q a) := rdpoly_of_affineEquiv hnorm hrd
  have ha0 : a ≠ 0 := by
    rw [ha_def]
    exact div_ne_zero (sub_ne_zero.mpr (Ne.symm hcr2)) hrc
  have ha1 : a ≠ 1 := by
    intro hEq
    apply hr1r2
    rw [ha_def] at hEq
    field_simp [hrc] at hEq
    linarith
  refine ⟨a, ?_, hnorm⟩
  rw [rd211_iff_natural]
  exact ⟨ha0, ha1, hrd_Q⟩

theorem classify_backward (a : ℚ) (ha : RD211 a) :
    RDPoly (Q a) ∧ IsP211 (Q a) := by
  obtain ⟨h0, h1, hnat⟩ := (rd211_iff_natural a).mp ha
  exact ⟨hnat, isP211_Q a h0 h1⟩

/-- **The affine classification**: a split (2,1,1) quartic is rational-derived
iff it is `<X*>`-equivalent to a member of the normalised family with gate
parameter in `RD211`. -/
theorem classification (f : ℚ[X]) (hf : IsP211 f) :
    RDPoly f ↔ ∃ a : ℚ, RD211 a ∧ AffineEquiv f (Q a) := by
  constructor
  · intro hrd
    exact classify_forward f hf hrd
  · rintro ⟨a, ha, heq⟩
    exact rdpoly_of_affineEquiv (affineEquiv_symm heq) (classify_backward a ha).1

/-- **The classification by the curve** (with `thm7prime`): a split (2,1,1)
quartic is rational-derived iff it is `<X*>`-equivalent to `Q (aMap w z)` for
a rational point `(w,z)` of `E` = 576i2 away from the denominator and
exceptional loci. -/
theorem classification_by_curve (f : ℚ[X]) (hf : IsP211 f) :
    RDPoly f ↔ ∃ w z : ℚ, OnE w z ∧ aDen w z ≠ 0 ∧
      aMap w z ≠ 0 ∧ aMap w z ≠ 1 ∧ AffineEquiv f (Q (aMap w z)) := by
  rw [classification f hf]
  constructor
  · rintro ⟨a, ha, heq⟩
    obtain ⟨w, z, hOn, hD, hMap⟩ := thm7prime.2 a ha
    refine ⟨w, z, hOn, hD, ?_, ?_, ?_⟩
    · rw [hMap]; exact ha.1
    · rw [hMap]; exact ha.2.1
    · rw [hMap]; exact heq
  · rintro ⟨w, z, hOn, hD, h0, h1, heq⟩
    exact ⟨aMap w z, thm7prime.1 w z hOn hD h0 h1, heq⟩

end Thm7Classification

#print axioms Thm7Classification.affineEquiv_refl
#print axioms Thm7Classification.affineEquiv_symm
#print axioms Thm7Classification.derivative_comp_linear
#print axioms Thm7Classification.splits_comp_linear
#print axioms Thm7Classification.splits_C_mul
#print axioms Thm7Classification.rdpoly_of_affineEquiv
#print axioms Thm7Classification.isP211_Q
#print axioms Thm7Classification.affineEquiv_normalize
#print axioms Thm7Classification.classify_forward
#print axioms Thm7Classification.classify_backward
#print axioms Thm7Classification.classification
#print axioms Thm7Classification.classification_by_curve
