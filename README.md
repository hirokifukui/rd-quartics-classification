# rd-quartics-classification

Lean 4 formalization and computational certificates for:

**The classification of rational-derived quartics with a repeated root: a proof gap, its unconditional repair, and the formalization that found both** (Hiroki Fukui, 2026 — manuscript in preparation; will appear in `paper/`).

A monic polynomial over ℚ is *rational-derived* if it and all of its derivatives split completely over ℚ. Buchholz–MacDougall (J. Number Theory 81 (2000), Theorem 7) presented a classification of the repeated-root quartics `x²(x−1)(x−a)` by the rational points of the elliptic curve 576i2. This repository contains:

1. **The gap** (`Gap/`): kernel certificates that the published proof of Theorem 7 contains a circularity and a quantifier jump, exhibited by an explicit quartic over two base fields (`BMThm7Gap.lean`, `BMThm7Transcript.lean`; adjudication record in `ADJUDICATION.md`).
2. **The repair** (`Thm7Prime/`): Theorem 7′ — an unconditional, rank-free repair of the classification statement of BM2000 Theorem 7: the exact characterisation of the normalised repeated-root parameters (`RD211`) as the image of the rational points of 576i2, in both directions. The reduction of a general p(2,1,1) quartic to the normalised family is the classical ⟨X*⟩ normalisation; its identity layer is kernel-checked (`caseA_scale`, `caseA_normalized`). Both directions reduce to explicit polynomial certificates together with elementary field and order reasoning, consuming no Mordell–Weil input; the completeness direction uses an explicit rational reconstruction of a curve point from the two gate witnesses. Main statement: `theorem thm7prime : Thm7Prime` in `Thm7Prime/Master.lean`.
3. **Computational certificates** (`scripts/`): Magma and Sage scripts and logs for every CAS-derived fact (rank corrections to BM2000 Table 5 and Stroeker Ex. 4.1; the curve E₀ = 576i2 identifications; all Gröbner/elimination/Nullstellensatz cofactors, which are additionally reproduced verbatim in the Lean source and checked by the kernel; the Guy-1989 multiples 2P–5P scripts will be added with the manuscript).

## Verification

Toolchain `v4.31.0-rc1`, mathlib pin `d568c8c` (see `lean-toolchain`, `lake-manifest.json`). The rc toolchain is the one this mathlib pin builds against; both are pinned together for reproducibility.

```
lake exe cache get
lake build                            # primary: Thm7Prime (Master + Fidelity) and Gap
lake env lean Thm7Prime/Master.lean   # per-declaration axiom report
```

The main statement, verbatim from `Thm7Prime/Master.lean`:

```lean
def Thm7Backward : Prop :=
  ∀ w z : ℚ, OnE w z → aDen w z ≠ 0 → aMap w z ≠ 0 → aMap w z ≠ 1 →
    RD211 (aMap w z)
def Thm7Forward : Prop :=
  ∀ a : ℚ, RD211 a → ∃ w z : ℚ, OnE w z ∧ aDen w z ≠ 0 ∧ aMap w z = a
def Thm7Prime : Prop := Thm7Backward ∧ Thm7Forward
theorem thm7prime : Thm7Prime
```

The kernel reports the axiom footprint of `thm7prime` as exactly `[propext, Classical.choice, Quot.sound]` — no custom axioms, no `sorry`. The auxiliary declaration `rank_E576i2` (the single disclosed axiom: rank 1 of 576i2, unconditional 2-descent, two-system: `scripts/magma/wp1_rank576i2.m` md5 `0bf3fb70e86f0832c73fffb1980ebd68`, cross-checked in Sage) is retained deliberately as a trace of the earlier conditional architecture. Exactly two declarations depend on it — `rankOneE_holds` and the superseded wrapper `thm7prime_of_forward` — and the per-declaration axiom report shows that neither the main theorem `thm7prime` nor the forward direction `thm7_forward` does: both are rank-free polynomial arguments closing on the three standard axioms. The kernel's per-declaration report thus records not only the final state of the proof but its history; the axiom's elimination from the main line is itself machine-readable. The in-file status comments in `Thm7Prime/Master.lean` were aligned with the completed state on 2026-08-02 under an adjudicated amendment of the file's freeze (docstrings and comments only; no statement, proof, or axiom changed — see `TRANSFER_MANIFEST.md`); the per-declaration axiom report remains the authoritative record: `thm7_forward` and `thm7prime` close on the standard three axioms.

**Statement form.** `RD211` is the division-free *gate form* of rational-derivedness (design choice: verification-friendly restatement). The kernel contains the quartic itself (`quartic211`, with `quartic211_expand`), the identification of the two gates as the derivative discriminants (`gate1_is_disc`, `gate2_is_disc`), and the explicit rational splittings of both derivatives under the gates (`dq1_splits`, `dq2_splits`). Both links between the gate form and the natural `Polynomial.Splits` form are closed in the kernel in `Thm7Prime/Fidelity.lean`: the `Polynomial.derivative`s of the quartic are computed in the kernel (`derivative_Q`, `derivative2_Q`, with evaluation anchors to `dq1`, `dq2`), and the equivalence `rd211_iff_natural` — `RD211 a ↔ a ≠ 0 ∧ a ≠ 1 ∧ NaturalRD a` — holds with the standard three axioms in both directions (converse via `disc_sq_of_quadratic_splits`). The design-time CAS cross-check (`scripts/sage/wp1_fidelity.sage`, md5 `5cbcc1b4c4a70acd58e8e967c873852f`) remains as the independent leg. The frozen theorem statement is the gate form.

## Theorem → file map

| Claim (paper) | Formal declaration | File |
|---|---|---|
| Theorem 7′ (both directions) | `thm7prime` | `Thm7Prime/Master.lean` |
| Printed assumption ⟺ splitting of residual quadratic | `T2_iff_conclusion` | `Gap/BMThm7Transcript.lean` |
| Concluding universal ⟸ printed assumption | `T9_via_T2` | `Gap/BMThm7Transcript.lean` |
| ℚ-counterexample chain | — | `Gap/BMThm7Gap.lean` |
| Backward gate identities | `gate1_cleared`, `gate2_cleared` | `Thm7Prime/Master.lean` |
| Forward reconstruction & denominator control | `curve_cleared`, `aden_cleared`, `wD_ne`, `K1_ne`, `adP6_cover` | `Thm7Prime/Master.lean` |
| Gate form ⟺ natural rational-derivedness | `rd211_iff_natural` | `Thm7Prime/Fidelity.lean` |

(Line-pinned links to be added at release freeze.)

## Lineage

This repository merges and supersedes, for the purposes of the merged paper, two earlier per-paper repositories, both preserved with their own DOIs:

- `rational-derived-audit` — the audit and gap note. Zenodo: 10.5281/zenodo.21465598 (v1.2.0).
- `rd-quartics-thm7prime` — the repair paper. Zenodo: 10.5281/zenodo.21470001. This repository is seeded from it (git history preserved).

`archive/` preserves the pre-merge sources with their manifests for provenance; it is not part of the current build (`lake build` compiles the `Thm7Prime` and `Gap` libraries only).

## License / Citation

See `LICENSE` and `CITATION.cff`.
