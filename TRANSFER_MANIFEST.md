# TRANSFER_MANIFEST — rd-quartics-classification への転記来歴

Seed: `rd-quartics-thm7prime` @ main（git 履歴ごと clone、2026-08-01、logos）。
以下は seed に**追加**した全ファイルの三つ組（出典・md5・変換）。出典は release tag 固定の raw URL（immutable）。

## Gap/（出典: rational-derived-audit @ v1.2.0 /certificates/）

| dest | origin | md5 | 変換 |
|---|---|---|---|
| Gap/BMThm7Gap.lean | certificates/BMThm7Gap.lean | ed3374b360169103b7a7973b05575342 | なし |
| Gap/BMThm7Transcript.lean | certificates/BMThm7Transcript.lean | d2784dd4d5b4ff42aba4f1a3a8f30981 | なし |
| Gap/ADJUDICATION.md | certificates/ADJUDICATION.md | 25dc0766dd6d4517d1c68448557f249b | なし |

## scripts/rank/（出典: rational-derived-audit @ v1.2.0 /audit/）

| dest | origin | md5 | 変換 |
|---|---|---|---|
| m33.sage / m33.log | bm2000_audit/ | d12cade47c0cd179e68201edd3f23adc / 4e35f1f4773d18ae5312aae357b092d5 | なし |
| rank_tables.sage / .log | bm2000_audit/ | 73aeebae85ebdf439dae3d0de6a52e74 / bc3acf2a880be98b4bfd8b309cf9b443 | なし |
| rank_unruly.sage / .log | bm2000_audit/ | 30ae740b5edbb0580c11d8753eb712d0 / 8d954eedbdb48338f300a33d5823c57d | なし |
| s16_rank1.sage | stroeker_audit/ | d31a9c6e05617995fae2bce1ecf6fc42 | なし |
| s17_rankbounds.sage | stroeker_audit/ | 9392ea993c4399599ab7b64d1bdb8fb0 | なし |
| s21_ex41rank.sage | stroeker_audit/ | 7ffbb895fb55b4c5c2ec8232ce4ae479 | なし |
| s23_anrank.sage | stroeker_audit/ | f814995c3973715ee06b378677fdeef0 | なし |

## 新規・変更（seed 由来でないもの）

- `Gap.lean` — 新規（Gap.BMThm7Gap / Gap.BMThm7Transcript の import 二行）
- `lakefile.toml` — defaultTargets に "Gap" 追加、`[[lean_lib]] name = "Gap"` 追記
- `README.md` — 全面置換（出典: 金庫 submission_regs_AFM_20260801/repo_staging/README_draft.md、変換: `gap/`→`Gap/` の sed のみ）

## 追記 2026-08-01（同日第二便）

- Gap/BMThm7Boundary.lean — 出典: 金庫 qderived/bm_thm7_gap/repo/BMThm7/（audit-repo 未収録、本 repo で初公開）md5 b238bdf459c242ad90bb0f621ad64ac7、変換なし
- Gap/BMThm7GapK.lean — 同上、md5 607ec2377deaea1739d8aeb1a453d743、変換なし
- 検証: fetched 済み二枚と gap repo 版は md5 完全一致（正典整合確認済み）
- blueprint 五章合流: 01_provenance / 02_transcript（gap 側そのまま）、03_repair（旧 thm7.tex、章ラベル付与）、04_boundary / 05_obstacles（gap 側 03/04 を 7′ 成立後の枠組みで改訂: 冒頭一文・W1 顛末・W5 外部性明確化）
- web.tex / print.tex: 新 repo URL・新タイトル・五章 include
- blueprint/lean_decls: 19 + 44 → 63 名（和集合）、checkdecls 通過

## 追記 2026-08-02（Phase A-1 敵対的再読の修正、claude.ai/logos）

敵対監査（新context独立）で確認した誤りの修正。監査記録 = kernel_audit/20260802_phaseA_audit.md
（20260801_merge_audit.md を supersede: 旧記録は GapK/Boundary 追加前に固定・thm7prime_of_forward 行が途絶）。

