---
description: "Spec Kit: generate tasks.md from plan.md (like /speckit.tasks)."
---
1. Identify target spec directory (same logic as /speckit.plan).
2. Read:
   - `spec.md`
   - `plan.md`
3. Ensure `tasks.md` exists:
   - `cp .specify/templates/tasks-template.md <SPEC_DIR>/tasks.md` (if missing)
4. Replace `<SPEC_DIR>/tasks.md` with an actionable task list:
   - grouped by user story/phase
   - dependency-ordered
   - include files touched + endpoints
   - mark parallel tasks with [P]
   - “done when” per task
5. Respond with “ready for /speckit.implement”.
