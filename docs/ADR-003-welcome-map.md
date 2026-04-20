# ADR-003: Home page as "welcome map" vs traditional landing

**Status:** Proposed — pending outside-viewer reaction before accepting
**Date:** 2026-04-19
**Deciders:** co (sole author); ENC 3241 rubric is the implicit second voter
**Supersedes:** ADR-002 home-page recommendation
**Baselines:** `8dc68fa` (plain work-list), `94d6e14` (constellation grid home)

## Context

`index.html` currently ships as a welcome-map: four scattered constellation nav nodes with dim-to-full labels, no traditional nav header. About Me content lives at `/about.html`.

ENC 3241 rubric awards 1 pt for a URL that lands directly on "About Me". The URL submitted to Canvas is `olaecheamk0.github.io/about.html`, so rubric compliance is already satisfied. This decision is only about first impression at the bare domain.

## Options

### A. Keep welcome-map home + separate about.html (current)
- **Pros:** Distinctive; signals craft; About page stays clean for grading.
- **Cons:** Higher bounce risk — visitors may not understand the four labeled glyphs are nav; no self-introduction above the fold.

### B. Welcome-map with root-to-about redirect
- **Pros:** Rubric-friendly if grader types bare URL; removes ambiguity.
- **Cons:** Deletes the welcome experience for everyone; adds a redirect for a one-page site; contradicts intent of shipping A.

### C. Revert to `94d6e14` (traditional landing w/ constellation grid)
- **Pros:** Self-introducing above the fold; coursework visible; keeps visual identity.
- **Cons:** Muddles two metaphors (grid + constellation); loses the distinctive welcome concept.

### D. Revert to baseline `8dc68fa` (plain work-list)
- **Pros:** Simplest; zero ambiguity.
- **Cons:** Generic; no personality; throws away recent design work.

## Trade-off

Core tension: **memorability vs. legibility**. Welcome-map (A) optimizes for visitors who will explore; traditional landing (C) optimizes for visitors who won't. For a portfolio primarily read by the professor (who receives the `/about.html` URL directly), legibility at the root isn't load-bearing.

Option B solves a problem that doesn't exist (rubric already satisfied) at the cost of deleting the signature.

## Recommendation

**Option A**, with the polish applied tonight:
- Label opacity raised from 0.35 → 0.7 so labels are readable without hover (fixes WCAG AA contrast fail flagged by accessibility-review)
- "Hover to navigate" hint removed (excluded keyboard/touch users; the higher label opacity makes the hint unnecessary)
- Hover + focus-visible rules collapsed into a single selector list
- Corner positions de-symmetrized slightly for a less-mirrored scatter
- About constellation given one extra asymmetric star to avoid Mercedes-logo symmetry
- Dead `.work-list` and `.constellation-grid` CSS deleted (~150 lines)

Revisit if an outside viewer fails to reach a project page in <15 seconds.

## Revert commands

```sh
# Full revert to baseline (plain work-list home)
git -C ~/Desktop/portfolio reset --hard 8dc68fa

# Revert to constellation-grid home (pre-welcome-map)
git -C ~/Desktop/portfolio reset --hard 94d6e14

# Scoped revert — restore welcome-map home only, keep project-page constellations + about.html
git -C ~/Desktop/portfolio checkout 94d6e14 -- index.html
git -C ~/Desktop/portfolio commit -m "revert: welcome-map to constellation-grid home"
```
