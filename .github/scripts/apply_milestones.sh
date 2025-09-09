#!/usr/bin/env bash
# Apply milestones and placeholder-owner labels to the repo using gh CLI.
# Usage: update GH CLI and authenticate (gh auth login) with a user that has repo admin rights.
# Then run: bash .github/scripts/apply_milestones.sh
set -euo pipefail

REPO="N0th1ngless/btsc-risk-register"

# Create owner placeholder labels (colors chosen arbitrarily)
declare -a LABELS=(
  "owner:IT_Lead#0e8a16"
  "owner:Lab_Ops#fbca04"
  "owner:Analytics_IT#1d76db"
  "owner:Supply_Ops#8a2be2"
  "owner:Donor_Mgmt#d73a49"
  "owner:Logistics#006b75"
  "owner:Field_Ops#bfe5bf"
  "owner:Program_Lead#ffd33d"
  "owner:Legal#6f42c1"
  "owner:Clinical_Lead#e11d21"
)

echo "Creating owner placeholder labels (if they don't already exist)..."
for entry in "${LABELS[@]}"; do
  IFS="#" read -r name color <<< "$entry"
  if gh label list --repo "$REPO" --limit 1000 | grep -Fq "$name"; then
    echo "Label '$name' already exists, skipping creation."
  else
    gh label create "$name" --color "$color" --repo "$REPO" || true
    echo "Created label: $name"
  fi
done

# Create milestones
declare -A MILESTONES=(
  ["Critical Controls & Stabilization"]="2025-10-21"
  ["Rapid Response & Redistribution"]="2025-11-30"
  ["Coordination, Scheduling & MOUs"]="2025-12-31"
  ["Clinical Prioritization & Training"]="2026-01-31"
)

echo "Creating milestones..."
for title in "${!MILESTONES[@]}"; do
  due="${MILESTONES[$title]}"
  if gh milestone list --repo "$REPO" --limit 1000 | grep -Fq "$title"; then
    echo "Milestone '$title' exists, skipping creation."
  else
    gh milestone create "$title" --repo "$REPO" --due "$due" --description "Roadmap milestone: $title (placeholder)"
    echo "Created milestone: $title (due: $due)"
  fi
done

# Map issues -> milestone + labels (adjust as needed)
# Format: issue_number|milestone_name|comma-separated-labels
declare -a ASSIGNMENTS=(
  "53|Critical Controls & Stabilization|owner:IT_Lead"
  "47|Critical Controls & Stabilization|owner:IT_Lead,owner:Lab_Ops"
  "45|Critical Controls & Stabilization|owner:Analytics_IT"
  "38|Critical Controls & Stabilization|owner:Supply_Ops"
  "56|Rapid Response & Redistribution|owner:Donor_Mgmt"
  "50|Rapid Response & Redistribution|owner:Supply_Ops"
  "54|Rapid Response & Redistribution|owner:Logistics"
  "49|Rapid Response & Redistribution|owner:Field_Ops"
  "52|Coordination, Scheduling & MOUs|owner:Program_Lead,owner:Legal"
  "44|Coordination, Scheduling & MOUs|owner:Logistics"
  "42|Coordination, Scheduling & MOUs|owner:Program_Lead,owner:IT_Lead"
  "51|Clinical Prioritization & Training|owner:Clinical_Lead"
)

echo "Applying milestone assignments and owner placeholder labels to issues..."
for entry in "${ASSIGNMENTS[@]}"; do
  IFS="|" read -r issue milestone labels <<< "$entry"
  # Add milestone
  gh issue edit "$issue" --repo "$REPO" --milestone "$milestone" || {
    echo "Warning: failed to set milestone '$milestone' on issue #$issue"
  }
  # Add labels (comma-separated)
  gh issue edit "$issue" --repo "$REPO" --add-label "$labels" || {
    echo "Warning: failed to add labels '$labels' on issue #$issue"
  }
  echo "Updated issue #$issue -> milestone: '$milestone', labels: $labels"
done

echo "Done. Replace owner:... labels with real GitHub usernames and optionally add assignees."