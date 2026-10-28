---
name: snowpack-reader
description: >-
  Synthesizes lecture slides, raw professor notes, or textbooks into clean,
  single-column, mathematically rigorous technical readers compiled with
  Snowpack or Typst. Use this skill when the user asks to create a study reader,
  course companion, lecture summary, or textbook chapter notes.
---

# Snowpack Reader Generator (Single-Column Technical Reader Engine)

## Summary
Synthesizes dense lecture slides, professor notes, and course textbooks into structured, highly readable, single-column technical readers. Engineered for high pedagogical clarity using European / TU Delft systems engineering standards, pairing formal mathematical derivations with high-resolution vector visualizations, zero-assumption mechanical intuition, and clean typography powered by **Snowpack** and native **Typst**.

## When to Use
- The user provides raw course slide decks, reader PDFs, or lecture transcripts and requests a comprehensive course reader, cheatsheet notebook, or study companion.
- The user asks to turn technical documentation or lecture material into a publication-grade PDF report or chapter reader.
- The user is preparing for technical exams and needs a structured, step-by-step breakdown of syllabus theorems and numerical examples.

---

## 1. Document Architecture & Formatting Contract

### Single-Column Typography Rules (Strict)
- **Strictly Single-Column**: Always use a clean single-column layout with generous margins ($2.4\text{ cm}$ top/bottom, $2.6\text{ cm}$ left/right). **Never generate multi-column splits or leaking side-by-side card wrappers in technical readers.**
- **Judicious Callout Usage**: Do not wrap standard explanatory paragraphs inside decorative card containers. Write continuous, well-structured academic prose. Reserve clean left-bordered callout blocks exclusively for named theorems, definitions, and critical exam pitfalls.
- **Engine Selection**:
  - **Native Typst (`report.typ`)**: Recommended for zero-friction compilation, robust math typesetting, and native `#pagebreak()` support.
  - **Snowpack Markdown (`report.md`)**: Set frontmatter `mode: report` with `engine: typst` to leverage Snowpack's automated report template.

---

## 2. Pedagogical Architecture per Chapter

Every chapter must follow this self-contained 7-part pedagogical progression:

1. **Chapter Heading**: Clear numbering and topic name.
2. **The Intuitive / Physical Anchor**:
   - Ground abstract mathematics immediately in physical hardware realities (spring stiffness, resistor power dissipation, motor current saturation, or hydraulic fluid pressure).
   - Never start with naked, ungrounded Greek symbols.
3. **The "Why"**:
   - Explain the concrete engineering dilemma or historical bottleneck that forced researchers to invent this abstraction (e.g., why Newton's optimization step fails on non-convex saddles, why multi-variable systems require a matrix Hessian instead of a single scalar second derivative).
4. **Formula Decomposition & Variable Breakdown**:
   - Explicitly define every symbol, vector dimension, and matrix structure ($A \in \mathbb{R}^{m \times n}, x \in \mathbb{R}^n$).
   - Explain why equations are constructed the way they are (e.g., why $x^T$ sandwiches $H$, why the factor of $1/2$ is placed in advance).
5. **High-Resolution Vector Visualizations**:
   - Pair explanations with clean, high-resolution vector figures (SVG) generated via Python plotting scripts or native Typst `cetz`.
   - Every figure must have an informative caption explaining the geometry (e.g., level curves, phase trajectories, force equilibrium).
6. **Step-by-Step Worked Numerical Example**:
   - Provide a concrete numerical calculation (using real numbers such as $2 \times 2$ matrices) solved by hand to demonstrate that the abstract formula produces the exact same result as basic algebra.
7. **Exam Pitfalls & Diagnostic Alerts**:
   - Highlight deceptive slide questions, non-convex traps, indefinite Hessian cases, or condition number bottlenecks.

---

## 3. Scaffolding, Compilation & Tooling Pipeline

### Scaffolding via Basecamp
Initialize a clean Snowpack workspace using Basecamp:
```bash
# Initialize a Snowpack workspace configured for report mode
basecamp init snowpack report

# Or initialize a native Typst workspace
basecamp init typ
```

### Compilation via Snowpack
Compile documents to publication-grade PDFs:
```bash
# Compile report.md using Snowpack
snowpack report.md -m report

# Continuous live-watch mode during authoring
snowpack report.md -m report -w

# Native Typst compilation
snowpack report.typ -w
```

### Programmatic Sled MCP Integration
When orchestrating builds from agent sessions, utilize Sled's `snowpack_build` atomic tool:
```json
{
  "source": "report.md",
  "mode": "report",
  "engine": "typst"
}
```

### Visuals via Barograph
Generate vector graphics using Barograph-compatible standalone scripts:
- Export SVG figures via `barograph build plot.py --format svg` (or via Sled MCP `barograph_build`).
- Embed resulting `.svg` files directly into Typst (`#image("plot.svg", width: 85%)`) or Markdown (`![Caption](plot.svg)`).
