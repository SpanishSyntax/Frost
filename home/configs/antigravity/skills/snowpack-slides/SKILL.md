---
name: snowpack-slides
description: >-
  Generates high-impact 16:9 widescreen presentation slide decks directly
  compiled with Snowpack or Typst using Keynote-inspired card layouts and
  vector hero figures. Use this skill when the user asks to turn technical
  notes, research papers, or algorithms into presentation slides.
---

# Snowpack Slides Generator (16:9 Keynote Deck Engine)

## Summary
Generates high-impact, mathematically rigorous 16:9 widescreen presentation slide decks directly compiled via **Snowpack** or native **Typst**. Employs an Apple Keynote-inspired design system with dark/light themes, clean typography, vector hero plots, and zero-assumption mathematical explanations.

## When to Use
- The user asks to turn course material, lecture notes, technical papers, or architectural designs into presentation slide decks.
- The user requests a 16:9 widescreen presentation deck formatted for Snowpack or Typst.
- The user wants a clean, publication-grade slide template pairing vector diagrams with concise mathematical bullet points.

---

## 1. Presentation Authoring Principles

### Widescreen Layout & Typography
- **16:9 Aspect Ratio**: Native $1920 \times 1080$ presentation format (`paper: "presentation-16-9"` in Typst, or `mode: slides` in Snowpack).
- **One Core Concept Per Slide**: Maximize visual engagement. Never crowd slides with walls of text or multi-paragraph blocks.
- **Split-Hero Card Layout**:
  - **Left Column ($55-60\%$)**: High-resolution vector graphic (SVG) illustrating the geometric, dynamic, or architectural phenomenon.
  - **Right Column ($40-45\%$)**: Concise mathematical formulation, physical intuition, and diagnostic take-away.

### Visuals & Theming
- **Vector Graphics**: Always embed clean vector SVGs generated via Python plotting scripts (`barograph build plot.py --format svg`) or native Typst `cetz`. Avoid low-resolution raster images or ASCII diagrams.
- **Theming**:
  - **Dark Theme (Default)**: Deep slate/black background (`#09090b` / `#000000`) with high-contrast text, accent blue (`#2997ff`), and emerald (`#30d158`).
  - **Light Theme**: Clean paper background (`#fbfbfd`) with crisp typography.

---

## 2. Scaffolding, Compilation & Tooling Pipeline

### Scaffolding via Basecamp
Initialize a clean slides workspace using Basecamp:
```bash
# Initialize a Snowpack workspace configured for 16:9 slides
basecamp init snowpack slides

# Or initialize a native Typst slides workspace
basecamp init typst:slides
```

### Authoring via Snowpack Markdown
In Markdown, slide transitions are delineated by horizontal rules (`---`):
```markdown
---
title: "Optimal Control & Pontryagin's Principle"
author: "Systems Architecture Group"
mode: slides
theme: dark
engine: typst
---

# Problem Formulation

<div class="split">

![State Trajectory](plot_trajectory.svg)

- State dynamics: $\dot{x}(t) = A x(t) + B u(t)$
- Quadratic cost: $J = \int_0^\infty (x^T Q x + u^T R u) dt$
- Goal: Synthesize state-feedback gain $K$ such that $u = -Kx$ minimizes $J$.

</div>

---

# The Riccati Solution
...
```

### Compilation via Snowpack
Compile presentation decks to PDF:
```bash
# Compile slides.md in slides mode with hot-reload watch
snowpack slides.md -m slides -w

# Native Typst compilation
snowpack slides.typ -w
```

### Programmatic Sled MCP Integration
Compile slides programmatically during agent sessions using Sled's `snowpack_build` atomic tool:
```json
{
  "source": "slides.md",
  "mode": "slides",
  "engine": "typst"
}
```
