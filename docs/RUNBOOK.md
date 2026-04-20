# Portfolio Post-Deploy Runbook

Site: `https://olaecheamk0.github.io` · Source: `~/Desktop/portfolio/`

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
git -C /Users/co/Desktop/portfolio reset --hard 8dc68fa
```
Commit `8dc68fa` ("baseline: pre-constellation experiment") is the known-good anchor.

### 6d. Stars on Retina look too faint or too bright
**Symptoms:** Constellation stars either pop too aggressively or disappear into the background depending on display.

**Fix:** Adjust `filter: drop-shadow()` blur radius in `css/style.css` (`.constellation .stars circle`, `.feature-constellation .stars circle`). Lower blur = crisper / less glow. Default is `1.4–1.6px`; dial to `0.8px` if too soft or `2.2px` if too hard.
