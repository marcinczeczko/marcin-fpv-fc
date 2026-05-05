# Technology Stack

**Project:** polski_fc (KiBot Automation)
**Researched:** 2024

## Recommended Stack

### Core Framework
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| KiBot | v2.x | Automation Engine | Most comprehensive, actively maintained CLI tool for KiCad 6/7/8 outputs. |
| Docker | Latest | Execution Environment | Ensures identical execution locally and in CI, avoiding local KiCad/Python dependency hell. |

### Infrastructure
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| GitHub Actions | v2 | CI/CD Pipeline | Integrates perfectly with the `INTI-CMNB/KiBot@v2` action for seamless runs on push. |

### Supporting Libraries
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| inti-cmnb/kicad8_auto_full | Latest | Docker Image | Use the `_full` variant when generating 3D renders (Blender) or STEP models, as base images lack these heavy dependencies. |

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Automation | KiBot | KiCad CLI (native) | KiCad 8 CLI is improving but lacks native interactive BOM generation, advanced JLCPCB CPL rotation filtering, and zip packaging without external bash scripting. |
| Execution | Docker | Local Python Install | Python paths and OS-level dependencies (like OpenCASCADE for 3D) break frequently between developers. |

## Installation

```bash
# Local wrapper example
docker run --rm -it \
    -v $(pwd):/tmp/work \
    -u $(id -u):$(id -g) \
    ghcr.io/inti-cmnb/kicad8_auto_full:latest \
    kibot -c config.kibot.yaml
```

## Sources

- KiBot GitHub repository and official documentation.