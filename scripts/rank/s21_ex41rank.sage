R.<x>=QQ[]
F1=3*(x^4+4*x^3+4*x^2+3)
print("F1 =",F1," disc=",F1.discriminant()," irreducible?",F1.is_irreducible())
# Method A: I,J invariants Jacobian
a,b,c,d,e=3,12,12,0,9
I=12*a*e-3*b*d+c^2; J=72*a*c*e-27*a*d^2-27*e*b^2+9*b*c*d-2*c^3
E=EllipticCurve([0,0,0,-27*I,-27*J]).minimal_model()
print("Jacobian minimal:",E)
print("  rank=",E.rank()," rank_bounds=",E.rank_bounds()," analytic_rank=",E.analytic_rank())
print("  gens=",E.gens())
# Method B: rational points on Z^2=F1 for small t to see how many independent
pts=[]
for q in range(1,12):
  for p in range(-30,31):
    if gcd(p,q)==1:
        t=QQ(p)/q; v=F1(t)
        if v>=0 and v.is_square(): pts.append((t,sqrt(v)))
print("small rational pts (t,Z) on Z^2=F1:",pts[:15]," count:",len(pts))
