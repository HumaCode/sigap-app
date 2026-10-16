---
name: Clean Telemetry Light
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#3d4947'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#6d7a77'
  outline-variant: '#bcc9c6'
  surface-tint: '#006a61'
  primary: '#00685f'
  on-primary: '#ffffff'
  primary-container: '#008378'
  on-primary-container: '#f4fffc'
  inverse-primary: '#6bd8cb'
  secondary: '#b61722'
  on-secondary: '#ffffff'
  secondary-container: '#da3437'
  on-secondary-container: '#fffbff'
  tertiary: '#825100'
  on-tertiary: '#ffffff'
  tertiary-container: '#a36700'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#89f5e7'
  primary-fixed-dim: '#6bd8cb'
  on-primary-fixed: '#00201d'
  on-primary-fixed-variant: '#005049'
  secondary-fixed: '#ffdad7'
  secondary-fixed-dim: '#ffb3ad'
  on-secondary-fixed: '#410004'
  on-secondary-fixed-variant: '#930013'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
  canvas-bg: '#ffffff'
  surface-subtle: '#f8fafc'
  surface-border: '#e2e8f0'
  accent-teal: '#14b8a6'
  accent-teal-dark: '#0f766e'
  mint-badge-tint: '#ccfbf1'
  status-operational: '#10b981'
  status-operational-bg: '#ecfdf5'
  status-outage: '#ef4444'
  status-outage-bg: '#fef2f2'
  status-degraded: '#f59e0b'
  status-degraded-bg: '#fffbeb'
  text-primary: '#0f172a'
  text-secondary: '#475569'
  text-caption: '#94a3b8'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '800'
    lineHeight: 34px
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
  title-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 18px
  code-lg:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  code-md:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  code-sm:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
  label-xs:
    fontFamily: JetBrains Mono
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 12px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  gutter-tablet: 1rem
  gutter-desktop: 1.5rem
  margin: 1rem
  margin-tablet: 1.5rem
  margin-desktop: 2rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system is tailored for mobile SREs, on-call engineers, and DevOps leads who demand instantaneous situational awareness without cognitive fatigue. Departing from heavy, low-contrast dark palettes, the interface embraces an ultra-clean, high-legibility light mode aesthetic grounded in modern minimalism and systematic clarity.

The experience projects precision, calm authority, and operational speed. Generous whitespace, razor-sharp structural alignments, and subtle borders replace visual noise. Telemetry cards, latency benchmarks, and incident states stand out crisply against pure white and delicate cool-slate canvases, providing effortless readability even in high-glare environments.

## Colors

The color palette prioritizes high-contrast legibility and rapid semantic decoding on light backgrounds:

- **Canvas & Surface Tiering**: The base canvas alternates between crisp Pure White (`#ffffff`) and soft Cool Slate-50 (`#f8fafc`). Elevated container cards use `#ffffff` framed by subtle `#e2e8f0` borders.
- **Brand & Primary Accent**: Cyber-mint and deep teal (`#0d9488`) lead the interactive surface vocabulary, supported by vibrant `#14b8a6` for active micro-interactions and `#0f766e` for focused press states. Light mint badge tints (`#ccfbf1`) offer soft background fills.
- **Semantic Status Architecture**:
  - **Operational**: Vibrant Emerald (`#10b981`) paired with faint green surface fill (`#ecfdf5`).
  - **Outage / Sev-1**: Crimson Red (`#ef4444`) with soft red highlight tint (`#fef2f2`).
  - **Degraded / Warning**: Amber (`#f59e0b`) paired with warm warning fill (`#fffbeb`).
- **Text & Hierarchy**: Slate-900 (`#0f172a`) establishes authoritative headline contrast, Slate-600 (`#475569`) provides balanced readability for secondary body content, and Slate-400 (`#94a3b8`) isolates metadata, timestamps, and captions.

## Typography

The typography system distributes clear functional responsibilities across three complementary typefaces:

1. **Plus Jakarta Sans** provides structural elegance, modern geometric curves, and approachability for high-level screen titles, incident severity labels, and service names.
2. **Inter** handles narrative density with neutral, highly legible glyphs for incident timelines, runbooks, logs, Slack integrations, and triage comments.
3. **JetBrains Mono** governs all precision metrics, ensuring optical alignment across tabular data, HTTP response statuses (`200 OK`, `502 BAD GATEWAY`), latency readouts (`42ms`), commit hashes, and infrastructure nodes.

All monospaced labels (`label-xs`) apply `+0.04em` letter spacing to preserve crisp rendering at micro-scales.

## Layout & Spacing

The layout model emphasizes airy, organized information density without visual crowding.

- **Grid Structure**:
  - **Mobile (<600px)**: 4-column fluid layout with `1rem` edge margins and `0.75rem` gutters. Metric overview cards display in 2-column grids, transitioning to single-column full-width containers for incident streams and latency charts.
  - **Tablet (600px–1023px)**: 8-column layout with `1.5rem` margins and `1rem` gutters, facilitating side-by-side node health maps and active incident feeds.
  - **Desktop (1024px+)**: 12-column layout with `2rem` outer margins and `1.5rem` gutters for dedicated multi-region operational views.
