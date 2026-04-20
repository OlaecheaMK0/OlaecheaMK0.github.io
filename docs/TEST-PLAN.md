# Portfolio — Manual Test Plan

Pre-push manual checks. Run alongside `./smoketest.sh`.

## Existing coverage (unchanged)
- **Smoke flows** — every page loads, internal links resolve, no console errors
- **Responsive** — 640px hard break; header/nav wraps, content stays fluid
- **A11y** — focus rings visible, `aria-current` correct, reduced-motion respected
- **Offline / slow 3G** — fonts fall back cleanly, no layout shift, SVG + text carry meaning
- **`smoketest.sh`** — all routes 200, 404 returns 404, W3C Nu validation passes

## New — welcome-map (2026-04-19)

### 1. Welcome-map nav reachability (keyboard-only)
On `index.html`, Tab from page load:
- Tab order hits all 4 constellation links in visual/reading order (no skips, no traps)
- Each link shows 2px `--accent` focus ring at 3px offset
- Label brightens from dim to `--ink` on focus (same treatment as hover)
- Shift+Tab reverses cleanly; Enter activates link
- No focusable elements outside the 4 links (no hidden tabstops)

### 2. Mobile constellation grid — 320 / 375 / 414
DevTools device mode, each width:
- Grid is 2x2, no horizontal scroll (check `document.documentElement.scrollWidth`)
- Every link's tap target ≥44x44px (Inspect → box model)
- Labels legible at rest — no hover required to read them on touch
- Constellation SVGs don't overflow their cells

### 3. Return-to-welcome affordance
From each of `about.html`, `project-1/2/3.html`:
- Brand/name link in header points to `index.html` (verify `href` + click)
- No dead-end pages — user can always get back to the map in one click

### 4. SEO / crawlability of welcome-map
`index.html` has no traditional `<h1>` hero copy. Verify:
- `<title>` + `<meta name="description">` present and distinctive
- Each constellation `<a>` has `aria-label` or visible text naming the project
- At least one on-page text element names the site owner (for "who is this" crawl signal)
- `view-source:` on `/` shows project titles as plain text (not JS-rendered)
- If too sparse, add a visually-hidden `<h1>` with name + role

### 5. `smoketest.sh` covers `about.html`
Grep `smoketest.sh` for `about.html` — confirmed present in `ROUTES` array and HTML-validation loop. No change needed.

## New — content-presence curl checks
Add to `smoketest.sh` after the route loop, or run standalone:

```sh
BASE="${1:-http://localhost:8000}"

# Welcome map present on home
curl -s "$BASE/" | grep -q 'map-nav' \
  && echo "PASS  welcome  map-nav on /" \
  || echo "FAIL  welcome  map-nav missing on /"

# About page has its heading
curl -s "$BASE/about.html" | grep -q 'about-heading' \
  && echo "PASS  about    about-heading on /about.html" \
  || echo "FAIL  about    about-heading missing on /about.html"
```

Guards against accidental template regressions (e.g., publishing the wrong `index.html`).

## Gaps / follow-ups
- No automated keyboard-nav test — manual only until a Playwright pass lands
- No visual regression — constellation positions could drift on CSS edits; eyeball check for now
