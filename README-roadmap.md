# Roadmap Milestones & Placeholder Owner Labels

This PR adds a roadmap YAML and a script to create GitHub milestones and placeholder owner labels for the `N0th1ngless/btsc-risk-register` repository.

Files added:
- `roadmap_milestones.yml` — the roadmap and milestone definitions used by the script.
- `.github/scripts/apply_milestones.sh` — script that uses the GitHub CLI (`gh`) to create owner placeholder labels, create milestones, and attach owner placeholder labels to issues.

Why this PR
- Owners were not available as GitHub usernames. We use placeholder labels (owner:<role>) so you can assign accountability without needing actual GitHub user handles.

How to run
1. Install and authenticate the GitHub CLI: `gh auth login` (use an account with repo admin permissions).
2. Make the script executable and run it:

```bash
chmod +x .github/scripts/apply_milestones.sh
bash .github/scripts/apply_milestones.sh
```

Notes and security
- The script uses the authenticated `gh` session. Be mindful to run it with an account that has appropriate rights.
- Replacing `owner:<role>` labels with actual usernames is a manual step. After labels are applied you can update issues to add assignees.

Acceptance criteria for this PR
- Files added and linted (YAML valid, script executable).
- Instructions clear in README-roadmap.md.
- The repository contains a reproducible script to create the milestones and placeholder owner labels.