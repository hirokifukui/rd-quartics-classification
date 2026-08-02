# PROVENANCE.md - public provenance chain for the Gap audit (Chapters 1-2)

Date: 2026-08-02 (ISO).  Authoritative anchors are the hashes below together with
the public git history of this repository; internal session names appearing in
file headers (e.g. `session_2026-07-16c`) are working labels whose public meaning
is exhausted by this file.

## Source under audit

Buchholz, R. H. and MacDougall, J. A., *When Newton met Diophantus: a study of
rational-derived polynomials and their extension to quadratic fields*,
J. Number Theory 81 (2000), 210-233.  Section 2.2 (Theorem 7 and its proof) is
the audited passage; blueprint line anchors (l.553-558, l.568, l.606, l.611,
l.615-623) refer to the working plain-text layout extraction of that paper.
The source text itself is not redistributed here (copyright); the layout
extraction is pinned by md5 `a177e2e673705c0d68cc5fdf3a6626ce` in the working
archive, and every quoted anchor is verifiable against any copy of the paper.

## Audit documents in this repository

| file | sha256 |
|---|---|
| `Gap/STEPS.md` (segmentation + pre-registration, frozen before any Lean build) | `f6de78ef24af7028375379cb52e811caa0401c6d077108d1ea95fd31f58185f7` |
| `Gap/ADJUDICATION.md` (adjudication record) | `8cf0efd3ec96280e06a261aac58f6994f98eba561a3157a5e0ac3a0fdb329d2b` |

## Status of the pre-registration

The pre-registration record (`STEPS.md`, predictions P1-P7) is a methodological
audit trail: the predictions and their confirmations were both produced within
this project.  It documents that the formal reconstruction was fixed before the
kernel results existed - a procedural transparency measure - and is not itself
independent verification.  What the kernel provides is machine verification of the stated formal
propositions; independent human verification is what any reader can perform by
re-running the build and reading the statements.