- **Spacing Rhythm**: Component padding relies on structured tokens: `space-xs` and `space-sm` for metric pills and status tags; `space-md` for compact card insets; `space-lg` for standard card bodies; and `space-xl` for section separation.

## Elevation & Depth

Depth is established through low-contrast hairline borders combined with soft ambient drop shadows, preserving an ultra-clean, distraction-free environment:

- **Level 0 (Base Canvas)**: Flat Pure White (`#ffffff`) or Cool Slate-50 (`#f8fafc`) with zero elevation.
- **Level 1 (Telemetry Cards & Panels)**: Pure White (`#ffffff`) surface with a crisp `1px solid #e2e8f0` outline and an ultra-soft drop shadow (`box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.04), 0 1px 2px -1px rgba(0, 0, 0, 0.02)`).
- **Level 2 (Active/Hover Cards & Sticky Headers)**: Pure White (`#ffffff`) with `1px solid #cbd5e1` outline and an elevated shadow (`box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -2px rgba(0, 0, 0, 0.03)`).
- **Level 3 (Modals, Bottom Sheets & Command Overlays)**: `#ffffff` surface, `1px solid #e2e8f0`, backed by an ambient scrim and focused shadow (`box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -4px rgba(0, 0, 0, 0.03)`).
- **Critical Alert Elevation**: Outage cards employ a soft crimson boundary (`1px solid #fecaca`) and a subtle red tint wash (`#fef2f2`), eliminating reliance on harsh glowing effects.

## Shapes

The shape system employs roundedness level 2, generating balanced, ergonomic surfaces standard in modern mobile operating systems:

- **Standard UI Controls** (buttons, input fields, dropdown triggers): `0.5rem` (`8px`) corner radius.
- **Service Cards & Diagnostic Panels**: `1rem` (`16px`) corner radius (`rounded-lg`) for a clean, contained silhouette.
- **Bottom Drawers, Modals & Notification Banners**: `1.5rem` (`24px`) top corner radius (`rounded-xl`).
- **Telemetry Pills, Badges & Ping Beacons**: Fully rounded pill shapes (`9999px`) to visually separate continuous status tags from structural cards.

## Components

### Buttons
- **Primary Action**: Background `#0d9488` with text `#ffffff` (`title-sm`), rounded `8px`. Hover/active shifts to `#0f766e`.
- **Secondary Action**: Background `#ffffff`, border `1px solid #e2e8f0`, text `#0f172a`. Hover state switches surface to `#f8fafc` with border `#cbd5e1`.
- **Destructive (Resolve / Kill Service)**: Background `#ef4444`, text `#ffffff`. Subtle shadow with red tint focus ring (`rgba(239, 68, 68, 0.2)`).

### Service & Telemetry Cards
- Containers use `#ffffff` with `1px solid #e2e8f0` and soft elevation.
- Internal padding is `space-lg` (`1rem`). Card headers display service name (`title-sm`, `#0f172a`), AWS/GCP region tag (`code-sm`, `#94a3b8`), and dynamic status badge right-aligned.

### Status Badges & Indicators
- **Operational**: Pill container with `#ecfdf5` fill, `#10b981` text (`code-sm`), with an integrated 6px solid emerald dot.
- **Degraded**: Pill container with `#fffbeb` fill, `#d97706` text (`code-sm`), with a 6px amber dot.
- **Outage**: Pill container with `#fef2f2` fill, `#ef4444` text (`code-sm`), accompanied by a pulsing crimson dot.

### Input Fields & Search Bars
- Background `#ffffff` with border `1px solid #e2e8f0` and text `#0f172a` (`body-md`).
- Focus state activates a `1px solid #0d9488` border and a soft ring shadow (`0 0 0 3px rgba(13, 148, 136, 0.15)`). Monospaced font is used for filter inputs and PromQL/LogQL queries.

### Lists & Incident Streams
- Incident rows separated by a clean hairline divider (`1px solid #f1f5f9`).
- Left edge includes a 3px rounded vertical indicator strip reflecting state: Emerald for restored, Amber for investigation, Red for active Sev-1/Sev-2.
- Timestamp rendered in `code-sm` (`#94a3b8`) for rapid temporal scanning.

### Checkboxes, Switches & Radio Controls
- Switch tracks use `#e2e8f0` when idle; active tracks fill with `#0d9488`. Thumb is crisp `#ffffff` with soft shadow.
- Checkboxes use `4px` corner radius, filling with `#0d9488` and a crisp white tick mark upon selection.

### Telemetry Sparklines & Metrics
- Inline graphs feature a light teal gradient stroke (`#0d9488`, 1.5px width) over a transparent fill fading into `#ffffff`.
- Min, p95, and max metrics appear below the line in `code-sm` using `#475569`.