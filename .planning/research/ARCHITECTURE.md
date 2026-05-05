# Architecture Patterns

**Domain:** PCB Output Automation
**Researched:** 2026-05-04

## Recommended Architecture

A modular KiBot configuration utilizing a core entrypoint file and a dedicated configuration directory (`.kibot/`) to encapsulate specific output domains (fabrication, documentation, JLCPCB).

### Component Boundaries

| Component | Responsibility | Communicates With |
|-----------|---------------|-------------------|
| `project.kibot.yaml` | Main orchestrator / entrypoint | Imports all sub-configs |
| `.kibot/base.kibot.yaml` | Core settings, preflights (ERC/DRC), variants | Imported by all standard configs |
| `.kibot/fab.kibot.yaml` | Standard manufacturing (Gerbers, Drill, generic BOM) | Imports `base.kibot.yaml` |
| `.kibot/jlcpcb.kibot.yaml` | JLCPCB-specific outputs (CPL, JLC-formatted BOM) | Imports `base.kibot.yaml`, uses JLC template |
| `.kibot/docs.kibot.yaml` | Schematic PDF, PCB PDF, iBOM | Imports `base.kibot.yaml` |
| `.kibot/3d.kibot.yaml` | STEP models, 3D render images | Imports `base.kibot.yaml` |

### Data Flow

1. Developer/CI runs `kibot -c project.kibot.yaml`.
2. `project.kibot.yaml` uses the `import:` directive to pull in required configurations from the `.kibot/` directory.
3. Preflights are executed first based on `base.kibot.yaml`.
4. Outputs are generated into their respective `Outputs/` subdirectories (`Outputs/Fab`, `Outputs/JLCPCB`, `Outputs/Docs`, `Outputs/3D`).

## Patterns to Follow

### Pattern 1: Modular Configs via Imports
**What:** Break down monolithic `.kibot.yaml` files into functional modules using the `import` directive.
**When:** The project has multiple distinct output targets (e.g., standard fab vs JLCPCB vs documentation) and the main config grows beyond ~150 lines.
**Example:**
```yaml
# project.kibot.yaml
kibot:
  version: 1
  imported_global_has_less_priority: true

import:
  - .kibot/base.kibot.yaml
  - .kibot/docs.kibot.yaml
  - .kibot/jlcpcb.kibot.yaml
```

### Pattern 2: Parameterized Templates via Definitions
**What:** Define variables (`@VAR@`) in modular files and pass them via `definitions:` during import.
**When:** Reusing the same output structure for different manufacturers or board revisions.
**Example:**
```yaml
import:
  - file: .kibot/fab_template.kibot.yaml
    definitions:
      MANUFACTURER: 'JLCPCB'
      BOARD_REV: 'v1.0'
```

### Pattern 3: Using Internal Templates
**What:** Use KiBot's built-in templates to avoid writing repetitive configuration for known vendors.
**When:** Targeting common fabricators like JLCPCB, Elecrow, PCBWay.
**Example:**
```yaml
import:
  - _JLCPCB
```

## Anti-Patterns to Avoid

### Anti-Pattern 1: Monolithic Config File
**What:** Placing all preflights, filters, and 50+ outputs in a single `.kibot.yaml` file.
**Why bad:** Very difficult to debug when a single output fails, hard to maintain, and hard to run specific subsets (e.g., only docs) without complex CLI filtering.
**Instead:** Split into `.kibot/docs.kibot.yaml`, `.kibot/fab.kibot.yaml` and import them or run them independently.

### Anti-Pattern 2: Hardcoding Paths in Sub-Configs
**What:** Hardcoding output directory paths inside deeply nested imported configs.
**Why bad:** When moving configurations between projects, directory structures break.
**Instead:** Use global path definitions in the main `project.kibot.yaml` and reference them as `@DIR@` or rely on `kibot -d` output directory flags.

## Scalability Considerations

| Concern | Simple Board | Complex Project | Multi-Variant Project |
|---------|--------------|-----------------|-----------------------|
| Configuration Management | Single `.kibot.yaml` | Modular `.kibot/` directory | Parameterized imports with `definitions:` |
| Execution Speed | Run everything locally | Run domain-specific configs (e.g., only `docs`) | Parallelize CI/CD steps per config |

## Sources

- KiBot Official Documentation (Imports & Modularization): HIGH
- Real-world GitHub Examples via Web Search: HIGH