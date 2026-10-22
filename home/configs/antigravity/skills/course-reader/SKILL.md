---
name: course-reader
description: Synthesizes course notes, lecture slides, or textbooks into clean, single-column, mathematically rigorous explainer readers compiled via native Typst or Folio. Trigger with /reader or /chapter.
---

# Course Reader Generator (Single-Column Technical Reader Engine)

## Summary
Synthesizes dense lecture slides, professor notes, and course textbooks into structured, highly readable, single-column technical readers. Built for high pedagogical clarity using TU Delft / European systems engineering standards, pairing mathematical derivations with high-resolution vector visualizations and zero-assumption mechanical intuition.

## When to Use
- User types `/reader` or `/chapter`.
- User provides raw course slide decks, reader PDFs, or lecture transcripts and requests a comprehensive course reader, cheatsheet notebook, or study companion.

---

## 1. Document Architecture & Formatting Contract

### Single-Column Typography Rules (Strict)
- **Strictly Single-Column**: Always use a clean single-column layout with generous margins ($2.4\text{ cm}$ top/bottom, $2.6\text{ cm}$ left/right). **Never generate multi-column splits or leaking side-by-side card wrappers in technical readers.**
- **No Card Overuse**: Do not wrap paragraph after paragraph in decorative card containers. Use continuous, structured academic prose. Reserve clean left-bordered `callout` boxes exclusively for named theorems (e.g., Sylvester's Criterion, Wolfe's Entry Rule, Schur Complement).
- **Native Typst Foundation**: Prefer compiling via native Typst (`report.typ`) to avoid Pandoc markdown parsing bugs (such as raw `#pagebreak()` printing as literal headers).

---

## 2. Pedagogical Architecture per Chapter

Every chapter must follow this self-contained 7-part pedagogical progression:

1. **Chapter Heading**: Clear numbering and topic name.
2. **The Intuitive / Physical Anchor**:
   - Ground abstract mathematics immediately in physical hardware realities (spring stiffness, resistor power dissipation, motor current saturation, or hydraulic fluid pressure).
   - Never start with naked symbols.
3. **The "Why"**:
   - Explain the concrete engineering dilemma or historical bottleneck that forced researchers to invent this abstraction (e.g. why Newton's step fails on non-convex saddles, why multi-variable systems require a matrix Hessian instead of a single scalar second derivative).
4. **Formula Decomposition & Variable Breakdown**:
   - Define every symbol, vector dimension, and matrix structure ($A \in \mathbb{R}^{m \times n}, x \in \mathbb{R}^n$).
   - Explain why the equations are constructed the way they are (e.g. why $x^T$ sandwiches $H$, why the factor of $1/2$ is placed in advance).
5. **High-Resolution Vector Visualizations**:
   - Always embed clean, high-resolution vector figures (SVG generated via Python with `matplotlib`, `seaborn`, `cmocean` or native `cetz`).
   - Every figure must have an informative caption explaining the geometry (e.g. level curves, pivot trajectories, force equilibrium).
6. **Step-by-Step Worked Numerical Example**:
   - Provide a concrete numerical calculation (with real numbers like $2 \times 2$ matrices) solved by hand to show how the matrix formula produces the exact same result as basic algebra.
7. **Exam Pitfalls & Diagnostic Alerts**:
   - Highlight deceptive slide questions, non-convex traps, indefinite Hessian cases, or condition number bottlenecks.

---

## 3. Visuals & Plotting Pipeline
- Generate publication-grade vector graphics using a dedicated Python script:
  - Formats: Always export to **vector SVG** (`plt.savefig("plot.svg")`) for razor-sharp typography at any zoom level.
  - Palettes: Use perceptually uniform colormaps (`cmocean.cm.ice_r`, `dense_r`, `curl`, `deep_r`) with crisp styling.
  - No ASCII or terminal art diagrams—always real plots!
