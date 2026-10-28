---
name: math-to-sim
description: >-
  Generates executable, zero-boilerplate Python simulation and numerical
  validation scripts to dynamically visualize differential equations,
  state-space systems, and control concepts using Basecamp and Barograph. Use
  this skill when the user asks to simulate, numerically validate, or dynamically
  plot mathematical models, dynamical systems, or control proofs.
---

# Math to Sim

## Summary
Generates executable, clean Python simulation scripts to simulate and visualize dynamical systems, ordinary differential equations (ODEs), matrix stability proofs, and control algorithms. Designed for rapid numerical validation within the Frost ecosystem using **Basecamp** for environment scaffolding and **Barograph** for multi-backend figure extraction, live-reload serving, and vector export.

## When to Use
- The user asks to simulate, numerically validate, or visualize a system of differential equations, phase portrait, or dynamical trajectory.
- An analytical algebraic proof is intractable, stiff, or counterintuitive and requires numerical simulation to verify convergence or stability.
- The user requests a standalone plotting or simulation script formatted for the Frost ecosystem.

## Operational Procedures

1. **Physical Formulation**:
   - Briefly define the state vector $x(t)$, inputs $u(t)$, and governing differential or difference equations $\dot{x} = f(x, u, t)$.
   - Explicitly list physical parameter values with units (mass $m$, damping $c$, stiffness $k$, sampling period $T$).

2. **Scaffold Environment via Basecamp**:
   - For new simulation projects, utilize Basecamp to generate the reproducible Nix DevShell and starter template:
     ```bash
     basecamp init barograph
     ```
   - This sets up `flake.nix`, `.envrc`, and a starter `plot.py` with NumPy, SciPy, and Plotly pre-configured.

3. **Construct Barograph-Compatible Simulation (`plot.py`)**:
   - Structure the script to adhere to Barograph's zero-boilerplate figure extraction protocol:
     ```python
     import numpy as np
     import plotly.graph_objects as go
     from scipy.integrate import solve_ivp

     # Define dynamics
     def dynamics(t, state, m, c, k):
         x, v = state
         return [v, (-c * v - k * x) / m]

     # Numerical integration
     t_span = (0.0, 10.0)
     t_eval = np.linspace(t_span[0], t_span[1], 500)
     sol = solve_ivp(dynamics, t_span, [1.0, 0.0], args=(1.0, 0.2, 5.0), t_eval=t_eval)

     # Top-level figure assignment for Barograph
     fig = go.Figure()
     fig.add_trace(go.Scatter(x=sol.t, y=sol.y[0], mode="lines", name="Displacement (m)"))
     fig.add_trace(go.Scatter(x=sol.t, y=sol.y[1], mode="lines", name="Velocity (m/s)"))
     fig.update_layout(
         title="Damped Harmonic Oscillator",
         xaxis_title="Time (s)",
         yaxis_title="State Amplitude",
         margin=dict(l=40, r=40, t=60, b=40),
     )
     ```
   - **Critical Rule**: Do NOT call `fig.show()` or `plt.show()`. Barograph automatically discovers `fig` or the Matplotlib figure stack.

4. **Execution & Validation via Barograph**:
   - **Interactive Live Preview**:
     ```bash
     barograph serve plot.py
     ```
     Starts a local HTTP server with automatic port discovery, file-watching, and instant browser synchronization.
   - **Batch Vector Export**:
     ```bash
     barograph build plot.py --format svg
     ```
     Compiles figures to standalone SVG or HTML files ready for inclusion in readers, slide decks, or documentation.
   - **Sled Programmatic MCP**: In agentic workflows, inspect and compile plots using Sled's `barograph_list` and `barograph_build` atomic tools.

5. **Numerical Sanity Check**:
   - Ensure simulations converge cleanly without `NaN`s, unhandled singularities, or solver warnings (`sol.success == True`).
   - Clearly map code variables back to the abstract mathematical symbols from the original derivation.
