---
name: folio-slides
description: Generates high-impact 16:9 widescreen presentation slide decks in Markdown compiled to PDF via Folio slides mode. Trigger with /slides or /deck.
---

# Folio Slides Generator (16:9 Keynote Deck Engine)

## Summary
Generates high-impact, mathematically rigorous 16:9 widescreen presentation slide decks in standard Markdown compiled directly into publication-grade PDFs via **Folio** in `slides` mode (`folio slides.md` or `cryo/folio_build`). Utilizes an Apple Keynote-inspired minimalist typography design system with native Typst math, dark/light themes, and card layouts.

## When to Use
- User types `/slides`, `/deck`, or `/presentation`
- User wants to turn lecture material, technical reports, architecture reviews, or thesis defenses into slide decks.
- User wants to scaffold or compile presentation slides in Markdown via Folio.

---

## 1. Project Scaffolding with Flaker
Before authoring, ensure the document workspace has the Folio slides foundation:
- Run in target workspace:
  ```bash
  flaker init folio:slides
  ```
  Or if adding to an existing folder:
  ```bash
  flaker project folio:slides
  ```
- **Scaffolded Foundation**:
  - `flake.nix` & `.envrc` (DevShell with Typst, Pandoc, Tinymist)
  - `slides.typ` (16:9 Widescreen 1920x1080 minimalist presentation template)
  - `packages.typ` (Package bundle: CeTZ, Fletcher, Physica, Tablex, Mermaid)
  - `library.bib` (BibTeX bibliography)
  - `slides.md` (Starter presentation deck)

---

## 2. Document Frontmatter Contract
The presentation markdown file (`slides.md`) MUST contain the Folio slides YAML frontmatter:

```yaml
---
title: "Distributed Swarm Consensus"
subtitle: "Convergence Rates Under GPS-Denied Communication Topologies"
author: "Author Name"
dependency: "TU Delft • Department of Systems & Control"
date: "October 2026"
mode: "slides"
engine: "typst"
theme: "dark" # "dark" (Keynote OLED black) or "light" (clean lecture hall print)
aspect-ratio: "16-9"
---
```

> **Rules**:
> - `mode: "slides"` instructs Folio to wrap Pandoc AST output in `slides.typ`.
> - `theme: "dark"` activates deep black background `#000000`, card backgrounds `#161618`, and accent blue `#2997ff`.
> - `theme: "light"` activates paper-white background `#fbfbfd` with contrast text.
> - `aspect-ratio: "16-9"` guarantees native 1080p widescreen presentation formatting.

---

## 3. Presentation Authoring Principles

### Slide Delimiters & Typography
- **Slide Break**: A horizontal rule `---` creates an explicit slide transition (`pagebreak(weak: true)` in `slides.typ`).
- **Slide Title**: Level 1 Markdown heading `# Exact Slide Title` becomes the slide frame title.
- **Subtitle / Context**: Directly follow `# Title` with a short bold lead or italics.
- **Information Density Rule**: **One core concept per slide**. Max 4–5 bullets or 1 central equation/diagram block. Do not crowd slides with dense narrative paragraphs.

### Mathematical Formatting
- Use standard display math `$$\dots$$` for central formulations:
  $$
  \min_{\mathbf{x}_i} \sum_{j \in \mathcal{N}_i} \|\mathbf{x}_i - \mathbf{x}_j - \mathbf{d}_{ij}\|_{\mathbf{\Sigma}_{ij}}^2
  $$
- Call out key guarantees with blockquotes:
  > **Theorem (Exponential Convergence)**: Under connectivity $\lambda_2(\mathcal{L}) > 0$, consensus converges with rate $\rho < 1$.

### Visual Elements & Diagrams
- **Code Blocks**: Deterministic, syntax-highlighted snippets with clean indentation.
- **Diagrams**: Fenced `mermaid` blocks or `cetz`/`fletcher` imports from `packages.typ`.
- **Key-Value Metrics & Tables**: Clean Markdown tables for parameters, benchmark numbers, and state variables.

---

## 4. Multi-Deck or Modular Lecture Organization
For large lecture series or multi-part talks:
```text
lecture-slides/
├── flake.nix
├── packages.typ
├── slides.typ
├── library.bib
├── slides.md               <-- Master deck
└── modules/
    ├── part1_motivation.md
    ├── part2_estimator.md
    └── part3_experimental.md
```
To combine multiple module decks into `slides.md`:
1. **Via CLI (`folio assemble`)**:
   ```bash
   folio assemble modules -o slides.md -m slides --title "Swarm Consensus" --theme dark
   ```
2. **Via Cryo MCP (`cryo/folio_assemble`)**:
   ```json
   call_mcp_tool("cryo", "folio_assemble", {
     "chapters_dir": "modules",
     "output_file": "slides.md",
     "title": "Swarm Consensus",
     "subtitle": "Convergence Guarantees",
     "mode": "slides",
     "theme": "dark"
   })
   ```

---

## 5. Compilation & Preview
1. **Via Cryo MCP**:
   ```json
   call_mcp_tool("cryo", "folio_build", {"input_file": "slides.md", "mode": "slides"})
   ```
2. **Via CLI**:
   ```bash
   folio slides.md
   ```
3. **Live Watch (Interactive Keynote Preview)**:
   ```bash
   folio slides.md -w
   ```
   (In Neovim: `<leader>wfb` to compile, `<leader>wfv` to open PDF in Sioyek).
