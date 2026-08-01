import signal
class TO(Exception): pass
def h(s,f): raise TO()
signal.signal(signal.SIGALRM,h)
def E1c(t):
    T=(t^2+t+1)/(3*t)
    return EllipticCurve(QQ,[-2*(7*T+3),2*(16*T^2-7),-36*(7*T+3),-324,-648*(16*T^2-7)])
# 3 flagged curves
print("== paper's 3 rank-ambiguous E1 curves (claims rank in {1,2,3}) ==")
for t in [QQ(-2)/11,QQ(-5)/8,QQ(4)/5]:
    E=E1c(t)
    signal.alarm(40)
    try:
        lb,ub=E.rank_bounds()
        signal.alarm(0)
        print(f"t={t}: rank_bounds=({lb},{ub})  analytic_rank≈{E.analytic_rank()}")
    except TO:
        print(f"t={t}: rank_bounds TIMEOUT>40s")
    except Exception as e:
        signal.alarm(0); print(f"t={t}: err {e}")
