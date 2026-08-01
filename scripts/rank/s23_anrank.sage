import signal
from collections import Counter
class TO(Exception): pass
signal.signal(signal.SIGALRM, lambda s,f:(_ for _ in ()).throw(TO()))
def cand():
    S=set()
    for q in range(1,21):
        for p in range(1,q+1):
            if gcd(p,q)==1 and QQ(p)/q<1: S.add(QQ(p)/q)
    return sorted(S)
setP=cand()
def E1c(t):
    T=(t^2+t+1)/(3*t); return EllipticCurve(QQ,[-2*(7*T+3),2*(16*T^2-7),-36*(7*T+3),-324,-648*(16*T^2-7)])
def E2c(t):
    T=(t^2+t+1)/(3*t); return EllipticCurve(QQ,[-2*(3*T+1),2*(36*T^2-3),-36*(3*T+1),-324,-648*(36*T^2-3)])
def dist(fam,name):
    c=Counter(); to=[]
    for t in setP:
        signal.alarm(12)
        try:
            c[fam(t).analytic_rank()]+=1; signal.alarm(0)
        except TO: signal.alarm(0); to.append(t)
        except Exception: signal.alarm(0); to.append(t)
    print(name,"analytic-rank dist over (0,1),",len(setP),"curves:",dict(sorted(c.items())),"timeouts:",len(to))
dist(E1c,"E1"); dist(E2c,"E2")
