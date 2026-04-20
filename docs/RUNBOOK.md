# Portfolio Post-Deploy Runbook

Site: `https://olaecheamk0.github.io` · Source: `~/Desktop/college/Sophomore/Spring/ENC/portfolio/`

## 1. Pushed but site still 404s
**Symptoms:** `git push` succeeded, but the URL returns "There isn't a GitHub Pages site here."

**Triage:**
1. Wait 2–3 min — Pages build isn't instant.
2. Settings → Pages: source branch = `main`, folder = `/`.
3. Confirm repo name is exactly `OlaecheaMK0.github.io` (case matters).
4. Actions tab → look for a failed `pages-build-deployment` run.
5. Verify `index.html` is at the path Pages is serving.

**Fix:** Re-select the source branch in Settings → Pages to retrigger the build.

## 2. Site loads but looks broken / unstyled
**Symptoms:** Plain HTML, no CSS, broken images, or 404s in DevTools Network.

**Triage:**
1. DevTools → Network, hard reload (⌘⇧R) to bypass cache.
2. Check failing asset paths — a leading `/` on a project page URL breaks under a subpath.
3. Case sensitivity: `Style.css ≠ style.css` on GitHub's Linux server.
4. Confirm assets are actually committed: `git ls-files | grep css`.

**Fix:** Use relative paths (`css/style.css`, not `/css/style.css`) when hosting under a repo subpath.

## 3. Google Fonts missing / slow
**Symptoms:** Text renders in Times New Roman briefly or permanently.

**Triage:**
1. DevTools → Network → filter "font" — look for failed `fonts.googleapis.com` requests.
2. Confirm the `<link>` is in `<head>`, not `<body>`.
3. Test on another network — campus WiFi sometimes blocks.

**Fix:** CSS already has a system-font fallback. If fonts fail, the site still reads cleanly in Iowan Old Style / Inter fallbacks.

## 4. Accidentally committed secrets / private info
**Symptoms:** Email, API key, address, or token visible in a pushed commit.

**Triage:**
1. Rotate the secret **immediately** — revoke on the issuing platform.
2. Remove from current files, commit the cleanup.
3. Rewrite history: `git filter-repo --path the-file --invert-paths` (or BFG).
4. Force-push: `git push --force-with-lease origin main`.

**Fix:** Add to `.gitignore` first; use `.env` for local secrets; never commit.

## 5. Professor can't access / reports an error
**Triage:**
1. Ask: exact URL, browser, screenshot, time of attempt.
2. Test the same URL in an incognito window.
3. githubstatus.com — check for Pages incidents.
4. Verify repo is **Public** (Settings → General → Danger Zone).

**Fix:** If private, flip to public. Otherwise send the direct live URL.

## 6. Constellation-specific issues

### 6a. SVG doesn't render
**Symptoms:** Blank area where the constellation should be; no fallback text visible; DevTools shows a CSP violation for inline SVG.

**Triage:**
1. DevTools → Elements: confirm the `<svg>` node exists in the DOM.
2. Network tab: is an external SVG 404ing, or is inline markup being stripped?
3. Console: look for CSP `violated-directive` entries.

**Fix:** The site is static — no CSP is set by GitHub Pages, so inline SVG renders by default. If the issue is an ancient browser, the text labels (`<h3>` + blurb) still carry all the meaning; the constellation is purely decorative.

### 6b. Hover state stuck on touch devices
**Symptoms:** On iPad or phone, a card stays lifted / highlighted after tap.

**Triage:** Already guarded — hover rules live inside `@media (hover: hover) and (pointer: fine)`. If you see a stuck state, confirm the media query survived any CSS edit.

### 6c. Reverting the constellation concept
**Symptoms:** You decide the concept is too gimmicky.

**Fix:**
```sh
git -C /Users/co/Desktop/college/Sophomore/Spring/ENC/portfolio reset --hard 8dc68fa
```
Commit `8dc68fa` ("baseline: pre-constellation experiment") is the known-good anchor.

### 6d. Stars on Retina look too faint or too bright
**Symptoms:** Constellation stars either pop too aggressively or disappear into the background depending on display.

**Fix:** Adjust `filter: drop-shadow()` blur radius in `css/style.css` (`.feature-constellation .stars circle`, `.map-glyph .stars circle`). Lower blur = crisper / less glow. Default is `1.4–1.6px`; dial to `0.8px` if too soft or `2.2px` if too hard.

## 7. Welcome-map specific issues

### 7a. Professor reports "I can't find Carlos's About Me"
**Likely cause:** she typed the bare domain `olaecheamk0.github.io` and landed on the welcome-map instead of About.

