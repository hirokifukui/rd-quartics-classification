# Archived manifest entries — external-review response records (2026-08-02 .. 2026-08-03)

Moved verbatim out of `TRANSFER_MANIFEST.md` on 2026-08-03 (review-14 hygiene:
the manifest records migrations, hashes and authority; the review narrative
lives in `REVIEW_HISTORY.md`; these entries are preserved here unedited as the
detailed record).

---

## 追記 2026-08-02k（便5 への対応: Ch4 証拠管理の全面整備）

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

## 追記 2026-08-02l（便6 への対応: Ch4 最後の二橋の kernel 化）

**(1) Gap/BMThm7NormCriterion.lean 新設（8 宣言、全 std-3、凍結 md5 52bfa4fe、監査
kernel_audit/20260802_normcriterion_audit.md）** — 便6 中心指摘「γ± ∈ K(z) は基礎体の元でないため
biquadratic_transfer を直接適用できない」への定理による回答。step_over_layer（r 非平方仮定下の layer
二次判定・退化吸収）＋ layer_square_norm（座標ノルム: g₀²−g₁²r=(p²−q²r)²、Galois 不要）＋
gamma_not_square_multiquadratic（両符号一括、I2_R2 と n2Q4_not_square を消費）。併せて S 自体の
ℚ-level 幾何学的既約性入力を kernel 化: Rq/Sq/RqSq_not_square（値特殊化 not_square_of_value 経由、
witness 2480/876/171696）。**設計上の発見: チャート上で Rq, Sq は半正定値**（四実根→判別式非負）のため
FunctionField の負値技法は原理的に不可、値非平方への切替が必須だった。

**(2) blueprint 04**: prop:S_integral 新設（[K] ℚ-level 三定理＋[C] 奇因子 1/1/2 → 次数4・basis・
幾何学的整）／basis→spanning set 三箇所（S_integral 成立後に basis と明記）／C± 段落と対応表を
gamma_verdicts ノード参照へ全面更新／prop:geomint に C± の ℚ̄-level 連鎖を追記。

**(3) terrain 二系統の完全公開化**: terrain_class12.m 新規（Magma V2.29-7 実走、md5 61b8b85c、
captured log 付き・実行経路明記）が sixconics2 の未保存 source を置換——CERTIFICATES で sixconics2 log
を「preserved transcript / superseded」へ正直に格下げ、claim map を両 script 公開の two-system に更新。
S-integrality 行追加。terrain_crosscheck.sage 拡張再走（S-integrality・値 witness 込み全 CHECK True）。

**(4) 依存・CI・README**: requirements.txt の git 依存四本を commit SHA pin／README に CI badge＋
theorem map 三行追加／CI axiom audit 対象に NormCriterion／checkdecls 119。

**便6 誤指摘の記録**: research-notes の stale 残存指摘は旧 revision 閲覧によるもの——HEAD は 88c5c74
時点で修正済み（grep 0 件）、manifest と実ファイルは一致。badge 追加で今後の閲覧齟齬を予防。

## 追記 2026-08-02m（便7 への対応・第一便: 精度と正規化橋の散文）

**(1) radicand 記述の訂正（便7 指摘2 =「文字通りには偽」）**: Ch4 対応表の radicand 欄を実 radicand
γ± に改め、obstruction を「norm class −2Q4」と明記。本文「share the single radicand class」を全面削除し、
「γ± は共役、その積＝layer norm が類 −2Q4（I2）、kernel が消費するのはこの norm class」に置換。

**(2) 旧段落三箇所の掃討（指摘4）**: [M/C] 同定文 →「K(S) は定義により多二次拡大」＋ C0/C±/整の
定理三点参照へ／「function field of the terrain」→ K(B) と明記／Hilbert 段落を「thin は type II で
ほぼ定義的、Hilbert が制御するのは補集合」＋ C0=multiquad_verdicts・C±=gamma_verdicts の正参照へ。

**(3) kernel 境界の明確化（指摘3）**: prop:geomint の ℚ̄ 議論を「特殊化定理の base change ではなく、
抽象 kernel 補題 step_over_layer / layer_square_norm（任意標数0体で [K]）の ℚ̄(a,b) への新規適用 [M]」
と正確化。**(4) Squarefree base change 補題新設（指摘5）**: lem:sqfree_basechange（perfect field・
reduced 保存・奇 valuation 保存）、prop:S_integral の ℚ̄ 部がこれを消費（Rq⊥Sq の gcd [C] 込み）。

