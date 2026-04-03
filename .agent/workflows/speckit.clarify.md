---
description: "Spec Kit+: ask clarifying questions + record assumptions for a spec."
---
1) Identify target spec directory (same logic).
2) Read: `spec.md`, `plan.md` (if exists), `tasks.md` (if exists).
3) Produce a prioritized list of clarifying questions grouped by:
   - Product/UX
   - Data model & migrations
   - API contracts
   - AuthN/AuthZ & roles
   - Edge cases & failure modes
4) Also produce “Default assumptions if unanswered” (explicit and testable).
5) Write `<SPEC_DIR>/clarify.md` containing:
   - Questions (numbered, priority P0/P1/P2)
   - Assumptions (bullets)
   - Decisions needed (who decides / by when)
6) Ask the user to answer P0 questions; if user refuses, proceed using the default assumptions and note them in `spec.md` as an “Assumptions” section.
