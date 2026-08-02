# terrain_crosscheck.sage -- fresh single-file Sage verification (2026-08-02) of the
# Chapter-4 [C] claims; second system to the original Magma scripts in this directory
# (session 2026-07-16c). All outputs labeled CHECK <name>: True/False; every claim
# consumed by the blueprint must print True.
R.<a,b> = PolynomialRing(QQ)
den = a*b + a + b
s1n = (1+a+b)*den - a*b
s2n = (a+b+a*b)*den - a*b*(1+a+b)
Rq  = 9*s1n^2 - 32*s2n*den
Sq  = 9*s1n^2 - 24*s2n*den
Q4  = (3*Rq - Sq)/18
F1 = a*b + a + b - 1
F2 = a*b + a - b^2 + b
F3 = a^2 - a*b - a - b
print("CHECK I1_18Q4:", 18*Q4 == 3*Rq - Sq)
print("CHECK I2_funnel:", s1n^2 - Rq == -8*Q4)
print("CHECK Q4_eq_F1F2F3:", Q4 == F1*F2*F3)
FQ = Q4.factor()
print("CHECK Q4_three_irreducible_factors:", len(list(FQ)) == 3 and all(e == 1 for _, e in FQ))
print("CHECK Q4_squarefree:", all(e == 1 for _, e in FQ))
def irr(f):
    FF = list(f.factor())
    return len(FF) == 1 and FF[0][1] == 1 and f.degree() > 0
print("CHECK F_irreducible:", irr(F1), irr(F2), irr(F3))
print("CHECK F2_F3_swap:", F2(a=b, b=a) == -F3)
# eight square tests in QQ[a,b] (poly square iff square in QQ(a,b), QQ[a,b] UFD)
def is_sq(f): return f.is_square()
tests = [("Q4",Q4),("Q4Rq",Q4*Rq),("Q4Sq",Q4*Sq),("Q4RqSq",Q4*Rq*Sq),
         ("n2Q4",-2*Q4),("n2Q4Rq",-2*Q4*Rq),("n2Q4Sq",-2*Q4*Sq),("n2Q4RqSq",-2*Q4*Rq*Sq)]
print("CHECK eight_nonsquares:", all(not is_sq(f) for _, f in tests))
# genus 0: each Fi is linear in one variable => rational curve; also verify via Curve
from sage.schemes.curves.constructor import Curve
print("CHECK genus_zero:", Curve(F1).genus() == 0, Curve(F2).genus() == 0, Curve(F3).genus() == 0)
# explicit parametrizations (linear solve), pole at t = -1 in all three
Rt1.<t> = PolynomialRing(QQ)
K = Rt1.fraction_field(); t = K(t)
par = {"F1": (( 1-t)/(1+t), t), "F2": ((t^2-t)/(1+t), t), "F3": (t, (t^2-t)/(1+t))}
for name, (av, bv) in par.items():
    Fi = {"F1": F1, "F2": F2, "F3": F3}[name]
    print("CHECK param_%s_on_curve:" % name, Fi(a=av, b=bv) == 0)
    Rt = Rq(a=av, b=bv); St = Sq(a=av, b=bv); Dt = den(a=av, b=bv)
    def numden_sq(r, mult=1):
        n = r.numerator(); d = r.denominator()
        return (n*d*mult).is_square()
    print("CHECK Rq_square_on_%s:" % name, numden_sq(Rt))
    print("CHECK Sq_class12_on_%s:" % name, (not numden_sq(St)) and numden_sq(St, 12))
    nroots = [r for r, _ in St.numerator().roots(QQ)]
    print("CHECK Sq_rational_zeros_%s:" % name, sorted(nroots))
    all_degenerate = True
    for r0 in nroots:
        if r0 == -1:
            print("  zero t=%s: parametrization pole -- inadmissible" % r0); continue
        a0 = QQ(av(r0)); b0 = QQ(bv(r0)); d0 = a0*b0 + a0 + b0
        if d0 == 0:
            print("  zero t=%s: point (%s,%s), den=0 -- c undefined, inadmissible" % (r0, a0, b0)); continue
        c0 = -a0*b0/d0
        roots4 = [QQ(1), a0, b0, c0]
        distinct = len(set(roots4)) == 4
        print("  zero t=%s: point (%s,%s), c=%s, roots distinct=%s%s" % (r0, a0, b0, c0, distinct, "" if distinct else " -- degenerate quartic, inadmissible"))
        if distinct: all_degenerate = False
    print("CHECK Sq_zeros_all_inadmissible_%s:" % name, all_degenerate)
# Hilbert-proposition inputs: Fi coprime to Rq*Sq (so branch loci avoid the components)
print("CHECK gcd_Fi_RqSq_one:", gcd(F1, Rq*Sq) == 1, gcd(F2, Rq*Sq) == 1, gcd(F3, Rq*Sq) == 1)
# pairing identities (kernel-checked in Lean as cleared forms; verified here in QQ(a,b))
Fr = R.fraction_field(); af = Fr(a); bf = Fr(b); denf = af*bf + af + bf
cf = -af*bf/denf
print("CHECK pairing_F1:", denf*(1 + cf - af - bf) == Fr(F1)*(-af-bf))
print("CHECK pairing_F2:", denf*(1 + af - bf - cf) == Fr(F2)*(af+1))
print("CHECK pairing_F3:", denf*(1 + bf - af - cf) == Fr(F3)*(-bf-1))
# K-witness sanity
w = (QQ(-51)/13, QQ(-17)/7)
print("CHECK witness_Q4_negative:", Q4(a=w[0], b=w[1]) < 0)
print("DONE")
