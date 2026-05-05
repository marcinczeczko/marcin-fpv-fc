# Phase 02: Configuration Refactoring - Research

**Researched:** 2025-03-24
**Domain:** KiBot Automation & Project Hierarchy
**Confidence:** HIGH

## Summary

This phase focuses on refactoring the flat KiBot configuration structure into a modular hierarchy aligned with the project's directory structure. The goal is to move from the current `.kibot/` directory to a new `kibot_yaml/` directory, while redirecting outputs from a generic `output/` folder to specific project-level directories like `Schematic/`, `Manufacturing/`, and `3D/`.

Additionally, a `VARIANT` logic will be implemented to manage project status (DRAFT, PRELIMINARY, CHECKED, RELEASED) dynamically, leveraging KiCad's text variables and KiBot's variant system.

**Primary recommendation:** Use KiBot's `import:` directive for modularity and the `variants` system combined with `set_text_variables` for project status management.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| KiBot | 1.x | Automation Engine | Industry standard for KiCad automation. |
| KiCad CLI | 9.0 | Backend processing | Required for KiCad 9 compatibility. |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|--------------|
| Docker | Latest | Environment Isolation | Ensuring consistent runs in CI/CD (GitHub Actions). |

## Architecture Patterns

### Recommended Project Structure
```
kibot_yaml/
├── kibot_main.yaml        # Entry point, imports other modules
├── kibot_preflight.yaml   # ERC/DRC/Filters and Global Variables
├── kibot_out_docs.yaml    # Redirection to Schematic/
└── kibot_out_fab.yaml     # Redirection to Manufacturing/
```

### Pattern 1: Modular Redirection
To redirect outputs to top-level project folders instead of a nested `output/` directory, set the global `out_dir` to the root and use relative paths in the individual outputs.

**Example:**
```yaml
# kibot_yaml/kibot_main.yaml
global:
  out_dir: '.'  # Root of the project

import:
  - kibot_out_docs.yaml
  - kibot_out_fab.yaml
```

```yaml
# kibot_yaml/kibot_out_docs.yaml
outputs:
  - name: 'schematic_pdf'
    type: 'pdf_sch_print'
    dir: 'Schematic'  # Resolves to ./Schematic/
```

### Pattern 2: VARIANT / Status Logic
Leverage KiBot's `variants` system to define project states. This allows running `kibot -v RELEASED` to automatically update the title block in KiCad.

**Example:**
```yaml
# kibot_yaml/kibot_main.yaml
variants:
  - name: 'DRAFT'
  - name: 'PRELIMINARY'
  - name: 'CHECKED'
  - name: 'RELEASED'

preflight:
  set_text_variables:
    - name: 'STATUS'
      text: '${VARIANT}'  # Maps KiBot variant to KiCad variable
```

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| JLCPCB Formats | Custom CSV logic | `_JLCPCB` templates | KiBot has built-in support for JLCPCB's specific column requirements. |
| Path Joining | Manual string concat | KiBot `dir` + expansion | KiBot handles OS-specific paths and environment variables correctly. |

## Common Pitfalls

### Pitfall 1: Absolute Paths in Docker
**What goes wrong:** Using absolute paths (e.g., `/home/user/project/Schematic`) fails in Docker where the mount point is different (e.g., `/home/kicad/project`).
**How to avoid:** Always use paths relative to the project root (the directory where KiBot is executed).

### Pitfall 2: Pre-flight Filter Visibility
**What goes wrong:** Importing pre-flight filters *after* the outputs might lead to filters not being applied if not structured correctly.
**How to avoid:** KiBot merges configurations, but it's best practice to import `kibot_preflight.yaml` first in `kibot_main.yaml`.

## Code Examples

### Integrated Variant & Variable Logic
```yaml
# Source: KiBot Official Docs (Text Variables)
kibot:
  version: 1

global:
  out_dir: '.'

variants:
  - name: 'RELEASED'
    comment: 'Final release build'

preflight:
  set_text_variables:
    - name: 'STATUS'
      text: '${VARIANT|DRAFT}' # Default to DRAFT if no variant specified
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Flat `.kibot.yaml` | Modular `import:` | KiBot v1.x | Easier maintenance of complex projects. |
| Hardcoded version strings | `${GIT_HASH}` / `${VARIANT}` | KiCad 6+ | Dynamic versioning without manual edits. |

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | KiBot Dry Run / Syntax Check |
| Config file | `kibot_yaml/kibot_main.yaml` |
| Quick run command | `kibot -n -c kibot_yaml/kibot_main.yaml` |
| Full suite command | `./kibot.sh -c kibot_yaml/kibot_main.yaml` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| REQ-01 | Config Modularity | Syntax | `kibot -n -c kibot_yaml/kibot_main.yaml` | ❌ Wave 0 |
| REQ-02 | Output Redirection | Smoke | `kibot -c kibot_yaml/kibot_main.yaml schematic_pdf` | ❌ Wave 0 |
| REQ-03 | Variant Logic | Integration | `kibot -v RELEASED -c kibot_yaml/kibot_main.yaml schematic_pdf` | ❌ Wave 0 |

## Sources

### Primary (HIGH confidence)
- KiBot Documentation - [Modularity/Import](https://kibot.readthedocs.io/en/latest/configuration.html#import)
- KiBot Documentation - [Text Variables](https://kibot.readthedocs.io/en/latest/preflights/set_text_variables.html)
- KiBot Documentation - [Variants](https://kibot.readthedocs.io/en/latest/variants/index.html)

### Secondary (MEDIUM confidence)
- KiCad 9 Release Notes - Verified CLI compatibility.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Using verified KiBot/KiCad 9 tools.
- Architecture: HIGH - Modular pattern is standard KiBot practice.
- Pitfalls: HIGH - Path resolution is a known issue in Docker environments.

**Research date:** 2025-03-24
**Valid until:** 2025-04-24
