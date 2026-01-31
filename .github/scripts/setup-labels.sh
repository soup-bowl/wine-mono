#!/bin/bash
# Script to create the required labels for the release monitoring workflow
# Run this script manually if the labels don't exist in your repository

set -e

echo "Creating labels for release monitoring workflow..."

# Check if gh CLI is authenticated
if ! gh auth status >/dev/null 2>&1; then
    echo "Error: GitHub CLI is not authenticated."
    echo "Please run: gh auth login"
    exit 1
fi

# Create or update labels
gh label create "enhancement" --description "New feature or request" --color "a2eeef" --force
gh label create "upstream-release" --description "New release from upstream repository" --color "0e8a16" --force

echo "✓ Labels created successfully!"
echo ""
echo "You can view your labels at: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/labels"
