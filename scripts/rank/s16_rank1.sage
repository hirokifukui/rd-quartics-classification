def cand():
    S=set()
    for q in range(1,21):
        for p in range(1,q+1):
            if gcd(p,q)==1 and QQ(p)/q<1:
                S.add(QQ(p)/q)
    return sorted(S)   # (0,1)
setP=cand()
def E1c(t):
    T=(t^2+t+1)/(3*t)
    return EllipticCurve(QQ,[-2*(7*T+3),2*(16*T^2-7),-36*(7*T+3),-324,-648*(16*T^2-7)])
def E2c(t):
    T=(t^2+t+1)/(3*t)
    return EllipticCurve(QQ,[-2*(3*T+1),2*(36*T^2-3),-36*(3*T+1),-324,-648*(36*T^2-3)])
bad1=[];bad2=[]
for t in setP:
    E1=E1c(t); E2=E2c(t)
    P1=E1(18,0); P2=E2(18,0)
    if not P1.has_infinite_order(): bad1.append(t)
    if not P2.has_infinite_order(): bad2.append(t)
print("E1(t): (18,0) FINITE-order (rank>=1 fails) for t in (0,1):", bad1)
print("E2(t): (18,0) FINITE-order for t in (0,1):", bad2)
print("=> rank>=1 confirmed via (18,0) for all",len(setP),"curves E1 and E2?", (not bad1) and (not bad2))
