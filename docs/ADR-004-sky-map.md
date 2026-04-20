# ADR-004: Home Page — Sky-Map (one big constellation + intro animation)

**Status:** Proposed (supersedes ADR-003)
**Date:** 2026-04-19
**Deciders:** co (sole author); ENC 3241 rubric is the implicit second voter.
**Baselines:**
- `8dc68fa` — pre-constellation plain work-list
- `94d6e14` — constellation-grid home (3 grid items)
- `de0d4a9` — welcome-map (4 scattered small constellations)
- `5b46d89` — **sky-map** (one big constellation + intro animation, current)

## Context

After iterating through three landing treatments, the user explicitly asked for **one big constellation** on the home page where **each clickable star is a page**, with **smaller hitboxes** than the prior welcome-map cards, and an **intro animation** that shrinks the name from a big size to a normal title size as the constellation fades in. The current commit (`5b46d89`) ships that pattern. This ADR captures the decision and evaluates revert options.

## Options

### A. Sky-map (current `5b46d89`) — one big constellation + intro animation
- **Pros:** Matches the explicit latest ask. A single focal shape reads as intentional, not decorative. Animation rewards first-visit visitors without blocking readers on Canvas (who land directly on `/about.html`).
- **Cons:** Animation adds perceived load delay (must honor `prefers-reduced-motion`). Four anchor stars cap IA — adding a fifth section requires reshaping the constellation.

### B. Welcome-map (`de0d4a9`) — 4 scattered small constellations
- **Pros:** No animation cost. Each section owns its own shape.
- **Cons:** Four competing shapes = no focal point; reads as decoration, not a map.

### C. Constellation-grid (`94d6e14`) — 3 grid items on a traditional landing
- **Pros:** Conventional, scannable, SEO-friendly. Fastest time-to-interactive.
- **Cons:** Constellation becomes ornamental garnish. Throws away the concept.

### D. Baseline (`8dc68fa`) — plain work-list
- **Pros:** Zero cleverness tax. Accessible and fast by default.
- **Cons:** Indistinguishable from every other student portfolio.

## Decision Factors

1. **Fidelity to last stated preference** — user explicitly asked for A.
2. **Concept coherence** — "sky map" only works with one dominant shape (A).
3. **Accessibility** — any option with animation must gate on `prefers-reduced-motion`; A already does.
4. **Extensibility** — A caps at ~4 anchors without redesign; C scales better past that.
5. **Performance budget** — D < C < B < A.

## Recommendation

**Keep A (sky-map), with the polish applied tonight** (all surfaced by the round-4 agent review):
- `aria-hidden` removed from `.sky-field` wrapper (kept on `.sky-svg`) — fixes focus-skip regression
- `transform-origin: center center` on `.sky-svg` — animation no longer drifts from top-left
- `.sky-lines` stroke-opacity 0.42 → 0.58 + width 0.85 → 0.95 — non-text contrast now 3.6:1 (passes WCAG 1.4.11)
- `.sky-label` opacity 0.7 → 0.82 — text contrast safety margin
- Proposal anchor nudged from `cy=400` to `cy=420` (and overlay to `--y:80.8%`) — breaks the flat bottom axis
- Two redundant rib lines deleted — cleaner kite silhouette
- `sky-fade` delay 700 → 500ms; `.sky-link` 1600 → 1400ms; `.sky-foot` 1800 → 1600ms — tightens the intro
- `.sky-link` label gap 0.35 → 0.55rem — breathing room
- Mobile `mast-settle` keyframe capped at scale 1.25 — prevents 375px overflow

Conditions: honor `prefers-reduced-motion` with a static end-state render, keep the intro under 2.1s total, ensure anchor stars have real `<a>` semantics with visible focus rings.

If a fifth top-level section appears within the next two months, revisit and consider C.

## Revert Commands

```sh
# Stay on A (current) — nothing to do
git -C ~/Desktop/portfolio log -1 --oneline

# Revert to B (welcome-map)
git -C ~/Desktop/portfolio reset --hard de0d4a9

# Revert to C (constellation-grid home)
git -C ~/Desktop/portfolio reset --hard 94d6e14

# Revert to D (baseline plain work-list)
git -C ~/Desktop/portfolio reset --hard 8dc68fa
```