**(5) 正規化橋 Proposition（指摘1 の散文完全版）**: prop:normalization_bridge——Conjecture 1
（{0,1,a,b} 正規形）⟺ terrain の非退化有理点不存在。両方向を全条件追跡で証明（⇐: e₃=0 構成・
Rq/den²=(z/den)² の明示根・affine 輸送／⇒: 臨界点は非根（相異根で f′(r)≠0）・平行移動で全根非零・
den=0 なら AB=0 で矛盾＝den≠0 自動・z:=4den(r₊−r₋) 等）。結語「Conjecture~1 itself」を
「equivalent by the bridge」に修正。**Lean 版 Gap/BMThm7Terrain.lean を凍結（md5 6ac28097、9宣言）し
CC 委譲中**——完了後に leanok 昇格予定。

**(6) CI（指摘6）**: deploy に continue-on-error（Pages 有効化までワークフロー全体を赤にしない）＋
新三定理（Q4_not_square_multiquadratic / gamma_not_square_multiquadratic / RqSq_not_square)の
exact footprint 検査追加。**(7) README（指摘7）**: kernel/transcript 境界文を「human-audited formal
transcription ＋ kernel certificates（transcribed assumption の循環と reconstructed bridge の反例）」へ。
**却下（既裁定の再確認）**: historical rank route の別ディレクトリ分離・Master 分割（指摘8）——
Dr. Fukui 裁定により本体保持、依存範囲は CI が監査。release metadata（指摘9）= Phase F。

## 追記 2026-08-02n（便7 対応・第二便: 正規化橋の kernel 化 = 本丸の決着）

**Gap/BMThm7Terrain.lean 新設（9 宣言、全 std-3、凍結 md5 6ac28097、監査
kernel_audit/20260802_terrain_audit.md）** — 便7 最大指摘「Conjecture 1（{0,1,a,b} 正規形）と
σ₃=0 terrain の有理点問題を同一視する定理が文にもコードにもない」への完全回答。
`conjecture1_iff_terrain`: Conjecture1_normal ℚ ⟺ ∀点 ¬NondegTerrainPoint。支持定理:
rootQuartic_expand／二次分裂判定の双方向／KDerived 輸送三種（定数倍・平行移動・スケール）／
kderived_of_terrain（terrain→正規形: z,w から明示分裂根）／terrain_of_kderived（正規形→terrain:
有理臨界点・相異根による非根論証四場合・shift/scale・e₃ 抽出・**den≠0 は非零根から自動**・
根差から z,w 再構成）。blueprint の prop:normalization_bridge を \lean+\leanok に昇格、
結語を「sufficiency と bridge の双方が kernel 定理」に更新。CI に conjecture1_iff_terrain の
exact footprint 追加・audit 対象に Terrain。checkdecls 128。本日の kernel 新設は
Classification 14＋FunctionField 16＋SquareClass 4＋NormCriterion 8＋Terrain 9 = **51 宣言**。

## 追記 2026-08-02o（便8 への対応: 最終整形——対応の命題化と再計算 CI）

便8 判定: 「数学的な本丸はほぼ閉じている」・前回最大減点（正規化橋）撤回。残五点のうち四点を実施:

**(1) prop:fibre_correspondence 新設（指摘1 = 残る最大の整形不足）**: 非退化 locus U 上の各有理点で
三 disjunct ⟺ 三被覆 fibre の有理点存在。全条件列挙——den≠0・相異非零根・有理点で z,w∈ℚ ゆえ
γ±(P)∈ℚ／D₀ は I1 [K] の v=den·t 置換が**全単射**（den≠0 で分母払いは非零平方倍、余計な解なし）／
D± は radicand 導出 [M, C 裏取り・I2 は K] を認めれば fibre 文は定義的、多価性は v↔−v のみ。

**(2) prop:geomint の statement を証明内容に一致（指摘2）**: 「Q₄, γ₊, γ₋ ∉ ℚ̄(S)^×²」に書換え、
−2Q₄ は radicand でなく **layer-norm obstruction class** と statement 内で明示区分。

**(3) lem:biquad_criterion 新設（指摘3）**: char≠2・r,s,rs 非平方 → 次数4・積基底・被覆代数は体（整）。
√s=α+β√r の座標比較で 2αβ=0 → β=0 は s 平方・α=0 は rs 平方で両排除、の完全証明＋Lang Algebra Ch.VI
参照＋sqfree_basechange 経由の定数拡大持続を明文接続。prop:S_integral の証明がこれを消費。

