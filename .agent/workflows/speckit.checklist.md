---
description: "Spec Kit+: generate an execution + QA + PR checklist for a spec."
---
1) Identify target spec directory (same logic as `/speckit.analyze`).
2) Read: `spec.md`, `plan.md`, `tasks.md`, and `.specify/memory/constitution.md` if present.
3) Create `<SPEC_DIR>/checklist.md` with:
   - Build checklist (dev steps, migrations, env vars)
   - Testing checklist (unit/integration/e2e, edge cases)
   - Security checklist (authz, input validation, secrets)
   - Observability checklist (logs/metrics/alerts)
   - Performance checklist (N+1, caching, payloads)
   - Release checklist (rollout plan, rollback, data backfill)
4) Ensure every checklist item maps back to either:
   - an acceptance criterion from spec.md, or
   - a task in tasks.md, or
   - a rule in constitution.md.
5) Output: the path to `checklist.md` + 5 “highest risk” items to do first.
