# WP4 [MC] + isogeny cross-check (2026-07-21, thm7_repair session3)
E = EllipticCurve([0,12,0,-108,0])     # 576i2
EA = EllipticCurve([0,-42,0,-288,0])   # 576i3 (BK E_A: Y^2 = X(X-48)(X+6))

def amap(P):
    w,z = P[0],P[1]
    den = (z-w-18)*(8*w+z)
    if den == 0: return None
    return 9*(2*w+z-12)*(w+2)/den

# ---- WP4-1: preimages of a=0 and a=1 in a generous point range ----
G = E.gens()[0]
tors = [t.element() for t in E.torsion_subgroup()]
pts = []
for n in range(-8,9):
    for t in tors:
        P = n*G + t
        if not P.is_zero(): pts.append(P)
pre0 = [P for P in pts if amap(P) == 0]
pre1 = [P for P in pts if amap(P) == 1]
print("[1] a=0 preimages (|n|<=8):", pre0)
print("[2] a=1 preimages (|n|<=8):", pre1)

# ---- WP4-2: exact divisor computation for aMap = 1 ----
# aNum - aDen = 0 on E: solve the system exactly.
Rz.<w,z> = QQ[]
hE = z^2 - (w^3 + 12*w^2 - 108*w)
diff1 = 9*(2*w+z-12)*(w+2) - ((7*w-18)*z + (w^3+4*w^2-252*w))
Jd = Rz.ideal([hE, diff1])
print("[3] aMap=1 locus dimension:", Jd.dimension())
elw = Jd.elimination_ideal([z])
print("[4] aMap=1 eliminant in w, factored:", [factor(g) for g in elw.gens()])
# rational w-roots -> check rational z
for g in elw.gens():
    for root, mult in g.univariate_polynomial().roots(QQ) if g.degree() > 0 else []:
        rhs = root^3 + 12*root^2 - 108*root
        print("    w =", root, " z^2 =", rhs, " rational z:", rhs.is_square())

# ---- WP4-3: a=0 exact divisor (aNum = 0 on E) ----
num0 = 9*(2*w+z-12)*(w+2)
J0 = Rz.ideal([hE, num0])
el0 = J0.elimination_ideal([z])
print("[5] aNum=0 eliminant in w, factored:", [factor(g) for g in el0.gens()])
for g in el0.gens():
    for root, mult in g.univariate_polynomial().roots(QQ) if g.degree() > 0 else []:
        rhs = root^3 + 12*root^2 - 108*root
        if rhs.is_square():
            for zz in ([rhs.sqrt(), -rhs.sqrt()] if rhs != 0 else [QQ(0)]):
                P = E(root, zz)
                print("    point", P, " aMap =", amap(P))

# ---- WP4-4: gates at a=0 and a=1 (statement-level record) ----
for aa in [QQ(0), QQ(1)]:
    g1 = 9*aa^2-14*aa+9; g2 = 9*aa^2-6*aa+9
    print("[6] a =", aa, ": g1 =", g1, "square:", g1.is_square(), "; g2 =", g2, "square:", g2.is_square())

# ---- isogeny cross-check: Magma's map w |-> (w^2+12w+36)/(w-6) ----
# kernel {O,(6,0)}; verify it is the degree-2 isogeny E -> EA.
K6 = E(6, 0)
phi = E.isogeny(K6)
Ecod = phi.codomain()
print("[7] Sage isogeny codomain:", Ecod.ainvs(), " label:", Ecod.minimal_model().cremona_label())
iso = Ecod.isomorphism_to(EA) if Ecod.is_isomorphic(EA) else None
print("[8] codomain isomorphic to EA(576i3):", iso is not None)
# check x-coordinate map matches Magma's formula (up to the post-isomorphism)
ok = True
for n in range(1,7):
    P = n*G
    if P.is_zero() or P[0] == 6: continue
    xm = (P[0]^2 + 12*P[0] + 36)/(P[0] - 6)
    Q = phi(P)
    Q2 = iso(Q)
    if Q2[0] != xm:
        ok = False
        print("    mismatch at n =", n, ": magma-x =", xm, " sage-x =", Q2[0])
print("[9] Magma x-formula == Sage isogeny (post-iso), n=1..6:", ok)
print("[10] kernel check: phi(E(6,0)) is zero:", phi(K6).is_zero(), "; degree:", phi.degree())
print("DONE")
