---
name: tradeoff-matrix
description: Performs rigorous architectural, computational, and physical tradeoff analysis between multiple systems, algorithms, or control frameworks, emitting structured Artifacts with matrices and diagrams.
---

# Tradeoff Matrix

## Summary
Performs architectural tradeoff analysis between multiple systems, algorithms, or theoretical frameworks. Synthesizes complex comparisons into structured Antigravity Artifacts containing matrices, Mermaid charts, and engineering verdicts.

## When to Use
- User types `/compare` or asks to evaluate two or more approaches (e.g. Euler-Lagrange vs. Port-Hamiltonian, Stdio vs. SSE for MCP, RK45 vs. Radau).
- During design reviews when choosing hardware, architecture, or numerical schemes.

## Steps
1. **Define the Axes**: Evaluate systematically across:
   - **Physical / Mathematical Constraints**: Stability, energy conservation (passivity), conservation of invariants.
   - **Computational & Memory Load**: Discretization requirements, stiffness handling, algorithmic complexity.
   - **Implementation & Toolchain Complexity**: Dependencies, maintainability, debugging friction.
   - **Safety & Robustness**: Margin against parameter drift, noise rejection, failure modes.
2. **Artifact Generation**:
   Create a dedicated Markdown Artifact containing:
   - A Mermaid diagram (`graph TD` or `sequenceDiagram`) visualizing the contrasting workflows.
   - A clean Markdown comparison table.
   - A carousel block if comparing before/after or alternative pipelines.
3. **Definitive Architectural Verdict**:
   Do not hedge ambiguously. Provide a definitive recommendation based on systems engineering realities and specific project constraints.
