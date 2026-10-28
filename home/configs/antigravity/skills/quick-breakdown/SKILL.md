---
name: quick-breakdown
description: >-
  Deconstructs dense mathematical formulas, matrix equations, and theoretical
  theorems character-by-character into intuitive physical mechanics,
  middle-school arithmetic, and plain English without assuming prior knowledge.
  Use this skill when the user asks to explain, decode, or break down a formula,
  Greek notation, matrix quadratic form, or theoretical proof.
---

# Quick Breakdown (Zero-Assumption Math & Physics Deconstructor)

## Summary
Deconstructs dense mathematical formulas, matrix expressions, and theoretical theorems character-by-character into tangible physical mechanics, high-school intuition, and concrete arithmetic. Strips away academic pretension and gatekeeping by refusing to assume prior specialized fluency, breaking down notation into explicit, approachable components directly inside the chat response.

## When to Use
- The user asks "what does this formula mean?", "break this down for me", "can you explain this equation?", or "what does this symbol stand for?".
- The user expresses confusion over condensed linear algebra, quadratic forms ($x^T H x$), Karush-Kuhn-Tucker (KKT) conditions, Riccati equations, Lyapunov inequalities, or Laplace/Fourier transforms.
- The user encounters unfamiliar Greek symbols, operator notations, or matrix dimensions in a paper or lecture.

## Operational Contract (⚡ Quick / In-Terminal)
- **Zero Workspace Clutter**: Strictly conversational and educational; never creates files, directories, or virtual environments on disk.
- **Immediate Response**: Answers directly in chat with clean Markdown tables, letter-by-letter dissection charts, and LaTeX equations.
- **Zero Jargon Gatekeeping**: Never assumes prerequisite matrix calculus; explains transposes, dimensions, and inner/outer products plainly.

---

## The 4-Tier Breakdown Protocol

Every formula is systematically processed through these 4 tiers:

### Tier 1: The Physical Hardware Anchor
Before introducing any Greek notation or matrix operator, ground the equation in a tangible, physical system:
- **Resistors & circuits**: Ohm's law, dissipated electrical power ($P = I^2 R$), battery voltage drops.
- **Springs & dampers**: Hooke's law ($F = -kx$), damping forces ($F_d = -c\dot{x}$), potential energy bowls ($E = \frac{1}{2}kx^2$).
- **Water pipes & tanks**: Volumetric flow rate, hydraulic head pressure, valve friction.
- **Rulers & rigid boundaries**: Physical stops, clamps, support beams, and concrete walls.

### Tier 2: Letter-by-Letter Decomposition (The Cutting Board)
Isolate **every individual symbol, exponent, subscript, superscript, and operator**:
```text
   f(x)  =   1/2   ·   xᵀ   ·   H   ·   x   +   cᵀ   ·   x
    │         │        │        │       │       │        │
 Total Cost  Half   Transpose  Hessian Vector  Linear  Vector
  [Joules]   Factor   State    Matrix  State   Force    State
```
For each component, explicitly explain:
1. **Identity & Dimension**: Scalar, column vector ($n \times 1$), or matrix ($n \times n$), along with standard SI units (meters, Volts, Joules).
2. **Functional Role**: What real-world tuning knob or parameter it represents (e.g., "stiffness", "tuning weights", "applied force").
3. **Notation Quirks**: Clarify mathematical idiosyncrasies without jargon (e.g., why $x^T$ is needed on the left to reduce matrix multiplication to a single scalar number, or why the factor $1/2$ is placed in advance to cleanly cancel the exponent during differentiation).

### Tier 3: Concrete Numbers Walkthrough (The Arithmetic Proof)
Never stop at symbols alone. Instantiate the equation with trivial, concrete numbers (such as $2 \times 2$ diagonal matrices or 2D vectors):
- Write out the explicit scalar arithmetic without matrix shortcuts.
- Demonstrate that the compact matrix equation collapses directly into standard high-school algebra (e.g., two independent parabolas).
- Solve the numerical instance step by step to prove that the formal matrix theorem (e.g., $x^* = -H^{-1}c$) produces the exact same answer as basic calculus.

### Tier 4: Constraint & Boundary Intuition (Lagrange / KKT)
Whenever constraints, Lagrange multipliers ($\lambda$), or dual variables appear:
- Treat the multiplier as a **physical force sensor** (in Newtons) measuring how hard the state is pressing against an unyielding boundary.
- **Primal Feasibility**: The system cannot penetrate solid walls ($g(x) \le 0$).
- **Dual Feasibility**: Walls only push back; they cannot pull you into the surface ($\lambda \ge 0$).
- **Complementary Slackness**: If the system is not actively touching the wall, the force sensor registers exactly zero ($\lambda g(x) = 0$).
