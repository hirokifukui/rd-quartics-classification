# WP3: verify the inverse map, extract certificates, analyze degenerate loci.
import itertools

R = PolynomialRing(QQ, names=('a','r','s'), order='degrevlex')
a, r, s = R.gens()
hr = r^2 - (9*a^2 - 14*a + 9)
hs = s^2 - (9*a^2 - 6*a + 9)
I = R.ideal([hr, hs])
F = R.fraction_field()

# ---- the candidate inverse map (from Magma GB) ----
Dw = 3*r - 7*s + 12
Nw = 18*(15*a - 6*r - s - 13)
wF = F(Nw)/F(Dw)

# consistency with the GB linear relation
gb_lin = wF*(r - QQ(7)/3*s + 4) + QQ(45)/4*r^2 + 36*r - QQ(45)/4*s^2 + 6*s + 78
print("[1] w-formula matches GB relation (mod I):", I.reduce(gb_lin.numerator()) == 0)

# z from linearity of a*aden - anum in z
Dz_f = a*(7*wF - 18) - 9*(wF + 2)
Nz_f = 9*(2*wF - 12)*(wF + 2) - a*(wF^3 + 4*wF^2 - 252*wF)
zF = Nz_f / Dz_f

# ---- the two core identities ----
curve_id = zF^2 - (wF^3 + 12*wF^2 - 108*wF)
print("[2] OnE(wF,zF) (mod I):", I.reduce(curve_id.numerator()) == 0)

adenv = (7*wF - 18)*zF + (wF^3 + 4*wF^2 - 252*wF)
anumv = 9*(2*wF + zF - 12)*(wF + 2)
amap_id = anumv - a*adenv
print("[3] aMap(wF,zF) = a (mod I):", I.reduce(amap_id.numerator()) == 0)

# ---- structural simplification: what are Dz and aden as functions on C? ----
Dz_num_red = I.reduce(Dz_f.numerator())
print("[4] Dz numerator (mod I), factored:")
print("    ", factor(Dz_num_red) if Dz_num_red != 0 else 0, "  /  den:", factor(Dz_f.denominator()))
aden_num_red = I.reduce(adenv.numerator())
print("[5] aden(wF,zF) numerator (mod I), factored:")
print("    ", factor(aden_num_red) if aden_num_red != 0 else 0, "  /  den:", factor(adenv.denominator()))

# ---- sanity on a concrete RD value: a = 90/77 ----
aa = QQ(90)/77; rr = QQ(171)/77; ss = QQ(291)/77
assert 9*aa^2-14*aa+9 == rr^2 and 9*aa^2-6*aa+9 == ss^2
E = EllipticCurve([0,12,0,-108,0])
def eval_pt(aa, rr, ss):
    dw = 3*rr - 7*ss + 12
    if dw == 0: return None
    ww = 18*(15*aa - 6*rr - ss - 13)/dw
    dz = aa*(7*ww-18) - 9*(ww+2)
    if dz == 0: return None
    zz = (9*(2*ww-12)*(ww+2) - aa*(ww^3+4*ww^2-252*ww))/dz
    return (ww, zz)
for (sr, st) in itertools.product([1,-1],[1,-1]):
    pt = eval_pt(aa, sr*rr, st*ss)
    if pt is None:
        print("[6] combo", sr, st, ": degenerate")
        continue
    ww, zz = pt
    on = (zz^2 == ww^3+12*ww^2-108*ww)
    aden_v = (7*ww-18)*zz + (ww^3+4*ww^2-252*ww)
    am = None if aden_v == 0 else 9*(2*ww+zz-12)*(ww+2)/aden_v
    print("[6] combo", sr, st, ": w,z =", ww, zz, " OnE:", on, " aden!=0:", aden_v != 0, " aMap:", am)

