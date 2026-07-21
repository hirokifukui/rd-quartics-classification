# rd-quartics-thm7prime

Lean 4 formalization of **Theorem 7′**: an unconditional, machine-verified
repair of the classification of rational-derived quartics with a repeated
root (Theorem 7 of Buchholz–MacDougall, *J. Number Theory* **81** (2000),
210–233).

**Main statement.** For the normalized family `x²(x−1)(x−a)`, the
rational-derived parameters `a ∉ {0,1}` are exactly the values of the
Buchholz–MacDougall a-map on the rational points of the elliptic curve
`E : z² = w(w−6)(w+18)` (Cremona 576i2), away from an explicit degenerate
locus. Both directions are proved by explicit polynomial identities; no
rank computation enters.

```
theorem Thm7Statement.thm7prime : Thm7Prime
-- axioms: [propext, Classical.choice, Quot.sound]
```

## Verify it yourself (~30 minutes)

1. Install [elan](https://leanprover-community.github.io/get_started.html).
2. ```
   git clone https://github.com/hirokifukui/rd-quartics-thm7prime
   cd rd-quartics-thm7prime
   lake exe cache get
   lake build
   ```
3. The build elaborates `Thm7Prime/Master.lean`, whose trailing
   `#print axioms` commands report the footprint of every declaration.
   The main theorem `thm7prime` must report exactly
   `[propext, Classical.choice, Quot.sound]`. Two auxiliary declarations
   (`rankOneE_holds`, `thm7prime_of_forward`) additionally report the
   single disclosed axiom `rank_E576i2` (Mordell–Weil rank of 576i2,
   verified unconditionally in Magma and Sage); they are the retained
   trace of an earlier conditional architecture and are not used by
   `thm7prime`.

Toolchain: `leanprover/lean4:v4.31.0-rc1`, mathlib pinned to
`d568c8c09630de097a046763c17b9ea99f95f950`.

## Layout

- `Thm7Prime/Master.lean` — the complete development (34 declarations),
  MD5 `a1b1d54566481b50bd0ce3667c2ee509`.
- `blueprint/` — leanblueprint sources (natural-language ↔ Lean
  correspondence, dependency graph).
- `scripts/sage/`, `scripts/magma/` — the exact computer-algebra scripts
  used for statement-fidelity gating, certificate extraction (Gröbner
  lifts), and cross-system verification; `scripts/wp3_stage3_certs.txt`
  is the raw Sage lift output (the certificates are reproduced verbatim
  inside the Lean source, where the kernel checks them).
- `archive/` — the three session files from which `Master.lean` was
  assembled by verbatim concatenation, with their MANIFESTs (provenance;
  not built — they share declaration names with the master).

## Related

- Companion note (the gap report): H. Fukui, *A proof gap in the claimed
  classification of rational-derived quartics, two rank corrections, and
  a common elliptic curve*, submitted to J. Number Theory (2026).
  Artifacts: <https://doi.org/10.5281/zenodo.21465598>.
- The accompanying paper for this repository is submitted to
  *Research in Number Theory*.

## License

Apache License 2.0. See `LICENSE`.
