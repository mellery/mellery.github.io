#!/usr/bin/env bash
# Publish the current state of this directory to footloose.info
set -euo pipefail

cd "$(dirname "$0")"

if [[ ! -f CNAME ]]; then
  echo "error: CNAME file is missing - the custom domain will break. Aborting." >&2
  exit 1
fi

if git diff --quiet && git diff --cached --quiet && [[ -z "$(git status --porcelain)" ]]; then
  echo "Nothing to deploy - working tree is clean."
  exit 0
fi

git add -A
git status --short
git commit -m "${1:-Update site}"
git push

echo
echo "Pushed. GitHub Pages usually goes live within a minute."
echo "Check status: ./status.sh"
