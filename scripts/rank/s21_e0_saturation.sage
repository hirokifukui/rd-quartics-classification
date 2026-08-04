# s21_e0_saturation.sage -- Theorem "Corrected ranks" (b): E0 rank 1,
# generator, saturation of (-8,36).  Fresh run 2026-08-03 (logos, Sage 10.8);
# to enter scripts/rank/ at the release accompanying the AFM manuscript.
E0 = EllipticCurve([0,0,0,-156,560])
print("[curve]", E0.ainvs(), "conductor", E0.conductor())
print("[rank_bounds]", E0.rank_bounds())
print("[rank rigorous]", E0.rank())
print("[gens]", E0.gens())
print("[torsion]", E0.torsion_subgroup().invariants())
P = E0(-8,36)
sat, index, reg = E0.saturation([P])
print("[saturation of (-8,36)] index =", index, " saturated gens =", sat)
print("[analytic rank]", E0.analytic_rank())
