---
description: "Spec Kit+: convert tasks.md into GitHub issues (via gh CLI script)."
---
1) Identify target spec directory (same logic).
2) Read `<SPEC_DIR>/tasks.md`. Extract tasks:
   - Each task must yield: Title, Purpose, Files touched, Endpoints, Done-when.
3) Create `<SPEC_DIR>/issues.sh` that uses GitHub CLI (`gh issue create`) to create one issue per task.
   - Issue title format: `[<SPEC_NAME>] <TASK_TITLE>`
   - Body includes Purpose, Files, Endpoints, Done-when, and link to spec dir path.
4) If `gh` is not installed or not authenticated, do NOT attempt to create issues. Instead:
   - output the script path + instructions: `bash <SPEC_DIR>/issues.sh`
5) If `gh` is installed and authenticated, ask the user if they want you to run the script now (issue creation is a side-effect).
