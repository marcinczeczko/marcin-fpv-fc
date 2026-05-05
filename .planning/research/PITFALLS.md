# Domain Pitfalls

**Domain:** KiBot Automation for KiCad CI/CD
**Researched:** 2024
**Overall confidence:** HIGH

## Critical Pitfalls

Mistakes that cause rewrites or major issues.

### Pitfall 1: Docker Root File Ownership
**What goes wrong:** When running KiBot via Docker (e.g. locally or in Jenkins), output files (PDFs, Gerbers) are created with `root` ownership.
**Why it happens:** Docker containers run as root by default. When the container writes to a bind-mounted volume, the host kernel preserves the root UID/GID.
**Consequences:** Developers get "Permission Denied" errors when trying to delete or modify generated files on their local machine, breaking local workflows and wrappers.
**Prevention:** Always pass the host's User ID and Group ID to the container using `docker run -u $(id -u):$(id -g)`. In Docker Compose, use `user: "${UID}:${GID}"`.
**Detection:** `ls -l` shows `root` as the owner of the `Generated` or `output` directory.

### Pitfall 2: CI/CD Pipeline Blocked by DRC/ERC Failures
**What goes wrong:** The CI/CD pipeline fails during the KiBot step, preventing releases or artifact generation.
**Why it happens:** KiBot's default `preflight` checks will run DRC (Design Rules Check) and ERC (Electrical Rules Check). A single warning (e.g., missing PWR_FLAG, or an intentional silk overlap) yields a non-zero exit code (often Exit Code 4).
**Consequences:** Blocking of CI pipelines even for intentional design violations or minor warnings.
**Prevention:** 
- Use KiBot's YAML regex `filters` under `preflight` to ignore specific known errors (e.g., `pin_not_driven`).
- For KiCad 8+, set `dont_stop: true` in the `preflight` section to report errors but proceed.
- Ensure `check_zone_fills: true` is enabled before `drc: true`, or DRC will fail due to unpoured planes.

## Moderate Pitfalls

### Pitfall 1: Missing 3D Models in CI (Path Resolution Issues)
**What goes wrong:** 3D renders or STEP files generated in CI are missing components, whereas they look perfect locally.
**Why it happens:** Local machines have the KiCad standard 3D models installed, but official KiBot Docker images exclude them to save space. Also, absolute local paths (e.g., `C:/models`) fail in Docker.
**Prevention:** 
- Always use environment variables like `${KICAD8_3DMODEL_DIR}` or `${KICAD6_3DMODEL_DIR}` in footprint 3D settings.
- Enable `cache3D: YES` in the GitHub Action, or set `KIBOT_3D_MODELS` environment variable pointing to a cache dir to allow KiBot to download missing standard models without stalling the pipeline.
- Use the `_full` tag for KiBot Docker images if using STEP export or Blender renders.

### Pitfall 2: JLCPCB SMT Component Rotation Errors
**What goes wrong:** Components are rotated incorrectly (90, 180 degrees) in JLCPCB's SMT preview, causing fabrication delays or ruined boards.
**Why it happens:** KiCad follows IPC-standard zero-orientations, but JLCPCB expects "as-delivered-on-tape" orientation.
**Prevention:**
- Use KiBot's built-in `import: - file: JLCPCB` template to apply standard corrections automatically.
- For specific parts, define a `rot_footprint` filter in `kibot.yaml` with `bennymeg_mode: true` and `mirror_bottom: true` (for bottom side parts).
- Override individual parts using a custom field `JLCPCB Rotation Offset` (e.g., `90`) in the KiCad schematic.

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| Local Wrapper Setup | Output files owned by root | Use `-u $(id -u):$(id -g)` in docker run command. |
| JLCPCB Config | Rotations are 90 deg off | Import `JLCPCB` standard config, verify bottom side parts with `mirror_bottom`. |
| CI/CD Setup | Pipeline blocks on DRC warnings | Implement `preflight` filters or `dont_stop: true` in kibot.yaml. |
| 3D Output Config | Missing 3D packages in renders | Use standard environment variable paths and enable `cache3D`. |

## Sources

- HIGH confidence: Official KiBot Documentation (preflight, JLCPCB rot_footprint filters, 3D model caching).
- HIGH confidence: INTI-CMNB/KiBot GitHub Action Documentation (cache3D, usage of KIBOT_3D_MODELS).
- MEDIUM confidence: StackOverflow / Reddit community discussions (docker UID mapping, JLCPCB rotation nuances).