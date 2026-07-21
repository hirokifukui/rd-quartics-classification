# Thm7ForwardProof.lean / Thm7PrimeMaster.lean — MANIFEST

## Thm7ForwardProof.lean（WP3 = forward 方向 [P]）
- 昇格日: 2026-07-21 / 経路: 逆写像発見 Magma Groebner（A9, job wp3_invert）→
  厳密検証+証明書抽出 Sage（stage1–3, /tmp/wp3_*.sage）→ 設計凍結 claude.ai →
  証明書転記+戦術修復 Claude Code（job thm7wp3, run 20260721_154655）→
  **独立 kernel 監査 claude.ai（lake 直叩き + 凍結断片 24 点機械照合）**
- md5: `67d8af571f93f692edceffb732a10a3c`
- kernel（claude.ai 独立実測）: exit 0 / error 0 / sorry 0。**9 宣言すべて
  `[propext, Classical.choice, Quot.sound]` ちょうど — 公理ゼロ**。
  rank_E576i2 は一切不消費。sorryAx / ofReduceBool / native_decide = 0。
- 凍結突合: 定義 14・定理文 9・#print ブロックの全 24 断片が凍結版と逐語一致
  [MC 機械照合]。CC の変更は戦術ブロックと、開示済み per-theorem
  `set_option maxHeartbeats ... in` 4 箇所のみ（heartbeat 保険、規律内）。
- 内容: **`thm7_forward : Thm7Forward` [P]**。
  - 逆写像 w = wNp/wDp, z = zNp/zDp（Magma lex GB、飽和イデアル）。
  - `wD_ne`/`K1_ne`: 消去式証明書 + (15a−7)²+189 > 0 + `sq_ne_96`
    （a=5/3, 3/5 枝は Gate1 が (3r)²=(5r)²=96 を強制、96 は ℚ 非平方 —
    Rat.sqrt ルートで閉）。a≠0 で**全符号**非消滅。
  - `adP6_cover`: 単位イデアル Nullstellensatz 証明書（六余因子）で
    四符号中一つが必ず生存。
  - `curve_cleared`/`aden_cleared`: Sage lift 証明書（65 項×2 / 35 項×2）。
  - `anchor_90_77`: (90/77, 171/77, 291/77) ↦ (726/25, 22176/125) ↦ 90/77 [MC]。
- 数値裏取り [MC]: a = 90/77, 77/90, 497610/167167 で全パイプライン通過
  （Sage stage3 [8]）。

## Thm7PrimeMaster.lean（統合 = Theorem 7′ 無条件）
- 昇格日: 2026-07-21 / 合成法: **逐語連結＋橋一行（書換ゼロ）**。
  Part 1 = Thm7Statement.lean（md5 4a3ea6db…）の end/#print 前まで、
  Part 2 = Thm7ForwardProof.lean（md5 67d8af57…）の §2 以降（§1 の逐語重複
  定義を除去）、Bridge = `theorem thm7prime : Thm7Prime :=
  ⟨thm7_backward, thm7_forward⟩` のみ。python 合成、claude.ai 執行。
- md5: `a1b1d54566481b50bd0ce3667c2ee509`（651 行、34 宣言）
- kernel（claude.ai 独立実測）: exit 0 / error 0 / sorryAx 0。
  **`thm7prime` = `[propext, Classical.choice, Quot.sound]` ちょうど。**
  34 宣言中 32 が std-3；例外は旧接合対 `rankOneE_holds` /
  `thm7prime_of_forward`（std-3 + 開示公理 rank_E576i2）のみ — WP1 時点の
  [P-ax] 設計の記録として残置、`thm7prime` に上書きされた。
- **意味: BM2000 Theorem 7（26 年間 gap を含んだ p(2,1,1) 分類）の修復版
  Theorem 7′ が、無条件・機械検証済み・公理開示すら不要の完全証明 [P] で
  成立。** rank 入力は両方向ともゼロ（§2.3 監査の判決「rank は E(ℚ) の
  点列挙にのみ要る」と整合）。
- toolchain: v4.31.0-rc1 / mathlib rev 9196a81（magicsq-lean 間借り）。
  正典 pin d568c8c 再検査 TODO は 6 本に拡大。
- cross-ref: DEPENDENCY_MAP addendum A5 / Thm7Statement.MANIFEST.md /
  CC RESULT: /tmp/thm7wp3/RESULT.md（揮発、要旨転記済）/ 証明書一次資料:
  /tmp/wp3_stage3_certs.txt（揮発 — **証明書は .lean 本体に逐語で永続**）
