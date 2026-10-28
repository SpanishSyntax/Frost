---
name: tradeoff-matrix
description: >-
  Performs rigorous architectural, computational, and physical tradeoff
  analyses comparing competing systems, algorithms, or engineering frameworks,
  emitting structured Artifacts with comparison matrices and Mermaid diagrams.
  Use this skill when the user asks to compare, evaluate, or choose between
  multiple architectures, algorithms, or technical approaches.
---

# Tradeoff Matrix

## Summary
Performs systematic, multi-dimensional tradeoff analyses comparing competing engineering architectures, numerical algorithms, or theoretical control frameworks. Synthesizes complex comparisons into structured Antigravity Artifacts containing side-by-side matrices, Mermaid architectural flowcharts, and unambiguous engineering verdicts.

## When to Use
- The user asks to compare, contrast, or evaluate two or more technical approaches (e.g., Port-Hamiltonian vs. Euler-Lagrange, Stdio vs. Streamable HTTP for MCP, Runge-Kutta vs. Symplectic Integrators, Rust vs. C++ for embedded controllers).
- The user is making architectural design decisions and needs an objective breakdown of computational, mathematical, and maintenance costs.
- During technical planning sessions when evaluating migration strategies or selecting software frameworks.

## Operational Procedures

1. **Establish Multi-Dimensional Evaluation Axes**:
   - Evaluate competing approaches across rigorous, domain-specific criteria:
     - **Physical & Mathematical Guarantees**: Energy conservation (passivity), Lyapunov stability, symplectic preservation, constraint handling.
     - **Computational & Memory Footprint**: Time complexity, memory allocation behavior, stiffness handling, numerical scalability.
     - **Implementation & Toolchain Friction**: Dependency burden, build times, debugging overhead, ecosystem maturity within Frost/Nix.
     - **Operational Robustness & Failure Modes**: Sensitivity to parameter drift, sensor noise resilience, fault-tolerance.

2. **Artifact Generation**:
   Construct a dedicated Markdown Artifact containing:
   - **Executive Problem Statement**: Concise framing of the design dilemma.
   - **Mermaid Architectural Diagram**: Use `flowchart TD`, `flowchart LR`, or `sequenceDiagram` to visualize the structural or operational differences between options.
   - **Structured Markdown Comparison Matrix**: Clear table comparing options across all evaluation axes with rating symbols (e.g., `🟢 High`, `🟡 Moderate`, `🔴 Low`).
   - **Before/After or Alternative Walkthrough**: Use ````carousel blocks if illustrating sequential state transitions or contrasting pipeline steps.

3. **Definitive Engineering Verdict**:
   - Deliver an unambiguous, justified engineering recommendation based on project constraints.
   - Avoid non-committal conclusions ("Both have their pros and cons"). Explicitly state: "Choose Option A if $X$ is the primary constraint; choose Option B strictly when $Y$ occurs."
