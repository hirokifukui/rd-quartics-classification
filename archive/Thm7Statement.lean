/-
thm7_repair WP1 -- Theorem 7' statement assembly (Thm7Statement.lean).

Provenance (2026-07-21, claude.ai design session, agora):
* Section 2 is copied VERBATIM from Thm7RepairGates.lean
  (md5 ec4ababf9a58447f0a8add83dc5cf4ef; 7 declarations, std-3 exactly,
  independently kernel-audited 2026-07-21 on agora, exit 0).
* Statement fidelity [MC] (Sage 10.8 fresh 2026-07-21, /tmp/wp1_fidelity.sage;
  Magma A9 fresh, job wp1_rank576i2):
  - the gate polynomials are the derivative discriminants of
    q_a(x) = x^2 (x-1) (x-a): the quadratic factor of q_a' has discriminant
    9a^2-14a+9, and disc(q_a'') = 4*(9a^2-6a+9).
  - E : z^2 = w^3+12w^2-108w is Cremona 576i2, conductor 576; Sage 2-descent
    rank_bounds (1,1) (unconditional), analytic rank 1, torsion Z/2 x Z/2,
    generator (-2,16); Magma RankBounds 1 1, CremonaReference 576i2.
  - BK1995's E_A : Y^2 = X(X-48)(X+6) is 576i3, RankBounds 1 1, torsion
    Z/2 x Z/2; 2-isogenous (NOT isomorphic) to E; Magma exhibits the isogeny
    w |-> (w^2+12w+36)/(w-6), kernel {O,(6,0)}  (DEPENDENCY_MAP addendum A1).
  - a-map scan: every sampled point n*G + T (n in [-3,3], T in torsion) of
    E(Q) passes D_reduce and both gates; the locus {hMside = 0, aDen != 0}
    consists of exactly the two points (54,432) and (9,-27), both mapping to
    a = 77/90, with gate witnesses r = 19/10 and s = 97/30.
* Rank axiom five-point gate: see the docstring of `rank_E576i2`.

Statement design frozen by claude.ai under Dr. Fukui's WP1 directive.
Claude Code may repair TACTIC BLOCKS ONLY; every def / theorem statement /
axiom / docstring / #print axioms line is FROZEN.
-/
import Mathlib

set_option autoImplicit false

namespace Thm7Statement

/-! ## 1. The normalized p(2,1,1) family and its derivative gates -/

/-- The normalized p(2,1,1) quartic `q_a(x) = x^2 (x-1) (x-a)`,
roots `{0,0,1,a}`; genuine p(2,1,1) shape iff `a ∉ {0,1}`. -/
def quartic211 (a x : ℚ) : ℚ := x^2 * (x - 1) * (x - a)

/-- First derivative of `q_a` (expanded form). -/
def dq1 (a x : ℚ) : ℚ := 4*x^3 - 3*(1+a)*x^2 + 2*a*x

/-- Second derivative of `q_a`. -/
def dq2 (a x : ℚ) : ℚ := 12*x^2 - 6*(1+a)*x + 2*a

/-- Expansion anchor: `q_a = x^4 - (1+a)x^3 + a x^2`, so `dq1`/`dq2` are its
formal first and second derivatives coefficientwise. -/
theorem quartic211_expand (a x : ℚ) :
    quartic211 a x = x^4 - (1+a)*x^3 + a*x^2 := by
  unfold quartic211; ring

/-- `x = 0` is always critical: `q_a' = x * (4x^2 - 3(1+a)x + 2a)`. -/
theorem dq1_factor (a x : ℚ) :
    dq1 a x = x * (4*x^2 - 3*(1+a)*x + 2*a) := by
  unfold dq1; ring

/-- Gate 1 is precisely the discriminant of the quadratic factor of `q_a'`. -/
theorem gate1_is_disc (a : ℚ) :
    (3*(1+a))^2 - 4*4*(2*a) = 9*a^2 - 14*a + 9 := by ring

/-- Gate 2 is 4 times the discriminant of `q_a''`. -/
theorem gate2_is_disc (a : ℚ) :
    (6*(1+a))^2 - 4*12*(2*a) = 4*(9*a^2 - 6*a + 9) := by ring

