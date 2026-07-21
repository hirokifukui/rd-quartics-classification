# WP3 stage 2: rational roots of degeneracy eliminants, all-fail locus,
# final Lean-ready polynomial forms and certificates.
import itertools

R = PolynomialRing(QQ, names=('a','r','s'), order='degrevlex')
a, r, s = R.gens()
hr = r^2 - (9*a^2 - 14*a + 9)
hs = s^2 - (9*a^2 - 6*a + 9)
I = R.ideal([hr, hs])

# ---- exact polynomial forms ----
wN = 18*(15*a - 6*r - s - 13)
wD = 3*r - 7*s + 12
K1 = a*(7*wN - 18*wD) - 9*(wN + 2*wD)          # = 18*(105a^2-45ar-238a+51r+16s+105)
K1red = K1 / 18
print("[A] K1 = 18*K1red, K1red =", K1red)
L1 = 9*(2*wN - 12*wD)*(wN + 2*wD)*wD - a*(wN^3 + 4*wN^2*wD - 252*wN*wD^2)
zN = L1
zD = K1*wD^2
print("[B] deg zN:", zN.degree(), " zN nterms:", len(zN.monomials()))

# fraction check vs stage-1 construction
F = R.fraction_field()
wF = F(wN)/F(wD)
zF_direct = (F(9)*(2*wF-12)*(wF+2) - a*(wF^3+4*wF^2-252*wF)) / (a*(7*wF-18)-9*(wF+2))
print("[C] zN/zD == zF (as fractions):", F(zN)/F(zD) == zF_direct)

# ---- cleared curve identity: L1^2 = (wN^3+12wN^2*wD-108wN*wD^2) * K1^2 * wD  (mod I) ----
curve_clear = zN^2 * 1 - (wN^3 + 12*wN^2*wD - 108*wN*wD^2) * K1^2 * wD
# note zD^2 = K1^2*wD^4; z^2 - (w^3+12w^2-108w) cleared by K1^2*wD^4:
#   zN^2 - (wN^3+12wN^2 wD-108 wN wD^2)/wD^3 * K1^2 wD^4 = zN^2 - (...)*K1^2*wD
print("[D] curve_clear in I:", curve_clear in I)
lift_c = curve_clear.lift(I)
ok = (lift_c[0]*hr + lift_c[1]*hs == curve_clear)
print("[D2] curve certificate verifies:", ok, " cofactor degs:", [t.degree() for t in lift_c], " nterms:", [len(t.monomials()) for t in lift_c])

# ---- aden(W,Z) cleared: aden_clear = (7wN-18wD)*zN*wD + (wN^3+4wN^2*wD-252*wN*wD^2)*zD ... ----
# aden(W,Z) = (7W-18)Z + (W^3+4W^2-252W)
#           = [(7wN-18wD)*zN*wD^2 + (wN^3+4wN^2*wD-252*wN*wD^2)*zD] / (wD^3*zD)
adenC_num = (7*wN - 18*wD)*zN*wD^2 + (wN^3 + 4*wN^2*wD - 252*wN*wD^2)*zD
print("[E] adenC_num == c * adP * (extra factors)?  factor mod I:")
adenC_red = I.reduce(adenC_num)
fac = factor(adenC_red)
print("    unit:", fac.unit())
for p, e in fac:
    print("    factor(^%d), deg %d, terms %d: %s" % (e, p.degree(), len(p.monomials()), p if len(p.monomials()) < 30 else "(large)"))
# name adP = the essential quartic factor from stage 1
adP = -618165*a*r*s^2 - 136290*a*s^3 + 45450*r*s^3 + 204825*s^4 - 940680*a*r*s - 4200480*a*s^2 + 1332819*r*s^2 + 424934*s^3 - 762048*a*r - 1337904*a*s + 243720*r*s + 1872600*s^2 + 16977600*a - 7188480*r - 1718640*s - 19465920
# certificate: adenC_num - unitpart... instead: check adenC_num ≡ C * adP * X (mod I) for
# explicit cofactor X found by division; do it via lift of (adenC_num - candidate) later once shape known.

