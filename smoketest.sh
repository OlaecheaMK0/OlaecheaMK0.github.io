#!/usr/bin/env bash
# Pre-push smoke test. Run against a local server or the deployed URL.
#   Usage:  ./smoketest.sh [base-url]
#   Default: http://localhost:8000
set -u
BASE="${1:-http://localhost:8000}"
ROUTES=(/ /index.html /about.html /project-1.html /project-2.html /project-3.html /css/style.css /js/stars.js)
PASS=0
FAIL=0

echo "Smoke-testing $BASE"
echo "---"

for r in "${ROUTES[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE$r")
  if [[ "$code" == "200" ]]; then
    echo "PASS  200  $r"
    PASS=$((PASS+1))
  else
    echo "FAIL  $code  $r"
    FAIL=$((FAIL+1))
  fi
done

# 404 route should actually 404
code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/does-not-exist.html")
if [[ "$code" == "404" ]]; then
  echo "PASS  404  /does-not-exist.html (expected)"
  PASS=$((PASS+1))
else
  echo "FAIL  $code  /does-not-exist.html (expected 404)"
  FAIL=$((FAIL+1))
fi

# HTML validation via W3C Nu Validator (requires network)
echo "---"
echo "HTML validation (W3C Nu Validator)"
for p in index.html about.html project-1.html project-2.html project-3.html; do
  file="$(dirname "$0")/$p"
  if [[ ! -f "$file" ]]; then
    echo "SKIP  $p (file not found)"
    continue
  fi
  errs=$(curl -s -H "Content-Type: text/html; charset=utf-8" \
    --data-binary "@$file" \
    "https://validator.w3.org/nu/?out=json" | grep -o '"type":"error"' | wc -l | tr -d ' ')
  if [[ "$errs" == "0" ]]; then
    echo "PASS  html  $p"
    PASS=$((PASS+1))
  else
    echo "FAIL  html  $p ($errs errors)"
    FAIL=$((FAIL+1))
  fi
done

echo "---"
echo "Pass: $PASS   Fail: $FAIL"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