/-- Gate 1: `9a^2-14a+9` is a rational square (⟺ `q_a'` splits over ℚ). -/
def Gate1 (a : ℚ) : Prop := ∃ r : ℚ, 9*a^2 - 14*a + 9 = r^2

/-- Gate 2: `9a^2-6a+9` is a rational square (⟺ `q_a''` splits over ℚ). -/
def Gate2 (a : ℚ) : Prop := ∃ s : ℚ, 9*a^2 - 6*a + 9 = s^2

/-- Rational-derivedness of the normalized p(2,1,1) quartic, division-free
gate form: distinct roots (`a ∉ {0,1}`) and both derivative gates square. -/
def RD211 (a : ℚ) : Prop := a ≠ 0 ∧ a ≠ 1 ∧ Gate1 a ∧ Gate2 a

/-- Under Gate 1 the first derivative splits with explicit rational roots. -/
theorem dq1_splits (a r : ℚ) (hr : 9*a^2 - 14*a + 9 = r^2) (x : ℚ) :
    dq1 a x = 4 * x * (x - (3*(1+a) + r)/8) * (x - (3*(1+a) - r)/8) := by
  unfold dq1
  linear_combination (-(x/16)) * hr

/-- Under Gate 2 the second derivative splits with explicit rational roots. -/
theorem dq2_splits (a s : ℚ) (hs : 9*a^2 - 6*a + 9 = s^2) (x : ℚ) :
    dq2 a x = 12 * (x - ((1+a)/4 + s/12)) * (x - ((1+a)/4 - s/12)) := by
  unfold dq2
  linear_combination (-(1/12)) * hs

/-! ## 2. VERBATIM gate machinery
(Thm7RepairGates.lean, md5 ec4ababf9a58447f0a8add83dc5cf4ef; the six
declarations below are byte-identical copies modulo namespace). -/

theorem D_reduce (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w) :
    (z - w - 18)*(8*w + z) = (7*w - 18)*z + (w^3 + 4*w^2 - 252*w) := by
  linear_combination hE

theorem gate1_cleared (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w) :
    (9*(9*(2*w + z - 12)*(w + 2))^2
      - 14*(9*(2*w + z - 12)*(w + 2))*((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))
      + 9*((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))^2)
      * (w*(w + 18)*(w^2 - 63*w + 486))^2
    = (3*(w - 18)*(w + 6)*w*(w + 18) + (-21*w^2 + 108*w - 2916)*z)^2
      * ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))^2 := by
  linear_combination ((-21609*w^6 + 333396*w^5 - 7858620*w^4 + 66134880*w^3 - 618833520*w^2 + 2346843456*w - 2754990144)*z^2 + (28224*w^7 - 1487808*w^6 - 4199040*w^5 + 184757760*w^4 - 4232632320*w^3 + 44079842304*w^2 - 88159684608*w)*z + 1170*w^10 - 44361*w^9 - 239256*w^8 + 21638016*w^7 - 61515936*w^6 - 3111698592*w^5 + 4406472576*w^4 + 209787397632*w^3 - 352638738432*w^2 + 297538935552*w) * hE

theorem gate2_cleared (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w) :
    (9*(9*(2*w + z - 12)*(w + 2))^2
      - 6*(9*(2*w + z - 12)*(w + 2))*((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))
      + 9*((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))^2)
      * (w*(w + 18)*(w^2 - 63*w + 486))^2
    = (3*(w - 18)*(w + 6)*w*(w + 18) + (-9*w^2 - 648*w + 2916)*z)^2
      * ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w))^2 := by
  linear_combination ((-3969*w^6 - 551124*w^5 - 15090300*w^4 + 273987360*w^3 - 1488034800*w^2 + 3367210176*w - 2754990144)*z^2 + (1512*w^8 + 27864*w^7 - 6695136*w^6 + 19945440*w^5 + 1473863040*w^4 - 15713647488*w^3 + 56324242944*w^2 - 66119763456*w)*z + 1026*w^10 - 29673*w^9 - 495720*w^8 + 11617344*w^7 + 125341344*w^6 - 1808316576*w^5 - 27685950336*w^4 + 296314495488*w^3 - 44079842304*w^2 + 297538935552*w) * hE

