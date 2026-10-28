---
name: math-chopper
description: >-
  Deconstructs dense mathematical formulas, matrix expressions, and optimization
  equations letter-by-letter into tangible physical mechanics, high-school
  algebra, and concrete arithmetic without assuming prior knowledge. Use this
  skill when the user asks to decode, break down, or explain complex formulas,
  Greek symbols, matrix equations, or optimization theorems.
---

# Math Chopper (Zero-Assumption Formula Decoder)

## Summary
Deconstructs dense mathematical formulas, matrix equations, and theoretical theorems character-by-character into tangible physical mechanics, high-school intuition, and concrete arithmetic. Eliminates opaque academic gatekeeping by refusing to assume prior specialized fluency, breaking down notation into explicit, approachable components.

## When to Use
- The user asks "what does this formula mean?", "can you explain this equation?", or "what does this symbol stand for?".
- The user expresses confusion over condensed linear algebra, quadratic forms ($x^T H x$), Karush-Kuhn-Tucker (KKT) conditions, Riccati equations, or Lyapunov dissipation inequalities.
- The user is building a course reader or study companion and needs a zero-assumption formula breakdown for students.

## The 4-Tier Chopper Decomposition Protocol

Every target formula is systematically processed through these 4 tiers:

### Tier 1: The High-School Physical Anchor
Before introducing any Greek notation or matrix operator, ground the equation in a physical, everyday object:
- **Resistors & circuits**: Ohm's law, dissipated electrical power ($P = I^2 R$), battery voltage drops.
- **Springs & dampers**: Hooke's law ($F = -kx$), damping forces ($F_d = -c\dot{x}$), potential energy bowls ($E = \frac{1}{2}kx^2$).
- **Water pipes & tanks**: Volumetric flow rate, hydraulic head pressure, valve friction.
- **Rulers & geometric walls**: Physical barriers, clamps, and support beams.

### Tier 2: Letter-by-Letter Decomposition (The Cutting Board)
Isolate **every individual symbol, exponent, subscript, superscript, and operator**:
```text
   f(x)  =   1/2   ·   xᵀ   ·   H   ·   x   +   cᵀ   ·   x
    │         │        │        │       │       │        │
 Total Cost  Half   Transpose  Hessian Vector  Linear  Vector
  [Joules]   Factor   State    Matrix  State   Force    State
```
For each component, explicitly explain:
1. **Identity & Dimension**: Scalar, vector ($n \times 1$), or matrix ($n \times m$), along with standard SI units.
2. **Functional Role**: What real-world knob or parameter it represents (e.g., "stiffness", "tuning weights", "applied force").
3. **Notation Quirks**: Clarify mathematical idiosyncrasies without jargon (e.g., why $x^T$ is needed on the left to reduce the matrix multiplication to a single scalar number, or why the fraction $1/2$ is placed in advance to cleanly cancel the exponent during differentiation).

### Tier 3: Concrete Numbers Walkthrough (The Arithmetic Proof)
Never stop at symbols alone. Instantiate the equation with trivial, concrete numbers (such as $2 \times 2$ diagonal matrices or 2D vectors):
- Write out the explicit scalar arithmetic without matrix shortcuts.
- Demonstrate that the compact matrix equation collapses directly into standard high-school algebra (e.g., two independent parabolas).
- Solve the numerical instance step by step to prove that the formal matrix theorem (e.g., $x^* = -H^{-1}c$) produces the exact same answer as basic calculus.

### Tier 4: The Force & Wall Reaction (Lagrange / KKT Intuition)
Whenever constraints, Lagrange multipliers ($\lambda$), or dual variables appear:
- Treat the multiplier as a **physical force sensor** (in Newtons) measuring how hard the system is pressing against an unyielding boundary.
- **Primal Feasibility**: The system cannot penetrate solid walls.
- **Dual Feasibility**: Walls only push back; they cannot pull you into the surface.
- **Complementary Slackness**: If the system is not actively touching the wall, the force sensor registers exactly zero ($\lambda = 0$).

## Pedagogical Standards
1. **Zero Unexplained Assumptions**: Explicitly explain what transposes do, why matrices cannot be divided by simple division, and how eigenvalues dictate geometric curvature.
2. **Visual Pairings**: When providing plots, generate clean vector figures (SVG) or standalone scripts compatible with the **Barograph** runner (`barograph serve plot.py` / `barograph build plot.py`).
3. **Single-Column Architecture**: Maintain clean, single-column prose to prevent distracting layout wraps or excessive nested cards.