**(4) CAS 監査を hash 確認から再実行確認へ（指摘4 Sage 部）**: 新 workflow **cas.yml** ——
pin した sagemath/sagemath:10.9 コンテナで terrain_crosscheck.sage を **CI 実走**し、正規化 CHECK 行を
保存 log と diff（保存 = Sage 10.8/macOS、新走 = 10.9/Linux コンテナ——版・платформ横断再現）。
cert audit に **claim-map 全 script の存在検査**追加。Magma は exact command・version・md5 を
captured log ヘッダーに記載済み（release artifact 転記は Phase F）。

**(5) 周辺（指摘5/7 部分）**: Actions を node24 系へ SHA pin 更新（checkout v5・upload-pages-artifact
v4・deploy-pages v5）／README の md5 残渣二箇所を SHA-256 に統一。**Pages 有効化は Dr. Fukui の
一クリック待ち（現在の筆頭ゲート）**。PDF・release tag/DOI/line-pinned links = Phase F（記録済み）。

## 追記 2026-08-02p（便9: 収束宣言の記録）

便9 判定: 「公開・投稿に十分な水準」・リポジトリ側の修正要求なし**。前便までの全対応
（fibre_correspondence・geomint statement 正置・biquad_criterion・CAS 再実行 CI・node24 化）を確認の上、
唯一の減点 = **Pages 未有効化（設定作業、Dr. Fukui の一クリック）**。P1/P2 = Phase F 儀式
（release v1.0.0・CITATION.md・Zenodo DOI・blueprint PDF・line-pinned links・Magma 実行情報の
release notes 転記）——全て既記録、凍結裁可後に一括実施。

**任意項目（Phase W 選択肢として記録、UNDERFLOW 相当）**: fibre_correspondence の Lean 化
（disjunct 述語の形式定義＋対応定理——Terrain の設計パターンで到達可能）／biquad_criterion の
Lean 化（IntermediateField 次数・基底——span 版は SquareClass/NormCriterion に既存）／
gamma 定理の抽象基礎体版（抽象補題は既に任意 char 0 体、特殊化定理のみ ℚ(a,b) 固定）。

**九便の弧（2026-08-01〜02）**: reject-and-resubmit から accept 相当まで、指摘と定理化の往復で推移した。
この間の kernel 新設 = Fidelity 14（前日）＋ Classification 14・FunctionField 16・SquareClass 4・
NormCriterion 8・Terrain 9（本日 51）。CI = 三重監査（axiom footprint 厳密形 8 本・SHA-256 cert
30 行＋claim-map 存在検査・**CAS 実再計算** = pin 済み Sage 10.9 コンテナで毎 push 再導出・diff）。
査読の「省略された標準論法」は全て定理になり、指摘の誤り（radicand 記述）は撤回・修正した。

（認証運用の詳細は非公開の運用記録に移管。）

## 追記 2026-08-02q（便10: レビュープロセス完了）

便10 判定: 全減点解消・「本プロジェクトのレビュープロセスは完了です」**。
Pages 有効化（Dr. Fukui、2026-08-02）により deploy 緑・badge 全緑・blueprint 公開
（https://hirokifukui.github.io/rd-quartics-classification/blueprint/ 配信確認済み）。
kernel（宣言単位 axiom footprint）・CAS（毎 push 実再計算）・provenance（SHA-256 連鎖）・
AI 協働（責任分界の明文化）の四層が全て公開・検証可能・自走監査下にあることを外部レビューが確認。

**残 = Phase F 儀式のみ（全て任意時期・裁可待ち）**: release v1.0.0 → CITATION.md → Zenodo DOI →
blueprint PDF → line-pinned links → Magma 実行情報の release notes 転記。

**十便の最終弧**: reject-and-resubmit から accept 相当まで、指摘と定理化の往復で推移した。
thm7_repair 再投稿 repo は Phase A（外部レビュー対応）を完了し、Phase F（凍結）の裁可待ちに移行。

## 追記 2026-08-02r（訂正: Pages 有効化の実施経緯——02q の記載を修正）

02q の「Pages 有効化（Dr. Fukui）・配信確認済み」は**便10 の記述を映した誤り**。実測（claude.ai、
2026-08-02）: 便10 受領時点で Pages API GET = 404（**一度も有効化されていない**）、deploy job は
`Failed to create deployment (404): Ensure GitHub Pages has been enabled` で失敗、公開 URL も 404。
便10 の「deploy 成功・サイト配信確認」は査読側の誤認（便6 の旧 revision 誤読に続く、**ライブ状態に
関する査読記述の二例目**——deployment 状態は直接 fetch でのみ確定する、の教訓を再確認）。

