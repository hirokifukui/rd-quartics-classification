# CERTIFICATES.md - certificate and script provenance

CAS systems: Magma V2.29-7 (A9, Linux) and Sage 10.8 (macOS).  "Two-system" below
means both systems verified the same rigorous statement; rows whose Status column
says otherwise (analytic evidence, partial runs, single-system) are so labelled and
are NOT covered by that phrase.  Every polynomial cofactor consumed by a
`linear_combination` in the Lean source is reproduced verbatim in that source and
checked by the kernel - the kernel check, not the CAS transcript, is the standing
guarantee.  SHA-256 is authoritative; md5 retained for continuity.

## Consumers -> artifacts

- **Forward direction certificates** (`curve_cleared`, `aden_cleared`, `adP6_cover`,
  `forward_core` cofactors; reconstruction data): `scripts/sage/wp3_stage2.sage` /
  `wp3_stage3.sage`, raw store `scripts/wp3_stage3_certs.txt`; inversion
  cross-checked by `scripts/magma/wp3_invert.m` + `scripts/sage/wp3_invert_verify.sage`.
  Two-system, rigorous.
- **Cleared gate identities**: cofactors verbatim in `Thm7Prime/Master.lean`,
  kernel-checked; reproducible from the stated gate relations in any Groebner engine.
- **Disclosed axiom** `rank_E576i2` (off the main line, historical route only):
  Magma leg `scripts/magma/wp1_rank576i2.m` (unconditional 2-descent); Sage leg =
  `scripts/rank/rank_tables.log` line 1 (`PASS rk[E/Q]=1`, rigorous) and
  `scripts/rank/m33.log` line 1 (same curve, rank 1 rigorous).  Two-system, rigorous.
- **Statement-fidelity gate**: `scripts/sage/wp1_fidelity.sage`; kernel counterpart
  `Thm7Prime/Fidelity.lean`.
- **Chapter-3 [MC] cross-checks**: `scripts/sage/wp4_mc.sage`.
- **Chapter-4 terrain** (all [C] claims): original Magma session scripts and captured
  logs under `scripts/terrain/` (session 2026-07-16c, provenance `Gap/PROVENANCE.md`),
  independently re-verified 2026-08-02 by `scripts/terrain/terrain_crosscheck.sage`
  (fresh Sage 10.8, captured log).  Two-system: original Magma + fresh Sage.
- **Rank audit of BM Tables 4/5** (`scripts/rank/`): single-system Sage audit of the
  source paper's tables; NOT load-bearing (the main line is rank-free); per-file
  Status below.

## Chapter-4 claim map

