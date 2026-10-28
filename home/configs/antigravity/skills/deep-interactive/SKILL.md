---
name: deep-interactive
description: >-
  Generates interactive algorithmic explainer sites and Antigravity Artifacts
  with embedded data visualizations and live browser previews powered by
  Barograph. Use this skill when the user asks for an interactive explainer,
  visual deep-dive, or dynamic algorithmic demonstration.
---

# Deep Interactive (Visual Algorithmic Explainer & Live Dashboard Engine)

## Summary
Generates interactive, multi-section algorithmic explainer sites and Antigravity Markdown Artifacts with custom data visualizations, state-transition diagrams, and live-reloading browser preview powered by **Barograph**. Connects high-level intuition with mathematical derivations, parameter sensitivity explorations, and interactive plots.

## When to Use
- The user asks for an "interactive explainer", "visual deep-dive", "algorithmic breakdown with live plots", or "interactive dashboard".
- An algorithm, dynamical model, or optimization scheme requires parameter exploration (e.g., zooming into trajectories, toggling state variables, viewing convergence surfaces).
- The user wants companion simulation scripts with live browser hot-reload alongside documentation.

## Operational Contract (🏛️ Deep / Production Compiler)
- **Progressive Disclosure**: Emits an interactive Antigravity Markdown Artifact layered as: (1) High-level problem statement and physical intuition, (2) Embedded vector or interactive visualization, (3) Mermaid architectural flowchart, and (4) Expandable mathematical derivation and complexity bounds.
- **Barograph Zero-Boilerplate Protocol**: Scripts (`plot.py`) construct standard **Plotly** (`fig = go.Figure()`) or **Matplotlib/Seaborn** figures without calling `fig.show()`. Barograph auto-extracts the top-level `fig` object.
- **Live Preview Daemons**: Can launch `barograph serve plot.py` to spawn a local HTTP server with automatic port discovery, file-watching, and instant browser synchronization.
- **Batch Export**: Emits standalone SVG or HTML files via `barograph build plot.py` or Sled MCP tool `barograph_build`.

---

## Toolchain & Execution Pipeline

### Step 1: Script Construction (`plot.py`)
Write the self-contained simulation script adhering to Barograph protocols:
```python
import numpy as np
import plotly.graph_objects as go
from scipy.integrate import solve_ivp

# Define dynamic system (e.g. Lorenz Attractor)
def lorenz(t, state, sigma=10.0, rho=28.0, beta=8.0 / 3.0):
    x, y, z = state
    return [sigma * (y - x), x * (rho - z) - y, x * y - beta * z]

t_span = (0.0, 40.0)
t_eval = np.linspace(t_span[0], t_span[1], 4000)
sol = solve_ivp(lorenz, t_span, [1.0, 1.0, 1.0], t_eval=t_eval)

# Construct interactive 3D figure
fig = go.Figure()
fig.add_trace(
    go.Scatter3d(
        x=sol.y[0],
        y=sol.y[1],
        z=sol.y[2],
        mode="lines",
        line=dict(color=sol.t, colorscale="Viridis", width=2),
        name="Phase Trajectory",
    )
)
fig.update_layout(
    title="Lorenz Strange Attractor Phase Space",
    scene=dict(xaxis_title="X", yaxis_title="Y", zaxis_title="Z"),
    margin=dict(l=0, r=0, t=40, b=0),
)
```

### Step 2: Live Browser Serving via Barograph
Start the interactive server:
```bash
barograph serve plot.py
```
This discovers an open port, pushes the interactive Plotly HTML to the default browser, and continuously watches `plot.py` for updates.

### Step 3: Batch Vector & HTML Export
Compile standalone visual assets for inclusion in Artifacts:
```bash
barograph build plot.py --format svg --out-dir dist/
barograph build plot.py --format html --out-dir dist/
```
Or via Sled MCP:
```json
{
  "path": "plot.py",
  "format": "svg"
}
```

### Step 4: Antigravity Markdown Artifact Construction
Create a comprehensive Markdown Artifact combining:
1. **Executive Concept & Physical Analogy**: Intuitive grounding of the algorithm.
2. **Interactive Visual Link / Embedded Plot**: Link to live localhost server or embedded SVG.
3. **Mermaid Flowchart**: Visualizing algorithmic iterations, convergence checks, or state transitions.
4. **Mathematical Derivation**: Formal proofs, Lyapunov candidate functions, and asymptotic stability bounds.