/-- Auxiliary identity (pure algebra: clear the division into one fraction).
    gate1 corresponds to c = 14, gate2 to c = 6. -/
theorem combine_frac (N D c : ℚ) (hD : D ≠ 0) :
    9*(N/D)^2 - c*(N/D) + 9 = (9*N^2 - c*N*D + 9*D^2)/D^2 := by
  field_simp

theorem gate1_sq (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w)
    (hM : w*(w + 18)*(w^2 - 63*w + 486) ≠ 0)
    (hD : (7*w - 18)*z + (w^3 + 4*w^2 - 252*w) ≠ 0) :
    ∃ r : ℚ, 9*((9*(2*w + z - 12)*(w + 2)) / ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w)))^2
        - 14*((9*(2*w + z - 12)*(w + 2)) / ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w)))
        + 9 = r^2 := by
  refine ⟨(3*(w - 18)*(w + 6)*w*(w + 18) + (-21*w^2 + 108*w - 2916)*z) / (w*(w + 18)*(w^2 - 63*w + 486)), ?_⟩
  rw [combine_frac _ _ _ hD, div_pow,
      div_eq_div_iff (pow_ne_zero 2 hD) (pow_ne_zero 2 hM)]
  linear_combination gate1_cleared w z hE

theorem gate2_sq (w z : ℚ) (hE : z^2 = w^3 + 12*w^2 - 108*w)
    (hM : w*(w + 18)*(w^2 - 63*w + 486) ≠ 0)
    (hD : (7*w - 18)*z + (w^3 + 4*w^2 - 252*w) ≠ 0) :
    ∃ r : ℚ, 9*((9*(2*w + z - 12)*(w + 2)) / ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w)))^2
        - 6*((9*(2*w + z - 12)*(w + 2)) / ((7*w - 18)*z + (w^3 + 4*w^2 - 252*w)))
        + 9 = r^2 := by
  refine ⟨(3*(w - 18)*(w + 6)*w*(w + 18) + (-9*w^2 - 648*w + 2916)*z) / (w*(w + 18)*(w^2 - 63*w + 486)), ?_⟩
  rw [combine_frac _ _ _ hD, div_pow,
      div_eq_div_iff (pow_ne_zero 2 hD) (pow_ne_zero 2 hM)]
  linear_combination gate2_cleared w z hE

/-! ## 3. The curve E = 576i2 and the a-map -/

/-- Membership on `E : z^2 = w^3 + 12w^2 - 108w`
(`= z^2 = w(w-6)(w+18)`, Cremona 576i2). -/
def OnE (w z : ℚ) : Prop := z^2 = w^3 + 12*w^2 - 108*w

/-- Numerator of the BM2000 a-map. -/
def aNum (w z : ℚ) : ℚ := 9*(2*w + z - 12)*(w + 2)

/-- Reduced denominator of the a-map (`D_reduce`: equals `(z-w-18)(8w+z)`
on the curve). -/
def aDen (w z : ℚ) : ℚ := (7*w - 18)*z + (w^3 + 4*w^2 - 252*w)

/-- The BM2000 a-map `a(w,z) = 9(2w+z-12)(w+2) / ((z-w-18)(8w+z))`, written
with the on-curve reduced denominator. -/
def aMap (w z : ℚ) : ℚ := aNum w z / aDen w z

/-- Side factor whose nonvanishing feeds the generic gate witnesses. -/
def hMside (w : ℚ) : ℚ := w*(w + 18)*(w^2 - 63*w + 486)

/-- The quadratic side factor splits: `w^2-63w+486 = (w-9)(w-54)`. -/
theorem hMside_factor (w : ℚ) :
    hMside w = w*(w + 18)*((w - 9)*(w - 54)) := by
  unfold hMside; ring

/-! ## 4. Theorem 7' -- the exact statement -/

