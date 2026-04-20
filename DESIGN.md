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
