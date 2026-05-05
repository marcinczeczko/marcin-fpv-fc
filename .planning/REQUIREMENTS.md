# Requirements: KiBot Automation

**Defined:** 2026-05-04
**Core Value:** Ensure reliable, repeatable, and comprehensive automated generation of all KiCad project outputs both locally and via CI/CD without manual GUI interaction.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Setup & Environment

- [x] **ENV-01**: User can run a local script wrapping the KiCad 9 KiBot Docker container to generate files without local dependencies.
- [x] **ENV-02**: Configuration is divided into modular YAML files (e.g. base, docs, fab, jlcpcb).
- [ ] **ENV-03**: Execute the automated generation in a GitHub Actions CI/CD pipeline on every push.

### Preflight Checks

- [x] **CHK-01**: KiBot automatically runs an Electrical Rules Check (ERC) before generation.
- [x] **CHK-02**: KiBot automatically runs a Design Rules Check (DRC) before generation.
- [x] **CHK-03**: KiBot is configured with filters to ignore specific safe/known warnings to prevent generation blocking.

### Fabrication

- [x] **FAB-01**: KiBot generates standard format Gerber files.
- [x] **FAB-02**: KiBot generates plated and non-plated drill files.
- [x] **FAB-03**: KiBot packages fabrication outputs into a ZIP file specifically formatted for JLCPCB.

### Assembly

- [x] **ASSY-01**: KiBot generates a formatted CSV BOM for JLCPCB.
- [x] **ASSY-02**: KiBot generates a formatted CSV CPL (Pick and Place) for JLCPCB.
- [x] **ASSY-03**: KiBot automatically applies rotation offsets for SMT components to match JLCPCB tape orientations.

### Documentation

- [x] **DOCS-01**: KiBot generates a PDF of the schematic.
- [x] **DOCS-02**: KiBot generates an Interactive HTML BOM (iBOM).
- [x] **DOCS-03**: KiBot exports a 3D STEP model of the board.

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| Modifying the PCB | Automation only, no design changes. |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| ENV-01 | Phase 1 | Completed |
| ENV-02 | Phase 1 | Completed |
| CHK-01 | Phase 1 | Completed |
| CHK-02 | Phase 1 | Completed |
| CHK-03 | Phase 1 | Completed |
| FAB-01 | Phase 2 | Completed |
| FAB-02 | Phase 2 | Completed |
| FAB-03 | Phase 2 | Completed |
| ASSY-01 | Phase 3 | Completed |
| ASSY-02 | Phase 3 | Completed |
| ASSY-03 | Phase 3 | Completed |
| DOCS-01 | Phase 4 | Completed |
| DOCS-02 | Phase 4 | Completed |
| DOCS-03 | Phase 4 | Completed |
| ENV-03 | Phase 5 | Planned |

**Coverage:**
- v1 requirements: 15 total
- Mapped to phases: 15
- Unmapped: 0 ✓

---
*Requirements defined: 2026-05-04*
*Last updated: 2026-05-05 after migration completion*
