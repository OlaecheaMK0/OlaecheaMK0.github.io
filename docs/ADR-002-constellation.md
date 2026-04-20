# ADR-002: Constellation Navigation vs. Simple Work List

**Status:** Proposed — pending outside-viewer reaction before accepting
**Date:** 2026-04-19
**Deciders:** co (sole author); ENC 3241 rubric is the implicit second voter
**Supersedes baseline:** `8dc68fa` (git commit "baseline: pre-constellation experiment")

## Context

`index.html` currently ships a constellation-grid navigation. Each project is an inline SVG of linked nodes. Project pages extend the motif with feature constellations beside the hero title. ENC 3241 grades on "polished and professional," "beyond a template," and "formal tone."

The constellation is a deliberate aesthetic bet: distinctive if executed well, gimmicky if not. Seventeen review agents have audited the current implementation; the consensus is "ship it, with fixes applied." All flagged fixes have been merged.

## Options Considered

### A. Keep constellation as-is (including project-page feature constellations)
- **Pros:** Distinctive. Scores "beyond a template." Motif reinforces itself across pages.
- **Cons:** Higher cringe risk if SVGs read as decorative noise. Inline SVG is duplicated across 4 pages (pay the DRY cost at N=4+ projects). Couples index and project pages — harder to revert later.

### B. Keep on home, strip from project pages
Retain constellation grid on `index.html`; demote project-page heroes back to title + prose only.
- **Pros:** Preserves the signature without over-committing. Lowers cringe surface area. Easier to argue as "intentional" if a grader questions it.
- **Cons:** Motif becomes index-page-only. Loses the cross-page payoff.

### C. Revert to baseline (`git reset --hard 8dc68fa`)
Restores the plain `.work-list` on home, no project-page constellations.
- **Pros:** Unambiguously formal. Zero accessibility risk. Rubric-safe.
- **Cons:** Reads template-adjacent. Forfeits the "beyond a template" lift.

## Decision Factors

1. How does the constellation render on a phone and on a projector, not just this laptop?
2. Would a stranger describe it as "polished" or "busy" in five seconds?
3. Can I defend the metaphor in one sentence if the grader asks?
4. Is the project-page coupling worth the revert cost later?

## Recommendation

**Option B** is the safest win. Keep the home-page constellation grid as the signature; strip the project-page feature constellations. The rubric rewards distinctiveness *and* restraint — B buys both. Revisit after one outside viewer reacts.

Option A is defensible if the outside viewer reads the constellation as navigation within 5 seconds.

## Revert commands

```sh
# Full revert to baseline
git -C /Users/co/Desktop/portfolio reset --hard 8dc68fa

# Partial revert — strip project-page features only (Option B)
# Remove the has-feature class + <svg class="feature-constellation"> block
# from project-1.html, project-2.html, project-3.html. Keep index.html as-is.
```
