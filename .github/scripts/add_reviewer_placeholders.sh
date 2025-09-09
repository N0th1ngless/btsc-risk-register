#!/usr/bin/env bash
# Create reviewer placeholder labels and attach them to pull request #57
# Usage:
#   gh auth login   # authenticate with an account with repo admin rights
#   chmod +x .github/scripts/add_reviewer_placeholders.sh
#   bash .github/scripts/add_reviewer_placeholders.sh
set -euo pipefail

REPO="N0th1ngless/btsc-risk-register"
PR_NUMBER=57

# Reviewer placeholder labels (choose colors as desired)
declare -a LABELS=(
  "reviewer:IT_Lead#0e8a16"
  "reviewer:Lab_Ops#fbca04"
  "reviewer:Analytics_IT#1d76db"
  "reviewer:Supply_Ops#8a2be2"
  "reviewer:Donor_Mgmt#d73a49"
  "reviewer:Logistics#006b75"
  "reviewer:Field_Ops#bfe5bf"
  "reviewer:Program_Lead#ffd33d"
  "reviewer:Legal#6f42c1"
  "reviewer:Clinical_Lead#e11d21"
  "reviewer:Repo_Admin#1b1f23"
)

echo "Creating reviewer placeholder labels (if missing)..."
for entry in "${LABELS[@]}"; do
  IFS="#" read -r name color <<< "$entry"
  if gh label list --repo "$REPO" --limit 1000 | grep -Fq "$name"; then
    echo "Label '$name' already exists, skipping."
  else
    gh label create "$name" --color "$color" --repo "$REPO" || true
    echo "Created label: $name"
  fi
done

# Compose a comma-separated list of reviewer labels to add to the PR
label_names=$(printf "%s," "${LABELS[@]}")
# convert "label#color,label#color,..." -> "label,label,..."
label_names=$(echo "$label_names" | sed -E 's/#[0-9a-fA-F]{6}//g' | sed 's/,$//g' | tr '\n' ',' | sed 's/,$//')

echo "Adding reviewer placeholder labels to PR #$PR_NUMBER..."
gh issue edit "$PR_NUMBER" --repo "$REPO" --add-label "$label_names" || {
  echo "Warning: failed to add some labels to PR #$PR_NUMBER"
}

# Optional: update PR body to include a Reviewer placeholder list
read -r -d '' NEW_BODY <<'PRBODY' || true
This PR adds the roadmap YAML, a gh-CLI script to apply milestones/owner placeholders, and README instructions.

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
- These are placeholder labels only (not GitHub accounts). Replace them with actual GitHub usernames and add assignees once you have the handles.
- To replace placeholders, remove the reviewer:<role> label and request an actual user review, or add actual assignees.
PRBODY

echo "Updating PR body (appending placeholder reviewer list)..."
# Append the reviewer list to existing PR body
current_body=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json body --jq .body)
# Prevent empty/null issues
if [ "$current_body" = "null" ] || [ -z "$current_body" ]; then
  updated_body="$NEW_BODY"
else
  updated_body="$current_body\n\n---\n\n$NEW_BODY"
fi

# Use gh pr edit to set the new body
gh pr edit "$PR_NUMBER" --repo "$REPO" --body "$updated_body" || {
  echo "Warning: failed to update PR body for #$PR_NUMBER. You can paste PR_DESCRIPTION.md into the PR manually."
}

echo "Done. Reviewer placeholder labels added to PR #$PR_NUMBER."
echo "Next: replace reviewer:<role> labels with real GitHub handles and add assignees when ready."