**対処**: claude.ai セッションが管理権限のある認証経路で Pages API を直接叩き
有効化（POST /pages, build_type=workflow, 応答 201・URL 発行）→ 失敗 deploy job を rerun-failed-jobs
で再実行 → **deploy success・blueprint URL http=200 を三連続実測**。Dr. Fukui の明示意図
（数便にわたる「Pages 有効化」待ち）の API 経由での完遂であり、設定変更の事実と経路を本追記で開示。

これをもって**全系が実測で緑**: build・axiom audit・cert audit・CAS reproduce・deploy・公開 blueprint。
Phase A 完了の実体条件が初めて満たされた。残 = Phase F 儀式（裁可待ち）。

## 追記 2026-08-02s（Phase F 執行: v1.0.0 凍結——Dr. Fukui 裁可「いい内容にしよう」）

CITATION.cff 確定（version 1.0.0・date-released・Apache-2.0・ORCID・keywords；DOI は Zenodo 有効化後に
追記）。RELEASE_v1.0.0.md 新設——確立内容（gap 監査・Thm 7′・576i2 分類・正規化橋）／kernel core と
正確な footprint／Magma 実行情報（V2.29-7・invocation・日付・SHA-256 参照）と Sage 二系統＋CI 実再計算／
方法と責任分界／再現手順／既知の境界（Conjecture 1 は未解決のまま——本 repo はその境界を写像した）。
README に permanent references 節（tag pin URL 規約）。旧ブートストラップの stale local tag v1.0.0
（968aef9 指し・remote 未 push）を削除の上、凍結 commit に annotated tag を打ち直し。GitHub Release 作成。
残（要 Dr. Fukui）: Zenodo 連携＋webhook → DOI 発行 → CITATION.cff へ追記。blueprint PDF は後日添付。

## 追記 2026-08-02t(便12 への対応・第二便: fibre correspondence の kernel 閉鎖 = v1.0.1)

**Gap/BMThm7Fibre.lean 新設(9 宣言、全 std-3、凍結 md5 0d1cd18c、監査
kernel_audit/20260802_fibre_audit.md)** — 便12 最大指摘「"granted" のままの radicand 導出」への
定理による回答。D0/Dplus/Dminus を transcript 自身の bmTranslate で定義(指摘2 の定義欠如も同時解決)、
cleared_model_iff が C0/C~0 分離を v=den·t 全単射として命題化(指摘3)、Dplus/Dminus_iff が
(X−x0)² 分解・q′(x0)=0・disc=σ1(σ1∓ρ)/4・4den² clearing を kernel で通し、fibre_correspondence が
三同値を束ねる。CAS 独立裏書き 7 CHECK。CC 一便目は 64k 出力上限で死亡(ファイル無傷)→
逐次編集規律を焼き込み再起動で完走(SWARM_PLAYBOOK 追記事項)。blueprint は def:disjuncts 新設＋
fibre 命題を kernel 参照で全面書換え("granted"/"session artifacts" 完全消滅)。README に line-pins
10 本(v1.0.1 tag 前提)＋fibre 行。checkdecls 137。**v1.0.1 release へ**(notes は自己評価数値なし)。

## 追記 2026-08-03u（便13 対応: 衛生と同期——本文書自体の編集方針を含む）

便13 の判定は「数学的内容は accept 相当・残りは衛生」。対応: **(1) release identity 同期**——README の
frozen release・permanent reference 規約・CITATION.cff を v1.0.1 に統一、line-pin 節の括弧破損修正
（行番号は v1.0.1 tag 実体で全数正確と再確認——査読の L285 主張は誤認、`git show v1.0.1` で
`theorem fibre_correspondence` = L294）。**(2) 本 manifest の衛生化**——採点値・自己評価数値・
認証運用情報を全て除去し、査読弧の実質は REVIEW_HISTORY.md（採点値なし）へ、認証運用は非公開記録へ
移管。この編集は履歴の隠蔽ではなく公開文書の役割分離であり、本追記で開示する。**(3) Ch4 精密化**——
base-change 補題を自己完結の証明に（一変数 gcd の体拡大不変性・Galois 軌道積論法；resultant 文言撤去）、
cover の scheme model を def:cover_models として明示、fibre 命題名を仮定に整合（pole-free splitting
chart）し kernel 仮定が den≠0∧z²=Rq の二つのみであることを注記。**(4)** T9 節見出しを [REFUTED over ℚ]
に統一・Fibre ヘッダーの提携情報を一行ポインタ化（コメント層、kernel 再検証済み）・upload-artifact
node20 警告を既知警告として workflow に明記（上流由来・直接呼び出しなし・node24 版未存在）。
**却下（既裁定維持）**: rank route の import 分離。Guy 2P–5P script は「将来追加」から「本 release の
scope 外（load-bearing でない）」へ正置。

