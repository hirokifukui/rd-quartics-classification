Q := Rationals();
// base plane curves of Q4 = F1*F2*F3
A2<x,y> := AffineSpace(Q,2);
F1 := x*y + x + y - 1;
F2 := x*y + x - y^2 + y;
F3 := x^2 - x*y - x - y;
for i -> F in [F1,F2,F3] do
  C := Curve(A2,F);
  print "base factor", i, "irreducible:", IsIrreducible(C), "genus:", Genus(C);
end for;
// pullback components: parametrize each factor, restrict Rq, Sq
// Rq, Sq as polynomials in (a,b)
P2<a,b> := PolynomialRing(Q,2);
den := a*b + a + b;
s1n := (1+a+b)*den - a*b;
s2n := (a+b+a*b)*den - a*b*(1+a+b);
Rq := 9*s1n^2 - 32*s2n*den;
Sq := 9*s1n^2 - 24*s2n*den;
FT<t> := FunctionField(Q);
// helper: given rational functions A,B in t, genus of z^2=A, w^2=B tower
function TowerGenus(A,B)
  R1<Z> := PolynomialRing(FT);
  K1<z1> := FunctionField(Z^2 - A);
  R2<W> := PolynomialRing(K1);
  K2<w1> := FunctionField(W^2 - B);
  return Genus(K2);
end function;
function EvalAB(pa,pb)
  A := Evaluate(Rq,[pa,pb]);
  B := Evaluate(Sq,[pa,pb]);
  return A,B;
end function;
// F1: b = (1-a)/(1+a), param by a=t
A1,B1 := EvalAB(t,(1-t)/(1+t));
// F2: a = b(b-1)/(b+1), param by b=t
A2f,B2 := EvalAB(t*(t-1)/(t+1),t);
// F3: b = a(a-1)/(a+1), param by a=t
A3,B3 := EvalAB(t,t*(t-1)/(t+1));
labels := ["F1","F2","F3"];
As := [A1,A2f,A3]; Bs := [B1,B2,B3];
for i in [1..3] do
  A := As[i]; B := Bs[i];
  // splitting structure: which of A, B, AB is a square in Q(t)
  qa := IsSquare(A); qb := IsSquare(B); qab := IsSquare(A*B);
  print labels[i], ": A square", qa, "/ B square", qb, "/ AB square", qab;
  if qa or qb or qab then
    // biquadratic cover splits into two components, each a double cover
    if qa then g := TowerGenusB where TowerGenusB := Genus(FunctionField(PolynomialRing(FT).1^2 - B));
    elif qb then g := Genus(FunctionField(PolynomialRing(FT).1^2 - A));
    else g := Genus(FunctionField(PolynomialRing(FT).1^2 - A));
    end if;
    print labels[i], "splits: 2 components, each genus:", g;
  else
    print labels[i], "cover irreducible, genus:", TowerGenus(A,B);
  end if;
end for;
print "DONE";
quit;
quit;
