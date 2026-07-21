// Fresh two-system rank verification for E = 576i2 (2026-07-21, A9 Magma V2.29-7).
E := EllipticCurve([0,12,0,-108,0]);
print "Conductor:", Conductor(E);
print "CremonaRef:", CremonaReference(E);
lo, hi := RankBounds(E);
print "RankBounds:", lo, hi;
print "Torsion:", Invariants(TorsionSubgroup(E));
EA := EllipticCurve([0,-42,0,-288,0]);
print "EA CremonaRef:", CremonaReference(EA);
loA, hiA := RankBounds(EA);
print "EA RankBounds:", loA, hiA;
print "IsIsogenous:", IsIsogenous(E, EA);