| file | 変換 | 新 md5 |
|---|---|---|
| Gap/BMThm7Transcript.lean | docstring の行アンカー訂正 2 箇所のみ（D6: l.572-577→l.572-576 / deltaFp: l.605→l.606）。定理・定義・証明は不変。再監査 std-3 | ce4d7732c5fd663de325d82cefe8df06 |
| Gap/BMThm7Boundary.lean | #print axioms を全 14 宣言に補完（末尾ブロックのみ）。定理・定義・証明は不変。再監査 std-3 全数 | 0c06f2fb37cf0d7596719321093f1718 |
| blueprint 01_provenance.tex | 第二引用アンカー l.554--558 → l.553--558（引用冒頭 "We" は原文 l.553 末尾） | - |
| blueprint 02_transcript.tex | D6 表示アンカー l.572--577 → l.572--576（l.577 は空行） | - |
| blueprint 04_boundary.tex | Q4_factor 補題文を kernel 恒等式のみに切詰め、squarefree/既約/genus-0 等は補題外の散文へ [MC] 帰属で移設 | - |
| blueprint 05_obstacles.tex | W2「mining record accompanies the repository」を実在所在（companion archive、repo 外）へ訂正／W5 の構文破断 "has ... carries" を修復／W1 の不在主張を検索記録形へ | - |
| README.md | paper/ を「in preparation」に、Guy 2P-5P scripts を「will be added with the manuscript」に（先行主張の解消） | - |

注: 上記により blueprint 01/02 は gap repo 版と byte-identical ではなくなった（意図的訂正・本表が来歴）。
Gap/BMThm7Gap.lean / BMThm7GapK.lean / ADJUDICATION.md / Thm7Prime/Master.lean は非接触（md5 不変）。

## 追記 2026-08-02b（Option ii: Thm7Prime/Fidelity.lean 新設）

Gate form の statement fidelity を kernel 化（RD211 <-> 自然形 Polynomial.Splits、全 14 宣言 std-3）。
外部レビュー（異系統 AI、Phase A-2 便 1）が突いた「gate form は多項式性質と繋がっていない」攻撃面の恒久閉鎖。

| file | 来歴 | md5 |
|---|---|---|
| Thm7Prime/Fidelity.lean | statement 凍結 = claude.ai（金庫 Fidelity.STATEMENT_FREEZE_20260802.lean, md5 24b2d98d）／tactic = CC job fidelity_20260802（単線・28m28s）／独立監査 = claude.ai run_lean（記録 kernel_audit/20260802_fidelity_audit.md）。凍結照合: 15 セグメント逐語一致 | a4a2244fa5f220b4abdd9360cf5a8dc6 |
| Thm7Prime.lean | import Thm7Prime.Fidelity 追加（1 行） | - |
| blueprint/lean_decls | Thm7Fidelity 14 名追加（63→77、checkdecls 77/77 pass） | - |
| blueprint 03_repair.tex | 「Statement fidelity in the kernel」節追加（def:naturalrd / thm:fidelity、両 \leanok） | - |
| README.md | Statement form 段落を kernel 化後の文面へ、定理対応表に rd211_iff_natural 行追加 | - |

## 追記 2026-08-02c（Phase A-2 便2 = gpt5.6 レビューへの採用修正）

叙述が証明済み範囲を越える箇所の scoping pass ＋ 検証インフラ強化。数学・Lean 本体は非接触
（Master md5 不変 a1b1d545）。仕分け記録は金庫 SUBMISSION_PLAN 参照。

- blueprint 04: 章題「hangs from」→「the open sector and Conjecture 1」／「exact upper boundary」→
  「precise sufficient input」／thin⇒機構なし・twist無限⇒descent不能の非帰結を assessment 形へ／
  結語に「sufficiency のみ証明・necessity 非主張」を明文化
- blueprint 05: 「present artifact is std-3 throughout」の偽を訂正（main-line 限定＋rank_E576i2 明示）／
  「permanent under W1」→「W1 が立つ限り」／冒頭の「located the remaining open content」を精密化
- blueprint 01: 「every known route」→「known to us」／transcript-fidelity は人間判断であり kernel 定理
  でない旨の限定文を追加
