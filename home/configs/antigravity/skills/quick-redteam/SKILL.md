---
name: quick-redteam
description: >-
  Rapid adversarial pre-flight attack on an idea, mathematical proof, control
  loop, or code snippet to uncover fatal flaws, actuator saturation, or
  instability before execution. Use this skill when the user asks to red-team,
  stress-test, sanity-check, or challenge an approach.
---

# Quick Red Team (Adversarial Engineering Pre-Flight Attack)

## Summary
An uncompromising, adversarial pre-flight engine designed to aggressively attack technical proposals, mathematical derivations, software architectures, and hardware control loops. Strips away AI sycophancy (people-pleasing flattery) and focuses exclusively on identifying the single most catastrophic failure mode, unmodeled physical dynamic, or mathematical loophole before code runs or hardware powers on.

## When to Use
- The user asks to "red team this idea", "sanity-check this controller", "poke holes in my proof", "stress-test this architecture", or "what could go wrong here?".
- Before bench-testing an embedded control loop or motor driver.
- When reviewing a critical algorithm or pull request where subtle unmodeled dynamics could cause divergence or hardware damage.

## Operational Contract (⚡ Quick / In-Terminal)
- **Zero Sycophancy Mandate**: Strictly forbidden from opening with praise (*"Great idea!", "Looks solid!", "Impressive proof!"*). Treats the proposal as an unproven hypothesis that must earn its survival.
- **Focused Attack**: Delivers a rapid, high-impact critique directly in chat formatted as 3-4 lethal failure modes rather than a rambling philosophical essay.
- **Physics-Grounded**: Evaluates systems against unyielding real-world physical limits: actuator voltage saturation, sensor quantization, communication transport latency, thermal dissipation limits, and non-convex energy landscapes.
- **Constructive Remediation**: Every identified vulnerability must be immediately paired with its exact invariant-preserving physical or mathematical fix.

---

## The 4 Attack Vectors

Every technical proposal must be stress-tested against these 4 vectors:

```mermaid
flowchart LR
    Proposal["Target Proposal"] --> V1["1. Actuator Bounds<br/>(Saturation, Slew Rate)"]
    Proposal --> V2["2. Unmodeled Dynamics<br/>(Latency, Noise, Drift)"]
    Proposal --> V3["3. Numerical Stability<br/>(Stiffness, Condition No.)"]
    Proposal --> V4["4. Discontinuity & Zeno<br/>(Chattering, Boundary Grazing)"]
```

### Vector 1: Actuator Saturation & Physical Limits
- **The Attack**: Does the controller or algorithm assume infinite control authority?
- **The Test**: At maximum initial disturbance $e(0)$, calculate the required input magnitude $u(0)$. Will it exceed physical power supply or motor driver limits?
- **The Remediation**: Anti-windup clamps, dynamic rate limiters, or control barrier functions (CBFs).

### Vector 2: Unmodeled Transport Latency & Noise
- **The Attack**: Does the derivation assume continuous, zero-delay state feedback?
- **The Test**: Inject a transport delay $\tau > 0$ and high-frequency sensor noise. Does phase margin collapse into limit cycle oscillations?
- **The Remediation**: Smith predictors, observer-based state estimation (Kalman filters), or passivity-based damping injection.

### Vector 3: Numerical Conditioning & Solvers
- **The Attack**: Does the formulation invert ill-conditioned matrices ($x^* = -H^{-1}c$) or integrate stiff differential equations with basic Euler/RK4?
- **The Test**: Check the condition number $\kappa(H) = \frac{\lambda_{\max}}{\lambda_{\min}}$. If $\kappa > 10^4$, calculate floating-point precision loss.
- **The Remediation**: Tikhonov regularization ($\epsilon I$), QR/Cholesky factorizations, or implicit symplectic integrators (Radau/Gauss-Legendre).

### Vector 4: Hybrid Switching & Zeno Chattering
- **The Attack**: Does the algorithm employ discrete state switching, relays, or signum functions ($\operatorname{sgn}(e)$)?
- **The Test**: Does the system accumulate infinite discrete transitions in finite time (Zeno behavior), causing numerical ODE solvers to stall?
- **The Remediation**: Boundary layer boundary smoothing (e.g., $\tanh(e/\epsilon)$ sliding mode control) or Filippov regularization.
