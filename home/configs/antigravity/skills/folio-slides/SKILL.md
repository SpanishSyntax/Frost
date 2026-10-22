---
name: folio-slides
description: Generates high-impact 16:9 widescreen presentation slide decks in native Typst or Folio slides mode with vector hero plots and clean keynote cards. Trigger with /slides or /deck.
---

# Folio Slides Generator (16:9 Keynote Deck Engine)

## Summary
Generates high-impact, mathematically rigorous 16:9 widescreen presentation slide decks directly compiled via Typst (`slides.typ` or `folio slides.md`). Utilizes an Apple Keynote-inspired design system with dark/light themes, clean typography, vector hero plots, and zero-assumption mathematical explanations.

## When to Use
- User types `/slides`, `/deck`, or `/presentation`.
- User wants to turn course material, technical reports, or research papers into presentation decks.

---

## 1. Presentation Authoring Principles

### Widescreen Layout & Typography
- **16:9 Aspect Ratio**: Native $1920 \times 1080$ presentation format (`paper: "presentation-16-9"`).
- **One Core Concept Per Slide**: Maximize visual impact. Never crowd slides with walls of text.
- **Split-Hero or Focused Card Layout**:
  - Left column ($55-60\%$): High-resolution vector graphic (SVG).
  - Right column ($40-45\%$): Concise mathematical formulation, physical intuition, and diagnostic take-away.

### Plotting & Visual Rules
- **Always Real Vector Plots**: No terminal drawings or ASCII diagrams. Always use clean vector SVGs generated via `matplotlib`, `seaborn`, `cmocean`, or native Typst `cetz`.
- **Theming**: Dark theme uses deep background (`#09090b` / `#000000`) with accent blue (`#2997ff`) and emerald (`#30d158`); Light theme uses clean paper background (`#fbfbfd`) with crisp high-contrast text.

---

## 2. Compilation
- Native Typst compilation:
  ```bash
  typst compile slides.typ slides.pdf
  typst watch slides.typ slides.pdf
  ```
- Or via Folio CLI:
  ```bash
  folio slides.md -m slides -w
  ```
