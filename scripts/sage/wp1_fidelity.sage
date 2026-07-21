# WP1 statement-fidelity gate (2026-07-21, thm7_repair)
# 1. Gates vs derivative discriminants of q = x^2(x-1)(x-a)
T.<aa,xx> = QQ[]
qq = xx^2*(xx-1)*(xx-aa)
d1 = qq.derivative(xx)
d2 = d1.derivative(xx)
quadfac = 4*xx^2 - 3*(1+aa)*xx + 2*aa
print("q' = x*quadfac ?", (d1 - xx*quadfac).is_zero())
disc1 = (3*(1+aa))^2 - 4*4*(2*aa)
print("disc(quadfac) == 9a^2-14a+9 ?", disc1 == 9*aa^2-14*aa+9)
print("q'' form ok:", (d2 - (12*xx^2 - 6*(1+aa)*xx + 2*aa)).is_zero())
disc2 = (6*(1+aa))^2 - 4*12*(2*aa)
print("disc(q'') == 4*(9a^2-6a+9) ?", disc2 == 4*(9*aa^2-6*aa+9))

# 2. Curve E: z^2 = w^3 + 12w^2 - 108w
E = EllipticCurve([0,12,0,-108,0])
print("E label:", E.cremona_label(), " conductor:", E.conductor())
print("E rank_bounds (2-descent):", E.rank_bounds())
print("E rank():", E.rank())
print("E analytic rank:", E.analytic_rank())
print("E torsion:", E.torsion_subgroup().invariants())
print("E gens:", E.gens())
EA = EllipticCurve([0,-42,0,-288,0])
print("E_A (BK) label:", EA.cremona_label(), " rank_bounds:", EA.rank_bounds(), " torsion:", EA.torsion_subgroup().invariants())
print("isogenous E~E_A ?", E.is_isogenous(EA))
print("2-isogeny codomains of E:", [phi.codomain().minimal_model().cremona_label() for phi in E.isogenies_prime_degree(2)])

# 3. a-map fidelity on points of E
def amap(P):
    w,z = P[0],P[1]
    num = 9*(2*w+z-12)*(w+2)
    den = (z-w-18)*(8*w+z)
    if den == 0: return None
    return num/den
def denred(P):
    w,z = P[0],P[1]
    return (7*w-18)*z + (w^3+4*w^2-252*w)
G = E.gens()[0]
print("gen G:", G)
tors = [t.element() for t in E.torsion_subgroup()]
pts = []
for n in range(-3,4):
    for t in tors:
        P = n*G + t
        if P.is_zero(): continue
        pts.append(P)
ok = True
vals = set()
den0 = []
for P in pts:
    w,z = P[0],P[1]
    if (z-w-18)*(8*w+z) != denred(P):
        ok=False; print("D_reduce FAIL", P)
    aP = amap(P)
    if aP is None:
        den0.append(P); continue
    g1 = 9*aP^2-14*aP+9; g2 = 9*aP^2-6*aP+9
    if not (g1.is_square() and g2.is_square()):
        ok=False; print("GATE FAIL", P, aP)
    vals.add(aP)
print("all sampled points pass D_reduce + gates:", ok)
print("den=0 points:", den0)
print("contains a=0?", QQ(0) in vals, " a=90/77?", QQ(90)/77 in vals, " a=1?", QQ(1) in vals)
print("a=1 preimages in sample:", [P for P in pts if amap(P)==QQ(1)])
P0 = E(-12,36)
print("anchor P0=(-12,36) on E, a(P0) =", amap(P0))
# side factors hM at sample points: w(w+18)(w^2-63w+486)
hm0 = [P for P in pts if P[0]*(P[0]+18)*(P[0]^2-63*P[0]+486) == 0]
print("hM=0 points in sample:", hm0)