# ---- rational roots of the degeneracy eliminants ----
S = PolynomialRing(QQ, names=('A',)); A = S.gen()
DzElim = 50625*A^8 - 276750*A^7 + 629100*A^6 - 809520*A^5 + 647053*A^4 - 290010*A^3 + 53550*A^2
print("[F] Dz eliminant factors:", factor(DzElim))
AdElim = 3418960166015625*A^16 - 36255778453125000*A^15 + 185344708085156250*A^14 - 611336193539062500*A^13 + 1458599917348265625*A^12 - 2664043008071737500*A^11 + 3840500977724182500*A^10 - 4438772465200038000*A^9 + 4133119172757888600*A^8 - 3086515772989958400*A^7 + 1820672715626875264*A^6 - 823099287814688640*A^5 + 269682863834941200*A^4 - 57153299911848000*A^3 + 5847569136360000*A^2
print("[G] aden eliminant factors:", factor(AdElim))

# ---- ALL-FOUR-FAIL locus for adP alone ----
T = PolynomialRing(QQ, names=('A2','Rv','Sv')); A2, Rv, Sv = T.gens()
HR = Rv^2 - (9*A2^2 - 14*A2 + 9)
HS = Sv^2 - (9*A2^2 - 6*A2 + 9)
adPT = T(str(adP).replace('a','A2').replace('r','Rv').replace('s','Sv'))
combos = [adPT, adPT.subs({Rv:-Rv}), adPT.subs({Sv:-Sv}), adPT.subs({Rv:-Rv, Sv:-Sv})]
J = T.ideal([HR, HS] + combos)
el = J.elimination_ideal([Rv, Sv])
print("[H] all-four-adP-fail eliminant:", [factor(g) for g in el.gens()] if el.gens() else "empty(whole line?)")

# ---- certificate for wD_ne: eliminant of (wD, hr, hs) and membership ----
JD = R.ideal([wD, hr, hs])
elD = JD.elimination_ideal([r, s])
print("[I] wD eliminant:", [factor(g) for g in elD.gens()])
g0 = elD.gens()[0]
liftD = g0.lift(JD)
print("[I2] wD_ne certificate verifies:", liftD[0]*wD + liftD[1]*hr + liftD[2]*hs == g0,
      " cofactor terms:", [len(t.monomials()) for t in liftD])
# ---- same for K1red ----
JK = R.ideal([K1red, hr, hs])
elK = JK.elimination_ideal([r, s])
print("[J] K1red eliminant:", [factor(g) for g in elK.gens()])
gK = elK.gens()[0]
liftK = gK.lift(JK)
print("[J2] K1_ne certificate verifies:", liftK[0]*K1red + liftK[1]*hr + liftK[2]*hs == gK,
      " cofactor terms:", [len(t.monomials()) for t in liftK])

with open('/tmp/wp3_stage2.txt','w') as f:
    f.write("== wN ==\n%s\n== wD ==\n%s\n== K1red ==\n%s\n== zN ==\n%s\n== zD = 18*K1red*wD^2 ==\n\n" % (wN, wD, K1red, zN))
    f.write("== curve_clear ==\n%s\n\n== cert_curve_hr ==\n%s\n\n== cert_curve_hs ==\n%s\n\n" % (curve_clear, lift_c[0], lift_c[1]))
    f.write("== adenC_num ==\n%s\n\n== adenC_red (mod I) ==\n%s\n\n== adenC_red factored ==\n%s\n\n" % (adenC_num, adenC_red, fac))
    f.write("== adP ==\n%s\n\n" % adP)
    f.write("== wD eliminant ==\n%s\n== wD cert (cof wD, hr, hs) ==\n%s\n\n%s\n\n%s\n\n" % (g0, liftD[0], liftD[1], liftD[2]))
    f.write("== K1 eliminant ==\n%s\n== K1 cert ==\n%s\n\n%s\n\n%s\n\n" % (gK, liftK[0], liftK[1], liftK[2]))
    f.write("== all-adP-fail eliminant ==\n%s\n\n" % [str(g) for g in el.gens()])
print("DONE -> /tmp/wp3_stage2.txt")
