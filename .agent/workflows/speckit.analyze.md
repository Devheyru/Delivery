---
description: "Spec Kit+: analyze spec/plan/tasks for gaps, risks, missing steps, and ordering."
---
1) Identify target spec directory:
   - If the user provided a path, use it.
   - Else choose the most recently modified folder under `.specify/specs/`.
2) Read: `<SPEC_DIR>/spec.md`, `<SPEC_DIR>/plan.md` (if exists), `<SPEC_DIR>/tasks.md` (if exists), plus `.specify/memory/constitution.md` (if exists).
3) Produce an analysis report with these sections:
   - Summary of intent (1–2 paragraphs)
   - Gaps / missing requirements
   - Ambiguities (questions that must be clarified)
   - Risks (security, data loss, perf, DX, migrations)
   - Dependency/order check (what must happen before what)
   - Scope creep / over-engineering flags
   - Concrete fixes: propose edits to spec/plan/tasks (bullet list, with file names + what to change)
4) Write `<SPEC_DIR>/analysis.md` with the report.
5) End with “Next recommended command” (usually `/speckit.clarify` or `/speckit.checklist`).
