import Mathlib

/-!
# BM2000 §2.2.4 — faithful transcript (Phase B + C1: vocabulary, structure, identities)

Provenance:
* verbatim source: BM2000_full_layout.txt  md5 a177e2e673705c0d68cc5fdf3a6626ce, sec 2.2.4 = l.527-632
* segmentation + pre-registration: transcript/STEPS.md  md5 3ccf4bb1620b264baece2e2e510ad283
* frozen prior results (untouched): BMThm7Gap.lean (ed3374b3), BMThm7GapK.lean (607ec237)

Design (STEPS.md):
* transcribed over a general linearly ordered field K -- pre-registration P7:
  the K negative control demands the transcript be field-generic, so that
  Stroeker's published K-derived quartic (K = Q(sqrt 3441)) acts as a transparent
  control: a faithful transcript must NOT prove T0 over such K.
* `Polynomial.Splits p` on this mathlib pin means: p is a product of constants and
  monic linear factors over the base field itself -- exactly "all roots rational"
  relativized to K.
* "local minimum" (l.530) is rendered algebraically by the second-derivative test
  (faithful for the nondegenerate critical points of a quartic with 4 distinct
  real roots; the degenerate case D6 = 0 is excluded inside the argument, T7b).
-/

namespace BMThm7Transcript

open Polynomial

/-! ## Algebraic layer (no order needed) -/

section Algebra

variable {K : Type*} [Field K]

/-- T1 (l.549-551): `f(x) = x(x-1)(x-a)(x-b)`. -/
noncomputable def bmQuartic (a b : K) : K[X] :=
  X * (X - 1) * (X - C a) * (X - C b)

/-- Distinctness of the four roots {0, 1, a, b} (BM: p(1,1,1,1), four distinct roots). -/
def DistinctRoots (a b : K) : Prop :=
  a ≠ 0 ∧ a ≠ 1 ∧ b ≠ 0 ∧ b ≠ 1 ∧ a ≠ b

/-- BM sec 1: a polynomial is K-derived iff it and all its derivatives split
completely over K.  For a quartic the fourth derivative is constant; we state four
levels, matching "it and all its derivatives have all rational roots". -/
def KDerived (p : K[X]) : Prop :=
  p.Splits ∧ (derivative p).Splits ∧
  (derivative (derivative p)).Splits ∧
  (derivative (derivative (derivative p))).Splits

/-- Vertical translate by `c` (l.554-556, eq. (4)): `F(x) = f(x) + c`. -/
noncomputable def translate (p : K[X]) (c : K) : K[X] := p + C c

/-- Derivatives are invariant under vertical translation.  (Structural memo of
STEPS.md: this is why the derivative content of T2's assumption is inherited.) -/
@[simp] theorem derivative_translate (p : K[X]) (c : K) :
    derivative (translate p c) = derivative p := by
  simp [translate]

/-- BM's specific translate (l.529-531): move the graph so the chosen critical point
`x0` lands on the x-axis, i.e. translate by `c = -f(x0)`.  Note the soundness kernel
of the setup: `x0 : K` (available because `f'` splits over K when `f` is K-derived),
hence the translate amount `-eval x0 p` is K-rational -- this part of sec 2.2.4 is
sound and survives transcription. -/
noncomputable def bmTranslate (p : K[X]) (x0 : K) : K[X] :=
  translate p (-(p.eval x0))

@[simp] theorem bmTranslate_isRoot (p : K[X]) (x0 : K) :
    (bmTranslate p x0).IsRoot x0 := by
  simp [bmTranslate, translate, IsRoot]

/-- If `x0` is a critical point of `p`, then `x0` is a double root of the BM translate:
a root of it and of its derivative (l.529-531, "moved up to become a double root"). -/
theorem bmTranslate_critical_double (p : K[X]) (x0 : K)
    (hcrit : (derivative p).IsRoot x0) :
    (bmTranslate p x0).IsRoot x0 ∧ (derivative (bmTranslate p x0)).IsRoot x0 := by
  refine ⟨bmTranslate_isRoot p x0, ?_⟩
  simpa [bmTranslate] using hcrit

/-- T2 (l.554-558), the printed assumption, transcribed in content:
"We assume that the resulting quartic, F(x) ... is rational-derived and has a
double root."  (The double-root part is supplied by `bmTranslate_critical_double`
once `x0` is critical; the substantive content is `KDerived` of the translate.) -/
def T2_assumption (a b x0 : K) : Prop :=
  KDerived (bmTranslate (bmQuartic a b) x0)

/-- **Inheritance**: every derivative-level condition of `KDerived` transfers from `p`
to any vertical translate; hence, given `KDerived p`, asserting `KDerived` of the
translate is equivalent to asserting just the splitting of the translate itself. -/
theorem KDerived_translate_iff (p : K[X]) (c : K) (hp : KDerived p) :
    KDerived (translate p c) ↔ (translate p c).Splits := by
  constructor
  · exact fun h => h.1
  · intro h
    refine ⟨h, ?_, ?_, ?_⟩ <;>
      simp only [derivative_translate] <;>
      first
        | exact hp.2.1
        | exact hp.2.2.1
        | exact hp.2.2.2

/-- **P1 confirmed at kernel level**: under the standing hypothesis of sec 2.2.4 that
`f` is K-derived (l.549, "Consider a rational-derived quartic"), the printed
assumption T2 (l.554-558) is EQUIVALENT to the splitting of the translate over K --
which is exactly the section's promised conclusion T0 (l.531-534, "r and s" in K).
The assumption assumes the conclusion; nothing less, nothing more. [std-3 target] -/
theorem T2_iff_conclusion (a b x0 : K) (hf : KDerived (bmQuartic a b)) :
    T2_assumption a b x0 ↔ (bmTranslate (bmQuartic a b) x0).Splits :=
  KDerived_translate_iff _ _ hf

end Algebra

/-! ## Phase C, increment 1: the discriminant-identity layer (T3/T4/T7b/T8, P5, P6)

