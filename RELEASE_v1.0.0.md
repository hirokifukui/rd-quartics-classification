# v1.0.0 — freeze of the reviewed state (2026-08-02)

This release freezes the repository at the close of its external review process
(ten AI review rounds, 2026-08-01 to 2026-08-02; final assessment 100/100, all
responses and corrections recorded in `TRANSFER_MANIFEST.md`).

## What this repository establishes

Buchholz–MacDougall (*J. Number Theory* 81 (2000) 210–233) state as Theorem 7 the
classification of rational-derived quartics with a repeated root. This repository
contains: (1) a human-audited formal transcription of the printed proof, with
kernel certificates that the transcribed assumption is circular and a
counterexample to the reconstructed bridge claim; (2) an unconditional repair —
Theorem 7′ — proved rank-free by polynomial certificates; (3) the classification
restated through rational points of the elliptic curve 576i2; and (4) the
boundary analysis: the open statement is Conjecture 1, and the kernel theorem
`conjecture1_iff_terrain` identifies it exactly with the nonexistence of
nondegenerate rational points on the splitting terrain, whose three covers are
obstructed in the kernel through two square classes.

## Kernel-verified core

Toolchain `leanprover/lean4:v4.31.0-rc1`, mathlib pinned at `d568c8c`,
`checkdecls` rev-pinned; 128 blueprint declarations checked; no `sorry`. Every
listed file prints per-declaration axiom reports asserted by CI; the load-bearing
theorems close on exactly `[propext, Classical.choice, Quot.sound]`:

- `Thm7Statement.thm7prime` — Theorem 7′, the unconditional repair
- `Thm7Fidelity.rd211_iff_natural` — the gate form is the natural statement
- `Thm7Classification.classification_by_curve` — classification via 576i2(ℚ)
- `BMThm7FunctionField.covers_nonsquare` (eight exclusions in ℚ(a,b)),
  `BMThm7SquareClass.Q4_not_square_multiquadratic` / `n2Q4_…`,
  `BMThm7NormCriterion.gamma_not_square_multiquadratic` (the C± covers, both
  signs, layer step + coordinate norm), `Rq/Sq/RqSq_not_square` (integrality of
  the splitting cover, ℚ-level)
- `BMThm7Terrain.conjecture1_iff_terrain` — the normalization bridge

The single disclosed axiom `rank_E576i2` (rank of 576i2, unconditional
2-descent, two-system) is off the main line; the per-declaration reports prove
the main theorems do not depend on it.

## Computational evidence and its audit

Every Chapter-4 computational claim has a public script, a captured log, and a
SHA-256 entry with an honest status in `scripts/CERTIFICATES.md` (claim map
included). Two systems throughout:

- **Magma V2.29-7** (Linux; invocation `cd ~/magma && ./magma -b jobs/<script>.m`):
  original terrain scripts of 2026-07-16 and the fresh `terrain_class12.m` of
  2026-08-02; file hashes in `scripts/CERTIFICATES.md`, execution channel
  recorded in each captured log header.
- **SageMath 10.8** (macOS, 2026-08-02): `terrain_crosscheck.sage`, all checks
  pass; and **on every push**, CI re-executes this script inside the pinned
  container `sagemath/sagemath:10.9` and diffs the normalized output against the
  stored log (`.github/workflows/cas.yml`) — a cross-version, cross-platform
  reproduction, not a hash comparison.

## Provenance and method

Statements were designed and frozen before any proof search; tactic-level proof
filling was delegated to headless jobs; every delegation was independently
audited against the frozen statement layer, with the kernel re-run directly
(`kernel_audit/`). The division of labour and responsibility is declared in
`AI_PROVENANCE.md`; the public provenance chain for the source audit is
`Gap/PROVENANCE.md`; every adjudicated change is in `TRANSFER_MANIFEST.md`.
Blueprint (with the dependency graph and the [K]/[C]/[M]/[A] claim labels):
https://hirokifukui.github.io/rd-quartics-classification/blueprint/

## Reproduction

```
lake build                                  # 8500+ jobs
lake exe checkdecls blueprint/lean_decls    # 128/128
lake env lean Thm7Prime/Master.lean         # per-declaration axiom reports
sage scripts/terrain/terrain_crosscheck.sage
```

## Known boundaries

Conjecture 1 itself remains open — this repository maps its boundary, it does
not resolve it. Claims labelled [M] (ordinary mathematics) and [C] (computer
algebra) in blueprint Chapter 4 are exactly as labelled; nothing unlabelled
carries evidential weight. A Zenodo DOI and a compiled blueprint PDF will be
attached post-release once archival is enabled.