/-- **Theorem 7', ⇐ direction** (every a-map value on `E(ℚ)` away from the
denominator locus and from `{0,1}` is rational-derived). Proved below
([P], rank input zero). -/
def Thm7Backward : Prop :=
  ∀ w z : ℚ, OnE w z → aDen w z ≠ 0 → aMap w z ≠ 0 → aMap w z ≠ 1 →
    RD211 (aMap w z)

/-- **Theorem 7', ⇒ direction** (completeness: every rational-derived
p(2,1,1) parameter arises from `E(ℚ)`). [OPEN] = WP3; its rank-1 input is
spliced via `rank_E576i2` in `thm7prime_of_forward`. -/
def Thm7Forward : Prop :=
  ∀ a : ℚ, RD211 a → ∃ w z : ℚ, OnE w z ∧ aDen w z ≠ 0 ∧ aMap w z = a

/-- **Theorem 7'** (repaired BM2000 Theorem 7; unrestricted E-form per
DEPENDENCY_MAP addendum A1 -- the BK coset restriction is a phenomenon of
their 2-isogenous model 576i3, not of `E` = 576i2). -/
def Thm7Prime : Prop := Thm7Backward ∧ Thm7Forward

/-! ## 5. The backward direction, proved -/

/-- Exceptional locus resolution: on `E` with `aDen ≠ 0`, `hMside w = 0`
forces `(w,z) ∈ {(54,432), (9,-27)}`  (Sage-verified locus, fidelity gate). -/
theorem exceptional_points (w z : ℚ) (hE : OnE w z) (hD : aDen w z ≠ 0)
    (hM : hMside w = 0) : (w = 54 ∧ z = 432) ∨ (w = 9 ∧ z = -27) := by
  -- Roadmap (tactics may be repaired, statement frozen):
  -- hMside_factor + mul_eq_zero  ==>  w = 0 ∨ w = -18 ∨ w = 9 ∨ w = 54.
  -- w = 0  : hE gives z^2 = 0, so z = 0; then aDen 0 0 = 0, contradiction hD.
  -- w = -18: hE gives z^2 = 0, so z = 0; then aDen (-18) 0 = 0, contradiction.
  -- w = 9  : hE gives (z-27)*(z+27) = 0 (linear_combination hE);
  --          z = 27 makes aDen 9 27 = 0 (contradiction); z = -27 survives.
  -- w = 54 : hE gives (z-432)*(z+432) = 0;
  --          z = -432 makes aDen 54 (-432) = 0 (contradiction); z = 432 survives.
  unfold OnE at hE
  rw [hMside_factor] at hM
  rcases mul_eq_zero.mp hM with h | hfac
  · rcases mul_eq_zero.mp h with hw | hw
    · -- w = 0
      subst hw
      exfalso; apply hD
      have h2 : z ^ 2 = 0 := by rw [hE]; norm_num
      have hz : z = 0 := sq_eq_zero_iff.mp h2
      subst hz; unfold aDen; norm_num
    · -- w + 18 = 0
      have hw' : w = -18 := by linarith
      subst hw'
      exfalso; apply hD
      have h2 : z ^ 2 = 0 := by rw [hE]; norm_num
      have hz : z = 0 := sq_eq_zero_iff.mp h2
      subst hz; unfold aDen; norm_num
  · rcases mul_eq_zero.mp hfac with hw | hw
    · -- w - 9 = 0
      have hw' : w = 9 := by linarith
      subst hw'
      have hzf : (z - 27) * (z + 27) = 0 := by linear_combination hE
      rcases mul_eq_zero.mp hzf with hz | hz
      · exfalso; apply hD
        have : z = 27 := by linarith
        subst this; unfold aDen; norm_num
      · right; exact ⟨rfl, by linarith⟩
    · -- w - 54 = 0
      have hw' : w = 54 := by linarith
      subst hw'
      have hzf : (z - 432) * (z + 432) = 0 := by linear_combination hE
      rcases mul_eq_zero.mp hzf with hz | hz
      · left; exact ⟨rfl, by linarith⟩
      · exfalso; apply hD
        have : z = -432 := by linarith
        subst this; unfold aDen; norm_num

/-- a-map value at the first exceptional point. -/
theorem exceptional_amap_54 : aMap 54 432 = 77/90 := by
  unfold aMap aNum aDen; norm_num

