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

## TODO（未転記・未更新）

- CITATION.cff 更新（新タイトル・URL。version/DOI は release 凍結時）
- Guy 2P–5P スクリプトの特定・追加（執筆と往復で確定）
- `paper/` — Phase W 成果物

## 受入ゲート（この commit を push する前提条件）

`lake build`（Thm7Prime + Gap）成功 → `lake env lean` で Gap 二枚個別検査 → `#print axioms` が gap 側の白ノードを除き std-3 → その記録を kernel_audit として残す。