# ---- certificates: lift the cleared identities over (hr, hs) ----
# curve identity cleared: numerator(curve_id) = cr*hr + cs*hs
num_curve = curve_id.numerator()
lift_c = num_curve.lift(I)
print("[7] curve certificate found:", lift_c is not None and (lift_c[0]*hr + lift_c[1]*hs == num_curve))
print("    deg cofactors:", [t.degree() for t in lift_c])
num_amap = amap_id.numerator()
lift_a = num_amap.lift(I)
print("[8] amap certificate found:", (lift_a[0]*hr + lift_a[1]*hs == num_amap))
print("    deg cofactors:", [t.degree() for t in lift_a])

# save certificates verbatim
with open('/tmp/wp3_certs.txt','w') as f:
    f.write("== num_curve ==\n%s\n\n== cert_curve_hr ==\n%s\n\n== cert_curve_hs ==\n%s\n\n" % (num_curve, lift_c[0], lift_c[1]))
    f.write("== den_curve (denominator of curve_id) ==\n%s\n\n" % curve_id.denominator().factor())
    f.write("== num_amap ==\n%s\n\n== cert_amap_hr ==\n%s\n\n== cert_amap_hs ==\n%s\n\n" % (num_amap, lift_a[0], lift_a[1]))
    f.write("== den_amap ==\n%s\n\n" % amap_id.denominator().factor())
    f.write("== Dz_num_red factored ==\n%s\n\n" % (factor(Dz_num_red) if Dz_num_red != 0 else 0))
    f.write("== aden_num_red factored ==\n%s\n\n" % (factor(aden_num_red) if aden_num_red != 0 else 0))
print("[9] certificates written to /tmp/wp3_certs.txt")

# ---- degenerate locus: for which a does EVERY sign combo fail? ----
# conditions per combo (sr,st): Dw(sr*r,st*s) != 0, Dz != 0, aden != 0.
# Work in QQ[a][r,s]/(hr,hs).  Enumerate failure a-values via resultants.
S = PolynomialRing(QQ, names=('A','Rv','Sv'))
A, Rv, Sv = S.gens()
HR = Rv^2 - (9*A^2 - 14*A + 9)
HS = Sv^2 - (9*A^2 - 6*A + 9)
def bad_a_values(poly):
    # a-values where poly(a,r,s) = 0 meets the curve (some choice of r,s signs implicit in variety)
    J = S.ideal([HR, HS, poly])
    el = J.elimination_ideal([Rv, Sv])
    return el.gens()
# Dw = 3r-7s+12 with signs absorbed by r->±r, s->±s: the four combos are
# 3Rv-7Sv+12, 3Rv+7Sv+12, -3Rv-7Sv+12, -3Rv+7Sv+12; their PRODUCT vanishing
# at (a, |r|, |s|) means at least one combo has Dw = 0.  ALL-four-fail for the
# Dw condition alone would need product-vanishing under every sign assignment --
# but since combos exhaust signs, "combo (sr,st) fails Dw" is one factor.
prodDw = (3*Rv-7*Sv+12)*(3*Rv+7*Sv+12)*(-3*Rv-7*Sv+12)*(-3*Rv+7*Sv+12)
print("[10] a-values where SOME combo has Dw=0:", bad_a_values(prodDw))
# Dz numerator and aden numerator as polys in (a, r, s): recompute for generic combo
DzN = S(str(Dz_f.numerator()).replace('a','A').replace('r','Rv').replace('s','Sv'))
adenN = S(str(adenv.numerator()).replace('a','A').replace('r','Rv').replace('s','Sv'))
print("[11] a-values where SOME combo has Dz=0:")
prodDz = DzN * DzN.subs({Rv:-Rv}) * DzN.subs({Sv:-Sv}) * DzN.subs({Rv:-Rv,Sv:-Sv})
print("    ", bad_a_values(prodDz))
print("[12] a-values where SOME combo has aden=0:")
prodAd = adenN * adenN.subs({Rv:-Rv}) * adenN.subs({Sv:-Sv}) * adenN.subs({Rv:-Rv,Sv:-Sv})
print("    ", bad_a_values(prodAd))
print("DONE")
