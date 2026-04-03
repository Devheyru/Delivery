---
description: "Spec Kit: generate plan.md for a feature (like /speckit.plan)."
---
1. Identify target spec directory:
   - If user provides a path (e.g. `.specify/specs/001-foo`), use it.
   - Else, pick the most recent folder under `.specify/specs/`.
2. Read:
   - `spec.md`
   - `.specify/memory/constitution.md` (if present)
3. Ensure `plan.md` exists:
   - If `.specify/scripts/bash/setup-plan.sh` exists, run it.
   - Else copy template: `cp .specify/templates/plan-template.md <SPEC_DIR>/plan.md`
4. Update `<SPEC_DIR>/plan.md` with:
   - dependency-ordered implementation plan
   - file-level changes
   - migration ordering
   - test strategy
5. Respond with the spec dir path + “ready for /speckit.tasks”.
