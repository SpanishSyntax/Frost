---
name: barograph-explainer
description: >-
  Generates interactive, Artifact-based algorithmic and mathematical explainers
  with embedded data visualizations powered by Barograph. Use this skill when
  the user asks for deep-dive technical explainers, algorithmic breakdowns, or
  visual mathematical intuition for algorithms and dynamical systems in the
  Frost ecosystem.
---

# Barograph Explainer

## Summary
Generates interactive, Artifact-based technical explainer pages for algorithms, mathematical models, and control systems within the Frost ecosystem. Bridges intuitive concepts with rigorous mathematics, expandable technical deep dives, and data visualizations powered by the **Barograph** plot runner and exporter.

## When to Use
- The user asks to explain, visualize, or break down an algorithm, mathematical derivation, optimization method, or control theory concept.
- The user requests an interactive explainer document or deep-dive Artifact for a module or project in the Frost ecosystem.
- The user wants companion simulation scripts formatted for Barograph (`plot_*.py`) alongside theoretical documentation.

## Operational Procedures

1. **Intuition First (Zero-Jargon Grounding)**:
   - Begin with a high-level summary explaining what the algorithm achieves physically and why it was created, avoiding dense notation in the opening paragraphs.
   - Anchor the mechanism in a physical analogy (e.g., energy wells, spring-mass equilibria, hydraulic fluid pressure, or electrical network loops).

2. **Visual Architecture via Barograph**:
   - Design self-contained Python plotting scripts (`plot.py` or `plot_<concept>.py`) adhering to Barograph protocols:
     - **Supported Backends**: Construct standard figures using **Plotly** (`import plotly.graph_objects as go; fig = go.Figure()`), **Matplotlib** (`import matplotlib.pyplot as plt`), or **Seaborn**.
     - **Extraction Protocol**: Barograph automatically extracts the top-level `fig` attribute, callable `plot()` / `main()`, or the active Matplotlib figure stack (`plt.get_fignums()`).
     - **Execution & Export**:
       - Live interactive preview: `barograph serve plot.py` (auto-detects port, watches files, and pushes browser updates).
       - Static batch export: `barograph build plot.py --format svg` (or HTML/PNG).
       - MCP Bridge: Use Sled's atomic tools `barograph_build` or `barograph_list` when operating programmatically.
     - **Constraint**: Do NOT call `fig.show()` or `plt.show()` inside scripts intended for automated Barograph pipelines.

3. **Artifact Construction**:
   - Construct a structured Antigravity Markdown Artifact containing:
     - Clear executive summary and problem formulation.
     - Embedded vector plots (SVG) or exported interactive visualizations.
     - Mermaid diagrams (`flowchart TD`, `sequenceDiagram`, or `stateDiagram-v2`) showing algorithmic workflows, state transitions, or execution graphs.
     - Callout blocks (`> [!NOTE]`, `> [!IMPORTANT]`, `> [!TIP]`) to highlight non-obvious dynamics or convergence guarantees.

4. **Rigorous Technical Deep Dive**:
   - Follow the conceptual overview with mathematical derivations, convergence proofs, computational time/space complexity, and physical constraint handling.
   - Frame runtime environments within the Frost ecosystem, utilizing Basecamp (`basecamp init barograph` or `basecamp init python`) for reproducible Nix DevShells.
