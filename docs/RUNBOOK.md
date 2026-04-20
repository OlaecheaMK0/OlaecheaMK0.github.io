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
