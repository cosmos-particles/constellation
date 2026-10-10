#!/usr/bin/env bash
set -euo pipefail

# Pushes the contents of a local directory to a freshly created GitHub
# repository as its initial commit on the default branch.
#
# Usage: push-initial-content.sh <source_dir> <https_clone_url> <default_branch> <commit_message>

SOURCE_DIR="$1"
CLONE_URL="$2"
DEFAULT_BRANCH="$3"
COMMIT_MESSAGE="$4"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -n "${GITHUB_APP_ID:-}" && -n "${GITHUB_APP_INSTALLATION_ID:-}" && -n "${GITHUB_APP_PEM_FILE:-}" ]]; then
  TOKEN="$("$SCRIPT_DIR/github-app-token.sh")"
elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
  TOKEN="$GITHUB_TOKEN"
else
  echo "error: set GITHUB_APP_ID/GITHUB_APP_INSTALLATION_ID/GITHUB_APP_PEM_FILE or GITHUB_TOKEN" >&2
  exit 1
fi

AUTH_URL="${CLONE_URL/https:\/\//https:\/\/x-access-token:${TOKEN}@}"

cd "$SOURCE_DIR"

if [[ ! -d .git ]]; then
  git init -b "$DEFAULT_BRANCH" >/dev/null
fi

git add -A
git diff --cached --quiet || git commit -m "$COMMIT_MESSAGE" --quiet

git remote remove origin 2>/dev/null || true
git remote add origin "$AUTH_URL"
git push --quiet -u origin "HEAD:${DEFAULT_BRANCH}"

# Leave the local remote pointed at the clean URL - never persist the token.
git remote remove origin
git remote add origin "$CLONE_URL"
