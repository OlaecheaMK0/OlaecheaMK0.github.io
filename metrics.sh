#!/usr/bin/env bash
# Quantified efficiency / safety / robustness scoreboard.
# Usage: ./metrics.sh [base-url]  (default http://localhost:8765)
#
# Emits a single-line JSON result plus a human-readable report to stderr.
# Designed to be diffed across commits — every metric is deterministic
# given the same inputs.
set -u
PORT_URL="${1:-http://localhost:8765}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES=(index.html about.html project-1.html project-2.html project-3.html css/style.css js/script.js)
HTML_PAGES=(index.html about.html project-1.html project-2.html project-3.html)

# ── File-level byte accounting ────────────────────────────────────────
TOTAL_RAW=0
TOTAL_GZ=0
PER_FILE=""
for f in "${FILES[@]}"; do
  [[ -f "$DIR/$f" ]] || continue
  raw=$(wc -c <"$DIR/$f" | tr -d ' ')
  gz=$(gzip -c "$DIR/$f" | wc -c | tr -d ' ')
  TOTAL_RAW=$((TOTAL_RAW + raw))
  TOTAL_GZ=$((TOTAL_GZ + gz))
  PER_FILE+="  \"$f\": { \"raw\": $raw, \"gz\": $gz },"$'\n'
done
PER_FILE="${PER_FILE%,$'\n'}"

# ── Route latency (average of 3 per route) ────────────────────────────
TOTAL_TIME=0
ROUTE_COUNT=0
for p in "${HTML_PAGES[@]}"; do
  for _ in 1 2 3; do
    t=$(curl -s -o /dev/null -w "%{time_total}" "$PORT_URL/$p" 2>/dev/null || echo 0)
    TOTAL_TIME=$(awk "BEGIN { printf \"%.6f\", $TOTAL_TIME + $t }")
    ROUTE_COUNT=$((ROUTE_COUNT + 1))
  done
done
AVG_MS=$(awk "BEGIN { printf \"%.2f\", ($TOTAL_TIME / $ROUTE_COUNT) * 1000 }")

# ── Request-count per home page (inline counts as 0, external is 1) ──
# home (sky-map) loads: style.css, fonts, stars.js, sky.js + inline SVG (0 extra)
HOME_REQUESTS=$(grep -cE '<link rel="stylesheet"|<script src=' "$DIR/index.html")
ABOUT_REQUESTS=$(grep -cE '<link rel="stylesheet"|<script src=' "$DIR/about.html")

# ── HTML validation via W3C Nu Validator ──────────────────────────────
HTML_ERRORS=0
for p in "${HTML_PAGES[@]}"; do
  errs=$(curl -s -H "Content-Type: text/html; charset=utf-8" \
    --data-binary "@$DIR/$p" \
    "https://validator.w3.org/nu/?out=json" 2>/dev/null \
    | grep -o '"type":"error"' | wc -l | tr -d ' ')
  HTML_ERRORS=$((HTML_ERRORS + errs))
done

# ── Safety checklist (binary checks, 1 pt each) ───────────────────────
SAFETY_TOTAL=10
SAFETY_PASS=0
check() { local label=$1 cmd=$2; if eval "$cmd" >/dev/null 2>&1; then SAFETY_PASS=$((SAFETY_PASS+1)); fi; }
check "noopener on external links" "grep -q 'rel=\"noopener noreferrer\"' $DIR/about.html"
check "theme-color meta" "grep -q 'theme-color' $DIR/index.html"
check "viewport meta present on all pages" "! grep -L 'name=\"viewport\"' $DIR/index.html $DIR/about.html $DIR/project-*.html | grep ."
check "description meta on all pages" "! grep -L 'name=\"description\"' $DIR/index.html $DIR/about.html $DIR/project-*.html | grep ."
check "skip-to-content link" "grep -q 'class=\"skip\"' $DIR/index.html"
check "noscript fallback on sub-pages" "grep -q '<noscript>' $DIR/about.html"
check "aria-hidden on decorative SVG" "grep -q 'aria-hidden=\"true\"' $DIR/index.html"
check "aria-label on nav landmark" "grep -q 'aria-label=\"Portfolio\"' $DIR/index.html"
check "lang attribute on html" "grep -q '<html lang=' $DIR/index.html"
check "preconnect to external origin" "grep -q 'rel=\"preconnect\"' $DIR/index.html"

# ── Robustness checks ─────────────────────────────────────────────────
ROBUST_TOTAL=8
ROBUST_PASS=0
rcheck() { local cmd=$1; if eval "$cmd" >/dev/null 2>&1; then ROBUST_PASS=$((ROBUST_PASS+1)); fi; }
rcheck "grep -q 'prefers-reduced-motion' $DIR/css/style.css"
rcheck "grep -q '@media.*max-width' $DIR/css/style.css"
rcheck "grep -q 'focus-visible' $DIR/css/style.css"
rcheck "grep -qE 'font-display|display=swap' $DIR/index.html"
rcheck "grep -q 'BlinkMacSystemFont\|-apple-system' $DIR/css/style.css"
rcheck "grep -q '100svh' $DIR/css/style.css"
rcheck "grep -q '@media print' $DIR/css/style.css"
rcheck "test -f $DIR/.nojekyll"

