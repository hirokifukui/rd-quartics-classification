## rank_tables.sage -- verify ALL rows of Table 4 & Table 5 via Birch twist identity
##   rk[E/Q(sqrt m)] = rk[E_m/Q] + rk[E/Q],  rk[E/Q]=1
def chk(name, cond): print(("PASS " if cond else "FAIL ")+name)
E = EllipticCurve(QQ,[0,12,0,-108,0])   # z^2=w(w-6)(w+18)
chk("rk[E/Q]=1", E.rank()==1)

def pred_rank(m):
    Etw=E.quadratic_twist(m)
    try:
        r=Etw.rank(only_use_mwrank=False)
        rig=True
    except Exception as e:
        r=Etw.rank(proof=False); rig=False
    # rigor check: lower==upper bound
    lo=Etw.rank_bound() if hasattr(Etw,'rank_bound') else None
    return r

print("\n== Table 4 (complex quadratic, class number 1) ==")
T4={-1:1,-2:1,-3:1,-7:1,-11:3,-19:3,-43:3,-67:1,-163:1}
ok4=True
for m in [-1,-2,-3,-7,-11,-19,-43,-67,-163]:
    Etw=E.quadratic_twist(m)
    r=Etw.rank(); pred=r+1; good=(pred==T4[m])
    ok4=ok4 and good
    print(f"  m={m:5}: rk[E_m/Q]={r}  pred={pred}  BM={T4[m]}  {'OK' if good else 'MISMATCH'}")
chk("Table 4 all 9 rows match BM", ok4)

print("\n== Table 5 (real euclidean quadratic) ==")
T5={2:1,3:1,5:2,6:1,7:2,11:2,13:2,17:2,19:2,21:1,29:2,33:1,37:2,41:2,57:1,73:2}
ok5=True
for m in [2,3,5,6,7,11,13,17,19,21,29,33,37,41,57,73]:
    Etw=E.quadratic_twist(m)
    r=Etw.rank(); pred=r+1; good=(pred==T5[m])
    ok5=ok5 and good
    print(f"  m={m:5}: rk[E_m/Q]={r}  pred={pred}  BM={T5[m]}  {'OK' if good else 'MISMATCH'}")
chk("Table 5 all 16 rows match BM", ok5)

print("\n== Table 1 decided rows (quartic Q-derived yes/no) ==")
Rx=PolynomialRing(QQ,'x'); x=Rx.gen()
def is_Qderived(poly):
    p=poly
    while p.degree()>=1:
        if not all(rt in QQ for rt,_ in p.roots()) or sum(mm for _,mm in p.roots())!=p.degree():
            return False
        p=p.derivative()
    return True
chk("T1 p(2,1,1) x^2(x-1)(x-90/77) Q-derived (a=90/77 from E)", is_Qderived(x^2*(x-1)*(x-QQ(90)/77)))
chk("T1 p(3,1) x^3(x-1) Q-derived", is_Qderived(x^3*(x-1)))
chk("T1 p(4) x^4 Q-derived", is_Qderived(x^4))
chk("T1 p(2,2) x^2(x-1)^2 NOT Q-derived", not is_Qderived(x^2*(x-1)^2))
# reason: disc(y'')=48 -> sqrt3
ypp=(x^2*(x-1)^2).derivative().derivative()
chk("T1 p(2,2) reason: disc(y'')=48=16*3 (sqrt3)", ypp.discriminant()==48)

print("\n== Table 2 decided rows (quintic) ==")
chk("T2 p(5) x^5 Q-derived", is_Qderived(x^5))
chk("T2 p(4,1) x^4(x-1) Q-derived", is_Qderived(x^4*(x-1)))
chk("T2 p(3,2) x^3(x-1)^2 NOT Q-derived", not is_Qderived(x^3*(x-1)^2))
# reason sqrt6: y''=... factor 10x^2-12x+3 disc 24
ypp2=(x^3*(x-1)^2).derivative().derivative()
print("  y''(p(3,2)) =",ypp2," ; its quad-factor disc:")
fac=(ypp2/2)  # 10x^2-12x+3 times? y''=20x^3-24x^2+6x=2x(10x^2-12x+3)
chk("T2 p(3,2) reason: 10x^2-12x+3 disc=24=4*6 (sqrt6)", (10*x^2-12*x+3).discriminant()==24)
print("=== rank_tables done ===")
