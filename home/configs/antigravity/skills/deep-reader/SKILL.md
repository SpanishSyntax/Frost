---
name: deep-reader
description: >-
  Compiles comprehensive, publication-grade single-column technical readers,
  course companions, and textbook chapter notes into production PDFs using
  Snowpack and Typst. Use this skill when the user asks to compile a course
  reader, study companion, comprehensive lecture notes document, or textbook
  chapter.
---

# Deep Reader (Single-Column Technical Reader & Study Companion Engine)

## Summary
Synthesizes dense lecture slide decks, raw professor notes, syllabus topics, and textbook chapters into structured, publication-grade, single-column technical readers. Engineered for high pedagogical clarity using European / TU Delft systems engineering standards, pairing formal mathematical derivations with high-resolution vector visualizations, zero-assumption mechanical intuition, and clean typography powered by **Snowpack** and native **Typst**.

## When to Use
- The user provides raw course slide decks, reader PDFs, or lecture transcripts and requests a comprehensive course reader, cheatsheet notebook, or study companion.
- The user asks to turn technical documentation, lecture material, or a paper series into a publication-grade PDF report or textbook chapter.
- The user is preparing for technical exams and needs a structured, step-by-step breakdown of syllabus theorems with worked numerical examples.

## Operational Contract (🏛️ Deep / Production Compiler)
- **Enduring Deliverable**: Compiles a production-ready PDF (`report.pdf`) on disk rather than dumping massive walls of text into the chat stream.
- **Strictly Single-Column**: Always enforces a clean single-column layout with generous margins ($2.4\text{ cm}$ top/bottom, $2.6\text{ cm}$ left/right). **Never generate multi-column splits or leaking side-by-side card wrappers in technical readers.**
- **Judicious Callout Usage**: Standard academic prose flows continuously. Reserve clean left-bordered callout blocks exclusively for named theorems, formal definitions, and critical exam pitfalls.
- **Toolchain Orchestration**: Scaffolds via **Basecamp**, compiles via **Snowpack** (`report` mode) or native **Typst**, and generates vector figures via **Barograph**.

---

## The 7-Stage Pedagogical Chapter Progression

Every chapter must follow this self-contained 7-part pedagogical progression:

1. **Chapter Heading**: Clear numbering and topic name.
2. **The Intuitive / Physical Anchor**:
   - Ground abstract mathematics immediately in physical hardware realities (spring stiffness, resistor power dissipation, motor current saturation, or hydraulic fluid pressure).
   - Never start with naked, ungrounded Greek symbols.
3. **The Historical & Engineering "Why"**:
   - Explain the concrete engineering dilemma or historical bottleneck that forced researchers to invent this abstraction (e.g., why Newton's optimization step fails on non-convex saddles, why multi-variable systems require a matrix Hessian instead of a single scalar second derivative).
4. **Formula Decomposition & Variable Breakdown**:
   - Explicitly define every symbol, vector dimension, and matrix structure ($A \in \mathbb{R}^{m \times n}, x \in \mathbb{R}^n$).
   - Explain why equations are constructed the way they are (e.g., why $x^T$ sandwiches $H$, why the factor of $1/2$ is placed in advance).
5. **High-Resolution Vector Visualizations**:
   - Pair explanations with clean, high-resolution vector figures (SVG) generated via Python plotting scripts (`barograph build plot.py --format svg`) or native Typst `cetz`.
   - Every figure must have an informative caption explaining the geometry (e.g., level curves, phase trajectories, force equilibrium).
6. **Step-by-Step Worked Numerical Example**:
   - Provide a concrete numerical calculation (using real numbers such as $2 \times 2$ matrices) solved by hand to demonstrate that the abstract formula produces the exact same result as basic algebra.
7. **Exam Pitfalls & Diagnostic Alerts**:
   - Highlight deceptive slide questions, non-convex traps, indefinite Hessian cases, or condition number bottlenecks.

---

## Toolchain & Compilation Pipeline

### Step 1: Scaffolding via Basecamp
Initialize a clean Snowpack workspace in the target directory:
```bash
# Initialize a Snowpack workspace configured for report mode
basecamp init snowpack report

# Or initialize a native Typst workspace
basecamp init typ
```

### Step 2: Authoring with Typst or Snowpack Markdown
* **Native Typst (`report.typ`)**: Recommended for zero-friction compilation, robust math typesetting, and native `#pagebreak()` support.
* **Snowpack Markdown (`report.md`)**: Set frontmatter:
  ```markdown
  ---
  title: "Nonlinear Systems & Control Theory"
  author: "Systems Architecture Group"
  mode: report
  engine: typst
  ---
  ```

### Step 3: Compilation via Snowpack
Compile the document to a publication-grade PDF:
```bash
# Compile report.md in report mode
snowpack report.md -m report

# Continuous live-watch mode during authoring
snowpack report.md -m report -w

# Native Typst compilation
snowpack report.typ -w
```

### Step 4: Programmatic Sled MCP Integration
When compiling from agent sessions, trigger Sled's `snowpack_build` atomic tool:
```json
{
  "source": "report.md",
  "mode": "report",
  "engine": "typst"
}
```
Provide the user with a clickable link to the compiled PDF deliverable:
`[View Compiled Reader](file:///path/to/report.pdf)`