# ── Composite efficiency score (lower bytes / latency = higher score) ─
# Targets: gz < 8KB → 100, gz > 20KB → 0 (linear)
EFF_BYTES=$(awk "BEGIN { s = 100 - ( ($TOTAL_GZ - 8192) / 12288 ) * 100; if (s > 100) s = 100; if (s < 0) s = 0; printf \"%.1f\", s }")
# Target avg latency < 5ms → 100, > 50ms → 0
EFF_LAT=$(awk "BEGIN { s = 100 - (($AVG_MS - 5) / 45) * 100; if (s > 100) s = 100; if (s < 0) s = 0; printf \"%.1f\", s }")
# Validation: 0 errors = 100, 10+ errors = 0
EFF_VAL=$(awk "BEGIN { s = 100 - $HTML_ERRORS * 10; if (s < 0) s = 0; printf \"%.1f\", s }")

SAFETY_PCT=$(awk "BEGIN { printf \"%.1f\", ($SAFETY_PASS * 100.0) / $SAFETY_TOTAL }")
ROBUST_PCT=$(awk "BEGIN { printf \"%.1f\", ($ROBUST_PASS * 100.0) / $ROBUST_TOTAL }")

# Composite: weighted average
COMPOSITE=$(awk "BEGIN { printf \"%.1f\", ($EFF_BYTES * 0.30 + $EFF_LAT * 0.20 + $EFF_VAL * 0.15 + $SAFETY_PCT * 0.20 + $ROBUST_PCT * 0.15) }")

# ── Human-readable report to stderr ───────────────────────────────────
{
  echo "──────────────────────────────────────────────────────────────"
  echo "  Portfolio scoreboard  ·  $(date +%H:%M:%S)"
  echo "──────────────────────────────────────────────────────────────"
  printf "  total raw bytes ............... %8d  (%s kB)\n" "$TOTAL_RAW" "$(awk "BEGIN { printf \"%.1f\", $TOTAL_RAW/1024 }")"
  printf "  total gzipped bytes ........... %8d  (%s kB)\n" "$TOTAL_GZ" "$(awk "BEGIN { printf \"%.1f\", $TOTAL_GZ/1024 }")"
  printf "  compression ratio ............. %s\n" "$(awk "BEGIN { printf \"%.3f\", $TOTAL_GZ / $TOTAL_RAW }")"
  printf "  avg route latency ............. %s ms  (n=%d)\n" "$AVG_MS" "$ROUTE_COUNT"
  printf "  HTML validation errors ........ %s\n" "$HTML_ERRORS"
  printf "  requests per page (home/about). %s / %s\n" "$HOME_REQUESTS" "$ABOUT_REQUESTS"
  printf "  safety checks ................. %d / %d  (%s%%)\n" "$SAFETY_PASS" "$SAFETY_TOTAL" "$SAFETY_PCT"
  printf "  robustness checks ............. %d / %d  (%s%%)\n" "$ROBUST_PASS" "$ROBUST_TOTAL" "$ROBUST_PCT"
  echo  "──────────────────────────────────────────────────────────────"
  printf "  EFFICIENCY (bytes) ............ %s / 100\n" "$EFF_BYTES"
  printf "  EFFICIENCY (latency) .......... %s / 100\n" "$EFF_LAT"
  printf "  VALIDATION .................... %s / 100\n" "$EFF_VAL"
  printf "  SAFETY ........................ %s / 100\n" "$SAFETY_PCT"
  printf "  ROBUSTNESS .................... %s / 100\n" "$ROBUST_PCT"
  echo "  ─────────────────────────────────"
  printf "  COMPOSITE ..................... %s / 100\n" "$COMPOSITE"
  echo "──────────────────────────────────────────────────────────────"
} >&2

# ── JSON result to stdout ─────────────────────────────────────────────
cat <<EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "commit": "$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)",
  "totals": {
    "raw_bytes": $TOTAL_RAW,
    "gzipped_bytes": $TOTAL_GZ,
    "avg_latency_ms": $AVG_MS,
    "html_errors": $HTML_ERRORS,
    "home_requests": $HOME_REQUESTS,
    "about_requests": $ABOUT_REQUESTS
  },
  "safety": { "passed": $SAFETY_PASS, "total": $SAFETY_TOTAL, "pct": $SAFETY_PCT },
  "robustness": { "passed": $ROBUST_PASS, "total": $ROBUST_TOTAL, "pct": $ROBUST_PCT },
  "scores": {
    "efficiency_bytes": $EFF_BYTES,
    "efficiency_latency": $EFF_LAT,
    "validation": $EFF_VAL,
    "safety": $SAFETY_PCT,
    "robustness": $ROBUST_PCT,
    "composite": $COMPOSITE
  },
  "files": {
$PER_FILE
  }
}
EOF