| claim | script | log | status |
|---|---|---|---|
| I1, I2 (funnel identities) | terrain_crosscheck.sage; bm_thm7_Q4_terrain.m | terrain_crosscheck.captured.log; bm_thm7_Q4_terrain.log | two-system; also kernel (BMThm7Boundary) |
| Q4 = F1 F2 F3, squarefree, Fi irreducible | same | same | two-system |
| each Fi genus 0, rational parametrisation | terrain_crosscheck.sage; bm_thm7_Q4_genus.m | terrain_crosscheck.captured.log; bm_thm7_Q4_genus.log | two-system |
| S meet {Q4=0}: six components, dim 1 | bm_thm7_Q4_terrain.m | bm_thm7_Q4_terrain.log | Magma (primary decomposition); component count also forced by genus-log split 3x2 |
| Rq square on each component | terrain_crosscheck.sage; bm_thm7_Q4_genus.m | logs as above | two-system |
| Sq square class 12 on each component | terrain_crosscheck.sage; terrain_class12.m | captured logs of both | two-system (both scripts public) |
| no admissible rational points (all Sq-zeros degenerate) | terrain_crosscheck.sage; terrain_class12.m | captured logs of both | two-system (both scripts public); invariant form (den=0 / pole; F1: none) |
| S-integrality: Rq, Sq, RqSq nonsquare (odd-factor counts 1/1/2; value witnesses 2480/876/171696) | terrain_crosscheck.sage; terrain_class12.m | captured logs of both | two-system; Q-level also kernel (BMThm7NormCriterion) |
| Radicand derivation: disjunct at x0=(3s1+-rho)/8 <-> gamma_+- square (critical-point, (X-x0)^2-factorization, disc = s1(s1-+rho)/4, den^2-clearing) | terrain_crosscheck.sage | terrain_crosscheck.captured.log | symbolic identities over QQ[s1,s2,rho] mod (rho^2-(9s1^2-32s2)); kernel version = BMThm7Fibre (in progress at this row's writing, see repo) |
| gcd(Fi, Rq Sq) = 1 (geom.-integrality input) | terrain_crosscheck.sage; terrain_class12.m | captured logs of both | two-system |
| eight non-squares in Q(a,b) | terrain_crosscheck.sage; bm_thm7_Q4_terrain.m | logs as above | two-system; kernel-superseded (BMThm7FunctionField) |

## File hashes and status

| file | sha256 | md5 (legacy) | status |
|---|---|---|---|
| `scripts/magma/wp1_rank576i2.m` | `9cdcbfeb31b4e886e6922b7efc271c9a8b14f7d92fde0416c1b667273862cca6` | `0bf3fb70e86f0832c73fffb1980ebd68` | rigorous input script (Magma leg of rank_E576i2: unconditional 2-descent, RankBounds) |
| `scripts/magma/wp3_invert.m` | `d94b17871ee48e8ddf71365473c0641ede5b3fa4d5b75fcb719e9c55aacd45e4` | `0f6f0d78a4e7c29a6ab098e4fb5aa671` | rigorous input script (Magma leg of the inversion cross-check) |
| `scripts/rank/m33.log` | `d19ced5209a2f5146a9bcd041f14bf6d7d40bce7086c528db1118cbc6e3f3fa4` | `4e35f1f4773d18ae5312aae357b092d5` | mixed: E and E_33 ranks rigorous (bounds (1,1), generators); documents the correction of BM Table 5 at m=33 |
| `scripts/rank/m33.sage` | `dcf7cf602873d5a7ae1c154d778e81121412ebdfe02dde567f464994dac32851` | `d12cade47c0cd179e68201edd3f23adc` | rigorous input script (single-system Sage audit of BM Table 5, m=33) |
| `scripts/rank/rank_tables.log` | `f1fe815e28901105f60a6ead9cad53d1b98fd5d87b994dd00a3a4621276d18a2` | `bc3acf2a880be98b4bfd8b309cf9b443` | partial: rigorous for the seven twists shown; run aborts at an unresolved Sha[2] ambiguity (traceback preserved). Line 1 'PASS rk[E/Q]=1' is the rigorous Sage leg for rank_E576i2 |
| `scripts/rank/rank_tables.sage` | `379abb97b344d0d5ca1f8065cd291402f47a80d46d3777a0616470aaccb12c64` | `73aeebae85ebdf439dae3d0de6a52e74` | rigorous input script (run partial; see log) |
| `scripts/rank/rank_unruly.log` | `23c5e9d2cd300ddb35d9d11efa7a99e41f487277afb5964fb365dcaa105d9fbe` | `8d954eedbdb48338f300a33d5823c57d` | mixed: m=73 rigorous; m=-67,-163,57 analytic evidence only (BSD-type nondegeneracy), stated in the log |
| `scripts/rank/rank_unruly.sage` | `d36d75a7f62d147236a65c35e921490ab7d4aae36064a9df58cc47c16c981ef3` | `30ae740b5edbb0580c11d8753eb712d0` | rigorous input script (outputs mixed; see log) |
| `scripts/rank/s16_rank1.sage` | `0663165c87a5e8ace65021fb39d33f0ff5bb7f5f5c9b1299f016c47262d1975e` | `d31a9c6e05617995fae2bce1ecf6fc42` | rigorous input script |
| `scripts/rank/s17_rankbounds.sage` | `b6374322394fe12ff7ea3e71c016cf49d9ac214070adfc4cc617da62f4318bee` | `9392ea993c4399599ab7b64d1bdb8fb0` | rigorous input script |
| `scripts/rank/s21_ex41rank.sage` | `ea83b08d3b2f75a8f41670a065f127ff98e5d89b4bfd38515b546ed10d1a4560` | `7ffbb895fb55b4c5c2ec8232ce4ae479` | rigorous input script |
| `scripts/rank/s23_anrank.sage` | `12a675dd3dfdac3091779dafffe9268dd40998eb8482eff46bb815435ecf8b23` | `f814995c3973715ee06b378677fdeef0` | rigorous input script |
| `scripts/sage/wp1_fidelity.sage` | `21a77e63cdd56f4c10d5fb9e94e95a4dd00bf5fa0853aae4c0a089fe7a72f503` | `5cbcc1b4c4a70acd58e8e967c873852f` | rigorous verification script (statement-fidelity gate; kernel counterpart Fidelity.lean) |
| `scripts/sage/wp3_invert_verify.sage` | `14d104afbc6c02884908b4eb4f7e20ad13a798089ecdb1a18a6d0789058c43fa` | `886c0fca56999a833e16d21b65ed3540` | rigorous verification script (Sage leg of the inversion cross-check) |
| `scripts/sage/wp3_stage2.sage` | `17b4bd36b2c47cc6867d93f9b768536d1af38f4a97b92047d3ac60b0b1d51b3d` | `873de193ed8fdb1d0b2f66ab4cb52f5c` | rigorous input script (forward certificates, Sage leg) |
| `scripts/sage/wp3_stage3.sage` | `c9ba09a1174a20f0914d58533fef34709130b20c77373acded6c182a2204aa7a` | `64d009a1bd766c0d6f59cb37cc091531` | rigorous input script (forward certificates, Sage leg) |
| `scripts/sage/wp4_mc.sage` | `e74701073010efa9846033f779abd5138865599b4a8f357d92fdd1e2b3ddb94d` | `421b7f518a2357a2e5b6b714b0292de6` | rigorous verification script (Ch.3 [MC] cross-checks: aMap preimages, elimination, gate values; NOT the Ch.4 terrain) |
| `scripts/terrain/bm223_transcheck.captured.log` | `90481d5d17ade27125b89b9e51c291db6cc50204b0916f2d6cab73d6ace805fa` | `649f3ad751b3e75109f7c07d768d1ffa` | rigorous unconditional (exact identities; Magma) |
| `scripts/terrain/bm223_transcheck.m` | `97203ff27b6e692dde01dcd793fe0abf81eb82864a79f0e999dea42c05956698` | `13dee9e2cad5669325748ee93ccfc93c` | rigorous input script (transcription gate, Magma leg, session 2026-07-16c) |
| `scripts/terrain/bm223_transcheck_sage.captured.log` | `3558d48863e4b338ae7f3300c1c04781c6c43540a05ee37f3a7bc4b0e78e72d8` | `72da519ad2a41f948a5db028cdaf4689` | rigorous unconditional (exact identities; Sage leg of the transcription gate) |
| `scripts/terrain/bm_thm7_Q4_genus.log` | `c9ba84389bf523657c24091e75ddafe94d2646089be044facbe16a0978772282` | `9182e11ff40f9777a2229737b423779e` | rigorous unconditional (genus 0 x3; Rq square / Sq not, 2 components each) |
| `scripts/terrain/bm_thm7_Q4_genus.m` | `a9e0f4bb73a98a35223e99fdc0598e5706e48e802cc7efb274f95f713256b39c` | `17967f011245f17a89947e828cf92b0c` | rigorous input script (per-factor irreducibility, genus, Rq/Sq square tests on components; Magma) |
| `scripts/terrain/bm_thm7_Q4_terrain.log` | `3632d44d9d2b94ef8fbd0902b8fc8442e093e2ab84e1465cf8edd7236c9bc216` | `5582c6756784691577ce99bb1c6205e6` | rigorous unconditional (exact polynomial computations; six components dim 1) |
| `scripts/terrain/bm_thm7_Q4_terrain.m` | `538fc59ff4fda590f16d9959999a229d3119dff356635417a307dd112ef8047f` | `f958663173d1396524dd15917ab117b4` | rigorous input script (Q4 identities, factorization, eight square tests, primary decomposition; Magma, session 2026-07-16c) |
| `scripts/terrain/bm_thm7_sixconics2.captured.log` | `a18225e7b29227027247e75fe14567fb5272186b20c4a8086c2abf05a3ae63d2` | `02f2bd3e0b11a59b5e6f6edb0b969716` | preserved transcript only: the generating Magma source was not retained (session 2026-07-16c). Its claims are established two-system by terrain_class12.m + terrain_crosscheck.sage below; this file is historical corroboration, not a reproducibility artifact |
| `scripts/terrain/terrain_class12.captured.log` | `78714eda8ba963a672375cf4f5d5308ba22e6a156fcac1293b8ec0a3548cc9c5` | `2994df5b4667b99a90aff1ce62fc159d` | rigorous unconditional (all checks; agrees with the Sage leg line-by-line) |
| `scripts/terrain/terrain_class12.m` | `06e5047a210adf810ea403f604fdfc18f665124920c33d3b178baf735df15280` | `61b8b85c71bee97c67065a7b1a6e0626` | rigorous input script (fresh Magma leg 2026-08-02, V2.29-7 on A9: class 12, admissibility, S-integrality inputs, value witnesses; replaces the unpreserved sixconics2 source) |
| `scripts/terrain/terrain_crosscheck.captured.log` | `eccfaa7e0eda57abc038458da815d629c2c148aeb05f14b6c1e87dfe2a19e662` | `de81ef91e12fc023987099b3548440a8` | rigorous unconditional (43 CHECK lines, all True; zero False anywhere) |
| `scripts/terrain/terrain_crosscheck.sage` | `8ce36948831ce8ee840c6fe29c9ad4ccfb6b02c9239e90cd72bcf434646fa8dc` | `232d5dec59bbf19b26b1adcc27a93bd1` | rigorous verification script (Sage 10.8, extended 2026-08-02 review-12: adds the radicand derivation D0/D+-/gamma_+- -- critical-point, factorization, discriminant and clearing identities, symbolic over QQ[s1,s2,rho]/(rho^2-(9s1^2-32s2)); witness lines True-normalized) |
| `scripts/wp3_stage3_certs.txt` | `eda247f0f2d660570e8c7d88a182b03a4b56a85fe95cb0f62e768d6aa94b9904` | `8eebdcf498b04560796afa5a6609995b` | rigorous certificate store (cofactors reproduced verbatim in the Lean source and kernel-checked) |
