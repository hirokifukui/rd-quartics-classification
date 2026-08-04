# guy_multiples.sage -- Theorem "One curve through the family" part (c):
# a(nP) for n=2..5 on 576i2, gate verification, and identification with
# the four pairs printed in Guy, Amer. Math. Monthly 96 (1989).
# Staged 2026-08-03 (paper_afm); to enter scripts/rank/ at the release
# accompanying the AFM manuscript. Captured log alongside.
E = EllipticCurve([0,12,0,-108,0])     # 576i2: z^2 = w^3+12w^2-108w
P = E(-12,36)
def amap(Q):
    w,z = Q[0],Q[1]
    den = (z-w-18)*(8*w+z)
    if den == 0: return None
    return 9*(2*w+z-12)*(w+2)/den
def gates(a):
    return (9*a^2-14*a+9).is_square(), (9*a^2-6*a+9).is_square()
print("[torsion]", E.torsion_subgroup().invariants())
vals = {}
for n in range(2,6):
    a = amap(n*P); vals[n] = a
    g1,g2 = gates(a)
    print("[a(%dP)] = %s   gates: G1=%s G2=%s" % (n,a,g1,g2))
guy = [(308,360), (668668,1990440), (-277132848044,514660109040),
       (16695809521921862640, 28041466545675190604)]
for i,(p,q) in enumerate(guy, start=2):
    a = QQ(q)/QQ(p)
    which = "direct" if a == vals[i] else ("reciprocal" if a == 1/vals[i] else "NO")
    print("[Guy pair %d (%s,%s)] a=%s  vs a(%dP): %s" % (i-1,p,q,a,i,which))
R.<x> = QQ[]
klam = (x-193)*(x-141)*(x+167)^2
tr = klam.subs(x=x-167)
print("[Klamkin shift -167]", tr.factor(), "| equals x^2(x-308)(x-360):", tr == x^2*(x-308)*(x-360))
print("[Guy pair 2 = 4*(167167,497610)]", (QQ(668668)/4, QQ(1990440)/4))