- README: 「classification」の意味を明文化（正規化族の像特徴付け＋caseA kernel 橋）／「exact polynomial
  identities」→「certificates + elementary field/order reasoning」／lake build を第一検証コマンドに／
  主定理の Lean 文を Master から機械抽出で逐語掲載／Master 内 stale コメント（[OPEN] 等）は凍結下保持・
  公理報告が正である旨を明記／archive 非ビルド・rc toolchain 理由
- CITATION.cff: 旧 repo 指し（旧題・旧URL・v1.0.0）を現 repo に全面更新（version/DOI は release 凍結時）
- CI: 「Axiom footprint audit」step 新設 — sorryAx 不検出・公理 allowlist
  {std-3, Thm7Statement.rank_E576i2}・thm7prime / rd211_iff_natural の厳密 footprint を機械 assert
  （門は散文でなく機構に。ローカルで判定ロジック実走検証済み — BSD grep の空代替分岐バグを一つ潰した）
- scripts/CERTIFICATES.md 新設: 証明書↔生成スクリプト対応と全 18 ファイル md5（gate 恒等式の生成
  transcript は非保持である事実を明記 — kernel 検査が record の保証）

## 追記 2026-08-02d（Master 凍結の裁定付き修正 — stale docstring 訂正）

Dr. Fukui の裁定により Master.lean の凍結を docstring/コメント層に限り一時解除し、完成状態と矛盾する
stale 記述 4 箇所を訂正（Thm7Forward の [OPEN]/rank-1 記述、§6 見出し、RankOneE docstring、
WP1/WP3 splice docstring — 全て historical/superseded 標記へ）。**定理文・証明・axiom 宣言・#print 行は
一字も不変**。凍結ヘッダに修正来歴を追記。md5: a1b1d54566481b50bd0ce3667c2ee509 →
4966eaaf05a610ed5039a3a06f539412。再監査: 全宣言 footprint 従前と同一（std-3 ＋ 開示公理 2 宣言のみ）。

## 追記 2026-08-02e（Option ii 第二弾: Thm7Prime/Classification.lean 新設）

一般 (2,1,1) 分解四次式の大域アフィン分類橋を kernel 化（12 宣言、全 std-3）。頂点 =
`classification`（RDPoly f <-> <X*> 同値で Q a, RD211 a）と `classification_by_curve`
（thm7prime 経由で 576i2 の有理点表示）。gpt5.6 レビュー Point 1（最重要ブロッカー）への恒久回答。

| file | 来歴 | md5 |
|---|---|---|
| Thm7Prime/Classification.lean | statement 凍結 = claude.ai（金庫 Classification.STATEMENT_FREEZE_20260802.lean, md5 24da89e1）／tactic = CC job classification_20260802（単線・約11分）／独立監査 = claude.ai（記録 kernel_audit/20260802_classification_audit.md）。凍結照合: statement 層 13 セグメント逐語一致・宣言 15=15。逸脱記録: 証明 2 本が項形式（:= by の字義から逸脱、命題は無傷 — 精密化した検査器で検出） | ad676da3726f2968554b3d17c31438d2 |
| Thm7Prime.lean | import Thm7Prime.Classification 追加 | - |
| blueprint/lean_decls | Thm7Classification 12 名追加（77→89、checkdecls 89/89 pass） | - |
| blueprint 03_repair.tex | 「The affine classification」節追加（def:affequiv/isp211/rdpoly・thm:classification・thm:classcurve、全 \leanok） | - |
| README.md | repair 節を大域分類の kernel 化後の文面へ、対応表 2 行追加 | - |
| .github/workflows | axiom audit の対象に Classification 追加＋classification_by_curve footprint assert | - |

## 追記 2026-08-02f（Phase A-2 便3 = gpt6.5 再レビューへの採用修正）

判定 major revision・前回中心批判の明示的撤回を受けた精度パス。詳細仕分けは金庫 SUBMISSION_PLAN。

