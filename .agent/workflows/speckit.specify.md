---
description: "Spec Kit: create/update a feature spec (like /speckit.specify)."
---
1. Treat the user's text after `/speckit.specify` as the Feature Description. If it's empty, ask for it.
2. Ensure Spec Kit exists:
   - If `.specify/` is missing, run: `specify init . --ai gemini --force --ignore-agent-tools`
   - Ensure scripts are executable: `chmod +x .specify/scripts/bash/*.sh`
3. Run ONCE from repo root and capture JSON output:
   - `./.specify/scripts/bash/create-new-feature.sh --json "$FEATURE_DESCRIPTION"`
4. From that JSON, extract:
   - `BRANCH_NAME`
   - `SPEC_FILE` (path to spec.md)
5. Open `.specify/templates/spec-template.md` to understand required sections.
6. Write the filled spec content into `SPEC_FILE` using the template structure.
7. Respond with:
   - branch name
   - spec file path
   - “ready for /speckit.plan”
