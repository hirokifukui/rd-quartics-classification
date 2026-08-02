// Transcription check: [GJ15] (3.5) coefficients vs re-derivation from BM sec 2.2.3 verbatim
// (sigma3=0, c = -ab/(ab+a+b)).  Run 2026-07-16, A9 Magma V2.29-7, detach=False (output below).
P<a,b> := PolynomialRing(Rationals(),2);
den := a*b + a + b;
s1n := (1+a+b)*den - a*b;
s2n := (a+b+a*b)*den - a*b*(1+a+b);
Dr := 9*s1n^2 - 32*s2n*den;
Ds := 9*s1n^2 - 24*s2n*den;
r4 := 9*a^2+18*a+9;  r3 := 14*a^3+10*a^2+10*a+14;
r2 := 9*a^4-10*a^3-6*a^2-10*a+9;  r1 := 18*a^4-10*a^3-10*a^2+18*a;
r0 := 9*a^4-14*a^3+9*a^2;
t4 := 9*a^2+18*a+9;  t3 := 6*a^3-6*a^2-6*a+6;
t2 := 9*a^4+6*a^3+18*a^2+6*a+9;  t1 := 18*a^4+6*a^3+6*a^2+18*a;
t0 := 9*a^4-6*a^3+9*a^2;
Rq := r4*b^4 - r3*b^3 + r2*b^2 + r1*b + r0;
Sq := t4*b^4 - t3*b^3 + t2*b^2 + t1*b + t0;
print "MAGMA Dr eq Rq:", Dr eq Rq;
print "MAGMA Ds eq Sq:", Ds eq Sq;
aa := -51/13; bb := -17/7;
cc := -aa*bb/(aa*bb+aa+bb);
print "c matches -3:", cc eq -3;
DrV := Evaluate(Dr,[aa,bb]); DsV := Evaluate(Ds,[aa,bb]);
print "Dr at witness is square:", IsSquare(DrV);
print "Ds at witness square /Q (expect false):", IsSquare(DsV);
print "Ds/3441 is square:", IsSquare(DsV/3441);
quit;
