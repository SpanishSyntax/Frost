---
name: math-to-sim
description: Bypasses tedious algebraic derivations by instantly generating and validating Python simulation code to visualize math dynamically, formatted for the flaker MathVis template.
---

# Math to Sim

## Summary
Bypasses tedious algebraic derivations by generating executable Python code to simulate and visualize dynamical systems, differential equations, and control theory concepts dynamically. Formatted specifically for the custom `flaker` MathVis template utilizing `PlotConfigurator` for standardized rendering.

## When to Use
- User types `/sim` or asks to simulate/visualize a mathematical derivation, differential equation, matrix proof, or control theory concept.
- When an analytical solution is intractable or unintuitive and needs an interactive phase portrait, trajectory, or bifurcation diagram.

## Steps
1. **State the Physics**: Briefly state what the target equations represent physically (e.g. "Simulating the Zeno chattering of a hybrid bouncing ball with inelastic collisions").
2. **Scaffold with Flaker**:
   - Check if project exists or recommend `flaker new mv <name>` (or use `cryo/flaker_init`).
   - Generate the complete, self-contained `plot.py`.
3. **Flaker MathVis Template Requirements**:
   - Import and instantiate `PlotConfigurator` from `plotter.py`:
     ```python
     from plotter import PlotConfigurator
     import plotly.graph_objects as go
     import numpy as np
     from scipy.integrate import solve_ivp

     config = PlotConfigurator()
     fig = config.fig
     ```
   - Use `scipy.integrate.solve_ivp` (e.g. `method='RK45'` or `'Radau'` for stiff systems) and `numpy`.
   - Add interactive traces using `fig.add_trace(...)` with descriptive legend labels.
   - Apply theming using `config.apply_theme(...)` instead of raw Plotly updates.
   - End the script by calling `config.export("index.html")`. **Do NOT call `fig.show()`**.
4. **Agentic Execution & Verification**:
   - If operating in an active testbed/workspace, execute the script via python to verify that `scipy` converges without `LinAlgError`, unhandled zero-divisions, or `NaN`s, and confirm `index.html` is generated.
5. **Highlight Key Variables**: Explicitly map code variables back to the abstract mathematical symbols from the paper/derivation.
