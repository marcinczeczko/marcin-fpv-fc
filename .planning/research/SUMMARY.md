# Project Research Summary

## Executive Summary

The `polski_fc` project requires an automated CI/CD pipeline for generating KiCad manufacturing and documentation outputs. The industry-standard approach for this is KiBot, which offers a comprehensive, actively maintained automation engine for KiCad 6/7/8. Based on the research, the recommended approach is a modular KiBot configuration executed via Docker locally and GitHub Actions in CI/CD. This ensures consistent execution environments and avoids local dependency hell, particularly with Python and heavy 3D modeling libraries.

Key risks involve Docker permissions (resulting in root ownership of generated files), CI/CD pipelines failing due to minor or intentional DRC/ERC warnings, and incorrect component rotations for JLCPCB assembly. These are mitigated by proper Docker user mapping (`-u $(id -u):$(id -g)`), configuring preflight filters in KiBot to ignore acceptable warnings, and utilizing KiBot's built-in JLCPCB templates to correct SMT rotations.

## Key Findings

### Technology Stack
*   **Core Engine:** KiBot v2.x is the recommended automation engine.
*   **Execution:** Docker (`inti-cmnb/kicad8_auto_full` for 3D support) is essential to prevent OS-level dependency issues and ensure consistency between local and CI environments.
*   **CI/CD:** GitHub Actions (v2) integrates perfectly with KiBot.

### Feature Landscape
*   **Table Stakes:** Gerber/Drill generation, PDF schematics, and Preflight checks (DRC/ERC).
*   **Differentiators:** JLCPCB direct outputs (CPL/BOM properly formatted), Interactive BOM (`InteractiveHtmlBom`), and 3D Render/STEP generation.
*   **Anti-features:** Monolithic configurations and absolute local model paths must be avoided.

### Architecture Patterns
*   **Modular Approach:** Utilize a core entrypoint file (`project.kibot.yaml`) that uses the `import:` directive to pull in specific output domains from a `.kibot/` directory (e.g., `fab.kibot.yaml`, `jlcpcb.kibot.yaml`, `docs.kibot.yaml`).
*   **Parameterized Templates:** Define variables for reuse across different manufacturers or board revisions.
*   **Built-in Templates:** Leverage KiBot's internal templates (like `_JLCPCB`) to reduce boilerplate.

### Domain Pitfalls
*   **Docker Root Ownership:** Docker containers run as root, creating files that developers cannot modify. Prevent by passing host UID/GID.
*   **CI Blocked by Warnings:** Default preflights fail on minor warnings. Mitigate with regex filters or `dont_stop: true`.
*   **JLCPCB Rotations:** IPC-standard orientations differ from "as-delivered-on-tape" JLCPCB orientations. Use KiBot's JLCPCB standard config and `rot_footprint` filters to prevent fabricated boards from having incorrectly rotated parts.
*   **Missing 3D Models in CI:** Absolute paths fail. Use KiCad environment variables and enable `cache3D`.

## Implications for Roadmap

Suggested phases: 4

1. **Phase 1: Local Docker Wrapper & Preflight Setup**
   * *Rationale:* Establishes a safe local execution environment and ensures basic design rules pass before generating anything else.
   * *Delivers:* Local bash script wrapper for Docker, foundational `.kibot/base.kibot.yaml` with preflight checks and filters.
   * *Features Delivered:* Preflight Checks.
   * *Pitfalls Avoided:* Docker root file ownership (by using UID/GID mapping); CI/CD blocking on trivial DRC warnings (by implementing filters).

2. **Phase 2: Fabrication & JLCPCB Assembly Outputs**
   * *Rationale:* Generates the core manufacturing files needed to physically produce the board.
   * *Delivers:* Modular `.kibot/fab.kibot.yaml` and `.kibot/jlcpcb.kibot.yaml` configurations.
   * *Features Delivered:* Gerber/Drill Gen, JLCPCB Direct Outputs (CPL/BOM).
   * *Pitfalls Avoided:* JLCPCB SMT component rotation errors (by using KiBot templates and footprint filters).

3. **Phase 3: Documentation & 3D Rendering**
   * *Rationale:* Adds human-readable documentation and mechanical CAD integration, which take longer to run and require larger Docker images.
   * *Delivers:* `.kibot/docs.kibot.yaml` and `.kibot/3d.kibot.yaml`.
   * *Features Delivered:* PDF Schematics, Interactive BOM, 3D Render/STEP Gen.
   * *Pitfalls Avoided:* Missing 3D models in CI (by using standard env vars and 3D caching).

4. **Phase 4: CI/CD Integration**
   * *Rationale:* Automates the process on code push using GitHub Actions, relying on the robust local setup established in earlier phases.
   * *Delivers:* GitHub Actions workflow file (`.github/workflows/kibot.yml`).
   * *Features Delivered:* Fully automated pipeline.
   * *Pitfalls Avoided:* Same as Phase 1 (ensuring pipeline doesn't block on minor warnings).

## Research Flags

Needs research: None. 
Standard patterns: Phase 1, Phase 2, Phase 3, Phase 4. (The modular KiBot patterns are well established and documented).

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Based on official KiBot docs and established GitHub Actions integration. |
| Features | HIGH | Clear distinction between essential KiCad outputs and value-adds like iBOM. |
| Architecture | HIGH | Modular pattern is explicitly detailed in KiBot official documentation and examples. |
| Pitfalls | HIGH | Common Docker and JLCPCB rotation issues are well-known and thoroughly documented in the community and KiBot docs. |

**Gaps to Address:** None significant. The research provides a comprehensive and solid foundation for implementation.

## Sources
- KiBot GitHub repository and official documentation (HIGH)
- INTI-CMNB/KiBot GitHub Action Documentation (HIGH)
- Real-world GitHub Examples via Web Search (HIGH)
- StackOverflow / Reddit community discussions regarding Docker UID mapping and JLCPCB rotations (MEDIUM)