/-- a-map value at the second exceptional point. -/
theorem exceptional_amap_9 : aMap 9 (-27) = 77/90 := by
  unfold aMap aNum aDen; norm_num

/-- Both gates hold at `a = 77/90`, with explicit witnesses. -/
theorem gates_at_77_90 : Gate1 (77/90) ∧ Gate2 (77/90) :=
  ⟨⟨19/10, by norm_num⟩, ⟨97/30, by norm_num⟩⟩

/-- **Theorem 7', ⇐ direction: proved** ([P] target; rank input zero). -/
theorem thm7_backward : Thm7Backward := by
  intro w z hE hD h0 h1
  by_cases hM : hMside w = 0
  · -- exceptional branch: the two points, both a = 77/90
    rcases exceptional_points w z hE hD hM with ⟨hw, hz⟩ | ⟨hw, hz⟩ <;>
      subst hw <;> subst hz
    · rw [exceptional_amap_54]
      exact ⟨by norm_num, by norm_num, gates_at_77_90.1, gates_at_77_90.2⟩
    · rw [exceptional_amap_9]
      exact ⟨by norm_num, by norm_num, gates_at_77_90.1, gates_at_77_90.2⟩
  · -- generic branch: repackage gate1_sq / gate2_sq
    have hM' : w*(w + 18)*(w^2 - 63*w + 486) ≠ 0 := hM
    have hD' : (7*w - 18)*z + (w^3 + 4*w^2 - 252*w) ≠ 0 := hD
    have hE' : z^2 = w^3 + 12*w^2 - 108*w := hE
    refine ⟨h0, h1, ?_, ?_⟩
    · show ∃ r : ℚ, 9*(aMap w z)^2 - 14*(aMap w z) + 9 = r^2
      unfold aMap aNum aDen
      exact gate1_sq w z hE' hM' hD'
    · show ∃ s : ℚ, 9*(aMap w z)^2 - 6*(aMap w z) + 9 = s^2
      unfold aMap aNum aDen
      exact gate2_sq w z hE' hM' hD'

/-! ## 6. The rank-1 safe axiom and the WP3 splice -/

open WeierstrassCurve

/-- `E` as a mathlib Weierstrass curve:
`[a₁,a₂,a₃,a₄,a₆] = [0,12,0,-108,0]`, i.e. `z² = w³ + 12w² − 108w`,
Cremona 576i2. -/
def E576i2 : WeierstrassCurve ℚ := ⟨0, 12, 0, -108, 0⟩

/-- Fidelity bridge: `OnE` is exactly the affine Weierstrass equation of
`E576i2`. -/
theorem OnE_iff_equation (w z : ℚ) :
    OnE w z ↔ E576i2.toAffine.Equation w z := by
  rw [WeierstrassCurve.Affine.equation_iff]
  unfold OnE E576i2
  constructor <;> intro h <;> linarith

/-- Nonsingularity foothold (`Δ ≠ 0` by exact ℚ arithmetic): the axiom below
is a statement about a genuine elliptic curve. FULLY PROVED, not an axiom. -/
theorem E576i2_elliptic : E576i2.Δ ≠ 0 := by
  simp only [WeierstrassCurve.Δ, WeierstrassCurve.b₂, WeierstrassCurve.b₄,
    WeierstrassCurve.b₆, WeierstrassCurve.b₈, E576i2]
  norm_num

/-- **[P-ax] rank `E(576i2)` = 1** -- the single disclosed safe axiom of the
thm7_repair track (instance-localized, five-point-gated, style of
qderived `rank_W_*`):
  (i)   CONSISTENCY : a fixed true rank equality about one genuine elliptic
        curve (`Δ ≠ 0`, `E576i2_elliptic`); neither provable nor refutable
        in current mathlib (no Mordell-Weil rank computation); NOT a
        universal over a free predicate -- no degenerate-instance loophole.
  (ii)  LOCALIZED   : bound to the single concrete `WeierstrassCurve ℚ`
        `E576i2` = Cremona 576i2, conductor 576.
  (iii) MULTI-SYSTEM [MC fresh 2026-07-21]: Sage 10.8 2-descent
        `rank_bounds = (1,1)` (unconditional) + analytic rank 1 + certified
        generator `(-2,16)`; Magma V2.29-7 (A9) `RankBounds = 1 1`,
        `CremonaReference = 576i2`.  Independent prior [MC] recorded in
        DEPENDENCY_MAP WP3.
  (iv)  ELIMINATION : becomes a `theorem` the day mathlib computes
        Mordell-Weil rank (2-descent / Selmer rank) for this curve; the
        statement is already the target shape.
  (v)   FOOTPRINT   : appears in `#print axioms` of `rankOneE_holds` and
        `thm7prime_of_forward` below. -/
