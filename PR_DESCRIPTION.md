```markdown
Roadmap Milestones & Placeholder Owner Labels

This PR adds:
- roadmap_milestones.yml — roadmap and milestone definitions.
- .github/scripts/apply_milestones.sh — creates owner:<role> placeholder labels and milestones.
- README-roadmap.md — instructions to run the script.
- .github/scripts/add_reviewer_placeholders.sh — creates reviewer:<role> placeholder labels and attaches them to this PR.

Requested reviewers (placeholders):
- reviewer:IT_Lead
- reviewer:Lab_Ops
- reviewer:Analytics_IT
- reviewer:Supply_Ops
- reviewer:Donor_Mgmt
- reviewer:Logistics
- reviewer:Field_Ops
- reviewer:Program_Lead
- reviewer:Legal
- reviewer:Clinical_Lead
- reviewer:Repo_Admin

Notes:
- These are placeholder labels only (not GitHub accounts). Replace them with actual GitHub handles and add assignees when available.
- To apply owner placeholders & milestones: run `.github/scripts/apply_milestones.sh` (requires gh auth and repo admin rights).
- To add reviewer placeholders to the PR: run `.github/scripts/add_reviewer_placeholders.sh`.
```