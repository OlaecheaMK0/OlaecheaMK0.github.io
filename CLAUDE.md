# CLAUDE.md — Portfolio

Load this first if you're a Claude session new to this repo. Everything below is current state, not narrative.

## What this is

Personal portfolio for Carlos Olaechea (UCF CS sophomore). Built for ENC 3241 at UCF:
- **Activity 9** (2026-04-19, 8 pts, **SUBMITTED**) — working URL to About Me page. Submitted `https://olaecheamk0.github.io/about.html` on Canvas.
- **Project 4** (2026-05-02, 220 pts, **pending**) — same site, but each project page must hold its revised document + a 2–3 sentence intro paragraph. Currently Lorem Ipsum.

## Stack

Hand-coded static HTML/CSS/JS. No build step, no framework, no bundler. Deployed to GitHub Pages from `main` @ repo root. No GitHub Actions needed — user-site repo auto-builds.

- **Live:** https://olaecheamk0.github.io/
- **Repo:** https://github.com/OlaecheaMK0/OlaecheaMK0.github.io
- **Local path:** `/Users/co/Desktop/college/Sophomore/Spring/ENC/portfolio`

## File layout

```
index.html          Home sky-map: full constellation, 4 anchor stars linked via HTML overlay + goo metaball hover
about.html          About Me (this is the Activity 9 submission — content is real)
project-1.html      Instructions — sky-mini nav with its star lit, body is Lorem
project-2.html      Resume & Cover Letter — sky-mini, Lorem body
project-3.html      Proposal — sky-mini, Lorem body
css/style.css       All styling. Tokens in :root at top. Mobile break at 720px.
js/script.js        Starfield canvas + IntersectionObserver reveals + sky-map hover bridge
docs/               ADR-001..004 + RUNBOOK + TEST-PLAN
DESIGN.md           Component handoff (tokens, skeletons, interaction states)
metrics.sh          Scoreboard (bytes / latency / validation / safety / robustness → composite /100)
smoketest.sh        Route status + W3C Nu HTML validation
metrics/*.json      Historical score snapshots
.nojekyll           Ensures GitHub Pages serves files as-is
```

## Local dev

```sh
cd ~/Desktop/college/Sophomore/Spring/ENC/portfolio
python3 -m http.server 8765   # already usually running in the background
# → http://localhost:8765/
```

## Deploy

```sh
git add -A && git commit -m "…" && git push
```

Pages rebuilds in ~30–60 s for subsequent pushes. First-time deploy was verified `built` + `HTTP 200` immediately.

## What's real vs placeholder

**Real now** (don't regenerate):
- Name, tagline, email (`ca216004@ucf.edu`), GitHub link
- About Me prose (user's voice — not AI-polished; preserved by explicit instruction)
- Design system (colors, type scale, motion, spacing tokens)
- Sky-map home + sky-mini on each sub-page (current star lit, siblings clickable via goo metaball)

**Still Lorem Ipsum** (fill before Project 4 on May 2):
- `project-1.html` — overview / document description / reflection paragraphs
- `project-2.html` — position description / resume placeholder / cover letter placeholder
- `project-3.html` — research question / proposal placeholder / reflection
- Each project also needs its revised PDF dropped into `assets/` and embedded (replace each `.placeholder` block with `<object data="assets/…pdf" type="application/pdf" …>`)

## Conventions (from prior feedback, don't relearn)

- About Me prose stays in user's voice. User drafts; Claude fixes grammar only.
- Professor is always spelled "professor," never "prof."
- Rubric rewards "beyond a template" — hand-built wins over templated builders.
- Every commit must pass `./smoketest.sh http://localhost:8765` + W3C HTML validation.
- Privacy ask: one mention is enough for low-stakes data; still flag high-stakes leaks.
- No past-due / missing-work alerts — user ignores those by design.

## Revert anchors

```
ae215fe  About Me in user's voice + school email + no LinkedIn  (current)
535ee03  first content fill (more polished prose)
81f02be  round4: dead code + CSS tokens + perf hint
7180d74  dim goo blob opacity to 0.5
21ecf2f  a11y regression fix + pill normalization + focus ring
07c5f99  shine rays + goo metaball on sibling stars
5b46d89  sky-map v1 — one-constellation home with intro animation
94d6e14  constellation grid variant (superseded)
8dc68fa  pre-constellation baseline — plain work-list
```

Revert example: `git reset --hard 7180d74` returns to the state just before content fill.

## Architecture decisions

| ADR | Topic |
|---|---|
| `docs/ADR-001-stack.md` | Why plain HTML/CSS/JS over frameworks |
| `docs/ADR-002-constellation.md` | Constellation-grid home variant (superseded by 004) |
| `docs/ADR-003-welcome-map.md` | Welcome-map variant (superseded by 004) |
| `docs/ADR-004-sky-map.md` | Current: sky-map home + sky-mini sub-pages |

## Current scoreboard

Last snapshot in `metrics/round4_post.json`:

```
Composite:   84.4 / 100
  Bytes:     47.9   (floor — structural weight of 5 HTML pages + SVG-heavy sky-mini)
  Latency:  100.0
  Validation:100.0
  Safety:   100.0
  Robustness:100.0
```

Bytes are the sticky metric. Further gains require a build step (minification) or a JS template to dedupe the sky-mini SVG across sub-pages. Both declined previously — not worth the complexity at 5 pages.

## Common tasks

### Add a 5th anchor star to the sky
1. Pick SVG coords inside viewBox `0 0 1000 520`.
2. Edit `index.html` sky-svg: add a decorative line route + `<circle class="anchor">` + `<circle class="halo">` + HTML overlay `<a class="sky-link">` with `--x/--y` percentages.
3. Edit `css/style.css` — may need to widen `.sky-field` or relax the grid.
4. Update each sub-page's sky-mini SVG to include the new anchor (3 of the 4 sub-pages will have it as a non-current clickable; the new page has it as `.current`).
5. Run `./smoketest.sh` + `./metrics.sh`.

### Fill a project page for Project 4
1. Replace the `.project-summary` Lorem with a 2–3 sentence intro in the user's voice.
2. Replace body section Lorem paragraphs with real content.
3. Drop the revised project PDF into `assets/` and replace the `<div class="placeholder">` block with an `<object data="assets/…pdf" type="application/pdf" width="100%" height="800">` block.
4. Verify sky-mini still shows the right star lit.
5. `git push`.
