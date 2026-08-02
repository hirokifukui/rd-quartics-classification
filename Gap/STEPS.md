# TRANSCRIPT Phase A — BM2000 §2.2.4 の分節と事前登録

作成: 2026-07-16c セッション / node Humanities / Dr. Fukui 裁定「元論文に忠実に淡々と写経する」に基づく。
逐語源: `session_2026-07-13a_wave9/thm7lean/txt/BM2000_full_layout.txt` md5 `a177e2e673705c0d68cc5fdf3a6626ce`、§2.2.4 = l.527–632(l.633 から §2.3)。分節は l.527–632 の全行を被覆し、残余なし。行番号は grep 実測(2026-07-16c)。

**目的**: §2.2.4 の各推論を前段からの導出として Lean に一段ずつ写す。埋まらない最初の段が gap の住所。
**規律**: 凍結物(BMThm7Gap.lean / BMThm7GapK.lean)は不可侵。新ファイル `transcript/BMThm7Transcript.lean`。
CC 委譲は一段ずつ、claude.ai が run_lean + #print axioms で独立監査。**この STEPS.md の §事前登録は Phase B 着手前に md5 凍結し、以後改変しない**(予測が外れたら外れたと記録する。書き換えない)。

---

## 分節(左: 逐語の在処と要旨 / 右: Lean 対象名と分類)

分類: [A] 印字の論証がそのまま形式化可能 / [B] 結論は真だが印字の論証が不十分 → 自前補完を明示タグで /
[C] non-sequitur、孤立化して埋めない / [D] 仮定(導出でない) / [ID] 代数恒等式、CAS 検算後に形式化。

| # | 行(実測) | 印字の内容(要旨) | 分類 | Lean 対象 |
|---|---|---|---|---|
| T0 | 527–534 | 節の約束: 最高極小を重根化する垂直移動後、残り二根 r,s は有理 — "we show that the latter is precisely the case" (l.534) | 目標 | `T0_claim`(証明対象、写経の終点) |
| T1 | 549–553 | 正規化 f = x(x-1)(x-a)(x-b) (l.549–551)、移動量 c は有理 | [D] | `T1_setup` |
| T2 | 554–558 | **"assume that the resulting quartic, F(x) say" (l.554) ... "is rational-derived and has a double root" (l.558)**、式 (4) | [D]警 | `T2_assumption` |
| T3 | 558–562 | Delta(F) = Res(F,F') (l.561) = 256c^3 + p4 c^2 + p5 c + p6 (l.562) | [ID] | `T3_disc_cubic` |
| T4 | 566–577 | DeltaDeltaF = -2^12 (a-b-1)^2 (a-b+1)^2 (a+b-1)^2 D6^3 (l.568)、D6 明示 (l.572–577) | [ID] | `T4_disc_disc`([MC] 既済: 真) |
| T5 | 578–580 | DeltaF := Delta(Delta(F)) の定義 (l.578)、実根数 1/2/3 と判別式符号の対応 (l.579–580) | [A] | `T5_trichotomy`(Res 符号規約に注意: 本紙の Delta は Res 直、標準 disc と符号・首係数因子が異なる) |
| T6 | 581–592 | "routine analysis" (l.581)、Table 3 停留点解析 (l.583–589) → D6 >= 0 → DeltaF <= 0 → 実根がちょうど 1 は不可能 (l.591–592) | [B]警 | `T6_D6_nonneg`(結論は真の見込み [要MC+SOS]。印字論法は非有界領域で不十分) |
| T7a | 594–603 | DeltaF=0 の四分岐 (l.594–600) のうち sym 因子 = 0 の三ケース → 対称四次式は rational-derived になれない (l.601–603) | [A]? | `T7a_symmetric`(外部補題。BM 内の出典節を特定し依存ノード化) |
| T7b | 603–608 | 第四分岐 D6=0 → Delta(f')=0(∵ Delta(f')=-16 D6、l.605 [MC] 既済: 真)→ f' 重根 → 四根相異に矛盾 (l.606–608) | [A] | `T7b_D6zero` |
| T8 | 609–614 | DeltaF<0 のみ残る (l.609)。"DeltaF = 2^8 (sym)^2 Delta(f')^3" (l.611); DeltaF が -square でない → f' 三有理根なし (Thm 4) (l.612–613); "Conversely ... leading to three distinct roots ... as expected" (l.613–614) | [C]警 | `T8_square_class`(前係数は T4 と紙面内不整合 → P6。逆向きは non-sequitur → P4) |
| T9 | 615–623 | "Previously one may have thought" (l.615) ... "The result of all the previous work shows that the latter class is empty" → "we have proven" (l.622–623) | 警 | `T9_bridge`(**ここが埋まらない、が予測** → P2) |
| T10 | 624–632 | Theorem 7 の陳述: D*(4)、曲線 E: z^2 = w(w-6)(w+18) (l.630) | 陳述 | `T10_statement`(陳述忠実性のみ。証明対象は T0) |

