# AI_PROVENANCE.md - division of labour and responsibility

This project is a deliberate human-AI collaboration, declared rather than
concealed.  The in-file "statements FROZEN / tactics delegated" headers are
retained on purpose as provenance; this file states the division of labour once,
for readers of the Lean sources.

- **Mathematical responsibility**: Hiroki Fukui.  All definitions, theorem
  statements, proof strategies, and the decision to publish are his; adjudicated
  amendments to frozen files are recorded in `TRANSFER_MANIFEST.md`.
- **Statement design and freezing**: performed in the claude.ai session under
  Dr. Fukui's direction; each delegated file has a frozen statement reference
  (hash recorded in `TRANSFER_MANIFEST.md` and in `kernel_audit/`).
- **Tactic-level proof search**: delegated to headless Claude Code jobs
  (single-threaded, orchestration forbidden), which may repair proof bodies only.
- **Independent audit**: after every delegation, the claude.ai session re-runs
  `lake env lean` and `#print axioms` directly (never trusting the delegate's
  self-report), verifies the frozen statement layer verbatim against the
  reference, and records the audit in `kernel_audit/`.  Deviations found by this
  audit are recorded there (e.g. term-mode proofs replacing `by` blocks).
- **The guarantee of record** is the Lean kernel: every theorem's axiom
  footprint is printed in-source and asserted in CI.  Nothing in this file - and
  no statement about who or what wrote a proof - adds to or subtracts from that.