- Gap/STEPS.md 転記（金庫 bm_thm7_gap/transcript/ より、md5 3ccf4bb1620b264baece2e2e510ad283 = transcript header の凍結 pin と実機一致、変換なし）
- blueprint 02: T9 ノードの「OPEN」→「reconstructed claim, refuted below」／「It does not exist」→「reconstructed implication is false」
- blueprint 03: 「The group ⟨X*⟩」→「equivalence induced by」＋同値関係三定理の注記／classcurve と def:rdpoly の精密化（affine Weierstrass 点・pole locus・退化値 / RDPoly の次数限定注記）
- blueprint 04: 節題「terrain, machine-verified」→「Machine-verified algebraic anchors」／pairing 一致に余因子非零条件を明文化／specialization 原理と [MC] の scoping 一段落
- blueprint 05: W1 に「新規形式化 or 開示公理」の二択／W4 の断定四箇所を examined-mechanisms 形へ（題・rationally empty・therefore closed・constrains）
- Thm7Prime/Master.lean: 「safe axiom」残存 2 箇所 →「disclosed axiom」（裁定済みコメント修正権限、md5 4966eaaf→fede39b89b2706ccc9645ffdf6c24573、footprint 不変を再監査で確認）
- Thm7Prime/Classification.lean: RDPoly docstring 精密化＋ affineEquiv_trans 追加（claude.ai 直証、std-3、#print 追加、lean_decls 89→90 checkdecls 通過）
- README: 主結果の除外集合・affine 点の精密化／certificates の網羅主張を CERTIFICATES.md 参照へ／ADJUDICATION パス修正＋STEPS.md 言及／Result hierarchy 三層の明示
- CI: pull_request トリガ追加＋ Certificate hash audit step（表の全 md5 照合・未収載検出、ローカル実走 18 件 PASS 確認済み）

## 追記 2026-08-02g（裁定 (a): Ch5 分割 — W2–W5 を research-notes/ へ移設）

Dr. Fukui 裁定。blueprint Ch5 は intro（改稿）＋ W1（形式化天井、恒久）＋「Dated computational
records」節（移設先ポインタ）＋ Reading the map（微修正）に縮約。W2–W5（時点依存の計算記録:
測定 fibre・進行中 descent・cover 機構調査・companion の公理 footprint）は
`research-notes/2026-08-02-arithmetic-walls.md` へ日付付きで逐語移設（LaTeX→md 変換、\ref は
定理名直書き化、reopening gate 全保持）。W4 の数学的内容は Ch4 に残存（移設は wall 形式のみ）。
Conjecture1_normal の定義ノードは 04_boundary 在住で参照無傷を確認。lean ノード機構の損失ゼロ
（leanok/lean{} は Ch5 に元々不在）。

## 追記 2026-08-02h（裁定 (b): Gap/BMThm7FunctionField.lean 新設 — Ch4 [MC] 段の kernel 化）

Dr. Fukui の「先延ばしのメリットは？」への偵察が着工判断に転化した件。偵察の決め手 = Boundary.lean
ヘッダー自身が σ₃=0 チャート（c = -ab/den が (a,b) に有理従属）と明記 → ℚ(S) = ℚ(a,b) は定義的で、
私の「Fidelity 級以上」見積りは中央値的過大だった。実測: statement 設計〜監査完了まで一時間弱。

16 宣言、全 std-3。構成: ℚ[a,b] = Polynomial (Polynomial ℚ)、evalAB 環準同型（specialization 原理 =
map_pow + sq_nonneg）、UFD 整閉性による平方降下（square_descent）、Boundary 負値証明書八本を橋渡しで
消費する八つの非平方性定理。レビュー三便の「特に危険な箇所1」への恒久回答。

| file | 来歴 | md5 |
|---|---|---|
| Gap/BMThm7FunctionField.lean | 凍結 = FunctionField.STATEMENT_FREEZE_20260802.lean（md5 f90b27e6）／CC job functionfield_20260802（単線・約7分）／独立監査 = kernel_audit/20260802_functionfield_audit.md。凍結照合 17 セグメント逐語・宣言 26=26 | e228005c7562e4e49efb5c7f88d84efe |
| Gap/BMThm7Boundary.lean | ヘッダー「remains [MC]」→「kernel-proved in BMThm7FunctionField.lean」（裁定済みコメント修正区分、再監査 footprint 不変） | 2f94c36ce43349bd0b90a6b5988a0a72 |
| Gap.lean / blueprint/lean_decls | import 追加／+16（90→106、checkdecls 全通過） | - |
| blueprint 04 | 本日の scoping 段落を kernel 化後の記述へ上書き＋ノード 3 追加（spec_principle・sq_descent・covers_nonsquare、全 leanok） | - |
| .github/workflows | axiom audit 対象に FunctionField 追加 | - |

