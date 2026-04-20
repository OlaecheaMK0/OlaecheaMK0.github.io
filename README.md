# Portfolio

Live: `https://olaecheamk0.github.io` · Built: static HTML, CSS, and a little vanilla JS — no build step.

## Local preview

Open `index.html` directly, or serve the folder:

```sh
python3 -m http.server 8000
# visit http://localhost:8000
```

## Deploy to GitHub Pages

First time:

```sh
cd /Users/co/Desktop/portfolio
git init
git add .
git commit -m "Initial portfolio"
git branch -M main
git remote add origin https://github.com/OlaecheaMK0/OlaecheaMK0.github.io.git
git push -u origin main
```

Then: GitHub → repo → **Settings → Pages → Source: `main` / root**. First deploy can take up to ~10 minutes; subsequent pushes are under a minute.

## Redeploy

```sh
git add -A && git commit -m "update" && git push
```

Pages rebuilds automatically. Check the **Actions** tab on GitHub for build status. If the site 404s: Settings → Pages → confirm Source is still `main` / root.

## Customize

- **Name, bio, contact links**: `index.html` — search for `[` to find every placeholder
- **Each project page**: `project-N.html` — title, intro, embedded PDF
- **Colors, fonts, spacing**: `css/style.css` — tokens live at the top in `:root`
- **Starfield density**: `js/stars.js` — `STAR_DENSITY` constant

Quick scan for unfilled placeholders:

```sh
grep -rn "\[" *.html
```

## Structure

```
index.html          About Me + portfolio home
project-1.html      Instructions (ENC 3241 Project 1)
project-2.html      Resume & Cover Letter (Project 2)
project-3.html      Proposal (Project 3)
css/style.css       Tokens + component styles
js/stars.js         Static starfield + scroll reveals + year stamp
assets/             PDFs, images
docs/               ADR + runbook
DESIGN.md           Tokens & components handoff
smoketest.sh        Pre-deploy smoke test (bash)
.nojekyll           Tells GitHub Pages to serve files as-is
```

## Embedding a PDF on a project page

Drop the file in `assets/` and replace the `.placeholder` block:

```html
<object data="assets/your-file.pdf" type="application/pdf" width="100%" height="800">
  <p>Download the <a href="assets/your-file.pdf">PDF</a>.</p>
</object>
```
