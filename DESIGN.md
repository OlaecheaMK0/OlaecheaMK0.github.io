# Portfolio — Design Handoff

Hand-coded static site, 5 pages. Routes: `/`, `/about/`, `/instructions/`, `/resume/`, `/proposal/`. Old `.html` paths (e.g. `/about.html`) redirect to the new URLs. All tokens live in `css/style.css` `:root`.

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
- `--serif`: **Instrument Serif** 400 + italic — display, h2, brand, taglines, SVG star labels
- `--sans`: **Inter** 400/500 — UI, body, h3, nav, `.project-summary` (300/600 were dropped as unused)

### Spacing / layout
- `--container: 68rem` — main/header/footer max width
- `--prose: 36rem` — reading measure
- Section vertical rhythm: `clamp(5rem, 9vw, 8rem) 0 clamp(3.5rem, 6vw, 5rem)`
- Horizontal gutter: `1.5rem`

### Motion
- `--eo: cubic-bezier(0.22, 1, 0.36, 1)` — the only motion token. Individual durations are hard-coded per component (mast-settle 1800ms, sky-fade 1300ms, sky-link-fade 800ms, reveal 700ms, view-transitions 1500ms / 260ms lateral).

### Radius
- `2px` focus ring. No other rounded surfaces.

## 2. Component inventory
| Component | Props / variants |
|---|---|
| `.site-header` + `.brand` | Sub-page header with the name as a link to `/` |
| `.hero` + `.display` + `.tagline` | `.display .italic` span for mixed roman/italic; tagline capped at `32ch` (about.html) |
| `.project-hero` | Eyebrow + `.project-title` + `.project-summary` (sans, ≤48ch) |
| `.placeholder` | Left-rule muted serif block for WIP content |
| `.contact-list li` | Grid `8ch 1fr`; `.label` (uppercase muted, `0.18em`) + link (underline on `--accent-dim`) |
| `#stars` | Fixed canvas, `z-index: 0`, `pointer-events: none`, `aria-hidden` |

Home-only: `.sky-mast`, `.sky-name`, `.sky-sub`, `.sky-field`, `.sky-svg` (constellation SVG with embedded `<text>` labels), `.sky-nav` + `.sky-link` + `.sky-goo` + `.sky-bubble` + `.sky-pill` (clickable hover-blob overlay).

Sub-page-only: `.sky-mini` (navigation landmark, contains the smaller constellation SVG with embedded labels + 3 clickable `<a>` for non-current stars + `.star-shine` on the current star).

## 3. Responsive breakpoint
Single hard break at **`max-width: 720px`** — sky-field aspect ratio goes taller, `.sky-goo` shrinks, `mast-settle` keyframe caps at `scale(1.6)`, `.sky-pill` allows wrap. Everything else is fluid.

## 4. Interaction states
- **Hover + focus-visible** styled identically — no hover-only affordances
- **Global focus ring**: `2px solid --accent`, `outline-offset: 3px`, `border-radius: 2px`
- **`.sky-link` focus ring**: `2px solid --accent`, `outline-offset: 28px` (on the 0×0 anchor itself — kept outside the goo filter so the ring survives)
- **`prefers-reduced-motion`** forces `.reveal` / `.sky-mast` / `.sky-svg` / `.sky-link` visible, sets animation-duration to `0.001ms`, disables cross-document view transitions

## 5. Gaps / open questions
- No dark/light toggle — single dark theme
- No form styles (contact is `mailto:` only)
- No code/blockquote/img styles inside `.project-body` — add when embedding long text
- No mobile-menu pattern — relies on wrap; breaks past ~5 nav links
- No utility classes beyond `.italic`
- No `prefers-color-scheme` handling

## 6. Historical: constellation experiment (2026-04-19, superseded)

> Below is kept for archival context. The `.constellation-grid` / `.feature-constellation` / welcome-map variants were superseded by the current sky-map (§8). None of their CSS classes (`.constellation-grid`, `.feature-constellation`, `.welcome-*`, `.map-*`, `.pos-*`, `.work-list`, `.work-number`, `.work-meta`, `.site-footer`, `.back-link`) remain in `css/style.css`.

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

## 7. Welcome map (deprecated — superseded by §8 sky-map, 2026-04-19)

> Deprecated. The four scattered small-constellation nodes documented below were replaced by a single large asterism (§8). Retained for archival reference; CSS classes (`.welcome-*`, `.map-*`, `.pos-*`) are no longer present in `css/style.css`.

### Historical: Welcome map (home, 2026-04-19)

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

## 8. Sky map (home, 2026-04-19 — current)

Supersedes §7. One big constellation spans the viewport; four of its stars are clickable anchor destinations (About, Instructions, Resume, Proposal). The rest are decorative. The masthead animates in first, the sky fades in, then the labels and footer settle.

### 8.1 HTML skeleton

