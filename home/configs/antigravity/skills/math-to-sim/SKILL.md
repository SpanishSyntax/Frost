---
name: math-to-sim
description: Bypasses tedious algebraic derivations by instantly generating and validating Python simulation code to visualize math dynamically, formatted for the basecamp MathVis template.
---

# Math to Sim

## Summary
Bypasses tedious algebraic derivations by generating executable Python code to simulate and visualize dynamical systems, differential equations, and control theory concepts dynamically. Formatted for the clean, zero-boilerplate `basecamp` MathVis template powered by `barograph` for live-reloading preview and multi-backend export.

## When to Use
- User types `/sim` or asks to simulate/visualize a mathematical derivation, differential equation, matrix proof, or control theory concept.
- When an analytical solution is intractable or unintuitive and needs an interactive phase portrait, trajectory, or bifurcation diagram.

## Steps
1. **State the Physics**: Briefly state what the target equations represent physically (e.g. "Simulating the Zeno chattering of a hybrid bouncing ball with inelastic collisions").
2. **Scaffold with Basecamp**:
   - Check if project exists or recommend `basecamp new mv <name>` (or use `sled/basecamp_init`).
   - Generate the complete, self-contained `plot.py`.
3. **Basecamp MathVis Template Requirements (Powered by Barograph)**:
   - Construct self-contained Plotly or Matplotlib figures directly without boilerplate:
     ```python
     import plotly.graph_objects as go
     import numpy as np
     from scipy.integrate import solve_ivp

     # ... compute simulation data ...
     fig = go.Figure()
     fig.add_trace(go.Scatter(x=t, y=y, name="Trajectory"))
     fig.update_layout(title="Phase Portrait", margin=dict(l=40, r=40, t=60, b=40))
     ```
   - Barograph automatically extracts `fig`, streams live preview via `barograph serve`, and handles vector/raster batch builds via `barograph build`.
   - **Do NOT call `fig.show()`** or hardcode `index.html`.
4. **Agentic Execution & Verification**:
   - Verify that `scipy` converges without `LinAlgError`, unhandled zero-divisions, or `NaN`s, and run `barograph build` or `barograph serve --no-open` to confirm figure renders cleanly.
5. **Highlight Key Variables**: Explicitly map code variables back to the abstract mathematical symbols from the paper/derivation.
