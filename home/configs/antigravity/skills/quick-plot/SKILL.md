---
name: quick-plot
description: >-
  Provides instant in-terminal numerical simulation and visualization of
  dynamical systems, differential equations (ODEs), phase portraits, and matrix
  eigenvalues without project scaffolding. Use this skill when the user asks to
  plot, simulate, or visualize a mathematical formula, dynamical model, or
  trajectory.
---

# Quick Plot (Instant In-Terminal Dynamics & Curve Simulation)

## Summary
Generates and executes focused, zero-boilerplate Python simulation scripts to numerically integrate differential equations, plot dynamical trajectories, evaluate eigenvalues, and render phase portraits. Designed for rapid, sub-5-second visual feedback directly inside the chat response without creating clutter in the user's workspace.

## When to Use
- The user asks to "plot this ODE", "simulate this dynamical system", "show me the phase portrait", or "visualize these eigenvalues as a parameter varies".
- An analytical mathematical proof is counterintuitive, stiff, or non-obvious and needs fast numerical verification.
- The user needs an immediate vector plot illustrating convergence, damping, limit cycles, or bifurcation behavior.

## Operational Contract (⚡ Quick / In-Terminal)
- **Zero Workspace Clutter**: Never create unsolicited folders, `flake.nix`, or virtualenvs in the user's working directory. Temporary simulation code is written exclusively to the agent's private conversation scratchpad (`<artifactDir>/scratch/plot.py`).
- **Headless Execution**: Runs batch compilation via Barograph (`barograph build plot.py --format svg`) or direct Python integration. Never calls `fig.show()`, `plt.show()`, or launches lingering browser daemons.
- **Immediate Response**: Embeds the resulting vector SVG or numerical metrics directly into the chat stream.
- **Sensible Engineering Defaults**: Automatically chooses appropriate time spans ($t \in [0, 10]$), initial conditions, and numerical integrators (e.g., SciPy's `solve_ivp` with RK45 or Radau for stiff systems) rather than stalling the conversation with parameter interview questions.

---

## Execution Workflow

1. **Formulate the Dynamics**:
   - Express the state vector $x(t) \in \mathbb{R}^n$ and governing state equations $\dot{x} = f(x, t, \theta)$.
   - Assign realistic physical parameter values with explicit units.

2. **Generate Scratchpad Script (`<artifactDir>/scratch/plot.py`)**:
   - Write clean, self-contained Python code adhering to Barograph's figure extraction protocol:
     ```python
     import numpy as np
     import plotly.graph_objects as go
     from scipy.integrate import solve_ivp

     # Governing differential equation
     def system_dynamics(t, state, m, c, k):
         x, v = state
         return [v, (-c * v - k * x) / m]

     # Numerical integration
     t_span = (0.0, 12.0)
     t_eval = np.linspace(t_span[0], t_span[1], 600)
     sol = solve_ivp(system_dynamics, t_span, [1.5, 0.0], args=(1.0, 0.3, 4.0), t_eval=t_eval)

     # Top-level figure assignment (Barograph auto-detects `fig`)
     fig = go.Figure()
     fig.add_trace(go.Scatter(x=sol.t, y=sol.y[0], mode="lines", name="Displacement x(t)"))
     fig.add_trace(go.Scatter(x=sol.t, y=sol.y[1], mode="lines", name="Velocity v(t)"))
     fig.update_layout(
         title="Damped Oscillator State Trajectory",
         xaxis_title="Time (s)",
         yaxis_title="Amplitude",
         margin=dict(l=40, r=40, t=50, b=40),
     )
     ```

3. **Execute & Render Vector SVG**:
   - Compile headless:
     ```bash
     barograph build <artifactDir>/scratch/plot.py --format svg --out-dir <artifactDir>/scratch/
     ```
   - Embed the generated SVG and summary stats directly into the response:
     ```markdown
     ![Oscillator Trajectory](file:///<artifactDir>/scratch/plot.svg)
     ```

4. **Verify Numerical Health**:
   - Check that the integrator completed without warnings (`sol.success == True`).
   - Report key qualitative phenomena: damping ratio $\zeta$, oscillation period $T$, and asymptotic equilibrium.
