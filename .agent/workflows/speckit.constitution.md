---
description: "Spec Kit+: create/update .specify/memory/constitution.md for this repo."
---
1) Goal: write project governing principles that will constrain future /speckit.* outputs.
2) Create or update `.specify/memory/constitution.md` with:
   - Engineering principles (clarity > cleverness; simple first; correctness; tests)
   - Security baseline (authz by default, validate inputs, least privilege)
   - DX conventions (file naming, folder structure, commit hygiene)
   - Documentation expectations (spec/plan/tasks stay source-of-truth)
   - Performance expectations (avoid N+1, pagination, indexes where needed)
3) Add these repo-specific defaults (edit as needed):
   - If using Next.js + Supabase: all Supabase access must go through Next.js API routes (web + flutter clients never talk to Supabase directly).
   - Prefer concise editor prompts; avoid huge documentation blocks in prompts; keep explanations in chat summaries.
4) If user provided extra principles after the command, incorporate them verbatim as “User-provided constraints”.
5) Output the path and a short summary of what changed.