## 追記 2026-08-02i（Certificate hash audit 初回 CI が実在の穴を検出）

新設の Certificate hash audit が初回 CI 走行で fail — 原因は LaTeX 用の包括 `*.log` ignore 規則が
`scripts/rank/` の Magma 証明書ログ三本（m33.log / rank_tables.log / rank_unruly.log）を未追跡にして
いたこと。table はローカル現物から生成済みで三本を収載、CI checkout に実体なし → MISSING。
門が「repo が主張する証明書の実在」を機械検問した最初の実例。処置: `.gitignore` に
`!scripts/**/*.log` の再包含を追加し、三本を追跡下へ（md5 は収載値と一致、内容変換なし）。

## 追記 2026-08-02j（便4 = gpt 再々レビューへの対応: SquareClass kernel 化＋精度・provenance 一括）

便4 判定 = 中心定理 accept 相当・repo 全体 major revision・公開準備度 7.5。必須三点のうち (1)(2) を実施:

**(1) Gap/BMThm7SquareClass.lean 新設（4 宣言、全 std-3）** — 便4 の中心指摘「ℚ(a,b) の非平方性は多二次拡大
L = K(√Rq,√Sq) へ自動では移らない」への定理による回答。step（一段補題: 退化時は σ が基礎体に落ちて吸収）、
biquadratic_transfer（{1,ρ,σ,ρσ} 張成元の平方 → x/xr/xs/xrs のどれかが K で平方、master case split で退化全吸収）、
応用二本（FunctionField 八定理を消費、任意の拡大体 M を量化——ℚ(S) のモデル選択を前提しない）。
凍結 = SquareClass.STATEMENT_FREEZE_20260802.lean（md5 d743c715）、CC 逸脱記録 = scratch ファイル一時作成
（自己申告・現存せず）。監査 = kernel_audit/20260802_squareclass_audit.md。md5 = ea31047a51eb436f76cc2c0725d44fd0

**(2) T9 stale 全掃討** — Ch2 冒頭「two open propositions」訂正・ADJUDICATION の [OPEN]/「does not exist」訂正。

**精度・provenance 一括（便4 採用群）**: Ch2 highest-local-minimum の代数的述語限定／Ch4 claim-label 体系
[K]/[C]/[M]/[A] 導入＋genus・square class・admissible・thin（Hilbert 適用条件明文化）・[A] 標記・smallest field 訂正／
被覆結論を三層化（[K] 拡大体非平方まで → [M/C] ℚ(S) 同定 → [M] 既約性）／Ch5 permanent→standing ceiling・
only-known→currently-developed・reopening gate に local 形式化・polynomial identities 緩和／Classification docstring
の exceptional loci 訂正＋ **Setoid インスタンス追加**（affineSetoid、std-3、lean_decls 111）／Master「neither
provable nor refutable」→「not proved at the pinned mathlib」（裁定済み区分、md5 → a8a919a60f68dcc63b82b58cc7dbde0d）／README relation 表現・
build 対象修正／**CERTIFICATES.md SHA-256 主化＋rank ログ三本の正直な Status**（m33 rigorous／rank_tables 部分・
末尾 traceback／rank_unruly 三体 analytic のみ）＋two-system 文言の適用範囲限定／**CI: cert audit SHA-256 化・
deploy を main push 限定・permissions を job 限定・audit 対象に SquareClass**／**Gap/PROVENANCE.md**（BM2000 書誌・
STEPS/ADJUDICATION SHA-256・内部セッション名の公開的意味）／**AI_PROVENANCE.md**（責任分界一元化）／Ch1 に
preregistration = methodological audit trail の framing。却下: Master 分割・Actions SHA pin（Phase F 項目）。

