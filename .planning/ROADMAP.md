# Roadmap: KDT_Hierarchical_KiBot Migration

## Phase 1: Infrastructure & Scaffolding
Establish the new directory structure and migrate static assets.
- [x] Create `kibot_yaml/` and `kibot_resources/wks/` directories.
- [x] Move drawing sheets from `Templates/` to `kibot_resources/wks/`.
- [x] Create placeholder directories for new outputs: `Schematic/`, `Manufacturing/`, `Testing/`, `3D/`.
- [x] Initialize `kibot_pre_set_text_variables.yaml` with basic project metadata.

## Phase 2: Configuration Refactoring
Port existing KiBot configurations into the hierarchical structure.
**Goal:** Modularized and redirected KiBot configuration with variant support.
**Plans:** 3 plans

Plans:
- [x] 02-01-PLAN.md — Modular Core & Documentation
- [x] 02-02-PLAN.md — Fabrication Module
- [x] 02-03-PLAN.md — Integration & Variant Logic

Items:
- [x] Create `kibot_yaml/kibot_main.yaml` as the new central config.
- [x] Refactor `.kibot/docs.kibot.yaml` into `kibot_yaml/kibot_out_docs.yaml` (redirection to `Schematic/`).
- [x] Refactor `.kibot/fab.kibot.yaml` and `.kibot/jlcpcb.kibot.yaml` into `kibot_yaml/kibot_out_fab.yaml` (redirection to `Manufacturing/`).
- [x] Refactor `.kibot/base.kibot.yaml` into pre-flight filters and variables.
- [x] Implement the `VARIANT` logic in the main configuration.

## Phase 3: Template Integration & Variable Injection (COMPLETED)
Connect KiCad source files to the new KDT documentation system.
**Goal:** Template Integration & Variable Injection.
**Plans:** 1 plan

Plans:
- [x] 03-01-PLAN.md — Template & Variable Setup

Items:
- [x] Update schematic files (`.kicad_sch`) to use the new KDT worksheets.
- [x] Update PCB file (`.kicad_pcb`) to use the new KDT worksheets.
- [x] Verify that KiBot correctly injects variables into the generated PDFs.

## Phase 4: Verification & Cleanup (COMPLETED)
Ensure everything works as expected and remove legacy files.
**Goal:** Exhaustive Verification & Legacy Cleanup.
**Plans:** 2 plans

Plans:
- [x] 04-01-PLAN.md — Exhaustive Verification
- [x] 04-02-PLAN.md — Legacy Cleanup & Project Finalization

Items:
- [x] Run KiBot in all variants (`DRAFT`, `PRELIMINARY`, `CHECKED`, `RELEASED`) and verify outputs.
- [x] Verify JLCPCB compatibility of the new fabrication outputs.
- [x] Update `kibot.sh` to point to the new configuration.
- [x] Remove legacy `.kibot/` and `output/` folders.
- [x] Final project status report.

## Phase 5: GitHub Actions Integration (COMPLETED)
Automate the generation and distribution of project artifacts.
**Goal:** CI/CD pipeline for KiBot outputs.
**Plans:** 1 plan

Plans:
- [x] 05-01-PLAN.md — GitHub Actions Setup

Items:
- [x] Create `.github/workflows/kibot.yml`.
- [x] Configure `INTI-CMNB/KiBot@v2_k9` action.
- [x] Automate `RELEASED` group generation on push/PR.
- [x] Implement artifact uploading for `Schematic/`, `Manufacturing/`, and `3D/` directories.
