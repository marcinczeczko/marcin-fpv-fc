# KiBot Automation for polski_fc

## What This Is

This project transforms the existing "polski_fc" KiCad project by integrating KiBot to automate the generation of all manufacturing, documentation, and 3D outputs. It establishes a dual-execution environment (local script and CI/CD pipelines) using modular KiBot configuration files tailored for general outputs and specific fabricators like JLCPCB.

## Core Value

Ensure reliable, repeatable, and comprehensive automated generation of all KiCad project outputs (Gerbers, BOMs, Pick and Place, documentation, 3D models) both locally and via CI/CD without manual GUI interaction.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Automate generation of standard manufacturing files (Gerbers, drill files)
- [ ] Automate generation of JLCPCB specific outputs (BOM, CPL, Gerbers)
- [ ] Automate generation of documentation (Schematic PDF, PCB PDF)
- [ ] Automate generation of interactive BOM (iBOM)
- [ ] Automate generation of 3D models/views (STEP, images)
- [ ] Setup modular KiBot configuration files (e.g., fabrication, docs, 3d, jlcpcb)
- [ ] Setup local execution script/environment (e.g., Docker wrapper or local install)
- [ ] Setup CI/CD pipeline (e.g., GitHub Actions) for automated generation on push

### Out of Scope

- Modifying the actual PCB layout or schematic design (this project is purely about output automation).
- Hardware testing or physical assembly.

## Context

- The project is an existing KiCad design (`polski_fc`).
- Currently, manufacturing files are either generated manually or via scattered scripts/plugins.
- KiBot is a powerful CLI tool for KiCad that can generate almost any output, but it requires structured YAML configuration.
- We need to ensure the CI/CD environment has the correct KiCad 9 version, KiBot version, and necessary 3D models available if required.

## Constraints

- **Tech Stack**: Must use KiBot for the automation engine.
- **CI/CD Compatibility**: The solution must be compatible with standard CI/CD runners (likely relying on KiBot Docker images).
- **Maintainability**: Configurations must be modular so they are easy to read and update.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use modular KiBot configs | A single config doing "everything" becomes too large and hard to debug. Separate files for fab, docs, etc. are easier to maintain. | — Pending |
| Target JLCPCB explicitly | JLCPCB has specific requirements for BOM and CPL formats which KiBot supports, making direct ordering much easier. | — Pending |
| Support both Local and CI/CD | Developers need to verify outputs locally before pushing, while CI/CD ensures a source-of-truth artifact release. | — Pending |

---
*Last updated: 2026-05-04 after project initialization*