All identities below were CAS-gated first [MC, Magma V2.29-7 + Sage 10.8, 2026-07-16c,
jobs bm_transcript_T3T4 / bm_transcript_T3T4_sage2]:
* Res_x(F,F') is cubic in c with leading coefficient 256 (T3, l.561-562), and BM's
  Delta is the RESULTANT convention at BOTH levels (the standard-disc convention at
  the second level differs by a factor 16).
* DeltaF = -2^12 sym D6^3 (T4, l.568) is EXACT.
* Delta(f') = -16 D6 (l.605) is EXACT.
* P6 ADJUDICATED: DeltaF = sym * Delta(f')^3 with prefactor 1; the printed 2^8
  (l.611) is a typo, and with it l.568 and l.611 contradict each other on paper.
* P5 anchor: standard disc(f') = 4 D6, so D6 >= 0 wherever f' splits over an
  ordered field (discriminant = square of root differences) -- the honest
  replacement for T6's stationary-point argument (l.581-592), which cannot
  establish global nonnegativity on an unbounded domain.
The BM quantities are DEFINED by their closed forms; identities between them are
kernel-proved by `ring`; the identification with Resultants is the CAS gate above,
recorded in MANIFEST_phaseC1. -/

section Identities

variable {K : Type*} [Field K]

/-- sym (l.568 / l.611): the symmetric-configuration factor. -/
def symF (a b : K) : K := (a - b - 1)^2 * (a - b + 1)^2 * (a + b - 1)^2

/-- D6 (l.572-576), transcribed coefficientwise from the verbatim display. -/
def D6 (a b : K) : K :=
  9*a^4*b^2 - 14*a^3*b^3 + 9*a^2*b^4
  - (9*a^4*b - 3*a^3*b^2 - 3*a^2*b^3 + 9*a*b^4)
  + 9*a^4 + 3*a^3*b - 3*a^2*b^2 + 3*a*b^3 + 9*b^4
  - (14*a^3 - 3*a^2*b - 3*a*b^2 + 14*b^3)
  + 9*a^2 - 9*a*b + 9*b^2

/-- Delta(f') in BM's resultant convention (l.606): defined here by its closed form
-16 D6; the identification with Resultant(f', f'') is CAS-gated [MC]. -/
def deltaFp (a b : K) : K := -16 * D6 a b

/-- DeltaF (l.568, T4): defined by its closed form -2^12 sym D6^3; the identification
with the iterated resultant is CAS-gated [MC]. -/
def deltaF (a b : K) : K := -(2^12) * symF a b * (D6 a b)^3

/-- **P6 adjudicated, kernel form** (T4 vs T8 reconciliation): DeltaF equals
sym * Delta(f')^3 with prefactor 1.  The printed prefactor 2^8 at l.611 is a typo
[MC both systems]. -/
theorem deltaF_eq_sym_mul_deltaFp_cubed (a b : K) :
    deltaF a b = symF a b * (deltaFp a b)^3 := by
  simp only [deltaF, deltaFp, symF]; ring

/-- T7b (l.603-608), algebraic core: D6 = 0 -> Delta(f') = 0. -/
theorem deltaFp_eq_zero_of_D6 (a b : K) (h : D6 a b = 0) : deltaFp a b = 0 := by
  simp [deltaFp, h]

/-- The standard discriminant of a cubic p x^3 + q x^2 + r x + s. -/
def discCubic (p q r s : K) : K :=
  18*p*q*r*s - 4*q^3*s + q^2*r^2 - 4*p*r^3 - 27*p^2*s^2

/-- **P5 anchor, kernel form** [MC both systems]: the standard discriminant of
f' = 4x^3 - 3(1+a+b)x^2 + 2(a+b+ab)x - ab (the derivative of the T1 quartic,
coefficient bridge to be kernel-proved in increment 2) equals 4 D6. -/
theorem discCubic_fp_eq_four_D6 (a b : K) :
    discCubic 4 (-(3*(1+a+b))) (2*(a+b+a*b)) (-(a*b)) = 4 * D6 a b := by
  simp only [discCubic, D6]; ring

end Identities

/-! ## Order layer (l.530: "the (highest) local minimum") -/

section Order

variable {K : Type*} [Field K] [LinearOrder K] [IsStrictOrderedRing K]

/-- Local minimum at a critical point, rendered by the second-derivative test.
Fidelity note: BM speaks of the local minima of the real graph; for a quartic with
four distinct real roots all critical points are nondegenerate away from D6 = 0
(excluded in T7b), where the second-derivative test is equivalent. -/
def IsLocalMinCrit (p : K[X]) (x0 : K) : Prop :=
  (derivative p).IsRoot x0 ∧ 0 < (derivative (derivative p)).eval x0

/-- "(highest) local minimum" (l.530): a local-min critical point whose value
dominates every local-min critical point. -/
def IsHighestLocalMin (p : K[X]) (x0 : K) : Prop :=
  IsLocalMinCrit p x0 ∧ ∀ y : K, IsLocalMinCrit p y → p.eval y ≤ p.eval x0

/-- T0 (l.527-534): for a K-derived quartic with four distinct roots, the vertical
translate turning the highest local minimum into a double root leaves a quartic that
splits over K -- equivalently, "the remaining two roots, r and s say" (l.531) lie in K.
Stated over the ambient field to honour P7 (over K = Q(sqrt 3441) this must be
REFUTABLE via Stroeker's quartic; over Q it is Theorem 7's p(1,1,1,1) clause). -/
def T0_claim (K : Type*) [Field K] [LinearOrder K] [IsStrictOrderedRing K] : Prop :=
  ∀ a b x0 : K, DistinctRoots a b → KDerived (bmQuartic a b) →
    IsHighestLocalMin (bmQuartic a b) x0 →
    (bmTranslate (bmQuartic a b) x0).Splits

end Order

end BMThm7Transcript

#print axioms BMThm7Transcript.derivative_translate
#print axioms BMThm7Transcript.bmTranslate_critical_double
#print axioms BMThm7Transcript.KDerived_translate_iff
#print axioms BMThm7Transcript.T2_iff_conclusion
#print axioms BMThm7Transcript.deltaF_eq_sym_mul_deltaFp_cubed
#print axioms BMThm7Transcript.deltaFp_eq_zero_of_D6
#print axioms BMThm7Transcript.discCubic_fp_eq_four_D6

namespace BMThm7Transcript

open Polynomial

/-! ## Phase C, increment 2: coefficient bridge, honest T6, T9 scaffold (P2, P3)

P3 note (kernel-visible): no lemma or definition in this file takes any hypothesis
about the SECOND derivative of the quartic beyond what `KDerived` packages; the
transcribed chain T3-T8 consumes only f- and f'-level facts, matching the grep
finding of the frozen gap file. -/

section Bridge

variable {K : Type*} [Field K]

/-- Monomial expansion of the T1 quartic (Vieta form). -/
theorem bmQuartic_expand (a b : K) :
    bmQuartic a b
      = X^4 - (C a + C b + 1) * X^3 + (C a * C b + C a + C b) * X^2
          - C a * C b * X := by
  simp only [bmQuartic]; ring

/-- The derivative of the T1 quartic, explicit coefficients:
f' = 4x^3 - 3(1+a+b)x^2 + 2(a+b+ab)x - ab.  Bridges the abstract polynomial to
the coefficient list used in `discCubic_fp_eq_four_D6`. -/
theorem derivative_bmQuartic (a b : K) :
    derivative (bmQuartic a b)
      = 4 * X^3 - 3 * (C a + C b + 1) * X^2
          + 2 * (C a * C b + C a + C b) * X - C a * C b := by
  rw [bmQuartic_expand]
  simp only [derivative_sub, derivative_add, derivative_mul, derivative_C,
    derivative_X_pow, derivative_X, derivative_one, map_natCast]
  push_cast
  ring

set_option maxRecDepth 16384 in
/-- **Vieta form of the P5 anchor** [integer certificate found by Sage, verified by
kernel]: if the coefficients of f' match a split cubic 4(x-u)(x-v)(x-w) (the three
Vieta relations below), then D6 = 64 ((u-v)(u-w)(v-w))^2.  CharZero is genuinely
needed: in characteristic 3 the first Vieta relation degenerates. -/
theorem D6_eq_sq_of_vieta {K : Type*} [Field K] [CharZero K] (a b u v w : K)
    (h3 : 3*(1+a+b) = 4*(u+v+w))
    (h2 : 2*(a+b+a*b) = 4*(u*v+u*w+v*w))
    (h1 : a*b = 4*(u*v*w)) :
    D6 a b = 64 * ((u-v)*(u-w)*(v-w))^2 := by
  have h9 : (9:K) ≠ 0 := by norm_num
  refine mul_left_cancel₀ h9 ?_
  simp only [D6]
  linear_combination (27*a^3*b^2 - 69*a^2*b^3 + 96*a*b^4 + 36*a^2*b^2*u - 128*a*b^3*u + 48*a*b^2*u^2 + 36*a^2*b^2*v - 128*a*b^3*v + 96*a*b^2*u*v - 192*b^3*u*v + 256*b^2*u^2*v - 96*b*u^3*v + 48*a*b^2*v^2 + 256*b^2*u*v^2 + 192*b*u^2*v^2 - 96*b*u*v^3 + 36*a^2*b^2*w - 128*a*b^3*w + 96*a*b^2*u*w - 192*b^3*u*w + 256*b^2*u^2*w - 96*b*u^3*w + 96*a*b^2*v*w - 192*b^3*v*w + 384*b^2*u*v*w + 256*b^2*v^2*w - 96*b*v^3*w + 48*a*b^2*w^2 + 256*b^2*u*w^2 + 192*b*u^2*w^2 + 256*b^2*v*w^2 + 192*b*v^2*w^2 - 96*b*u*w^3 - 96*b*v*w^3 - 27*a^3*b + 9*a^2*b^2 + 69*a*b^3 + 96*b^4 - 36*a^2*b*u + 12*a*b^2*u - 128*b^3*u - 48*a*b*u^2 + 48*b^2*u^2 - 36*a^2*b*v + 12*a*b^2*v - 128*b^3*v - 96*a*b*u*v - 96*b^2*u*v - 208*b*u^2*v - 96*u^3*v - 48*a*b*v^2 + 48*b^2*v^2 - 208*b*u*v^2 + 192*u^2*v^2 - 96*u*v^3 - 36*a^2*b*w + 12*a*b^2*w - 128*b^3*w - 96*a*b*u*w - 96*b^2*u*w - 208*b*u^2*w - 96*u^3*w - 96*a*b*v*w - 96*b^2*v*w - 384*b*u*v*w - 208*b*v^2*w - 96*v^3*w - 48*a*b*w^2 + 48*b^2*w^2 - 208*b*u*w^2 + 192*u^2*w^2 - 208*b*v*w^2 + 192*v^2*w^2 - 96*u*w^3 - 96*v*w^3 + 27*a^3 + 9*a^2*b - 27*a*b^2 + 27*b^3 + 36*a^2*u + 12*a*b*u + 140*b^2*u + 48*a*u^2 + 48*b*u^2 + 36*a^2*v + 12*a*b*v + 140*b^2*v + 96*a*u*v + 48*b*u*v + 256*u^2*v + 48*a*v^2 + 48*b*v^2 + 256*u*v^2 + 36*a^2*w + 12*a*b*w + 140*b^2*w + 96*a*u*w + 48*b*u*w + 256*u^2*w + 96*a*v*w + 48*b*v*w + 96*u*v*w + 256*v^2*w + 48*a*w^2 + 48*b*w^2 + 256*u*w^2 + 256*v*w^2 - 69*a^2 + 69*a*b - 45*b^2 - 128*a*u - 128*b*u - 128*a*v - 128*b*v - 192*u*v - 128*a*w - 128*b*w - 192*u*w - 192*v*w + 96*a + 96*b) * h3 + (-144*b^4 + 384*b^3*u - 328*b^2*u^2 + 96*b*u^3 + 384*b^3*v - 368*b^2*u*v - 96*b*u^2*v + 144*u^3*v - 328*b^2*v^2 - 96*b*u*v^2 - 288*u^2*v^2 + 96*b*v^3 + 144*u*v^3 + 384*b^3*w - 368*b^2*u*w - 96*b*u^2*w + 144*u^3*w - 368*b^2*v*w - 96*b*v^2*w + 144*v^3*w - 328*b^2*w^2 - 96*b*u*w^2 - 288*u^2*w^2 - 96*b*v*w^2 - 288*v^2*w^2 + 96*b*w^3 + 144*u*w^3 + 144*v*w^3 - 144*b^3 + 36*b^2*u + 136*b*u^2 + 96*u^3 + 36*b^2*v + 560*b*u*v - 96*u^2*v + 136*b*v^2 - 96*u*v^2 + 96*v^3 + 36*b^2*w + 560*b*u*w - 96*u^2*w + 560*b*v*w + 432*u*v*w - 96*v^2*w + 136*b*w^2 - 96*u*w^2 - 96*v*w^2 + 96*w^3 - 36*b^2 - 108*b*u - 328*u^2 - 108*b*v - 368*u*v - 328*v^2 - 108*b*w - 368*u*w - 368*v*w - 328*w^2 - 36*b + 384*u + 384*v + 384*w - 144) * h2 + (-288*b^3 + 168*b^2*u + 288*b*u^2 - 576*u^3 + 168*b^2*v + 432*u^2*v + 288*b*v^2 + 432*u*v^2 - 576*v^3 + 168*b^2*w + 432*u^2*w - 864*u*v*w + 432*v^2*w + 288*b*w^2 + 432*u*w^2 + 432*v*w^2 - 576*w^3 + 180*b^2 - 456*b*u + 288*u^2 - 456*b*v - 432*u*v + 288*v^2 - 456*b*w - 432*u*w - 432*v*w + 288*w^2 + 180*b + 456*u + 456*v + 456*w - 504) * h1

end Bridge

section OrderConsequences

variable {K : Type*} [Field K] [LinearOrder K] [IsStrictOrderedRing K]

/-- **Honest T6** (replacing the insufficient stationary-point argument of
l.581-592): whenever f' splits in Vieta form, D6 >= 0 over any linearly ordered
field -- because it is 64 times a square.  This is stronger than BM's printed
claim (which lives on the real plane) and needs no analysis. -/
theorem D6_nonneg_of_vieta (a b u v w : K)
    (h3 : 3*(1+a+b) = 4*(u+v+w))
    (h2 : 2*(a+b+a*b) = 4*(u*v+u*w+v*w))
    (h1 : a*b = 4*(u*v*w)) :
    0 ≤ D6 a b := by
  rw [D6_eq_sq_of_vieta a b u v w h3 h2 h1]
  positivity

/-- ΔF <= 0 on the Vieta locus (T6's downstream conclusion, l.591-592):
deltaF = -2^12 * sym * D6^3 with sym a square and D6 >= 0. -/
theorem deltaF_nonpos_of_vieta (a b u v w : K)
    (h3 : 3*(1+a+b) = 4*(u+v+w))
    (h2 : 2*(a+b+a*b) = 4*(u*v+u*w+v*w))
    (h1 : a*b = 4*(u*v*w)) :
    deltaF a b ≤ 0 := by
  have hD6 : 0 ≤ D6 a b := D6_nonneg_of_vieta a b u v w h3 h2 h1
  have hsym : 0 ≤ symF a b := by simp only [symF]; positivity
  have : 0 ≤ symF a b * (D6 a b)^3 := mul_nonneg hsym (by positivity)
  simp only [deltaF]
  nlinarith [this]

/-- **T9 reconstructed bridge [REFUTED over ℚ]** (l.615-623, "The result of all the previous work shows
that the latter class is empty"): the implication the paper asserts, from the
hypotheses actually consumed by T3-T8 -- distinct roots (H1), f splits, f' splits
(H2), sym != 0 (H3) -- to T0's conclusion.  Stated as a definition, not proved:
pre-registration P2 predicts no derivation exists.  Over Q this proposition is
FALSE: the frozen witness file BMThm7Gap.lean (md5 ed3374b3, untouched) proves
`BM_sec224_argument_invalid` [std-3], refuting exactly this implication with the
quartic x(x-136)(x-52)(x+312).  Adding T2 instead closes it instantly -- see
`T9_via_T2` -- which is the circle P1. -/
def T9_bridge (K : Type*) [Field K] [LinearOrder K] [IsStrictOrderedRing K] : Prop :=
  ∀ a b x0 : K, DistinctRoots a b →
    (bmQuartic a b).Splits → (derivative (bmQuartic a b)).Splits →
    symF a b ≠ 0 → IsHighestLocalMin (bmQuartic a b) x0 →
    (bmTranslate (bmQuartic a b) x0).Splits

/-- The circle, restated at T9 (P2's second half): WITH the printed assumption T2,
the section's conclusion follows in one step -- because T2 contains it. -/
theorem T9_via_T2 {K : Type*} [Field K] (a b x0 : K)
    (h : T2_assumption a b x0) :
    (bmTranslate (bmQuartic a b) x0).Splits := h.1

end OrderConsequences

end BMThm7Transcript

#print axioms BMThm7Transcript.bmQuartic_expand
#print axioms BMThm7Transcript.derivative_bmQuartic
#print axioms BMThm7Transcript.D6_eq_sq_of_vieta
#print axioms BMThm7Transcript.D6_nonneg_of_vieta
#print axioms BMThm7Transcript.deltaF_nonpos_of_vieta
#print axioms BMThm7Transcript.T9_via_T2

namespace BMThm7Transcript

open Polynomial

/-! ## Phase C, increment 3: `¬ T9_bridge ℚ` (P2 completion, refutation over ℚ)

The T9 bridge (l.615-623, "the latter class is empty") is FALSE over ℚ.  This section
refutes it with the frozen BMThm7Gap.lean witness `x(x-136)(x-52)(x+312)` renormalised
to the file's `0,1,a,b` coordinates by dividing the roots by 136:

    a := 13/34,  b := -39/17,  x0 := 13/17.

All constants below were machine-verified (Magma V2.29-7 + Sage 10.8, two-system).  The
kernel checks reduce to `norm_num`/`ring`/`linear_combination` over ℚ plus the honest
irrationality of √209 (no integer, hence no rational, squares to 209 — mirroring the
gap file's `no_rat_sq_209`).

The heart is that the vertical translate turning the highest local minimum `x0 = 13/17`
into a double root leaves the residual quadratic `X^2 + (83/34)X + 104/289`, whose two
roots `r,s` satisfy `((2·root + 83/34)·34/5)^2 = 209` — irrational.  Hence the translate
does not split over ℚ, while `f`, `f'` split, the four roots are distinct and `sym ≠ 0`:
exactly the hypotheses T3-T8 consume.  P2 confirmed at kernel level. -/

section Inc3

/-- No integer squares to 209 (restated for this section; mirrors the frozen gap file). -/
theorem no_int_sq_209' : ∀ y : ℤ, y ^ 2 ≠ 209 := by
  intro y h
  have h1 : y ≤ 14 := by nlinarith [sq_nonneg (y - 15), sq_nonneg (y + 15)]
  have h2 : -14 ≤ y := by nlinarith [sq_nonneg (y - 15), sq_nonneg (y + 15)]
  interval_cases y <;> omega

/-- No rational squares to 209. -/
theorem no_rat_sq_209' (u : ℚ) (h : u ^ 2 = 209) : False := by
  have hr : ((u : ℝ)) ^ 2 = ((209 : ℤ) : ℝ) := by exact_mod_cast h
  have hv : ¬ ∃ z : ℤ, ((u : ℝ)) = (z : ℝ) := by
    rintro ⟨z, hz⟩
    have hu : u = (z : ℚ) := by exact_mod_cast hz
    refine no_int_sq_209' z ?_
    rw [hu] at h; exact_mod_cast h
  exact (Rat.not_irrational u) (irrational_nrt_of_notint_nrt 2 209 hr hv (by norm_num))

/-- (H1) The four roots `0, 1, 13/34, -39/17` are distinct. -/
theorem distinctRoots_witness : DistinctRoots (13/34 : ℚ) (-39/17) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> norm_num

/-- (H3) `sym ≠ 0`: not one of BM's excluded symmetric configurations. -/
theorem symF_ne_zero_witness : symF (13/34 : ℚ) (-39/17) ≠ 0 := by
  simp only [symF]; norm_num

/-- (H2a) `f` splits over ℚ: it is `X (X-1) (X - C(13/34)) (X - C(-39/17))`. -/
theorem bmQuartic_splits_witness : (bmQuartic (13/34 : ℚ) (-39/17)).Splits := by
  unfold bmQuartic
  refine ((Splits.X.mul ?_).mul (Splits.X_sub_C _)).mul (Splits.X_sub_C _)
  simpa using Splits.X_sub_C (1 : ℚ)

/-- Explicit factorisation of `f'` (three rational roots `13/17, 3/17, -13/8`). -/
theorem derivative_bmQuartic_factored :
    derivative (bmQuartic (13/34 : ℚ) (-39/17))
      = C 4 * (X - C (13/17)) * (X - C (3/17)) * (X + C (13/8)) := by
  apply Polynomial.funext
  intro x
  rw [derivative_bmQuartic]
  simp only [eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C, eval_one, eval_ofNat]
  ring

/-- (H2b) `f'` splits over ℚ. -/
theorem derivative_bmQuartic_splits_witness :
    (derivative (bmQuartic (13/34 : ℚ) (-39/17))).Splits := by
  rw [derivative_bmQuartic_factored]
  exact (((Splits.C 4).mul (Splits.X_sub_C _)).mul (Splits.X_sub_C _)).mul (Splits.X_add_C _)

/-- The second derivative of the witness quartic, evaluated pointwise. -/
theorem secondDerivative_bmQuartic_eval (y : ℚ) :
    (derivative (derivative (bmQuartic (13/34 : ℚ) (-39/17)))).eval y
      = 12 * y ^ 2 + (93/17) * y - 1612/289 := by
  rw [derivative_bmQuartic]
  simp only [derivative_sub, derivative_add, derivative_mul, derivative_C,
    derivative_X_pow, derivative_X, derivative_one, derivative_ofNat,
    mul_zero, zero_mul, add_zero, zero_add, mul_one,
    eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C, eval_one, eval_ofNat,
    eval_zero, Nat.cast_ofNat]
  ring

/-- The witness quartic, evaluated pointwise. -/
theorem bmQuartic_eval (y : ℚ) :
    (bmQuartic (13/34 : ℚ) (-39/17)).eval y
      = y * (y - 1) * (y - 13/34) * (y + 39/17) := by
  simp only [bmQuartic, eval_mul, eval_sub, eval_X, eval_C, eval_one]
  ring

/-- The (highest) local minimum sits at `x0 = 13/17`.  The critical points are exactly
`13/17, 3/17, -13/8`; the second-derivative signs are `1625/289 > 0`, `-1225/289 < 0`,
`79625/4624 > 0`, so `3/17` is a local maximum (excluded), and the two genuine local
minima satisfy `f(-13/8) = -6782139/1183744 ≤ -17576/83521 = f(13/17)`. -/
theorem isHighestLocalMin_witness :
    IsHighestLocalMin (bmQuartic (13/34 : ℚ) (-39/17)) (13/17) := by
  refine ⟨⟨?_, ?_⟩, ?_⟩
  · rw [IsRoot.def, derivative_bmQuartic_factored]
    simp only [eval_mul, eval_sub, eval_add, eval_C, eval_X]
    norm_num
  · rw [secondDerivative_bmQuartic_eval]; norm_num
  · intro y hy
    obtain ⟨hyroot, hypos⟩ := hy
    rw [IsRoot.def, derivative_bmQuartic_factored] at hyroot
    simp only [eval_mul, eval_sub, eval_add, eval_C, eval_X] at hyroot
    rcases mul_eq_zero.1 hyroot with hA | hR
    · rcases mul_eq_zero.1 hA with hAA | hM
      · rcases mul_eq_zero.1 hAA with hf4 | hL
        · exact absurd hf4 (by norm_num)
        · have hval : y = 13/17 := by linarith
          subst hval; simp only [bmQuartic_eval]; norm_num
      · have hval : y = 3/17 := by linarith
        rw [hval, secondDerivative_bmQuartic_eval] at hypos
        norm_num at hypos
    · have hval : y = -13/8 := by linarith
      subst hval; simp only [bmQuartic_eval]; norm_num

/-- Key factorisation: the BM vertical translate at `x0 = 13/17` is a double root at
`13/17` times the residual quadratic `X^2 + (83/34)X + 104/289`. -/
theorem bmTranslate_factored :
    bmTranslate (bmQuartic (13/34 : ℚ) (-39/17)) (13/17)
      = (X - C (13/17))^2 * (C 1 * X^2 + C (83/34) * X + C (104/289)) := by
  apply Polynomial.funext
  intro x
  simp only [bmTranslate, translate, bmQuartic, eval_add, eval_mul, eval_sub, eval_pow,
    eval_X, eval_C, eval_one]
  ring

/-- **The refutation core**: the BM translate does NOT split over ℚ, because its residual
quadratic has irrational roots (`√209`). -/
theorem bmTranslate_not_splits_witness :
    ¬ (bmTranslate (bmQuartic (13/34 : ℚ) (-39/17)) (13/17)).Splits := by
  intro hs
  rw [bmTranslate_factored] at hs
  have hq2ne : (C (1:ℚ) * X^2 + C (83/34) * X + C (104/289) : ℚ[X]) ≠ 0 := by
    have hd : (C (1:ℚ) * X^2 + C (83/34) * X + C (104/289)).degree = 2 :=
      degree_quadratic (by norm_num)
    intro h; rw [h] at hd; simp at hd
  have hne : ((X - C (13/17))^2 * (C (1:ℚ) * X^2 + C (83/34) * X + C (104/289)) : ℚ[X]) ≠ 0 :=
    mul_ne_zero (pow_ne_zero 2 (X_sub_C_ne_zero (13/17))) hq2ne
  have hdvd : (C (1:ℚ) * X^2 + C (83/34) * X + C (104/289) : ℚ[X]) ∣
      (X - C (13/17))^2 * (C (1:ℚ) * X^2 + C (83/34) * X + C (104/289)) :=
    Dvd.intro_left _ rfl
  have hq2 : (C (1:ℚ) * X^2 + C (83/34) * X + C (104/289) : ℚ[X]).Splits :=
    hs.of_dvd hne hdvd
  obtain ⟨y, hy⟩ := hq2.exists_eval_eq_zero
    (by rw [degree_quadratic (by norm_num : (1:ℚ) ≠ 0)]; decide)
  simp only [eval_add, eval_mul, eval_pow, eval_X, eval_C] at hy
  have hsq : ((2*y + 83/34) * (34/5))^2 = 209 := by linear_combination (4624/25 : ℚ) * hy
  exact no_rat_sq_209' _ hsq

/-- **P2 completed at kernel level** (l.615-623): the T9 bridge is FALSE over ℚ.  The
witness `a=13/34, b=-39/17, x0=13/17` satisfies every hypothesis the transcribed chain
T3-T8 consumes — four distinct roots, `f` and `f'` split, `sym ≠ 0`, and a highest local
minimum at `x0` — yet the vertical translate does not split.  So (H1)(H2)(H3)+highest-min
do NOT imply the section's conclusion; the printed argument cannot establish it.  (Adding
the printed assumption T2 instead closes it in one step — `T9_via_T2` — the circle P1.) -/
theorem not_T9_bridge_Q : ¬ T9_bridge ℚ := by
  intro h
  have hsplit :=
    h (13/34) (-39/17) (13/17) distinctRoots_witness bmQuartic_splits_witness
      derivative_bmQuartic_splits_witness symF_ne_zero_witness isHighestLocalMin_witness
  exact bmTranslate_not_splits_witness hsplit

end Inc3

end BMThm7Transcript

#print axioms BMThm7Transcript.not_T9_bridge_Q

namespace BMThm7Transcript

open Polynomial

/-! ## Phase C, increment 4: T7a in-house — `symF_zero_not_KDerived`

BM's Theorem 7 excludes the three "symmetric" root configurations `sym = 0`
(l.568 factor `(a-b-1)(a-b+1)(a+b-1)`) by a separate arithmetic argument: in each
symmetric case a K-derived quartic would force a rational point on a conic of the
shape `r² = 3(p² + q²)`, which by 3-adic descent has only the trivial solution.

The route (all constants machine-verified, Magma V2.29-7 + Sage 10.8):
* **A** `sq_ne_three_mul_sq_add_sq`: `r² = 3(m²+n²) → m = n = 0` over ℤ, by 3-adic
  descent (strong induction on `|m| + |n|`; squares mod 3 lie in `{0,1}`).
* **rat_descent**: the same over ℚ, by clearing denominators to integers.
* **B** `secondDerivative_bmQuartic`: `f'' = 12x² - 6(1+a+b)x + 2(a+b+ab)` in
  quadratic normal form, one derivative past `derivative_bmQuartic`.
* **C/D**: `sym = 0` splits (three squares) into `b = a-1`, `b = a+1`, `b = 1-a`;
  in each, `KDerived` makes `f''` split, giving a rational `y` with
  `f''(y) = 0`, whence `((24y-6(1+a+b))/4)² = 3(p²+q²)` with `(p,q)` equal to
  `(a-1,1)`, `(a,1)`, `(a,a-1)` respectively [disc values CAS-gated].  Descent
  forces `p = q = 0`, contradicting `q = 1` (cases 1,2) or `a ≠ 0` (case 3). -/

section Inc4

/-- **A** (first frozen statement): 3-adic descent.  If `r² = 3(m² + n²)` over ℤ
then `m = n = 0`.  Proof: `3 ∣ r²` ⟹ `3 ∣ r` (3 prime), write `r = 3s`, get
`3s² = m² + n²`; reducing mod 3 (squares are `{0,1}`) forces `3 ∣ m`, `3 ∣ n`;
writing `m = 3m'`, `n = 3n'` gives `s² = 3(m'² + n'²)` and the measure
`|m| + |n| = 3(|m'| + |n'|)` strictly drops — strong induction closes it. -/
theorem sq_ne_three_mul_sq_add_sq (r m n : ℤ) (h : r ^ 2 = 3 * (m ^ 2 + n ^ 2)) :
    m = 0 ∧ n = 0 := by
  suffices H : ∀ N : ℕ, ∀ r m n : ℤ, m.natAbs + n.natAbs ≤ N →
      r ^ 2 = 3 * (m ^ 2 + n ^ 2) → m = 0 ∧ n = 0 by
    exact H (m.natAbs + n.natAbs) r m n le_rfl h
  intro N
  induction N using Nat.strong_induction_on with
  | _ N ih =>
    intro r m n hN h
    -- 3 ∣ r
    have hdvdr : (3 : ℤ) ∣ r ^ 2 := ⟨m ^ 2 + n ^ 2, h⟩
    have h3r : (3 : ℤ) ∣ r := Int.prime_three.dvd_of_dvd_pow hdvdr
    obtain ⟨s, hr⟩ := h3r
    -- 3 * s^2 = m^2 + n^2
    have e1 : (3 : ℤ) * (3 * s ^ 2) = 3 * (m ^ 2 + n ^ 2) := by rw [← h, hr]; ring
    have e2 : (3 : ℤ) * s ^ 2 = m ^ 2 + n ^ 2 := mul_left_cancel₀ (by norm_num) e1
    -- 3 ∣ m, 3 ∣ n via ZMod 3
    have hdvd : (3 : ℤ) ∣ m ^ 2 + n ^ 2 := ⟨s ^ 2, by linarith⟩
    have hz : ((m : ZMod 3)) ^ 2 + ((n : ZMod 3)) ^ 2 = 0 := by
      have hcast : ((m ^ 2 + n ^ 2 : ℤ) : ZMod 3) = 0 := by
        rw [ZMod.intCast_zmod_eq_zero_iff_dvd]; exact_mod_cast hdvd
      push_cast at hcast; exact hcast
    have key : ∀ x y : ZMod 3, x ^ 2 + y ^ 2 = 0 → x = 0 ∧ y = 0 := by decide
    obtain ⟨hm0, hn0⟩ := key _ _ hz
    have h3m : (3 : ℤ) ∣ m := by
      have := (ZMod.intCast_zmod_eq_zero_iff_dvd m 3).mp hm0; exact_mod_cast this
    have h3n : (3 : ℤ) ∣ n := by
      have := (ZMod.intCast_zmod_eq_zero_iff_dvd n 3).mp hn0; exact_mod_cast this
    obtain ⟨m', hm'⟩ := h3m
    obtain ⟨n', hn'⟩ := h3n
    -- s^2 = 3 (m'^2 + n'^2)
    have e3 : (3 : ℤ) * s ^ 2 = 3 * (3 * (m' ^ 2 + n' ^ 2)) := by rw [e2, hm', hn']; ring
    have e4 : s ^ 2 = 3 * (m' ^ 2 + n' ^ 2) := mul_left_cancel₀ (by norm_num) e3
    -- measures
    have hmabs : m.natAbs = 3 * m'.natAbs := by rw [hm']; simp [Int.natAbs_mul]
    have hnabs : n.natAbs = 3 * n'.natAbs := by rw [hn']; simp [Int.natAbs_mul]
    by_cases hnm : m'.natAbs + n'.natAbs = 0
    · rw [Nat.add_eq_zero_iff] at hnm
      obtain ⟨hm'0, hn'0⟩ := hnm
      refine ⟨?_, ?_⟩
      · rw [hm', Int.natAbs_eq_zero.mp hm'0, mul_zero]
      · rw [hn', Int.natAbs_eq_zero.mp hn'0, mul_zero]
    · have hlt : m'.natAbs + n'.natAbs < N := by omega
      obtain ⟨hm'z, hn'z⟩ := ih _ hlt s m' n' le_rfl e4
      exact ⟨by rw [hm', hm'z, mul_zero], by rw [hn', hn'z, mul_zero]⟩

/-- Rational form of the descent: `r² = 3(p² + q²)` over ℚ forces `p = q = 0`.
Cleared to integers with the common denominator `D = r.den·p.den·q.den`, then
`sq_ne_three_mul_sq_add_sq` applies to `(D·r, D·p, D·q)`. -/
theorem rat_descent (r p q : ℚ) (h : r ^ 2 = 3 * (p ^ 2 + q ^ 2)) : p = 0 ∧ q = 0 := by
  set D : ℤ := (r.den : ℤ) * (p.den : ℤ) * (q.den : ℤ) with hD
  have hDpos : (0 : ℤ) < D := by
    have := r.den_pos; have := p.den_pos; have := q.den_pos
    positivity
  have hDne : (D : ℚ) ≠ 0 := by exact_mod_cast hDpos.ne'
  -- den * x = num  for each rational
  have hden : ∀ x : ℚ, (x.den : ℚ) * x = (x.num : ℚ) := by
    intro x
    have hd : (x.den : ℚ) ≠ 0 := by exact_mod_cast x.den_ne_zero
    have := (div_eq_iff hd).mp (Rat.num_div_den x)
    linear_combination -this
  -- integers R M N with (D:ℚ)*x = cast
  have hr' : (D : ℚ) * r = (((p.den : ℤ) * (q.den : ℤ) * r.num : ℤ) : ℚ) := by
    push_cast [hD]; linear_combination (p.den : ℚ) * (q.den : ℚ) * hden r
  have hp' : (D : ℚ) * p = (((r.den : ℤ) * (q.den : ℤ) * p.num : ℤ) : ℚ) := by
    push_cast [hD]; linear_combination (r.den : ℚ) * (q.den : ℚ) * hden p
  have hq' : (D : ℚ) * q = (((r.den : ℤ) * (p.den : ℤ) * q.num : ℤ) : ℚ) := by
    push_cast [hD]; linear_combination (r.den : ℚ) * (p.den : ℚ) * hden q
  set R : ℤ := (p.den : ℤ) * (q.den : ℤ) * r.num
  set M : ℤ := (r.den : ℤ) * (q.den : ℤ) * p.num
  set N : ℤ := (r.den : ℤ) * (p.den : ℤ) * q.num
  have hscaled : (R : ℚ) ^ 2 = 3 * ((M : ℚ) ^ 2 + (N : ℚ) ^ 2) := by
    rw [← hr', ← hp', ← hq']
    linear_combination (D : ℚ) ^ 2 * h
  have hscaledZ : (R : ℤ) ^ 2 = 3 * ((M : ℤ) ^ 2 + (N : ℤ) ^ 2) := by exact_mod_cast hscaled
  obtain ⟨hM, hN⟩ := sq_ne_three_mul_sq_add_sq R M N hscaledZ
  refine ⟨?_, ?_⟩
  · have : (D : ℚ) * p = 0 := by rw [hp']; exact_mod_cast hM
    rcases mul_eq_zero.1 this with h0 | h0
    · exact absurd h0 hDne
    · exact h0
  · have : (D : ℚ) * q = 0 := by rw [hq']; exact_mod_cast hN
    rcases mul_eq_zero.1 this with h0 | h0
    · exact absurd h0 hDne
    · exact h0

/-- **B**: the second derivative of the T1 quartic in quadratic normal form,
`f'' = 12x² - 6(1+a+b)x + 2(a+b+ab)`.  One derivative past `derivative_bmQuartic`. -/
theorem secondDerivative_bmQuartic {K : Type*} [Field K] (a b : K) :
    derivative (derivative (bmQuartic a b))
      = C 12 * X ^ 2 + C (-(6 * (1 + a + b))) * X + C (2 * (a + b + a * b)) := by
  rw [derivative_bmQuartic]
  simp only [derivative_sub, derivative_mul, derivative_C,
    derivative_X_pow, derivative_X, derivative_one, derivative_ofNat,
    mul_zero, zero_mul, add_zero, zero_add, mul_one,
    Nat.cast_ofNat, map_neg, map_mul, map_add, map_one, map_ofNat]
  ring

/-- **T7a in-house** (second frozen statement): a quartic in the symmetric locus
`sym = 0` with distinct roots is not K-derived over ℚ.  If it were, its second
derivative would split, yielding a rational `y` with `f''(y) = 0`; completing the
square gives `((24y - 6(1+a+b))/4)² = 3(p² + q²)` with `(p,q)` one of `(a-1,1)`,
`(a,1)`, `(a,a-1)` in the three symmetric cases.  `rat_descent` forces `p = q = 0`,
contradicting `q = 1` (cases `b = a±1`) or `a ≠ 0` (case `b = 1-a`). -/
theorem symF_zero_not_KDerived (a b : ℚ) (hd : DistinctRoots a b)
    (hsym : symF a b = 0) : ¬ KDerived (bmQuartic a b) := by
  intro hkd
  -- second derivative splits (third component of KDerived)
  have hsplit : (derivative (derivative (bmQuartic a b))).Splits := hkd.2.2.1
  rw [secondDerivative_bmQuartic] at hsplit
  -- extract a rational root y of f''
  obtain ⟨y, hy⟩ := hsplit.exists_eval_eq_zero
    (by rw [degree_quadratic (by norm_num : (12 : ℚ) ≠ 0)]; decide)
  simp only [eval_add, eval_mul, eval_pow, eval_X, eval_C] at hy
  have heq : 12 * y ^ 2 - 6 * (1 + a + b) * y + 2 * (a + b + a * b) = 0 := by
    linear_combination hy
  -- split sym = 0 into the three symmetric cases
  simp only [symF, mul_eq_zero, sq_eq_zero_iff] at hsym
  rcases hsym with (h1 | h2) | h3
  · -- b = a - 1 ;  (p, q) = (a - 1, 1)
    have hb : b = a - 1 := by linarith
    subst hb
    have hr2 : (6 * y - 3 * a) ^ 2 = 3 * ((a - 1) ^ 2 + 1 ^ 2) := by
      linear_combination 3 * heq
    obtain ⟨hp0, hq0⟩ := rat_descent _ _ _ hr2
    exact one_ne_zero hq0
  · -- b = a + 1 ;  (p, q) = (a, 1)
    have hb : b = a + 1 := by linarith
    subst hb
    have hr2 : (6 * y - 3 * (a + 1)) ^ 2 = 3 * (a ^ 2 + 1 ^ 2) := by
      linear_combination 3 * heq
    obtain ⟨hp0, hq0⟩ := rat_descent _ _ _ hr2
    exact one_ne_zero hq0
  · -- b = 1 - a ;  (p, q) = (a, a - 1)
    have hb : b = 1 - a := by linarith
    subst hb
    have hr2 : (6 * y - 3) ^ 2 = 3 * (a ^ 2 + (a - 1) ^ 2) := by
      linear_combination 3 * heq
    obtain ⟨hp0, hq0⟩ := rat_descent _ _ _ hr2
    exact hd.1 hp0

end Inc4

end BMThm7Transcript

#print axioms BMThm7Transcript.symF_zero_not_KDerived
#print axioms BMThm7Transcript.sq_ne_three_mul_sq_add_sq

namespace BMThm7Transcript

open Polynomial

/-! ## Phase C, increment 5: K negative control — `not_T0_claim_K` over K = ℚ(√3441)

The deepest control (pre-registration P7): the K-analogue of BM Theorem 7's p(1,1,1,1)
clause is FALSE.  We build the explicit real subfield `K = Ksub = {p + q√3441 : p q ∈ ℚ}`
of ℝ (a genuine `Subfield ℝ`, so it inherits `Field`, `LinearOrder` and
`IsStrictOrderedRing` from ℝ), and exhibit on it Stroeker's published proper K-derived
quartic (Rocky Mountain J. Math. 36(5) 2006, §5.2, D = 3·31·37 = 3441, t = −7/17),
renormalised to this file's `0,1,a,b` coordinates as `a = 39/56, b = 13/16, x0 = 13/14`.

All four levels (f and its three derivatives) split over K — the second derivative
genuinely needs the √3441 elements `(843 ± 5·√3441)/1344 ∈ K` — the four roots are
distinct, and `x0 = 13/14` is a highest local minimum.  Yet the vertical translate at
`x0` has residual quadratic `X² − (73/112)·X + 13/6272`, whose roots involve `√209`, and
`209` is not a square in K (a rational square in K is `p²` or `3441·q²`, and neither
`209` nor `209·3441 = 719169` is a rational square).  So the translate does not split
over K: `¬ T0_claim K`.

All constants machine-verified (Magma V2.29-7 + Sage 10.8, two-system).  Kernel checks
reduce to `ring`/`norm_num`/`linear_combination` pushed along the injective ring hom
`Ksub.subtype : K →+* ℝ`, plus the honest irrationalities of `√3441`, `√209`, `√719169`.
The square helpers mirror the frozen `BMThm7GapK.lean`; `no_rat_sq_209'` is reused from
increment 3. -/

section Inc5

theorem no_rat_sq_of_no_int_sq (n : ℤ) (hn : ∀ y : ℤ, y ^ 2 ≠ n) (u : ℚ)
    (h : u ^ 2 = (n : ℚ)) : False := by
  have hr : ((u : ℝ)) ^ 2 = ((n : ℤ) : ℝ) := by exact_mod_cast h
  have hv : ¬ ∃ y : ℤ, ((u : ℝ)) = (y : ℝ) := by
    rintro ⟨y, hy⟩
    have hu : u = (y : ℚ) := by exact_mod_cast hy
    refine hn y ?_; rw [hu] at h; exact_mod_cast h
  exact (Rat.not_irrational u) (irrational_nrt_of_notint_nrt 2 n hr hv (by norm_num))
theorem no_int_sq_of_natSqrt (n : ℕ) (h : Nat.sqrt n * Nat.sqrt n ≠ n) :
    ∀ y : ℤ, y ^ 2 ≠ (n : ℤ) := by
  intro y hy
  have hnat : y.natAbs * y.natAbs = n := by
    have h1 : ((y.natAbs * y.natAbs : ℕ) : ℤ) = y * y := Int.natAbs_mul_self
    have h2 : y * y = (n : ℤ) := by rw [← pow_two]; exact hy
    rw [h2] at h1; exact_mod_cast h1
  exact h ((Nat.exists_mul_self n).mp ⟨y.natAbs, hnat⟩)
theorem no_rat_sq_3441 (u : ℚ) (h : u ^ 2 = 3441) : False :=
  no_rat_sq_of_no_int_sq 3441 (no_int_sq_of_natSqrt 3441 (by norm_num)) u (by exact_mod_cast h)
theorem no_rat_sq_719169 (u : ℚ) (h : u ^ 2 = 719169) : False :=
  no_rat_sq_of_no_int_sq 719169 (no_int_sq_of_natSqrt 719169 (by norm_num)) u (by exact_mod_cast h)
theorem sqrt3441_irrational : Irrational (Real.sqrt 3441) := by
  have h2 : (Real.sqrt 3441) ^ 2 = ((3441 : ℤ) : ℝ) := by
    rw [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 3441)]; norm_num
  refine irrational_nrt_of_notint_nrt 2 3441 h2 ?_ (by norm_num)
  rintro ⟨y, hy⟩
  have hy2 : ((y : ℝ)) ^ 2 = ((3441 : ℤ) : ℝ) := by rw [← hy]; exact h2
  have : (y : ℤ) ^ 2 = (3441 : ℤ) := by exact_mod_cast hy2
  exact no_int_sq_of_natSqrt 3441 (by norm_num) y this
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
        have : (3441 : ℝ) * (q : ℝ) ^ 2 = (x : ℝ) := by rw [← hexp]; push_cast; ring
        exact_mod_cast this⟩
    · left; exact ⟨p, by
        have : ((p : ℝ)) ^ 2 = (x : ℝ) := by rw [← hexp]; push_cast; ring
        exact_mod_cast this⟩
  · exfalso
    have hc : (2 * (p : ℝ) * (q : ℝ)) ≠ 0 := by intro hz; apply hpq; exact_mod_cast hz
    have hval : Real.sqrt 3441 = (((x - p ^ 2 - 3441 * q ^ 2) / (2 * p * q) : ℚ) : ℝ) := by
      push_cast; rw [eq_div_iff hc]; linarith [hexp]
    exact sqrt3441_irrational ⟨_, hval.symm⟩

/-! ## Ksub -/
def Ksub : Subfield ℝ where
  carrier := { x : ℝ | ∃ p q : ℚ, x = p + q * Real.sqrt 3441 }
  mul_mem' := by
    rintro x y ⟨p,q,rfl⟩ ⟨p',q',rfl⟩
    refine ⟨p*p' + 3441*q*q', p*q'+q*p', ?_⟩
    have hs : (Real.sqrt 3441)^2 = 3441 := Real.sq_sqrt (by norm_num)
    push_cast; linear_combination (q:ℝ)*(q':ℝ)*hs
  one_mem' := ⟨1,0, by norm_num⟩
  add_mem' := by
    rintro x y ⟨p,q,rfl⟩ ⟨p',q',rfl⟩; exact ⟨p+p', q+q', by push_cast; ring⟩
  zero_mem' := ⟨0,0, by norm_num⟩
  neg_mem' := by rintro x ⟨p,q,rfl⟩; exact ⟨-p,-q, by push_cast; ring⟩
  inv_mem' := by
    rintro x ⟨p,q,rfl⟩
    have hs : (Real.sqrt 3441)^2 = 3441 := Real.sq_sqrt (by norm_num)
    by_cases hx : (p:ℝ) + q*Real.sqrt 3441 = 0
    · rw [hx, inv_zero]; exact ⟨0,0, by norm_num⟩
    · have hdne : (p^2 - 3441*q^2 : ℚ) ≠ 0 := by
        intro h0
        rcases eq_or_ne q 0 with hq | hq
        · rw [hq] at h0
          have hp0 : p = 0 := by nlinarith [sq_nonneg p]
          exact hx (by rw [hp0, hq]; norm_num)
        · exact no_rat_sq_3441 (p/q) (by field_simp; linarith [h0])
      have hDR : ((p:ℝ)^2 - 3441*(q:ℝ)^2) ≠ 0 := by exact_mod_cast hdne
      refine ⟨p/(p^2-3441*q^2), -q/(p^2-3441*q^2), ?_⟩
      refine inv_eq_of_mul_eq_one_right ?_
      push_cast
      rw [show ((p:ℝ) + q*Real.sqrt 3441) *
            (↑p/(↑p^2-3441*↑q^2) + (-↑q)/(↑p^2-3441*↑q^2)*Real.sqrt 3441)
            = (((p:ℝ)+q*Real.sqrt 3441)*((p:ℝ) - q*Real.sqrt 3441)) * (↑p^2-3441*↑q^2)⁻¹ from by ring]
      rw [show ((p:ℝ)+q*Real.sqrt 3441)*((p:ℝ) - q*Real.sqrt 3441) = (↑p^2-3441*↑q^2) from by
        linear_combination (-(q:ℝ)^2)*hs]
      exact mul_inv_cancel₀ hDR


/-- element builder for K = Q(sqrt 3441). -/
noncomputable def mk (p q : ℚ) : (↥Ksub) := ⟨(p:ℝ) + (q:ℝ)*Real.sqrt 3441, ⟨p,q,rfl⟩⟩

theorem map_mk (p q : ℚ) : Ksub.subtype (mk p q) = (p:ℝ) + (q:ℝ)*Real.sqrt 3441 := rfl

noncomputable abbrev aK : (↥Ksub) := ((39/56:ℚ) : ↥Ksub)
noncomputable abbrev bK : (↥Ksub) := ((13/16:ℚ) : ↥Ksub)
noncomputable abbrev x0K : (↥Ksub) := ((13/14:ℚ) : ↥Ksub)

theorem distinctRoots_K : DistinctRoots aK bK := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact Rat.cast_ne_zero.mpr (by norm_num)
  · have h : ((39/56:ℚ):↥Ksub) ≠ ((1:ℚ):↥Ksub) := Rat.cast_injective.ne (by norm_num)
    simpa using h
  · exact Rat.cast_ne_zero.mpr (by norm_num)
  · have h : ((13/16:ℚ):↥Ksub) ≠ ((1:ℚ):↥Ksub) := Rat.cast_injective.ne (by norm_num)
    simpa using h
  · exact Rat.cast_injective.ne (by norm_num)

theorem bmQuartic_splits_K : (bmQuartic aK bK).Splits := by
  unfold bmQuartic
  refine ((Splits.X.mul ?_).mul (Splits.X_sub_C _)).mul (Splits.X_sub_C _)
  simpa using Splits.X_sub_C (1 : ↥Ksub)

theorem derivative_bmQuartic_factored_K :
    derivative (bmQuartic aK bK)
      = C 4 * (X - C ((13/14:ℚ):↥Ksub)) * (X - C ((3/4:ℚ):↥Ksub)) * (X - C ((13/64:ℚ):↥Ksub)) := by
  apply Polynomial.funext; intro x
  rw [derivative_bmQuartic]
  simp only [eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C, eval_one, eval_ofNat]
  apply Ksub.subtype_injective
  simp only [map_mul, map_sub, map_add, map_pow, map_ofNat, map_one, map_ratCast]
  push_cast; ring

theorem derivative_bmQuartic_splits_K : (derivative (bmQuartic aK bK)).Splits := by
  rw [derivative_bmQuartic_factored_K]
  exact (((Splits.C 4).mul (Splits.X_sub_C _)).mul (Splits.X_sub_C _)).mul (Splits.X_sub_C _)

theorem secondDerivative_factored_K :
    derivative (derivative (bmQuartic aK bK))
      = C 12 * (X - C (mk (281/448) (5/1344))) * (X - C (mk (281/448) (-5/1344))) := by
  apply Polynomial.funext; intro x
  rw [secondDerivative_bmQuartic]
  simp only [eval_mul, eval_sub, eval_add, eval_pow, eval_X, eval_C]
  apply Ksub.subtype_injective
  have hs : (Real.sqrt 3441)^2 = 3441 := Real.sq_sqrt (by norm_num)
  simp only [map_mul, map_sub, map_add, map_pow, map_ofNat, map_neg, map_one, map_ratCast, map_mk]
  push_cast
  linear_combination (12*(5/1344:ℝ)^2) * hs

theorem secondDerivative_splits_K : (derivative (derivative (bmQuartic aK bK))).Splits := by
  rw [secondDerivative_factored_K]
  exact ((Splits.C 12).mul (Splits.X_sub_C _)).mul (Splits.X_sub_C _)

theorem thirdDerivative_factored_K :
    derivative (derivative (derivative (bmQuartic aK bK)))
      = C 24 * X + C (-(6 * (1 + aK + bK))) := by
  rw [secondDerivative_bmQuartic]
  simp only [derivative_mul, derivative_C,
    derivative_X_pow, derivative_X, derivative_one, derivative_ofNat,
    mul_zero, zero_mul, add_zero, zero_add, mul_one,
    Nat.cast_ofNat, map_neg, map_mul, map_add, map_one, map_ofNat]
  ring

theorem thirdDerivative_splits_K :
    (derivative (derivative (derivative (bmQuartic aK bK)))).Splits := by
  rw [thirdDerivative_factored_K]
  apply Polynomial.Splits.of_degree_le_one
  rw [degree_linear (show (24:↥Ksub) ≠ 0 by norm_num)]

theorem KDerived_K : KDerived (bmQuartic aK bK) :=
  ⟨bmQuartic_splits_K, derivative_bmQuartic_splits_K,
   secondDerivative_splits_K, thirdDerivative_splits_K⟩

theorem bmQuartic_eval_K (y : ↥Ksub) :
    (bmQuartic aK bK).eval y = y * (y - 1) * (y - aK) * (y - bK) := by
  simp only [bmQuartic, eval_mul, eval_sub, eval_X, eval_C, eval_one]

theorem isHighestLocalMin_K : IsHighestLocalMin (bmQuartic aK bK) x0K := by
  refine ⟨⟨?_, ?_⟩, ?_⟩
  · rw [IsRoot.def, derivative_bmQuartic_factored_K]
    simp only [eval_mul, eval_sub, eval_C, eval_X]
    apply Ksub.subtype_injective
    simp only [map_mul, map_sub, map_ofNat, map_ratCast, map_zero]
    push_cast; ring
  · have e : (derivative (derivative (bmQuartic aK bK))).eval x0K = ((1625/3136:ℚ):↥Ksub) := by
      rw [secondDerivative_bmQuartic]
      simp only [eval_add, eval_mul, eval_pow, eval_C, eval_X]
      apply Ksub.subtype_injective
      simp only [map_add, map_mul, map_pow, map_ofNat, map_neg, map_one, map_ratCast]
      push_cast; norm_num
    rw [e]; exact_mod_cast (by norm_num : (0:ℚ) < 1625/3136)
  · intro y hy
    obtain ⟨hyroot, hypos⟩ := hy
    rw [IsRoot.def, derivative_bmQuartic_factored_K] at hyroot
    simp only [eval_mul, eval_sub, eval_C, eval_X] at hyroot
    rcases mul_eq_zero.1 hyroot with hA | hR
    · rcases mul_eq_zero.1 hA with hAA | hM
      · rcases mul_eq_zero.1 hAA with hf4 | hL
        · exact absurd hf4 (by norm_num)
        · have hval : y = ((13/14:ℚ):↥Ksub) := by rw [sub_eq_zero] at hL; exact hL
          rw [hval]
      · have hval : y = ((3/4:ℚ):↥Ksub) := by rw [sub_eq_zero] at hM; exact hM
        rw [hval] at hypos
        have e2 : (derivative (derivative (bmQuartic aK bK))).eval ((3/4:ℚ):↥Ksub)
            = ((-25/64:ℚ):↥Ksub) := by
          rw [secondDerivative_bmQuartic]
          simp only [eval_add, eval_mul, eval_pow, eval_C, eval_X]
          apply Ksub.subtype_injective
          simp only [map_add, map_mul, map_pow, map_ofNat, map_neg, map_one, map_ratCast]
          push_cast; norm_num
        rw [e2] at hypos
        have hneg : ((-25/64:ℚ):↥Ksub) < 0 := by exact_mod_cast (by norm_num : (-25/64:ℚ) < 0)
        exact absurd hypos (not_lt.mpr hneg.le)
    · have hval : y = ((13/64:ℚ):↥Ksub) := by rw [sub_eq_zero] at hR; exact hR
      rw [hval]
      have hlhs : (bmQuartic aK bK).eval ((13/64:ℚ):↥Ksub)
          = ((-5714397/117440512:ℚ):↥Ksub) := by
        rw [bmQuartic_eval_K]
        apply Ksub.subtype_injective
        simp only [map_mul, map_sub, map_one, map_ratCast]
        push_cast; norm_num
      have hrhs : (bmQuartic aK bK).eval x0K = ((-2197/1229312:ℚ):↥Ksub) := by
        rw [bmQuartic_eval_K]
        apply Ksub.subtype_injective
        simp only [map_mul, map_sub, map_one, map_ratCast]
        push_cast; norm_num
      rw [hlhs, hrhs]
      exact_mod_cast (by norm_num : (-5714397/117440512:ℚ) ≤ -2197/1229312)

theorem bmTranslate_factored_K :
    bmTranslate (bmQuartic aK bK) x0K
      = (X - C x0K)^2
          * (C 1 * X^2 + C ((-73/112:ℚ):↥Ksub) * X + C ((13/6272:ℚ):↥Ksub)) := by
  apply Polynomial.funext; intro x
  simp only [bmTranslate, translate, bmQuartic, eval_add, eval_mul, eval_sub, eval_pow,
    eval_X, eval_C, eval_one]
  apply Ksub.subtype_injective
  simp only [map_add, map_mul, map_sub, map_pow, map_neg, map_one, map_ratCast]
  push_cast; ring

theorem bmTranslate_not_splits_K : ¬ (bmTranslate (bmQuartic aK bK) x0K).Splits := by
  intro hs
  rw [bmTranslate_factored_K] at hs
  have hq2ne : (C (1:↥Ksub) * X^2 + C ((-73/112:ℚ):↥Ksub) * X + C ((13/6272:ℚ):↥Ksub)) ≠ 0 := by
    have hd : (C (1:↥Ksub) * X^2 + C ((-73/112:ℚ):↥Ksub) * X + C ((13/6272:ℚ):↥Ksub)).degree = 2 :=
      degree_quadratic (by norm_num)
    intro h; rw [h] at hd; simp at hd
  have hne : ((X - C x0K)^2
      * (C (1:↥Ksub) * X^2 + C ((-73/112:ℚ):↥Ksub) * X + C ((13/6272:ℚ):↥Ksub))) ≠ 0 :=
    mul_ne_zero (pow_ne_zero 2 (X_sub_C_ne_zero x0K)) hq2ne
  have hdvd : (C (1:↥Ksub) * X^2 + C ((-73/112:ℚ):↥Ksub) * X + C ((13/6272:ℚ):↥Ksub)) ∣
      (X - C x0K)^2
        * (C (1:↥Ksub) * X^2 + C ((-73/112:ℚ):↥Ksub) * X + C ((13/6272:ℚ):↥Ksub)) :=
    Dvd.intro_left _ rfl
  have hq2 : (C (1:↥Ksub) * X^2 + C ((-73/112:ℚ):↥Ksub) * X + C ((13/6272:ℚ):↥Ksub)).Splits :=
    hs.of_dvd hne hdvd
  obtain ⟨y, hy⟩ := hq2.exists_eval_eq_zero
    (by rw [degree_quadratic (by norm_num : (1:↥Ksub) ≠ 0)]; decide)
  simp only [eval_add, eval_mul, eval_pow, eval_X, eval_C] at hy
  have hyR : (Ksub.subtype y)^2 - (73/112)*(Ksub.subtype y) + 13/6272 = 0 := by
    have h2 := congrArg (Ksub.subtype) hy
    simp only [map_add, map_mul, map_pow, map_one, map_ratCast, map_zero] at h2
    push_cast at h2
    linear_combination h2
  obtain ⟨py, qy, hmem⟩ := y.2
  rw [show Ksub.subtype y = (py:ℝ) + (qy:ℝ)*Real.sqrt 3441 from hmem] at hyR
  have key : (((((2*py-73/112)*(112/5)):ℚ):ℝ)
      + ((((224*qy/5):ℚ):ℝ))*Real.sqrt 3441)^2 = ((209:ℚ):ℝ) := by
    rw [show (((((2*py-73/112)*(112/5)):ℚ):ℝ) + ((((224*qy/5):ℚ):ℝ))*Real.sqrt 3441)
          = (2*((py:ℝ)+(qy:ℝ)*Real.sqrt 3441) - 73/112)*(112/5) from by push_cast; ring]
    rw [show ((2*((py:ℝ)+(qy:ℝ)*Real.sqrt 3441) - 73/112)*(112/5))^2 = (209:ℝ) from by
      linear_combination (50176/25:ℝ)*hyR]
    norm_num
  rcases rat_sq_in_K 209 _ _ key with ⟨p', hp'⟩ | ⟨q', hq'⟩
  · exact no_rat_sq_209' p' hp'
  · exact no_rat_sq_719169 (3441*q') (by linear_combination (3441:ℚ)*hq')

theorem not_T0_claim_K : ¬ T0_claim (↥Ksub) := by
  intro h
  exact bmTranslate_not_splits_K
    (h aK bK x0K distinctRoots_K KDerived_K isHighestLocalMin_K)

end Inc5

end BMThm7Transcript

#print axioms BMThm7Transcript.not_T0_claim_K

namespace BMThm7Transcript

/-! ## Boundary hook: Theorem 7 hangs from Conjecture 1 -/

/-- Conjecture 1 (BM2000), normalised form: no quartic x(x-1)(x-a)(x-b) with four
distinct roots is rational-derived.  (The unnormalised conjecture is equivalent via
BM's group <X*> of affine equivalences; only this direction is used here.)
Stated as a definition: an OPEN problem, deliberately without proof. -/
def Conjecture1_normal (K : Type*) [Field K] : Prop :=
  ∀ a b : K, DistinctRoots a b → ¬ KDerived (bmQuartic a b)

/-- **The white node**: Theorem 7's p(1,1,1,1) clause follows from Conjecture 1 --
vacuously, since the conjecture empties the hypothesis class.  This one line is the
ONLY known route to T0 (adjudication record, P1/P2/P7). [std-3] -/
theorem thm7_of_conjecture1 {K : Type*} [Field K] [LinearOrder K] [IsStrictOrderedRing K]
    (hc : Conjecture1_normal K) : T0_claim K :=
  fun a b _x0 hd hkd _ => absurd hkd (hc a b hd)

end BMThm7Transcript

#print axioms BMThm7Transcript.thm7_of_conjecture1