構造メモ(写経設計に効く事実、Phase B で kernel 化): F = f + c ゆえ **F' = f', F'' = f''**。
よって T2 の「F is rational-derived」のうち導関数条件は f から**遺伝**し、新規内容は「F の根がすべて有理」
= 「x_min 重根(所与)+ r,s が有理」**のみ**。

---

## 事前登録(Phase B 着手前凍結。kernel の判定と突合する予測)

- **P1(密輸の住所と形)**: 穴は T2。しかも遺伝構造により、T1 の設定の下で
  `T2_assumption <-> T0_claim` が **std-3 の定理として証明可能**と予測する。
  循環そのものを kernel 定理にするのが写経の終着形。
- **P2(止まる段)**: T9。T1, T3–T8 から T0 への導出は存在せず、kernel は T9 で止まる。
  T2 を仮定に入れれば全体は通る(が、それは循環 P1 の再演)。
- **P3(f'' 不使用)**: T1–T9 のいかなる段も f'' の分裂を使わない。写経が f'' 仮説なしで
  コンパイルされることで、grep 実測 [MC] から kernel 事実へ昇格する。
- **P4(T8 の逆向き)**: "Conversely, if DeltaF = -square ... leading to three distinct roots" は
  non-sequitur(Delta(f') が -square は Galois が A3 以下、C3 既約を排除しない)。ただし**荷重していない**
  (f' の分裂は仮定から出るため、この段は導出でなく整合性確認)。孤立化 [C]。
- **P5(T6 の論法)**: 停留点 + 二値の確認は非有界領域の大域非負性を導かない(無限遠挙動の欠落)。
  結論 D6 >= 0 自体は真と予測 [要MC](Res 符号規約で D6 = disc(f')/4 >= 0、実四根 + Rolle)。
  自前補完(SOS 証明書 or 実閉体判定)を明示タグで入れる。**短報の副次的所見候補**。
- **P6(誤植の住所)**: T4 の -2^12 (l.568) と T8 の 2^8 x (-16)^3 = -2^20 (l.611+l.605) は紙面内で不整合。
  セッション記録は DeltaF = -2^12 sym^2 D6^3 を [MC] 真としており、T8 前係数が誤植と予測。Phase C で再確認。
- **P7(K 負制御)**: 実埋め込みを持つ一般の体の上で写経する。T1, T3–T8 は体一般(+順序)で通り、
  T9 は通らない — Stroeker の実在物(BMThm7GapK.lean [P])が透過制御になる。
  もし T9 まで全段通ってしまえば偽命題の証明 = 写経の不忠実の証拠(s55c の負制御と同思想)。

## 成功判定と予算

- 完成 = T0–T10 の各段が [A]/[B]/[C]/[D]/[ID] の判定と Lean 対象を持ち、止まった段が [OPEN] 命題 P として
  凍結され、P1/P2 予測と突合済み。地形図(session_2026-07-16c RESULTS.md §2–10)との接続を一節書く。
- 予算: 2 セッション。超過時は報告して判定を仰ぐ(撤退・継続は Dr. Fukui 専決)。
- 三点照合: 各 [ID] 段は Magma + Sage の二系統検算後に形式化。荷重段は Wolfram を足して三方。
