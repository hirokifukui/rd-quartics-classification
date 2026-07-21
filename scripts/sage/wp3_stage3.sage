# WP3 stage 3: canonical adP6, its unit certificate, full data dump for Lean.
import itertools

R = PolynomialRing(QQ, names=('a','r','s'), order='degrevlex')
a, r, s = R.gens()
hr = r^2 - (9*a^2 - 14*a + 9)
hs = s^2 - (9*a^2 - 6*a + 9)
I = R.ideal([hr, hs])

wN = 18*(15*a - 6*r - s - 13)
wD = 3*r - 7*s + 12
K1red = 105*a^2 - 45*a*r - 238*a + 51*r + 16*s + 105
K1 = 18*K1red
zN = 9*(2*wN - 12*wD)*(wN + 2*wD)*wD - a*(wN^3 + 4*wN^2*wD - 252*wN*wD^2)
zD = K1*wD^2

# canonical aden clearing and adP6
adenC_num = (7*wN - 18*wD)*zN*wD^2 + (wN^3 + 4*wN^2*wD - 252*wN*wD^2)*zD
adenC_red = I.reduce(adenC_num)
fac = factor(adenC_red)
assert len(list(fac)) == 1
adP6 = list(fac)[0][0]
unit = fac.unit()
print("[1] unit:", unit, " adP6 deg:", adP6.degree(), " terms:", len(adP6.monomials()))
# certificate: adenC_num - unit*adP6 in I
diffpoly = adenC_num - unit*adP6
lift_ad = diffpoly.lift(I)
print("[2] aden certificate verifies:", lift_ad[0]*hr + lift_ad[1]*hs == diffpoly,
      " cofactor terms:", [len(t.monomials()) for t in lift_ad])

# curve certificate (recompute, canonical)
curve_clear = zN^2 - (wN^3 + 12*wN^2*wD - 108*wN*wD^2) * K1^2 * wD
lift_c = curve_clear.lift(I)
print("[3] curve certificate verifies:", lift_c[0]*hr + lift_c[1]*hs == curve_clear,
      " cofactor terms:", [len(t.monomials()) for t in lift_c])

# wD_ne certificate
JD = R.ideal([wD, hr, hs])
gD = JD.elimination_ideal([r, s]).gens()[0]
liftD = gD.lift(JD)
print("[4] wD_ne:", liftD[0]*wD + liftD[1]*hr + liftD[2]*hs == gD, " gD =", factor(gD),
      " cof terms:", [len(t.monomials()) for t in liftD])

# K1_ne certificate
JK = R.ideal([K1red, hr, hs])
gK = JK.elimination_ideal([r, s]).gens()[0]
liftK = gK.lift(JK)
print("[5] K1_ne:", liftK[0]*K1red + liftK[1]*hr + liftK[2]*hs == gK, " gK =", factor(gK),
      " cof terms:", [len(t.monomials()) for t in liftK])

# unit certificate for all-four-adP6-fail
c1 = adP6
c2 = adP6.subs({r:-r})
c3 = adP6.subs({s:-s})
c4 = adP6.subs({r:-r, s:-s})
JU = R.ideal([hr, hs, c1, c2, c3, c4])
print("[6] all-four-adP6-fail ideal is unit:", JU.is_one() if hasattr(JU,'is_one') else (R(1) in JU))
one_lift = R(1).lift(JU)
chk = sum(one_lift[i]*JU.gens()[i] for i in range(6)) == 1
print("[7] unit certificate verifies:", chk, " cofactor terms:", [len(t.monomials()) for t in one_lift],
      " cofactor degs:", [t.degree() for t in one_lift])

# full-pipeline numeric checks on three RD values
E = EllipticCurve([0,12,0,-108,0])
def pipeline(aa):
    g1 = 9*aa^2-14*aa+9; g2 = 9*aa^2-6*aa+9
    if not (g1.is_square() and g2.is_square()): return "gates fail"
    rr0 = g1.sqrt(); ss0 = g2.sqrt()
    out = []
    for (sr, st) in itertools.product([1,-1],[1,-1]):
        rr = sr*rr0; ss = st*ss0
        vals = {a:aa, r:rr, s:ss}
        dwv = wD.subs(vals); k1v = K1red.subs(vals); adv = adP6.subs(vals)
        if dwv == 0 or k1v == 0 or adv == 0:
            out.append((sr,st,"degenerate", dwv==0, k1v==0, adv==0)); continue
        ww = wN.subs(vals)/dwv
        zz = zN.subs(vals)/zD.subs(vals)
        on = (zz^2 == ww^3+12*ww^2-108*ww)
        adenv = (7*ww-18)*zz + (ww^3+4*ww^2-252*ww)
        am = 9*(2*ww+zz-12)*(ww+2)/adenv if adenv != 0 else None
        out.append((sr,st,"OK" if (on and adenv!=0 and am==aa) else "FAIL", on, adenv!=0, am==aa))
    return out
for aa in [QQ(90)/77, QQ(77)/90, QQ(497610)/167167]:
    print("[8] a =", aa, ":", pipeline(aa))

with open('/tmp/wp3_stage3_certs.txt','w') as f:
    def dump(name, poly):
        f.write("== %s ==\n%s\n\n" % (name, poly))
    dump("wN", wN); dump("wD", wD); dump("K1red", K1red); dump("zN", zN)
    dump("adP6", adP6); f.write("== unit (aden) ==\n%s\n\n" % unit)
    dump("cert_aden_hr", lift_ad[0]); dump("cert_aden_hs", lift_ad[1])
    dump("curve_clear_certR", lift_c[0]); dump("curve_clear_certS", lift_c[1])
    dump("gD", gD); dump("wD_cof0", liftD[0]); dump("wD_cofR", liftD[1]); dump("wD_cofS", liftD[2])
    dump("gK", gK); dump("K1_cof0", liftK[0]); dump("K1_cofR", liftK[1]); dump("K1_cofS", liftK[2])
    for i, nm in enumerate(["u_hr","u_hs","u_c1","u_c2","u_c3","u_c4"]):
        dump("unitcert_"+nm, one_lift[i])
print("DONE -> /tmp/wp3_stage3_certs.txt")
