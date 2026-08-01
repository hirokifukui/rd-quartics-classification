import Mathlib

/-!
# BM Theorem 7 -- the boundary layer (sigma3 = 0 chart), kernel anchors

Companion to BMThm7Transcript.lean.  This file kernel-certifies the algebraic skeleton
of the terrain map of session_2026-07-16c (RESULTS.md, [MC] Magma+Sage):
the sigma3 = 0 chart of BM sec 2.2.3, the funnel polynomial Q4, its factorisation into
the three symmetric-pairing curves, the identities (I1)/(I2), and negativity
certificates anchoring the cover-nontriviality verdicts.
Full function-field non-squareness remains [MC] (two-system); the negativity witnesses
below are its kernel-certified anchors: a square in Q(a,b) is nonnegative at every
rational point of its domain of definition.
-/

namespace BMThm7Boundary

/-- den = ab + a + b; the chart has roots 1, a, b, c with c = -ab/den (sigma3 = 0). -/
def den (a b : ℚ) : ℚ := a*b + a + b
/-- sigma1 * den. -/
def s1n (a b : ℚ) : ℚ := (1+a+b) * den a b - a*b
/-- sigma2 * den. -/
def s2n (a b : ℚ) : ℚ := (a+b+a*b) * den a b - a*b*(1+a+b)
/-- den^2 * (9 sigma1^2 - 32 sigma2): f' splitting condition, cleared. -/
def Rq (a b : ℚ) : ℚ := 9*(s1n a b)^2 - 32*(s2n a b)*(den a b)
/-- den^2 * (9 sigma1^2 - 24 sigma2): f'' splitting condition, cleared. -/
def Sq (a b : ℚ) : ℚ := 9*(s1n a b)^2 - 24*(s2n a b)*(den a b)
/-- The funnel: Q4 = (3 Rq - Sq)/18 = den^2 (sigma1^2 - 4 sigma2). -/
def Q4 (a b : ℚ) : ℚ := (3*Rq a b - Sq a b)/18

def F1 (a b : ℚ) : ℚ := a*b + a + b - 1
def F2 (a b : ℚ) : ℚ := a*b + a - b^2 + b
def F3 (a b : ℚ) : ℚ := a^2 - a*b - a - b

/-- (I1, cleared form): 18 Q4 = 3 Rq - Sq. -/
theorem I1_cleared (a b : ℚ) : 18 * Q4 a b = 3 * Rq a b - Sq a b := by
  simp only [Q4]; ring

/-- (I2): s1n^2 - Rq = -8 Q4 -- the C+- splitting obstruction funnels through Q4. -/
theorem I2 (a b : ℚ) : (s1n a b)^2 - Rq a b = -8 * Q4 a b := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; ring

/-- **The factorisation**: Q4 = F1 * F2 * F3. -/
theorem Q4_factor (a b : ℚ) : Q4 a b = F1 a b * F2 a b * F3 a b := by
  simp only [Q4, Rq, Sq, s1n, s2n, den, F1, F2, F3]; ring

/-! ## The degeneracy locus IS the symmetric case (pairing identities) -/

/-- den*(1 + c - a - b) = F1 * (-(a+b)): pairing {1,c}|{a,b}. -/
theorem pairing1 (a b : ℚ) :
    (1 - a - b) * den a b - a*b = F1 a b * (-(a+b)) := by
  simp only [den, F1]; ring

/-- den*(1 + a - b - c) = F2 * (a+1): pairing {1,a}|{b,c}. -/
theorem pairing2 (a b : ℚ) :
    (1 + a - b) * den a b + a*b = F2 a b * (a+1) := by
  simp only [den, F2]; ring

/-- den*(1 + b - a - c) = F3 * (-(b+1)): pairing {1,b}|{a,c}. -/
theorem pairing3 (a b : ℚ) :
    (1 - a + b) * den a b + a*b = F3 a b * (-(b+1)) := by
  simp only [den, F3]; ring

/-! ## Negativity certificates (kernel anchors of cover nontriviality [MC])

A square in the function field Q(a,b) is nonnegative at every rational point where it
is defined.  Each candidate below is NEGATIVE at an explicit rational point, anchoring
the two-system [MC] verdict that none of the eight is a square.
Point 1 = the K-witness (-51/13, -17/7) (Q4 < 0 there, Rq > 0, Sq > 0);
Point 2 = (1, 3) (Q4 = 72 > 0 there, Rq > 0, Sq > 0). -/

theorem Q4_neg : Q4 (-51/13) (-17/7) < 0 := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; norm_num

theorem Q4Rq_neg : Q4 (-51/13) (-17/7) * Rq (-51/13) (-17/7) < 0 := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; norm_num

theorem Q4Sq_neg : Q4 (-51/13) (-17/7) * Sq (-51/13) (-17/7) < 0 := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; norm_num

theorem Q4RqSq_neg :
    Q4 (-51/13) (-17/7) * (Rq (-51/13) (-17/7) * Sq (-51/13) (-17/7)) < 0 := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; norm_num

theorem n2Q4_neg : -2 * Q4 1 3 < 0 := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; norm_num

theorem n2Q4Rq_neg : -2 * Q4 1 3 * Rq 1 3 < 0 := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; norm_num

theorem n2Q4Sq_neg : -2 * Q4 1 3 * Sq 1 3 < 0 := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; norm_num

theorem n2Q4RqSq_neg : -2 * Q4 1 3 * (Rq 1 3 * Sq 1 3) < 0 := by
  simp only [Q4, Rq, Sq, s1n, s2n, den]; norm_num

end BMThm7Boundary

#print axioms BMThm7Boundary.Q4_factor
#print axioms BMThm7Boundary.I2
#print axioms BMThm7Boundary.pairing1
#print axioms BMThm7Boundary.Q4_neg
#print axioms BMThm7Boundary.n2Q4RqSq_neg
