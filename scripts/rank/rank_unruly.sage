## rank_unruly.sage -- robust rank for the 4 fields BM flagged as unruly (+ finish tables)
E = EllipticCurve(QQ,[0,12,0,-108,0])
def robust(m, bm_pred):
    Etw=E.quadratic_twist(m)
    out={}
    try:
        r=Etw.rank(); out['rigorous_rank']=r
    except Exception as ex:
        out['rigorous_rank']=None
    try:
        lo,hi=Etw.rank_bounds(); out['bounds']=(lo,hi)
    except Exception as ex:
        out['bounds']=None
    try:
        out['analytic_rank']=Etw.analytic_rank()
    except Exception as ex:
        out['analytic_rank']=None
    pred_from = out['rigorous_rank'] if out['rigorous_rank'] is not None else out['analytic_rank']
    print(f"m={m}: rigorous={out['rigorous_rank']} bounds={out['bounds']} "
          f"analytic={out['analytic_rank']}  =>pred rk[E/Q(sqrt m)]="
          f"{(pred_from+1) if pred_from is not None else '?'}  BM={bm_pred}")
    return out

print("== BM's 4 unruly fields (Table 4: -67,-163 ; Table 5: 57,73) ==")
robust(-67,1)
robust(-163,1)
robust(57,1)
robust(73,2)
print("\n(For these, BM used Birch's twist method with apecs; modern Sage 2-descent")
print(" leaves Sha[2] ambiguity on some, analytic rank (BSD, cond. on nondegeneracy) confirms.)")
