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
for url in http://footloose.info/ https://footloose.info/ \
           http://www.footloose.info/ https://www.footloose.info/; do
  code=$(curl -sIo /dev/null -w '%{http_code}' --max-time 10 "$url" 2>/dev/null)
  [[ "$code" == "000" ]] && code="unreachable"
  printf '%-30s %s\n' "$url" "$code"
done
exit 0
