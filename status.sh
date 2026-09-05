#!/usr/bin/env bash
# Show deploy + certificate status for footloose.info
set -uo pipefail

cd "$(dirname "$0")"

echo "== last build =="
gh api repos/mellery/mellery.github.io/pages/builds/latest \
  --jq '"status: \(.status)  commit: \(.commit[0:7])  at: \(.updated_at)" + (if .error.message then "\nerror: \(.error.message)" else "" end)'

echo
echo "== domain =="
gh api repos/mellery/mellery.github.io/pages \
  --jq '"domain: \(.cname)  https_enforced: \(.https_enforced)  cert: \(.https_certificate.state // "not issued yet")"'

echo
echo "== live =="
printf 'https://footloose.info      -> '; curl -so /dev/null -w '%{http_code}\n' --max-time 10 https://footloose.info/
printf 'https://www.footloose.info  -> '; curl -so /dev/null -w '%{http_code}\n' --max-time 10 https://www.footloose.info/