**Triage:**
1. Confirm which URL she submitted on Canvas. Activity 9 is `olaecheamk0.github.io/about.html` specifically.
2. If she visited the root: point her at the "About" constellation (upper-left) — labels are visible by default.
3. Fallback: send the direct `/about.html` link.

### 7b. "The constellation nav doesn't work on my phone"
Mobile is a 2×2 grid with always-visible labels. If broken:
- Verify `<meta name="viewport" content="width=device-width, initial-scale=1">` is in `<head>`.
- Verify the `@media (max-width: 720px)` block in `css/style.css`.
- Touch targets are `.map-node` including both glyph and label — should be ≥110px tall.

### 7c. JavaScript disabled
Welcome-map degrades gracefully:
- Starfield `<canvas>` stays blank (canvas needs JS).
- Constellations + labels + navigation all work (pure HTML/CSS).
- `.year` footer stays empty.

### 7d. Labels not brightening on hover
Causes: iOS sticky `:hover` (expected), `@media (hover: hover)` not matching a hybrid device, a CSS specificity override.

### 7e. Reverting the welcome-map only (keep project-page constellations + about.html)
```sh
git -C ~/Desktop/college/Sophomore/Spring/ENC/portfolio checkout 94d6e14 -- index.html
git -C ~/Desktop/college/Sophomore/Spring/ENC/portfolio commit -m "revert: welcome-map to constellation-grid home"
```
Full revert paths are documented in `docs/ADR-003-welcome-map.md`.

## 8. Sky-map specific issues (home, commit 5b46d89+)

### 8a. Intro animation never plays or stays stuck
**Symptoms:** Masthead stays at 1.55× scale; SVG stays invisible; labels never appear.

**Triage:**
1. DevTools → Console for any parse errors on `js/sky.js` or CSS.
2. Elements → Computed → check `animation-name` on `.sky-mast` — should be `mast-settle`. If not, CSS didn't load.
3. `prefers-reduced-motion: reduce` skips the animation BUT sets final state (opacity 1, transform none). Verify final state renders.
4. Safari may not animate `r:` on circles (cosmetic only — the `.active` class still toggles colors).

**Fix:** Hard reload bypassing cache (⌘⇧R). If `css/style.css` didn't load, check Network panel for 200.

### 8b. Anchor stars don't highlight on hover/focus
**Symptoms:** Hovering a label does nothing to the SVG star.

**Triage:**
1. Console: `document.querySelectorAll('.sky-link[data-star]').length` should equal 4.
2. Each `<a>`'s `data-star` must match an SVG `<circle>` id (e.g. `data-star="a-about"` ↔ `<circle id="a-about">`).
3. Confirm `js/sky.js` loaded (Network tab — 200).
4. The CSS `:has()` rule (`.sky-svg:has(.anchor.active) .sky-lines`) won't work in Firefox <121. The star still lights up; only the connecting-line tint is lost. Acceptable degradation.

**Fix:** Re-sync the IDs between HTML `data-star` values and SVG circle `id` values.

### 8c. HTML overlays misaligned with SVG stars
**Symptoms:** Labels appear next to empty sky, not on top of their stars.

**Triage:** SVG viewBox is `0 0 1000 520`. Each `<a>` `--x` is `cx/1000` and `--y` is `cy/520` as percentages. If a star was moved without updating the overlay, they drift.

**Fix:** Recompute `--x` / `--y` for the affected `<a>`. Example: anchor at `cx=790 cy=420` → `--x:79%;--y:80.8%`.

### 8d. Reduced-motion user sees a blank page
**Symptoms:** User with `prefers-reduced-motion: reduce` sees stuck masthead at opacity 0.

**Fix:** The reduced-motion block in `css/style.css` explicitly sets `opacity: 1 !important`, `transform: none !important`. If that got deleted, re-add.

### 8e. Motion sickness / vestibular report
Treat as SEV3. Two responses:
1. Ship a more conservative `prefers-reduced-motion` end state (opacity jump, no scale).
2. If reports persist, revert to the welcome-map (de0d4a9) which has no intro animation.

### 8f. Revert paths
```sh
# Revert sky-map to welcome-map (no animation, 4 small constellations)
git -C ~/Desktop/college/Sophomore/Spring/ENC/portfolio reset --hard de0d4a9

# Revert to constellation-grid home
git -C ~/Desktop/college/Sophomore/Spring/ENC/portfolio reset --hard 94d6e14

# Revert to plain work-list baseline
git -C ~/Desktop/college/Sophomore/Spring/ENC/portfolio reset --hard 8dc68fa
```
Full decision context in `docs/ADR-004-sky-map.md`.
