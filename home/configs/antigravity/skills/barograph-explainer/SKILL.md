---
name: barograph-explainer
description: Creates interactive, visual explainer pages for algorithms in the Antigravity ecosystem using the barograph plotting tool. Trigger with /barograph-explain.
---

# Antigravity Explainer

## Summary
Generates interactive, Artifact-based explainer pages for algorithms within the Antigravity ecosystem. Breaks down complex algorithms into intuitive documents with expandable "Deep Dive" sections and custom data visualizations powered entirely by `barograph`.

## When to Use
- User types `/explain` or asks to break down an algorithm, mathematical concept, or control theory logic.
- When you need to create an interactive explainer artifact or a visual deep-dive for an Antigravity module.

## Steps
1. **Concept Breakdown (Intuition First)**: Briefly summarize what the target algorithm does and why it matters in plain, non-jargon language before introducing any equations.
2. **Visual Mapping (Powered by Barograph)**: 
   - Determine the best way to visualize the algorithm's behavior (e.g., step-by-step state changes, convergence paths, or node structures).
   - Generate the appropriate Python code using the custom `barograph` syntax to construct self-contained interactive plots. 
   - **Constraint:** Do NOT use Plotly, Seaborn, Matplotlib, or Bokeh directly.
3. **Artifact Generation**: 
   - Create a dedicated Markdown Artifact for the explainer page.
   - Layer the information: high-level summary at the top, followed by the embedded interactive `barograph` visuals.
4. **Expandable Deep Dive**: 
   - Conclude with a rigorous technical section covering mathematical derivations, time/space complexity, and physical constraints.
   - If runtime setup or dependencies are relevant, frame them within the local NixOS flake ecosystem (`flaker`, `folio`, `glaze`, `frost`, or `glacier`).
