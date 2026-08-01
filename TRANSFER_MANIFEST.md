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

## TODO（未転記・未更新）

- CITATION.cff 更新（新タイトル・URL。version/DOI は release 凍結時）
- Guy 2P–5P スクリプトの特定・追加（執筆と往復で確定）
- `paper/` — Phase W 成果物

## 受入ゲート（この commit を push する前提条件）

`lake build`（Thm7Prime + Gap）成功 → `lake env lean` で Gap 二枚個別検査 → `#print axioms` が gap 側の白ノードを除き std-3 → その記録を kernel_audit として残す。
