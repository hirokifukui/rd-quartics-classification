E = EllipticCurve(QQ,[0,12,0,-108,0])
print("E =",E,"  rk[E/Q]=",E.rank())
Et=E.quadratic_twist(33)
print("\nE_33 (twist by 33):", Et)
print("  minimal model:", Et.minimal_model())
print("  rank (rigorous):", Et.rank())
print("  rank_bounds:", Et.rank_bounds())
print("  analytic_rank:", Et.analytic_rank())
print("  gens:", Et.gens())
print("  torsion:", Et.torsion_subgroup().invariants())
# independence: verify gen is non-torsion, infinite order
for G in Et.gens():
    print("   gen order:", G.order(), " height:", G.height())

# Direct: rank of E over K=Q(sqrt33)
print("\nDirect over K=Q(sqrt33):")
K.<s>=QuadraticField(33)
EK=E.change_ring(K)
try:
    print("  EK.rank() =", EK.rank())
except Exception as ex:
    print("  EK.rank() unavailable:", ex)
try:
    print("  EK.gens() =", EK.gens())
except Exception as ex:
    print("  EK.gens() err:", ex)
# analytic over K not directly; use twist decomposition
print("\nBirch decomposition: rk[E/K] = rk[E/Q] + rk[E_33/Q] =", E.rank(),"+",Et.rank(),"=",E.rank()+Et.rank())
print("BM Table 5 records rk[E/Q(sqrt33)] = 1")