## 追記 2026-08-02k（便5 = 84/100 への対応: Ch4 証拠管理の全面整備）

便5 判定 = 中心定理 accept 近接・Ch4 の証拠管理のみ major。P0 四点＋P1/P2 採用分を実施:

**(1) Ch4 [C] 主張の公開 artifact 化（−7 の解消）** — 親セッション 2026-07-16c の原 Magma スクリプト三本＋
採取ログ五本を scripts/terrain/ へ転記（provenance は Gap/PROVENANCE.md の session 名規定で公開的に確定）。
**新規 terrain_crosscheck.sage 作成・実走**（Sage 10.8, 2026-08-02, 全 CHECK True・採取ログ込み）: I1/I2・
Q4=F1F2F3 squarefree・Fi 既約 genus 0・明示パラメータ化・八非平方・Rq square / Sq class 12 per 成分・
Sq 有理零点の不変形判定（F1 は零点なし、F2/F3 は (0,0)=den 0 のみ→全て退化点）・gcd(Fi,RqSq)=1・
pairing 恒等式・witness。現行二系統 = 原 Magma（V2.29-7）＋新 Sage。CERTIFICATES に Ch4 claim map
（主張×script×log×status の対応表）を新設、全 28 行に Status 完備、rank_E576i2 の Sage 側を
rank_tables.log 冒頭 PASS 行として明示。

**(2) B/S 体系の正式定義** — Ch4 に「The chart, the surface, and the covers」節: B=(a,b) チャート・
K(B)=ℚ(a,b)・S=splitting cover・K(S)=ℚ(a,b)(z,w)（定義として多二次拡大）・基底 {1,z,w,zw} [M]・
span[K]/基底[M] の境界明示（multiquad_verdicts ノード本文は span 形に限定、拡大体到達は節外の [M] 注記へ）。

**(3) 三被覆対応表** — disjunct×cover×radicand×exclusion の表: C0 radicand=Q4（I1 [K]）、C± は共に
norm 判定（N(γ)=−8s1n²Q4 = I2 [K]）経由で −2Q4 [M]。三被覆・二平方類・一 sextic。

**(4) Hilbert 幾何学的既約性命題** — prop:geomint 新設: Q4=F1F2F3 各一乗 [C]＋gcd(Fi,RqSq)=1 [C] →
奇 valuation が ℚ̄(S) まで保存 [M] → Q4,−2Q4 ∉ ℚ̄(S)^×2。thin 括弧書きの参照を covers_nonsquare →
multiquad_verdicts＋prop:geomint に更新（便5 指摘 4 の参照齟齬解消）。Sq 零点文言を不変形に更新。

**P1/P2 一括**: 依存固定（lakefile checkdecls rev pin・Actions 四本 full SHA pin・ubuntu-24.04）／README
theorem map に新 kernel 五行／research-notes の stale（Ch.5→Ch.4、二重置換、生 \section）修正／
Classification ヘッダー（relation 表現・RDPoly 記述）修正＋三 Lean ファイルに AI_PROVENANCE 参照行
（ヘッダー保持方針は維持、md5: Classification=c3626ad6bf429f2fd101d86948a33e8c, FunctionField=39def1f0d6a7eddf9dec07af5e103407, SquareClass=89362d209c124656529a3f16883b0a49、footprint 再確認
14/16/4 std-3）／PROVENANCE の kernel 役割文を正確化。却下（既裁定・記録）: span の Lean 拡大体化は
Phase W 選択肢、line-pinned links・CITATION/DOI は Phase F。

## TODO（未転記・未更新）

- ~~CITATION.cff 更新~~ → 済 2026-08-02c（version/DOI のみ release 凍結時）。第三者監査の operative な根拠は本 repo の public hash；金庫参照は補助来歴
- Guy 2P–5P スクリプトの特定・追加（執筆と往復で確定）
- `paper/` — Phase W 成果物

## 受入ゲート（この commit を push する前提条件）

`lake build`（Thm7Prime + Gap）成功 → `lake env lean` で Gap 二枚個別検査 → `#print axioms` が gap 側の白ノードを除き std-3 → その記録を kernel_audit として残す。