axiom rank_E576i2 : Module.rank ℤ E576i2.toAffine.Point = 1

/-- The rank-1 obligation slot consumed by the WP3 completeness argument. -/
def RankOneE : Prop := Module.rank ℤ E576i2.toAffine.Point = 1

/-- The disclosed axiom discharges the slot (definitional). -/
theorem rankOneE_holds : RankOneE := rank_E576i2

/-- **The WP1/WP3 splice**: Theorem 7' follows from the single remaining
open slot `hF : RankOneE → Thm7Forward` (the BK1995-chain completeness
argument, to be built in WP3), with the rank input discharged by the
disclosed safe axiom. `#print axioms` of this theorem = std trio +
`rank_E576i2`, the machine-readable [P-ax] boundary of the track. -/
theorem thm7prime_of_forward (hF : RankOneE → Thm7Forward) : Thm7Prime :=
  ⟨thm7_backward, hF rankOneE_holds⟩

/-! ## 7. caseA bridge (normalization of a general p(2,1,1) translate) -/

/-- Scale-form normalization identity (no hypotheses): the case-A translate
`(x-c)²(x-r₁)(x-r₂)` of `QDCaseSplit.caseA_normal_form`, pulled back along
`x = c + (r₁-c)u`. -/
theorem caseA_scale (c r1 r2 u : ℚ) :
    (c + (r1-c)*u - c)^2 * (c + (r1-c)*u - r1) * (c + (r1-c)*u - r2)
      = (r1-c)^3 * (u^2 * (u-1) * ((r1-c)*u - (r2-c))) := by ring

/-- Normalization: for `r₁ ≠ c` the case-A translate is
`(r₁-c)⁴ · q_a(u)` with `a = (r₂-c)/(r₁-c)` -- the bridge from the
qderived case split into the normalized family of Theorem 7'. -/
theorem caseA_normalized (c r1 r2 u : ℚ) (h : r1 - c ≠ 0) :
    (c + (r1-c)*u - c)^2 * (c + (r1-c)*u - r1) * (c + (r1-c)*u - r2)
      = (r1-c)^4 * quartic211 ((r2-c)/(r1-c)) u := by
  unfold quartic211
  field_simp
  ring

end Thm7Statement

#print axioms Thm7Statement.quartic211_expand
#print axioms Thm7Statement.dq1_factor
#print axioms Thm7Statement.gate1_is_disc
#print axioms Thm7Statement.gate2_is_disc
#print axioms Thm7Statement.dq1_splits
#print axioms Thm7Statement.dq2_splits
#print axioms Thm7Statement.D_reduce
#print axioms Thm7Statement.gate1_cleared
#print axioms Thm7Statement.gate2_cleared
#print axioms Thm7Statement.combine_frac
#print axioms Thm7Statement.gate1_sq
#print axioms Thm7Statement.gate2_sq
#print axioms Thm7Statement.hMside_factor
#print axioms Thm7Statement.exceptional_points
#print axioms Thm7Statement.exceptional_amap_54
#print axioms Thm7Statement.exceptional_amap_9
#print axioms Thm7Statement.gates_at_77_90
#print axioms Thm7Statement.thm7_backward
#print axioms Thm7Statement.OnE_iff_equation
#print axioms Thm7Statement.E576i2_elliptic
#print axioms Thm7Statement.rankOneE_holds
#print axioms Thm7Statement.thm7prime_of_forward
#print axioms Thm7Statement.caseA_scale
#print axioms Thm7Statement.caseA_normalized
