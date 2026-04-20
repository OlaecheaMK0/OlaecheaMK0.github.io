# Portfolio — Design Handoff

Hand-coded static site, 4 pages (`index.html`, `project-1..3.html`). All tokens live in `css/style.css` `:root`.

## 1. Design tokens

### Colors
| Token | Hex / value | Usage |
|---|---|---|
| `--bg` | `#05080f` | Page base below gradients |
| `--bg-deep` | `#03060c` | Bottom-radial gradient stop |
| `--bg-glow` | `#0a1430` | Top-radial gradient stop |
| `--ink` | `#eaecf3` | Primary text, headings, brand |
| `--ink-soft` | `#b7bdcc` | Body prose, nav default, meta |
| `--ink-muted` | `#858da0` | Eyebrows, labels, footer, placeholders |
| `--rule` | `rgba(234,236,243,0.08)` | Borders and hairlines |
| `--accent` | `#8fb0ff` | Focus ring, hover underline |
| `--accent-dim` | `rgba(143,176,255,0.32)` | Resting underline color |

### Type scale (fluid, `clamp()`)
| Step | Min → Max | Used by |
|---|---|---|
| `--step--1` | 0.82 → 0.9rem | nav, eyebrow labels, footer, back-link, placeholder |
| `--step-0` | 1 → 1.125rem | body |
| `--step-1` | 1.15 → 1.35rem | `h3`, brand, `.prose`, project summary |
| `--step-2` | 1.4 → 1.85rem | tagline, project-body `h2` |
| `--step-3` | 1.9 → 2.75rem | `h2`, work-number |
| `--step-4` | 3 → 5.5rem | `.project-title` |
| `--step-5` | 3.25 → 6.5rem | `.display` (home hero) |

Plus fixed `0.72rem` for `.eyebrow` (letter-spacing `0.22em`, uppercase).

### Fonts
- `--serif`: **Instrument Serif** 400 + italic — display, h2, brand, taglines, work-number, back-arrow
- `--sans`: **Inter** 300/400/500/600 — UI, body, h3, nav, `.project-summary`

### Spacing / layout
- `--container: 68rem` — main/header/footer max width
- `--prose: 36rem` — reading measure
- Section vertical rhythm: `clamp(5rem, 9vw, 8rem) 0 clamp(3.5rem, 6vw, 5rem)`
- Horizontal gutter: `1.5rem`

### Motion
- `--dur-fast: 180ms` — color, border-color
- `--dur-med: 220ms` — work-list hover padding shift
- `--dur-slow: 700ms` — `.reveal` scroll-in
- `--ease: ease`

### Radius
- `2px` focus ring. No other rounded surfaces.

## 2. Component inventory
| Component | Props / variants |
|---|---|
| `.site-header` + `nav` | `aria-current="page"` on current link = permanent underline; collapses to column `<640px` |
| `.hero` + `.display` + `.tagline` | `.display .italic` span for mixed roman/italic; tagline capped at `32ch` |
| `.work-list li > a` | Grid `auto 1fr`; `.work-number` (italic serif, `--step-3`, 60% opacity) + `.work-meta` (h3 + p ≤52ch); hover shifts padding +1rem |
| `.project-hero` | Eyebrow + `.project-title` + `.project-summary` (sans, ≤48ch) |
| `.placeholder` | Left-rule muted serif block for WIP content |
| `.contact-list li` | Grid `8ch 1fr`; `.label` (uppercase muted, `0.18em`) + link (underline on `--accent-dim`) |
| `.site-footer` | Top rule, muted, single `<p>` |
| `.back-link` | `::before "←"` serif; gap expands on hover |
| `#stars` | Fixed canvas, `z-index: 0`, `pointer-events: none`, `aria-hidden` |

## 3. Responsive breakpoint
Single hard break at **`max-width: 640px`** — header switches to column, nav wraps. Everything else is fluid.

## 4. Interaction states
- **Hover + focus-visible** styled identically — no hover-only affordances
- **Focus ring**: `2px solid --accent`, offset `3px`
- **`aria-current="page"`** matches hover state
- **`prefers-reduced-motion`** forces `.reveal` visible, transitions to `0.001ms`

## 5. Gaps / open questions
- No dark/light toggle — single dark theme
- No form styles (contact is `mailto:` only)
- No code/blockquote/img styles inside `.project-body` — add when embedding long text
- No mobile-menu pattern — relies on wrap; breaks past ~5 nav links
- No utility classes beyond `.italic`
- No `prefers-color-scheme` handling

## 6. New components (constellation experiment — 2026-04-19)

Decorative inline SVG constellations reinforce each project's identity. Every project gets one, drawn inline with `viewBox="0 0 220 140"`.

### 6.1 `.constellation-grid` — home card list
3-column grid (`repeat(3, 1fr)`, gap `clamp(2rem, 4vw, 3.5rem)`) that collapses to 1-column at ≤820px. Each `<li>` holds one `<a>` → project page, containing: italic serif number + SVG + `h3` + summary + small-caps caption.

Tokens used: `--serif`, `--sans`, `--ink`/`--ink-soft`/`--ink-muted`, `--accent` (hover tint), `--dur-med` + `--ease`, `--star-body`/`--star-line`/`--star-anchor`.

