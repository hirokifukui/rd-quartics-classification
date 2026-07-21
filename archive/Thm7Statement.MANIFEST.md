# Thm7Statement.lean — MANIFEST

- 昇格日: 2026-07-21 / 経路: 設計 claude.ai（Sage/Magma 厳密検証 [MC] fresh）→
  戦術修復 Claude Code（job thm7wp1, run 20260721_151442）→
  **独立 kernel 監査 claude.ai（lake 直叩き + 凍結 diff 突合）**
- md5: `4a3ea6db8485dc5f308ee66b4a6136a7`
- kernel（claude.ai 独立実測）: exit 0 / error 0 / sorry 0。24 宣言中 **22 が
  `[propext, Classical.choice, Quot.sound]` ちょうど**、接合 2 定理
  `rankOneE_holds` / `thm7prime_of_forward` のみ **std trio + `rank_E576i2`**。
  sorryAx / ofReduceBool / native_decide = 0。
- 凍結突合: 昇格版と設計凍結版の diff は戦術ブロック 3 箇所のみ
  （dq1_splits / dq2_splits の linear_combination 係数、exceptional_points 本体）。
  statement / def / axiom / docstring 不変更を確認。
- 内容（WP1 = Theorem 7′ ステートメント組立 + WP3 接合）:
  - **`Thm7Prime = Thm7Backward ∧ Thm7Forward`**（A1 の無制限 E-形。BK の剰余類
    制限は 2-同種モデル 576i3 側の現象）。
  - **`thm7_backward` [P]**: ⇐ 方向を完全証明。generic 分岐 = gate1_sq/gate2_sq
    再梱包、例外分岐 = hMside=0 ∧ aDen≠0 の二点 (54,432)/(9,−27) → a=77/90、
    証人 (19/10, 97/30)。rank 入力ゼロ。
  - **`Thm7Forward`** = def : Prop（[OPEN] = WP3 の完全性方向）。
  - **`rank_E576i2`**: 唯一の開示安全公理（五点ゲート、docstring に全記録）。
    fresh 二系統 [MC] 2026-07-21: Sage 2-降下 rank_bounds (1,1) 無条件 +
    解析階数 1 + 生成元 (−2,16)／Magma RankBounds 1 1・CremonaRef 576i2。
  - **`thm7prime_of_forward : (RankOneE → Thm7Forward) → Thm7Prime`** —
    WP1/WP3 の接合点。footprint = std-3 + rank_E576i2 が本トラックの
    機械可読 [P-ax] 境界。残 open slot は hF ひとつ。
  - 忠実性錨: `OnE_iff_equation`（OnE ↔ mathlib Weierstrass 方程式）、
    `E576i2_elliptic`（Δ≠0）、gate↔導関数判別式錨、caseA 橋
    （`caseA_scale`/`caseA_normalized`: QDCaseSplit 平行移動 → 正規形 q_a）。
  - §2 は Thm7RepairGates.lean（md5 ec4ababf）の逐語コピー 6 宣言。
- 副産物 [MC]: Magma が E→E_A の明示 2-同種 w ↦ (w²+12w+36)/(w−6)
  （核 {O,(6,0)}、576i2→576i3）を提示 — TODO「E_A↔E 明示 2-同種」の素材。
- toolchain: v4.31.0-rc1 / mathlib rev 9196a81（magicsq-lean 間借り）。
  正典 pin d568c8c 再検査 TODO は本日の Lean 成果物 4 本に拡大。
- cross-ref: DEPENDENCY_MAP addendum A4 / Thm7RepairGates.MANIFEST.md /
  qderived/bm_thm7_gap/QDCaseSplit.lean / CC RESULT: /tmp/thm7wp1/RESULT.md
  （揮発 — 要旨は本 MANIFEST に転記済）/ 忠実性スクリプト: /tmp/wp1_fidelity.sage
  （揮発 — 検証項目は Thm7Statement.lean 冒頭コメントに転記済）
