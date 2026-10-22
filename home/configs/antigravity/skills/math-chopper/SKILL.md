---
name: math-chopper
description: Decomposes complex matrix equations, control proofs, and optimization formulas into letter-by-letter plain English, high-school analogies, and step-by-step arithmetic without assuming prior knowledge. Trigger with /chop or /decode.
---

# Math Chopper (Zero-Assumption Formula Decoder)

## Summary
Deconstructs dense mathematical formulas, matrix expressions, and academic theorems letter-by-letter into tangible physical mechanics, high-school algebra, and concrete arithmetic. Never assumes prior knowledge or skips steps. Written to bridge the gap for students who understand high-school intuition but feel alienated by naked mathematical formalism.

## When to Use
- User types `/chop`, `/decode`, or asks "what does this formula mean?", "explain this equation", "what does this letter stand for?".
- User expresses confusion over condensed matrix notations ($x^T H x$, KKT block matrices, Riccati equations, Lyapunov inequalities).
- When generating an explainer companion manual alongside a course reader.

---

## The 4-Tier Chopper Decomposition Protocol

Every formula must be passed through these 4 strict tiers:

### Tier 1: The High-School Physical Anchor
Before writing any Greek symbol or matrix, ground the equation in an everyday tangible object:
- **Resistors & circuits**: Ohm's law, dissipated heat, battery voltages.
- **Springs & weights**: Hooke's law, stiffness $k$, gravity weights $F = mg$, stretch $x$.
- **Water pipes & tanks**: Flow rate, hydraulic pressure, valve resistance.
- **Rulers & geometric boundaries**: Tangent rulers, guillotine clamps, physical concrete walls.

### Tier 2: Letter-by-Letter Decomposition (The Cutting Board)
Take the target equation and isolate **every single character, exponent, fraction, and superscript**:
```text
   f(x)  =   1/2   ·   xᵀ   ·   H   ·   x   +   cᵀ   ·   x
    │         │        │        │       │       │        │
 Total Cost  Half   Transpose  Hessian Vector  Linear  Vector
  [Joules]   Factor   State    Matrix  State   Force    State
```
For each letter, explain:
1. **What it is**: Dimension ($n \times 1$, scalar, $n \times n$) and standard units (Volts, meters, Newtons).
2. **What it does**: The role it plays in the equation (e.g. "the tuning knobs", "the stiffness", "the pulling force").
3. **Why it looks weird**: Explain linear algebra quirks without jargon (e.g. why $x^T$ is needed to sandwich a matrix into a single number, why the fraction $1/2$ is placed in advance to cancel the $2$ from the derivative).

### Tier 3: Concrete Numbers Walkthrough (The Arithmetic Proof)
Never stop at symbols! Instantiate the equation with trivial, concrete numbers (e.g. $2 \times 2$ diagonal matrices):
- Write out the full matrix multiplication explicitly.
- Show that the matrix equation collapses into two ordinary high-school parabolas or linear equations.
- Solve the numbers by hand to show that the abstract formula (e.g. $x^* = -H^{-1} c$) produces the exact same answer as basic middle-school calculus.

### Tier 4: The Force & Wall Reaction (Lagrange / KKT Intuition)
Whenever constraints or multipliers ($\lambda, \mu$) appear:
- Treat the multiplier as a **physical force gauge** (in Newtons) measuring how hard the state is pressing against a rigid boundary wall.
- **Primal feasibility**: You cannot walk through concrete walls.
- **Dual feasibility**: Walls push back; they cannot suck you into the wall.
- **Complementary slackness**: If you don't touch the wall, the force gauge reads zero.

---

## Pedagogical Golden Rules
1. **Never Assume Prerequisite Fluency**: Explain what a transpose is, why matrices don't divide like scalars, and why eigenvalues dictate curvature.
2. **Always Use High-Resolution Vector Visualizations**: Pair the explanation with a vector plot (e.g. via `matplotlib`, `seaborn`, or `cmocean`) showing the 2D energy bowl or geometric slice.
3. **Keep Explanations Single-Column**: Prevent multi-column text wrap or card-in-card nesting that clutters the reader's view.