States:
- Hover (gated by `@media (hover: hover)`) — lift `translateY(-3px)`, lines → `--accent` at 0.7 opacity, non-anchor stars → `--accent`, glow opacity 0.16 → 0.28
- Focus-visible — same visual treatment as hover plus 2px focus ring
- `prefers-reduced-motion` — transform suppressed, tint retained
- Touch devices — no hover state (prevents stuck highlight)

### 6.2 `.feature-constellation` — project page hero accent
Same SVG family at slightly larger star radii (`r=2` non-anchor, `r=3.5` anchor). Sits beside `.project-hero-text` in a `grid-template-columns: minmax(0, 1fr) 200px` layout; stacks ≤720px. No hover — hero is static.

### 6.3 The three shapes
- **01 Instructions — "The arrow"** — 6 stars, ascending chevron with branch
- **02 Resume & Cover Letter — "The frame"** — 5-point asymmetric pentagon
- **03 Proposal — "The keystone"** — 7 stars, arc with center keystone

### 6.4 Accessibility
- Each SVG is decorative — `aria-hidden="true"` + `focusable="false"`
- Parent `<a>` carries meaning via `aria-label="Project NN: Title"`
- Caption span uses `aria-hidden="true"` (purely decorative flourish)
- Constellation stars distinguished from ambient via: larger radius, `filter: drop-shadow()` halo, and connecting lines
- Reduced-motion: hover transform disabled

### 6.5 Extending
To add a 4th constellation: copy one `<li>` block in `index.html`, redraw the SVG inside `viewBox="0 0 220 140"` with ≤7 points and one `.anchor` star, update the `<h3>`, `<p>`, `.caption`, and the matching `project-4.html` feature SVG.

> **Historical note:** As of 2026-04-19 the `.constellation-grid` CSS was removed because the home page switched to the welcome-map pattern (§7). `.feature-constellation` (project-page hero) is still live. Recover the grid CSS via `git show 94d6e14:css/style.css` if needed.

## 7. Welcome map (home, 2026-04-19)

Replaces the prior constellation-grid on `index.html`. The home is now a centered masthead + a four-node scattered "map" of destinations + compact footer. Each node is an `<a>` containing an SVG glyph (120×120 viewBox) and a label.

### 7.1 Structure
```html
<body class="is-welcome">
  <main class="welcome">
    <header class="welcome-mast">
      <p class="eyebrow">Portfolio</p>
      <h1 class="welcome-name"><span class="italic">Name</span></h1>
      <p class="welcome-sub">Tagline</p>
    </header>
    <nav class="map-nav" aria-label="Portfolio">
      <a class="map-node pos-about" href="about.html">
        <svg class="map-glyph" viewBox="0 0 120 120" aria-hidden="true" focusable="false">...</svg>
        <span class="map-label">About</span>
      </a>
      <!-- .pos-instructions, .pos-resume, .pos-proposal -->
    </nav>
    <footer class="welcome-foot"><p>&copy; <span class="year"></span> Name</p></footer>
  </main>
</body>
```

`.welcome` is a 3-row grid (`auto 1fr auto`) filling `100svh`, with `100vh` fallback for older browsers.

### 7.2 Tokens
- Type: `--serif` (name + label), `--ink`/`--ink-soft`/`--ink-muted`
- Name size: `--step-4` · Tagline size: `--step-1` · Label size: `--step-1`
- Colors: `--star-body`, `--star-line`, `--star-anchor` (shared with `.feature-constellation`)
- Motion: `--dur-med` + `--ease`

### 7.3 Interaction states
- **Hover** (gated by `@media (hover: hover) and (pointer: fine)`) — node lifts `translateY(-3px)`.
- **Hover + focus-visible** (same visual treatment, collapsed via `:is(:hover, :focus-visible)`) — label opacity `0.7 → 1`, lines tint `--accent` at 0.8 opacity, non-anchor stars → `--accent`, glow `0.14 → 0.28`.
- **Focus-visible** — `2px solid --accent` outline at 4px offset.
- **Reduced motion** — transform suppressed.

### 7.4 Responsive
- **≥721px** — `.map-nav` is a `clamp(320px, 42vh, 480px)` tall box; each `.map-node` is absolutely positioned via `.pos-*`. Labels at opacity `0.7`.
- **≤720px** — `.map-nav` becomes a 2×2 grid. Labels always at opacity 1. Glyphs shrink to `clamp(72px, 22vw, 110px)`.

### 7.5 Accessibility
- `<nav aria-label="Portfolio">` names the landmark.
- Each `<a>` carries its destination via visible `.map-label` text.
- SVGs decorative: `aria-hidden="true"` + `focusable="false"`.
- Skip link `#welcome-main` targets `<main>`.
- Label opacity 0.7 passes WCAG AA for small text (~5.9:1 contrast).
- Tab order follows DOM order (about → instructions → resume → proposal).

### 7.6 Adding a 5th node
1. Append one `<a class="map-node pos-NEW">` inside `.map-nav` with a `viewBox="0 0 120 120"` SVG + `<span class="map-label">`.
2. Add `.pos-NEW { top/left/right/bottom: …%; }` inside `@media (min-width: 721px)`.
3. Mobile grid auto-reflows to 2×3 with one orphan; switch to `repeat(auto-fit, minmax(140px, 1fr))` if even distribution matters.
