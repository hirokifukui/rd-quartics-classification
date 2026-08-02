# Arithmetic walls W2–W5 — dated computational status (moved from blueprint Chapter 5)

**Date of record: 2026-08-02.** These four walls are records of computational status at a
point in time — measured fibres, a multi-day descent in progress, the cover mechanisms
examined, and a companion programme's disclosed-axiom footprint — not permanent
mathematics. On external review advice they were separated from the permanent blueprint
(which retains W1, the formalisation ceiling) so that the time-indexed laboratory record
and the durable mathematical document do not certify each other. Each wall keeps its
reopening gate. W4's mathematical content (the cover analysis and its kernel anchors)
remains blueprint Chapter 4; the wall form recorded here adds no mathematical claim.
None of these is an assertion of impossibility.

## Wall W2: five measured fibres are the noise floor
In the companion programme attacking `Conjecture1_normal` (blueprint Ch.4, the open statement) through
the fibred structure of the associated elliptic surfaces, the target parity datum
beta has been measured for exactly five fibres (n = 2,...,6).  A systematic
mining run over 488 atomic arithmetic features (with a pre-declared overfit
guard) found 16 exact matches against 15.25 expected by chance: agreement over
five fibres is statistically vacuous, and every surviving rule was verified to be
an avatar of the single invariant [3 does not divide n].  Candidate softer structures were
refuted by extension testing.  The mining record, with checksums, is preserved in the companion
programme's archive, outside this repository (cf.~Wall~W5).  **Reopening gate:** measurement of beta for any fibre with
n >= 7.


## Wall W3: the cost of one more fibre
The reason n >= 7 is unmeasured is concrete.  The 2-descent on the genus-2
Jacobian attached to the fibre n = 6 — an integral model with leading
coefficient of 171 decimal digits — has, at the time of writing, been running
continuously for more than three and a half days on a dedicated machine inside the
class-group stage, under an unconditional (non-GRH) regime.  The launch record and
log are preserved.  This is the physical form of Wall~W2: the per-fibre cost of
unconditional descent grows past the practical horizon exactly where finer
structure would first become visible.
**Reopening gate:** completion of the n = 6 computation; or an improved model
reducing the coefficient blow-up; or an algorithmic advance in unconditional
class-group computation.


## Wall W4: no examined mechanism yields finiteness
blueprint Chapter 4 shows that away from the symmetric locus (which carries no admissible rational points,
blueprint Chapter 4), the conclusion of Theorem~7 demands the lifting of rational points through
one of three nontrivial double covers governed by the single polynomial Q_4, and
that we found among the relevant twist classes no finiteness that a descent
argument could exploit.  Every mechanism we examined at the function-field level
failed to yield a finite reduction, and the field-dependence exhibited by the two refutations
(`not_T9_bridge_Q` over Q,
`not_T0_claim_K` over Q(sqrt 3441), both funnelling
through the square class 209) suggests that a proof along these lines would have to engage the arithmetic of
the base field in an essential way.
**Reopening gate:** a new arithmetic mechanism — for instance a Brauer--Manin
computation on the surface confining its rational points — or
`Conjecture1_normal` (blueprint Ch.4, the open statement) itself.


## The measured distance

## Wall W5: the disclosed-axiom footprint
The companion programme — whose artifacts live outside this repository; the main-line theorems of the present artifact close on the standard three axioms, with the single disclosed axiom `rank_E576i2` retained off the main line (README / blueprint Ch.3 rank remark) — has a current summit theorem for
`Conjecture1_normal` (blueprint Ch.4, the open statement) that carries, by independent kernel measurement, an
axiom footprint consisting of the three standard axioms of Lean's classical logic
together with five disclosed axioms: three encapsulating specific computer-algebra
rank computations, one packaging the tail of an even-orbit Mordell--Weil argument,
and one a coordinate function pending replacement by the library's Weierstrass
group law.  This footprint is the honest, machine-readable measure of the distance
between the present state and a complete proof; two of the five are engineering
debts with identified repairs; the remaining three stand exactly as long as Wall~W1 does
(a property of the current library, not of the mathematics).
**Reopening gate:** discharge of the load-bearing reduction through
`Conjecture1_normal` (blueprint Ch.4, the open statement); the two
engineering repairs; and, for the remaining three, Wall~W1.
