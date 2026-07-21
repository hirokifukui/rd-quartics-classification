# Thm7RepairGates.lean — MANIFEST

- 昇格日: 2026-07-21 / 経路: 設計 claude.ai(Sage 厳密検証 [MC]) → 転記 Claude Code
  (job thm7gates, run 20260721_143532) → **独立 kernel 監査 claude.ai(lake 直叩き)**
- md5: `ec4ababf9a58447f0a8add83dc5cf4ef`
- kernel(claude.ai 独立実測): exit 0 / error 0 / warning 0。全 7 宣言
  `[propext, Classical.choice, Quot.sound]` ちょうど。sorry/axiom/native_decide/set_option = 0。
- 内容(WP2 = Thm 7′ の ⇐ 方向、rank 入力ゼロ):
  `D_reduce`(a-map 分母の曲線上還元)/ **`gate1_cleared` / `gate2_cleared`**
  (両 gate の平方性 = 分母払い済み多項式恒等式、λ は Sage 厳密計算値の逐語転記)/
  `anchor`(P=(−12,36): a=0, 両 gate = 9)/ `combine_frac`(CC 追加の純代数補助 —
  抽象変数上、数学不変、監査済)/ **`gate1_sq` / `gate2_sq`**(除算形の系:
  hM・hD ≠ 0 の下で ∃r, g_i(a) = r² — **除外因子が仮定として明示**)。
- 意味: BM2000 Theorem 7 の「a(P) は必ず rational-derived を与える」方向が
  **[P](std-3・rank 公理不要)** で確定。rank-1 安全公理が要るのは WP3(完全性)のみ。
- toolchain: v4.31.0-rc1 / mathlib rev 9196a81(magicsq-lean 間借り)。正典 pin 再検査 TODO 同前。
- cross-ref: DEPENDENCY_MAP addendum A2 / bm_thm7_gap/ResDiscProduct.lean / CC RESULT:
  /tmp/thm7gates/RESULT.md(揮発 — 要旨は本 MANIFEST に転記済)
