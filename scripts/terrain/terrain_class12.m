// terrain_class12.m -- fresh Magma verification (2026-08-02, V2.29-7) replacing the
// unpreserved source of bm_thm7_sixconics2: Sq square class 12 and admissibility on
// each component of Q4=0, plus the geometric-integrality inputs for S itself.
P<a,b> := PolynomialRing(Rationals(),2);
den := a*b + a + b;
s1n := (1+a+b)*den - a*b;
s2n := (a+b+a*b)*den - a*b*(1+a+b);
Rq := 9*s1n^2 - 32*s2n*den;
Sq := 9*s1n^2 - 24*s2n*den;
Q4 := (3*Rq - Sq)/18;
F1 := a*b + a + b - 1; F2 := a*b + a - b^2 + b; F3 := a^2 - a*b - a - b;
print "CHECK Q4_eq_F1F2F3:", Q4 eq F1*F2*F3;
// geometric-integrality inputs for S: odd-multiplicity nonconstant part of Rq, Sq, RqSq
function OddPart(f)
  cnt := 0;
  for t in Factorization(f) do
    if IsOdd(t[2]) and TotalDegree(t[1]) ge 1 then cnt +:= 1; end if;
  end for;
  return cnt;
end function;
print "CHECK Rq_odd_nonconst_factors:", OddPart(Rq);
print "CHECK Sq_odd_nonconst_factors:", OddPart(Sq);
print "CHECK RqSq_odd_nonconst_factors:", OddPart(Rq*Sq);
print "CHECK Rq_value_2_3:", Evaluate(Rq,[2,3]), "square:", IsSquare(Evaluate(Rq,[2,3]));
print "CHECK Sq_value_1_2:", Evaluate(Sq,[1,2]), "square:", IsSquare(Evaluate(Sq,[1,2]));
print "CHECK RqSq_value_1_2:", Evaluate(Rq*Sq,[1,2]), "square:", IsSquare(Evaluate(Rq*Sq,[1,2]));
// per-component: parametrize, restrict, square classes and rational zeros
K<t> := FunctionField(Rationals());
pars := [ [ (1-t)/(1+t), t ], [ t*(t-1)/(t+1), t ], [ t, t*(t-1)/(t+1) ] ];
names := [ "F1", "F2", "F3" ];
Fs := [F1, F2, F3];
function IsSqFF(r)  // r in K: square iff num*den is a square poly with square lc
  n := Numerator(r); d := Denominator(r);
  f := n*d;
  if f eq 0 then return true; end if;
  for u in Factorization(f) do
    if IsOdd(u[2]) then return false; end if;
  end for;
  fl, _ := IsSquare(LeadingCoefficient(f));
  return fl;
end function;
for i in [1..3] do
  av := pars[i][1]; bv := pars[i][2];
  print names[i], "on_curve:", Evaluate(Fs[i],[av,bv]) eq 0;
  Rt := Evaluate(Rq,[av,bv]); St := Evaluate(Sq,[av,bv]); Dt := Evaluate(den,[av,bv]);
  print names[i], "Rq_square_on_component:", IsSqFF(Rt);
  print names[i], "Sq_square:", IsSqFF(St), " Sq_over_12_square(class12):", IsSqFF(St/12);
  // rational zeros of Sq on the component and their degeneracy
  nz := Numerator(St);
  rts := Roots(nz);
  print names[i], "Sq_rational_zero_count:", #rts;
  for r in rts do
    t0 := r[1];
    if Evaluate(Denominator(av) * Denominator(bv), t0) eq 0 then
      print names[i], "zero t =", t0, ": parametrization pole -- inadmissible";
    else
      a0 := Evaluate(av, t0); b0 := Evaluate(bv, t0);
      d0 := a0*b0 + a0 + b0;
      if d0 eq 0 then
        print names[i], "zero t =", t0, ": point", a0, b0, "den=0 -- inadmissible";
      else
        c0 := -a0*b0/d0;
        print names[i], "zero t =", t0, ": point", a0, b0, "c =", c0, "distinct:",
          #{Rationals()!1, a0, b0, c0} eq 4;
      end if;
    end if;
  end for;
  print names[i], "gcd_with_RqSq_trivial:", TotalDegree(GCD(Fs[i], Rq*Sq)) eq 0;
end for;
print "DONE";
