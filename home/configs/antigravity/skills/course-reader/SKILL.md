---
name: course-reader
description: Synthesizes course notes, NotebookLM sources, or lecture transcripts into structured, modular chapter-by-chapter explainer readers compiled via Folio report mode. Trigger with /reader or /chapter.
---

# Course Reader Generator (Folio Report Engine)

## Summary
Synthesizes dense lecture transcripts, NotebookLM dumps, or slide notes into modular, mathematically rigorous course readers and study guides. Built explicitly for compilation via **Folio** in `report` mode (`folio report.md` or `cryo/folio_build`), using TU Delft / European systems engineering academic standards.

## When to Use
- User types `/reader` or `/chapter`
- User provides raw lecture dumps, NotebookLM excerpts, or course slides and requests a chapter, study guide, or comprehensive course reader.
- User wants to scaffold or compile a technical report or study reader in Markdown via Folio.

---

## 1. Project Scaffolding with Flaker
Before authoring, ensure the document workspace has the Folio report foundation:
- Run in target workspace:
  ```bash
  flaker init folio:report
  ```
  Or if adding to an existing folder:
  ```bash
  flaker project folio:report
  ```
- **Scaffolded Foundation**:
  - `flake.nix` & `.envrc` (DevShell with Typst, Pandoc, Tinymist)
  - `report.typ` (Minimalist A4/Letter sans-serif typography template)
  - `packages.typ` (Package bundle: CeTZ, Fletcher, Physica, Tablex, Mermaid)
  - `library.bib` (BibTeX bibliography)
  - `report.md` (Root compilation target)

---

## 2. Document Metadata & Frontmatter Contract
The root `report.md` (or master header) MUST contain the standard Folio YAML frontmatter:

```yaml
---
title: "Course Code: Full Course Title"
subtitle: "Comprehensive Explainer & Technical Reference Reader"
author: "Author Name"
dependency: "Department of Systems & Control • TU Delft"
date: "October 2026"
mode: "report"
engine: "typst"
---
```

> **Rules**:
> - `mode: "report"` signals Folio to wrap the AST in `report.typ`.
> - `engine: "typst"` guarantees sub-second native compilation with CeTZ/Fletcher/Physica support.
> - `dependency` maps to the institutional header in the Folio template.

---

## 3. Pedagogical Architecture per Chapter
Each chapter must be self-contained and structured with academic maturity:

1. **Chapter Heading**:
   - `# Chapter N: Exact Topic Title`
2. **Prerequisites & Learning Objectives**:
   - Concise bullet list of target concepts and prerequisite dependency graph.
3. **The Intuitive / Physical Anchor**:
   - Ground abstract mathematics immediately in physical hardware realities (actuators, motor windings, inertia tensors, circuits, discrete automata, or scheduling latency). Never begin with naked abstractions.
4. **Theoretical Formulation & Derivation**:
   - Explicit step-by-step mathematical treatment using standard LaTeX display math `$$\dots$$`.
   - Treat symbols as syntax for physical conservation laws (energy, momentum, mass, Kirchhoff laws).
   - Define all matrix dimensions explicitly (e.g. $\mathbf{A} \in \mathbb{R}^{n \times n}$, $\mathbf{B} \in \mathbb{R}^{n \times m}$).
5. **Worked Engineering Case Study**:
   - A concrete, non-trivial numerical or symbolic example with boundary conditions, matrix values, and step-by-step resolution.
6. **Architecture / State Diagram**:
   - A fenced `mermaid` block (flowchart, sequence, or state diagram) or `fletcher` diagram.
7. **Summary & Verification Questions**:
   - 3–4 conceptual diagnostic questions challenging edge cases (saturation, noise, unmodeled dynamics).
8. **Scholarly Citations**:
   - Reference sources using BibTeX keys matching `library.bib` (e.g. `[@khalil2002nonlinear; @astrom2010feedback]`).

---

## 4. Multi-Chapter Workspace Architecture & Assembly

For multi-chapter courses, keep chapters modular in a `chapters/` directory:

```text
course-workspace/
├── flake.nix
├── packages.typ
├── report.typ
├── library.bib
├── report.md                  <-- Master unified target compiled by Folio
└── chapters/
    ├── 01_foundations.md      <-- Modular chapters (NO duplicate YAML frontmatter)
    ├── 02_state_space.md
    └── 03_lyapunov_stability.md
```

### Chapter File Authoring Rules
- Individual files in `chapters/*.md` **must NOT** repeat the root `---` YAML frontmatter block. They start directly with `# Chapter N: ...`.
- Keep mathematical equations in standard LaTeX `$inline$` and `$$display$$`.
- Use standard Markdown tables and relative image links.

### Unifying Chapters (Assembly Pipeline)
Why assemble Markdown instead of merging PDFs?
- **Unified Table of Contents**: Typst automatically builds a linked global outline.
- **Continuous Pagination**: Master `Page X of Y` headers/footers with document title.
- **Unified Bibliography**: All `@cite` references across all chapters are resolved into a single deduplicated bibliography at the end of the document.
- **Cross-Chapter Links**: Hyperlinks between chapters remain fully intact.

**Assembly Methods**:
1. **Via CLI (`folio assemble`)**:
   ```bash
   folio assemble chapters -o report.md --title "SC42055 Control Systems" --subtitle "Course Reader"
   ```
2. **Via Cryo MCP (`cryo/folio_assemble`)**:
   ```json
   call_mcp_tool("cryo", "folio_assemble", {
     "chapters_dir": "chapters",
     "output_file": "report.md",
     "title": "SC42055 Control Systems",
     "subtitle": "Course Explainer Reader",
     "author": "Author Name",
     "dependency": "Department of Systems & Control • TU Delft",
     "mode": "report"
   })
   ```

---

## 5. Compilation & Verification
Once `report.md` is populated:
1. **Via Cryo MCP**:
   ```json
   call_mcp_tool("cryo", "folio_build", {"input_file": "report.md", "mode": "report"})
   ```
2. **Via CLI**:
   ```bash
   folio report.md
   ```
3. **Live Watch in Neovim / Terminal**:
   ```bash
   folio report.md -w
   ```
   (Or `<leader>wfb` in Neovim to build, `<leader>wfv` to view in Sioyek).
