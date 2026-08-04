# bk_errata_576i3.sage -- Remark "Errata in the sources": rows n=2,3 of the
# BK1995 table (p.131) are internally inconsistent.  Printed values below are
# transcribed from the published table (verified against the PDF, 2026-08-03):
#   row n=2: point (5329/100, +129283/1000);  a = 167167/497610;
#            roots (668668, 1990440)
#   row n=3: point (2447877675/4713241, +116043549439635/10232446211);
#            roots (-514660109040, 277132848044)
# Claim verified: printed points equal -2Q, -3Q for the printed generator
# Q=(75,405) under the canonical group law, while printed a-values and root
# pairs correspond to +2Q, +3Q (a-class {a, 1/a}).
# To enter scripts/ at the release accompanying the AFM manuscript.
EA = EllipticCurve([0,-42,0,-288,0])   # Y^2 = X(X-48)(X+6)
Q = EA(75,405)
def bkmap(P):
    X,Y = P.xy()
    return (5*X+Y+30)/(9*(X+2))
P2 = EA(QQ(5329)/100, QQ(129283)/1000)
print("[printed n=2 point == -2Q]", P2 == -2*Q, " == +2Q:", P2 == 2*Q)
print("[a at printed n=2 point]", bkmap(P2), " printed a =", QQ(167167)/497610, " a(+2Q) =", bkmap(2*Q))
print("[printed n=2 roots ratio]", QQ(1990440)/668668, " in a-class of +2Q:", QQ(1990440)/668668 in [bkmap(2*Q), 1/bkmap(2*Q)])
P3 = EA(QQ(2447877675)/4713241, QQ(116043549439635)/10232446211)
print("[printed n=3 point == -3Q]", P3 == -3*Q, " == +3Q:", P3 == 3*Q)
print("[a at printed n=3 point]", bkmap(P3), " a(+3Q) =", bkmap(3*Q))
r3 = QQ(277132848044)/QQ(-514660109040)
print("[printed n=3 roots ratio]", r3, " in a-class of +3Q:", r3 in [bkmap(3*Q), 1/bkmap(3*Q)])
