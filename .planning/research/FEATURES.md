# Feature Landscape

**Domain:** KiBot Automation for KiCad CI/CD
**Researched:** 2024

## Table Stakes

Features users expect. Missing = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Gerber/Drill Gen | Standard for manufacturing | Low | Handled natively by KiBot. |
| PDF Schematics | Essential for review/debugging | Low | Requires simple output config. |
| Preflight Checks | Prevent manufacturing broken boards | Medium | Needs tuning to ignore "acceptable" DRC warnings. |

## Differentiators

Features that set product apart. Not expected, but valued.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| JLCPCB Direct Outputs | CPL/BOM formatted exactly for JLCPCB SMT | Medium | Requires `rot_footprint` filtering for correct tape rotations. |
| Interactive BOM | Massively speeds up manual assembly/debug | Low | Uses `InteractiveHtmlBom` plugin natively via KiBot. |
| 3D Render/STEP Gen | Integrates into mechanical CAD | Medium | Requires `_full` Docker image and 3D cache configuration. |

## Anti-Features

Features to explicitly NOT build.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Monolithic Config | A single 1000-line `.kibot.yaml` is impossible to debug. | Use KiBot's `import` feature to split configs into `jlcpcb.yaml`, `docs.yaml`, etc. |
| Local Model Paths | Absolute paths (`C:/models`) break CI/CD. | Use KiCad environment variables (`${KICAD8_3DMODEL_DIR}`). |

## Feature Dependencies

```
Preflight Config → Fabrication Outputs (must pass checks first)
Docker Wrapper → All Local Generation
```

## MVP Recommendation

Prioritize:
1. Docker wrapper script with correct UID/GID mapping.
2. Preflight checks with basic filters.
3. JLCPCB Gerber/Drill/BOM/CPL generation.

Defer: 3D Renderings: Takes longest to run and requires downloading model caches.

## Sources

- KiBot official documentation.