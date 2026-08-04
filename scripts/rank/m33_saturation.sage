# m33_saturation.sage -- Theorem "Corrected ranks" (a) supplement: saturation
# of the generator (-35,240) on the m=33 twist.  Fresh run 2026-08-03
# (logos, Sage 10.8); to enter scripts/rank/ at the release accompanying
# the AFM manuscript.
Etw = EllipticCurve([0,-1,0,-2097,28305])
print("[E33tw]", Etw.ainvs())
print("[rank_bounds]", Etw.rank_bounds(), " rank:", Etw.rank())
sat, index, reg = Etw.saturation([Etw(-35,240)])
print("[saturation of (-35,240)] index =", index, " saturated =", sat)
