# TRANSCRIPT Phase D -- pre-registration vs kernel: the adjudication record (FINAL 2026-07-17)

Order of events (auditable): STEPS.md frozen md5 3ccf4bb1... at 12:25 2026-07-16c,
BEFORE any build.  Every verdict below postdates the freeze.

| Pre-reg | Prediction | Verdict | Evidence |
|---|---|---|---|
| P1 | The hole is T2; `T2_assumption <-> T0-conclusion` provable std-3 | **CONFIRMED [P]** | `T2_iff_conclusion` std-3 (Phase B, MANIFEST_phaseB) |
| P2 | Kernel stops at T9; no derivation from T1,T3-T8; with T2 it closes (circle) | **CONFIRMED [P]** | `T9_bridge` remains a bare def (the reconstructed proposition, refuted as stated by the next clause); `not_T9_bridge_Q` std-3 refutes the implication over Q on the renormalised frozen witness (a,b,x0)=(13/34,-39/17,13/17); `T9_via_T2` std-3 shows one-step closure with T2 (MANIFEST_phaseC2/C3) |
| P3 | No step of T1-T9 uses splitting of f'' | **CONFIRMED (structural)** | No lemma in the transcribed T3-T8 chain takes an f''-hypothesis; kernel-visible in signatures. (f'' enters ONLY through the KDerived package of T2 -- which is the conclusion.) |
| P4 | T8 "Conversely..." is a non-sequitur but carries no load | **CONFIRMED (by isolation)** | T8 transcribed as square-class identities only; the converse direction was never needed anywhere downstream -- the chain compiles without it. |
| P5 | T6's stationary-point argument insufficient; conclusion D6 >= 0 true; SOS-style repair | **CONFIRMED + UPGRADED [P]** | `discCubic_fp_eq_four_D6`, `D6_eq_sq_of_vieta` (Sage-found integer certificate, kernel-verified), `D6_nonneg_of_vieta`, `deltaF_nonpos_of_vieta` -- D6 >= 0 over ANY linearly ordered field where f' splits: stronger than the printed real-plane claim, no analysis needed. Bonus discovery: CharZero is genuinely required (char 3 degenerates the first Vieta relation) -- invisible on paper, surfaced by a failed general-Field build. |
| P6 | l.611 prefactor 2^8 is a typo; correct is -2^12 form (l.568) | **CONFIRMED [MC 2-system]** | DeltaF = sym * Delta(f')^3 with prefactor 1 exactly; `deltaF_eq_sym_mul_deltaFp_cubed` [P]. l.568 and l.611 as printed contradict each other. Convention finding: BM's Delta is the RESULTANT at BOTH levels (standard disc at level 2 differs by 16). |
| P7 | Field-generic transcript; T9 must fail over K = Q(sqrt 3441) on Stroeker's object | **CONFIRMED, DEEPEST FORM [P]** | `not_T0_claim_K` std-3: the K-analogue of the THEOREM'S STATEMENT (not merely the argument) is false in transcript vocabulary, on Stroeker's published quartic renormalised (39/56, 13/16, 13/14); K built as explicit Subfield of R; square classes 209 and 719169 killed (MANIFEST_phaseC5). Both refutations (Q and K) funnel through the same class 209. |
| -- | T7a (not pre-registered as provable): expected external-dependency node (Caldwell [6]) | **UPGRADED to [P] in-house** | `symF_zero_not_KDerived` std-3 via disc(f'') = 48(p^2+q^2) on all three sym cases + 3-adic descent `sq_ne_three_mul_sq_add_sq`. Caldwell (Math. Spectrum 23 (1990), closed access) is eliminated from the load path. |

## What survives of sec 2.2.4 (the transcript is a survey, not a demolition)
- The translate setup is sound: c = -f(x_min) is rational because f' splits; the
  critical point becomes a double root (`bmTranslate_critical_double` [P]).
- T4 and Delta(f') = -16 D6 are exact [MC], modulo the resultant convention.
- T6's CONCLUSION is true and now proved in stronger, analysis-free form [P].
- T7a is true and now proved self-containedly [P].
- T7b's algebraic core is exact (`deltaFp_eq_zero_of_D6` [P]).
What does not survive: the bridge from all of the above to "r and s are rational".
The reconstructed implication is false as stated (P2), because in the printed text it was assumed rather than derived (P1).


## Addendum (2026-07-21): prose discharge scan
Lines 557-625 of the layout text (from the printed assumption to the
concluding exhaustion sentence) were scanned for discharge language
(removal or suspension of the assumption, complementary case analysis,
"for the moment", "now suppose", "otherwise"): none is present. The sole
"Conversely" in the span is T8's converse, recorded above as a
non-load-bearing non-sequitur (P4). This textual scan complements the
structural kernel record (P2: the concluding universal is not derivable
from T1, T3-T8; P3: f''-splitting enters only through the assumption).
