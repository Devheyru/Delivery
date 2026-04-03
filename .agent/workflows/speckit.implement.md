---
description: "Implement a feature by consuming the whole Spec Kit spec directory."
---
1. Identify target spec directory:
   - Use the path in the user's message if provided.
   - Else pick the most recent under `.specify/specs/`.
2. Read ALL files in the spec directory:
   - `spec.md`, `plan.md`, `tasks.md`, plus any contracts/data-model/research docs.
3. Create (or overwrite) `<SPEC_DIR>/task.md`:
   - a checkbox checklist derived from tasks.md
4. Create (or overwrite) `<SPEC_DIR>/implementation_plan.md`:
   - group work by component/file
   - list commands to run (tests, migrations, lint)
5. Start executing tasks in order:
   - implement smallest coherent slice
   - run tests/lint
   - iterate until tasks are done
6. At the end:
   - summarize what changed
   - list commands to verify locally
   - note any TODOs/risks