```html
<body class="is-sky">
  <canvas id="stars" aria-hidden="true"></canvas>
  <main id="sky-main" class="sky">
    <header class="sky-mast"><!-- eyebrow + sky-name + sky-sub --></header>
    <div class="sky-field">
      <svg class="sky-svg" viewBox="0 0 1000 520" aria-hidden="true" focusable="false">
        <g class="sky-lines">...</g>
        <g class="sky-stars">
          <circle class="dec">…decorative stars…</circle>
          <circle id="a-about" class="anchor" cx="215" cy="135" r="3.4"/>
          <circle class="halo" cx="215" cy="135" r="14"/>
          <!-- 3 more anchor/halo pairs -->
        </g>
      </svg>
      <nav class="sky-nav" aria-label="Portfolio">
        <a class="sky-link" data-star="a-about" href="about.html" style="--x:21.5%;--y:26%">
          <span class="sky-hit"></span><span class="sky-label">About</span>
        </a>
        <!-- 3 more. .reverse on bottom-row stars flips the label above the hit -->
      </nav>
    </div>
    <footer class="sky-foot"><p>&copy; <span class="year"></span> Name</p></footer>
  </main>
  <script src="js/stars.js" defer></script>
  <script src="js/sky.js" defer></script>
</body>
```

`.sky` is `grid-template-rows: auto 1fr auto` filling `100svh`. `.sky-nav` is `position: absolute; inset: 0; pointer-events: none`; each `<a>` re-enables pointer events. Label gap is `0.55rem`.

### 8.2 Tokens

- Type: `--serif` + `--step-4` (name), `--step-1` (sub, labels), `0.72rem` (eyebrow, footer)
- Color: `--ink` / `--ink-soft` / `--ink-muted`; `--star-body` / `--star-line` / `--star-anchor`; `--accent`
- Halo: `r=14` rest, `r=18` active (Chrome/FF only; Safari keeps 14 — cosmetic)
- Motion: `--dur-med`, `--ease` for state; intro eases with `cubic-bezier(0.2, 0.75, 0.25, 1)`

### 8.3 Interaction states

`js/sky.js` toggles `.active` on the matched anchor + halo on `mouseenter`/`focus` (clears on `mouseleave`/`blur`). CSS owns the rest:

- **Default:** lines at 0.58 opacity (≥3:1 non-text), labels at 0.82 opacity
- **Hover / focus-visible:** `.sky-hit::after` blooms (inset 50% → 25%, opacity 0 → 0.14), label opacity → 1 and color → `--ink`
- **Active (JS class):** anchor `fill: --accent; r: 4.2`; halo `opacity: 0.34; r: 18`. `.sky-svg:has(.anchor.active) .sky-lines` re-tints all connecting lines to `--accent` at 0.7.
- **Focus-visible:** `2px solid --accent` outline, 4px offset, 6px radius.

### 8.4 Animation timings

| Keyframe | Target | Duration | Delay |
|---|---|---|---|
| `mast-settle` (scale 1.55 → 1.12 → 1, letter-spacing 0 → -0.015em) | `.sky-mast` | 1500ms | 120ms |
| `sky-fade` (opacity 0→1, scale 0.98→1) | `.sky-svg` | 1400ms | 500ms |
| `sky-fade` | `.sky-link` | 900ms | 1400ms |
| `sky-fade` | `.sky-foot` | 900ms | 1600ms |

Total intro: ~2.3s from load. `prefers-reduced-motion: reduce` disables all four and renders the final state immediately.

### 8.5 Responsive

- **Default (≥721px):** `.sky-field` aspect-ratio `1000/520`, `.sky-hit` 44×44, labels at 0.82 opacity
- **≤720px:** `.sky-field` aspect-ratio `1000/680` (taller), `.sky-hit` 44×44, labels always at 1, `.sky-sub` drops to `--step-0`, `mast-settle` starts at `scale(1.25)` instead of `1.55` to avoid 375px overflow

### 8.6 Accessibility

- `<nav aria-label="Portfolio">` names the landmark
- `.sky-field` is a plain wrapper (not `aria-hidden`) so its descendants remain reachable
- `.sky-svg` is `aria-hidden="true"` + `focusable="false"` — decorative only
- 44×44 hit targets (desktop and mobile) meet WCAG 2.5.5
- Skip link `#sky-main` targets `<main>`
- Tab order follows DOM order: about → instructions → resume → proposal

### 8.7 Adding a 5th anchor star

1. In the SVG, add `<circle id="a-NEW" class="anchor" cx="X" cy="Y" r="3.4"/>` plus a matching `<circle class="halo" cx="X" cy="Y" r="14"/>`. Extend `.sky-lines` polylines to connect the new star to existing lines so the shape stays coherent.
2. Append `<a class="sky-link" data-star="a-NEW" href="..." style="--x:P%;--y:Q%">` where `P = X/10`, `Q = Y/5.2` (percentages of the viewBox). Add `.reverse` if the star sits in the lower half.
3. No CSS changes — `sky.js` auto-discovers the new `[data-star]` on load.
