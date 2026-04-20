# ADR-001: Plain HTML/CSS/JS for Portfolio Site

**Status:** Accepted
**Date:** 2026-04-19
**Deciders:** co (owner / sole maintainer)

## Context

I need a personal portfolio hosted on GitHub Pages. The site is low-traffic, content-light (a handful of project pages, an About, and a contact block), and doubles as the deliverable for ENC 3241's Activity 9 / Project 4, whose rubric explicitly rewards work that "goes beyond a template." I am a CS sophomore comfortable in a text editor and want the stack to still make sense to me in two years when I revisit it.

## Decision

Hand-write the site in plain HTML, CSS, and vanilla JS with no build step. Deploy by pushing to a GitHub Pages branch.

## Consequences

**Easier**
- Zero toolchain. Clone, edit, push. No `node_modules`, no lockfile drift, no framework-upgrade tax.
- Full control over every byte of markup — directly demonstrable for ENC 3241 (semantic HTML, custom CSS, manual responsive work).
- Debugging is DevTools. What ships is what I wrote.
- Long-term maintenance cost is near zero. HTML from 2026 will still render in 2030.

**Harder**
- No component reuse primitive. Repeated markup (nav, footer) is copy-pasted.
- No routing, no MDX, no image optimization out of the box.
- If the site grows past ~10 pages or needs a blog with tags, re-evaluate.

**Revisit when:** page count exceeds ~10, I want a typed content model, or I need SSR for SEO beyond what static HTML provides.

## Alternatives considered

- **Next.js / Astro / SvelteKit** — Better ergonomics at scale, but introduce a build step, a dependency graph, and framework-churn risk for a site that has ~6 pages. Overhead outweighs benefit today.
- **Wix / WordPress / Squarespace** — Fastest to stand up, but template-shaped output works against the ENC 3241 rubric and hides the HTML/CSS skills I want to show. Also: vendor lock-in.
- **Static site generator (Hugo, Eleventy)** — Middle ground, but still a toolchain for content I can write directly in HTML right now.

**Trade-off summary:** Trade framework convenience for transparency, rubric alignment, and a maintenance floor of zero. Acceptable at current scale.
