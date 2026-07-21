// Groebner discovery of the rational inverse of the a-map (2026-07-21, A9).
// E: z^2 = w^3+12w^2-108w.  On E (away from hM*aDen=0):
//   a = anum/aden,  r = r1num/hM,  s = r2num/hM.
Q := RationalField();
P<z,w,a,r,s> := PolynomialRing(Q, 5, "lex");
hE    := z^2 - (w^3 + 12*w^2 - 108*w);
aden  := (7*w - 18)*z + (w^3 + 4*w^2 - 252*w);
anum  := 9*(2*w + z - 12)*(w + 2);
hM    := w*(w + 18)*(w^2 - 63*w + 486);
r1num := 3*(w - 18)*(w + 6)*w*(w + 18) + (-21*w^2 + 108*w - 2916)*z;
r2num := 3*(w - 18)*(w + 6)*w*(w + 18) + (-9*w^2 - 648*w + 2916)*z;
I := ideal<P | hE, a*aden - anum, r*hM - r1num, s*hM - r2num>;
I := Saturation(I, aden*hM);
G := GroebnerBasis(I);
print "GB size:", #G;
for g in G do
  if Degree(g, z) eq 0 and Degree(g, w) le 1 then print g; end if;
end for;
J := EliminationIdeal(I, {a,r,s});
for g in GroebnerBasis(J) do print g; end for;
print "DONE";
