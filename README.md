# rd-quartics-classification

**Frozen release: [v1.0.2](https://github.com/hirokifukui/rd-quartics-classification/releases/tag/v1.0.2)** (2026-08-03 JST; v1.0.0 and v1.0.1 remain as annotated earlier freezes; citation data in `CITATION.cff`; release notes in `RELEASE_v1.0.2.md`). Permanent file references should use the tag: `https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/<path>`.

[![CI](https://github.com/hirokifukui/rd-quartics-classification/actions/workflows/blueprint.yml/badge.svg?branch=main)](https://github.com/hirokifukui/rd-quartics-classification/actions/workflows/blueprint.yml)

Lean 4 formalization and computational certificates for:

**The classification of rational-derived quartics with a repeated root: a proof gap, its unconditional repair, and the formalization that found both** (Hiroki Fukui, 2026 — manuscript in preparation; will appear in `paper/`).

A monic polynomial over ℚ is *rational-derived* if it and all of its derivatives split completely over ℚ. Buchholz–MacDougall (J. Number Theory 81 (2000), Theorem 7) presented a classification of the repeated-root quartics `x²(x−1)(x−a)` by the rational points of the elliptic curve 576i2. This repository contains:

1. **The gap** (`Gap/`): a human-audited formal transcription of the printed proof of Theorem 7, with kernel certificates establishing circularity in the transcribed assumption and a counterexample to the reconstructed bridge, exhibited by an explicit quartic over two base fields (`BMThm7Gap.lean`, `BMThm7Transcript.lean`; adjudication record in `Gap/ADJUDICATION.md`, pre-registration frozen before any Lean build in `Gap/STEPS.md`).
2. **The repair** (`Thm7Prime/`): Theorem 7′ — an unconditional, rank-free repair of the classification statement of BM2000 Theorem 7: the exact characterisation of the normalised repeated-root parameters (`RD211`) as the image, under the parameter map, of the affine rational points of the Weierstrass model `z² = w³+12w²−108w` (Cremona 576i2) away from the pole locus of the map (`aDen ≠ 0`) and the degenerate values `a ∈ {0,1}`, in both directions. The reduction of a general p(2,1,1) quartic to the normalised family is a kernel theorem as well: `Thm7Prime/Classification.lean` defines the equivalence relation induced by ⟨X*⟩ (`AffineEquiv`; reflexivity, symmetry and transitivity proved, packaged as a `Setoid`) and proves the packaged classification — `classification` (a split (2,1,1) quartic is rational-derived iff ⟨X*⟩-equivalent to `Q a` with `RD211 a`) and `classification_by_curve` (iff ⟨X*⟩-equivalent to `Q (aMap w z)` for an affine rational point `(w,z)` of the Weierstrass model of 576i2 with `aDen ≠ 0` and `aMap ∉ {0,1}`, via `thm7prime`); the underlying identity layer is `caseA_scale` / `caseA_normalized`. Both directions reduce to explicit polynomial certificates together with elementary field and order reasoning, consuming no Mordell–Weil input; the completeness direction uses an explicit rational reconstruction of a curve point from the two gate witnesses. Main statement: `theorem thm7prime : Thm7Prime` in `Thm7Prime/Master.lean`.
3. **Computational certificates** (`scripts/`): Magma and Sage scripts and logs for the load-bearing CAS-derived facts — coverage and documented exceptions are inventoried in `scripts/CERTIFICATES.md` (rank corrections to BM2000 Table 5 and Stroeker Ex. 4.1; the curve E₀ = 576i2 identifications; all Gröbner/elimination/Nullstellensatz cofactors, which are additionally reproduced verbatim in the Lean source and checked by the kernel; the Guy-1989 multiples 2P–5P scripts are out of scope of the present release: they are not load-bearing for any claim here and belong to the manuscript).

## Verification

Toolchain `v4.31.0-rc1`, mathlib pin `d568c8c` (see `lean-toolchain`, `lake-manifest.json`). The rc toolchain is the one this mathlib pin builds against; both are pinned together for reproducibility.

```
lake exe cache get
lake build                            # primary: Thm7Prime (Master + Fidelity + Classification) and Gap
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

The kernel reports the axiom footprint of `thm7prime` as exactly `[propext, Classical.choice, Quot.sound]` — no custom axioms, no `sorry`. The auxiliary declaration `rank_E576i2` (the single disclosed axiom: rank 1 of 576i2, unconditional 2-descent, two-system: `scripts/magma/wp1_rank576i2.m` sha256 `9cdcbfeb31b4e886e6922b7efc271c9a8b14f7d92fde0416c1b667273862cca6`, cross-checked in Sage) is retained deliberately as a trace of the earlier conditional architecture. Exactly two declarations depend on it — `rankOneE_holds` and the superseded wrapper `thm7prime_of_forward` — and the per-declaration axiom report shows that neither the main theorem `thm7prime` nor the forward direction `thm7_forward` does: both are rank-free polynomial arguments closing on the three standard axioms. The kernel's per-declaration report thus records not only the final state of the proof but its history; the axiom's elimination from the main line is itself machine-readable. The in-file status comments in `Thm7Prime/Master.lean` were aligned with the completed state on 2026-08-02 under an adjudicated amendment of the file's freeze (docstrings and comments only; no statement, proof, or axiom changed — see `TRANSFER_MANIFEST.md`); the per-declaration axiom report remains the authoritative record: `thm7_forward` and `thm7prime` close on the standard three axioms.

**Statement form.** `RD211` is the division-free *gate form* of rational-derivedness (design choice: verification-friendly restatement). The kernel contains the quartic itself (`quartic211`, with `quartic211_expand`), the identification of the two gates as the derivative discriminants (`gate1_is_disc`, `gate2_is_disc`), and the explicit rational splittings of both derivatives under the gates (`dq1_splits`, `dq2_splits`). Both links between the gate form and the natural `Polynomial.Splits` form are closed in the kernel in `Thm7Prime/Fidelity.lean`: the `Polynomial.derivative`s of the quartic are computed in the kernel (`derivative_Q`, `derivative2_Q`, with evaluation anchors to `dq1`, `dq2`), and the equivalence `rd211_iff_natural` — `RD211 a ↔ a ≠ 0 ∧ a ≠ 1 ∧ NaturalRD a` — holds with the standard three axioms in both directions (converse via `disc_sq_of_quadratic_splits`). The design-time CAS cross-check (`scripts/sage/wp1_fidelity.sage`, sha256 `21a77e63cdd56f4c10d5fb9e94e95a4dd00bf5fa0853aae4c0a089fe7a72f503`) remains as the independent leg. The frozen theorem statement is the gate form.

**Result hierarchy.** (1) `thm7prime` — the parametric image characterisation on the normalised family (`Thm7Prime/Master.lean`); (2) `rd211_iff_natural` — statement fidelity of the gate form (`Thm7Prime/Fidelity.lean`); (3) `classification_by_curve` — the global affine classification of split (2,1,1) quartics by affine rational points of 576i2 (`Thm7Prime/Classification.lean`): the theorem corresponding to the repository title.

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
| Affine classification of split (2,1,1) quartics | `classification` | `Thm7Prime/Classification.lean` |
| Classification by rational points of 576i2 | `classification_by_curve` | `Thm7Prime/Classification.lean` |
| Specialisation principle and square descent in ℚ[a][b] | `sq_eval_nonneg`, `square_descent` | `Gap/BMThm7FunctionField.lean` |
| Eight non-squareness verdicts in ℚ(a,b) | `Q4_not_square` … `n2Q4RqSq_not_square` | `Gap/BMThm7FunctionField.lean` |
| Biquadratic square-class transfer | `biquadratic_transfer` | `Gap/BMThm7SquareClass.lean` |
| Q₄, −2Q₄ non-square in the multiquadratic extension | `Q4_not_square_multiquadratic`, `n2Q4_not_square_multiquadratic` | `Gap/BMThm7SquareClass.lean` |
| Rₔ, Sₔ, RₔSₔ non-square in ℚ(a,b) (splitting-cover integrality) | `Rq_not_square`, `Sq_not_square`, `RqSq_not_square` | `Gap/BMThm7NormCriterion.lean` |
| Layer quadratic step and coordinate norm passage | `step_over_layer`, `layer_square_norm` | `Gap/BMThm7NormCriterion.lean` |
| C±-exclusion in the layer (γ± not a square) | `gamma_not_square_multiquadratic` | `Gap/BMThm7NormCriterion.lean` |
| Normalization bridge: Conjecture 1 ⇔ no nondegenerate terrain point | `conjecture1_iff_terrain` (+ transport lemmas) | `Gap/BMThm7Terrain.lean` |
| Fibre correspondence: the three disjuncts ⇔ the three cover fibres (radicand derivation D± ⇔ γ±; chart cover ⇔ cleared model) | `fibre_correspondence`, `Dplus_iff`, `Dminus_iff`, `cleared_model_iff` | `Gap/BMThm7Fibre.lean` |

### Line-pinned references (v1.0.2)

- [`Thm7Statement.thm7prime`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Thm7Prime/Master.lean#L619)
- [`Thm7Fidelity.rd211_iff_natural`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Thm7Prime/Fidelity.lean#L173)
- [`Thm7Classification.classification_by_curve`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Thm7Prime/Classification.lean#L188)
- [`BMThm7FunctionField.Q4_not_square`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Gap/BMThm7FunctionField.lean#L134)
- [`BMThm7SquareClass.Q4_not_square_multiquadratic`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Gap/BMThm7SquareClass.lean#L293)
- [`BMThm7NormCriterion.gamma_not_square_multiquadratic`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Gap/BMThm7NormCriterion.lean#L272)
- [`BMThm7NormCriterion.RqSq_not_square`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Gap/BMThm7NormCriterion.lean#L76)
- [`BMThm7Terrain.conjecture1_iff_terrain`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Gap/BMThm7Terrain.lean#L394)
- [`BMThm7Fibre.fibre_correspondence`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Gap/BMThm7Fibre.lean#L293)
- [`BMThm7Transcript.not_T9_bridge_Q`](https://github.com/hirokifukui/rd-quartics-classification/blob/v1.0.2/Gap/BMThm7Transcript.lean#L489)

## Lineage

This repository merges and supersedes, for the purposes of the merged paper, two earlier per-paper repositories, both preserved with their own DOIs:

- `rational-derived-audit` — the audit and gap note. Zenodo: 10.5281/zenodo.21465598 (v1.2.0).
- `rd-quartics-thm7prime` — the repair paper. Zenodo: 10.5281/zenodo.21470001. This repository is seeded from it (git history preserved).

`archive/` preserves the pre-merge sources with their manifests for provenance; it is not part of the current build (`lake build` compiles the `Thm7Prime` and `Gap` libraries only).

## License / Citation

See `LICENSE` and `CITATION.cff`.
