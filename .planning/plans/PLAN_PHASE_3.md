---
phase: 03-assembly
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - .kibot/jlcpcb.kibot.yaml
  - polski_fc.kibot.yaml
autonomous: true
requirements:
  - ASSY-01
  - ASSY-02
  - ASSY-03

must_haves:
  truths:
    - "JLCPCB-compatible BOM CSV exists in output/Fab/"
    - "JLCPCB-compatible CPL CSV exists in output/Fab/"
    - "SMT component rotations are adjusted for JLCPCB tape orientations"
  artifacts:
    - path: ".kibot/jlcpcb.kibot.yaml"
      provides: "JLCPCB specific outputs (BOM, CPL)"
    - path: "polski_fc.kibot.yaml"
      provides: "Main entry point importing the assembly module"
  key_links:
    - from: "polski_fc.kibot.yaml"
      to: ".kibot/jlcpcb.kibot.yaml"
      via: "import directive"
---

<objective>
Generate compliant component placement (CPL) and Bill of Materials (BOM) files for JLCPCB PCBA service.

Purpose: Automate the generation of assembly data so the board can be manufactured and assembled by JLCPCB without manual intervention or rotation corrections.
Output: .kibot/jlcpcb.kibot.yaml, updated polski_fc.kibot.yaml, and verified CSV files in output/Fab/.
</objective>

<execution_context>
The project uses KiBot 1.8.5 via Docker (kibot.sh wrapper).
Phase 1 (Preflight) and Phase 2 (Fabrication) are complete.
</context>

<tasks>

<task type="auto">
  <name>Task 1: Create JLCPCB Assembly Configuration</name>
  <files>.kibot/jlcpcb.kibot.yaml</files>
  <action>
Create a new KiBot configuration file `.kibot/jlcpcb.kibot.yaml`.
This file should define two outputs:
1. `JLCPCB_bom`: Use the built-in JLCPCB BOM template. Ensure it maps fields to JLCPCB columns (Comment, Designator, Footprint, LCSC Part #).
2. `JLCPCB_position`: Use the built-in JLCPCB position template. Ensure it applies the `_rot_footprint_jlcpcb` filter for rotation corrections.

Example structure:
```yaml
kibot:
  version: 1

outputs:
  - name: 'JLCPCB_bom'
    comment: 'BOM for JLCPCB'
    type: 'jlcpcb_bom'
    dir: 'Fab'
    options:
      output: '%f-BOM-JLCPCB.%e'

  - name: 'JLCPCB_position'
    comment: 'Pick and Place for JLCPCB'
    type: 'jlcpcb_position'
    dir: 'Fab'
    options:
      output: '%f-CPL-JLCPCB.%e'
```
*Note: If built-in types `jlcpcb_bom` and `jlcpcb_position` are not available in KiBot 1.8.5, use generic `bom` and `position` types with JLCPCB-specific options and column mappings.*
  </action>
  <verify>
    <automated>ls .kibot/jlcpcb.kibot.yaml</automated>
  </verify>
  <done>Configuration file created with BOM and CPL output definitions.</done>
</task>

<task type="auto">
  <name>Task 2: Import Assembly Module</name>
  <files>polski_fc.kibot.yaml</files>
  <action>
Update the root `polski_fc.kibot.yaml` to include the newly created assembly module in the `import` section.
```yaml
import:
  - .kibot/base.kibot.yaml
  - .kibot/fab.kibot.yaml
  - .kibot/jlcpcb.kibot.yaml
```
  </action>
  <verify>
    <automated>grep -q ".kibot/jlcpcb.kibot.yaml" polski_fc.kibot.yaml</automated>
  </verify>
  <done>Assembly module imported into main configuration.</done>
</task>

<task type="auto">
  <name>Task 3: Generate and Verify Outputs</name>
  <files>output/Fab/polski_fc-BOM-JLCPCB.csv, output/Fab/polski_fc-CPL-JLCPCB.csv</files>
  <action>
Run the KiBot automation using the local `kibot.sh` script (or equivalent command) to generate the new outputs.
Verify that the files are created in the `output/Fab/` directory and contain the expected JLCPCB headers.
  </action>
  <verify>
    <automated>./kibot.sh && ls output/Fab/*-BOM-JLCPCB.csv output/Fab/*-CPL-JLCPCB.csv</automated>
  </verify>
  <done>BOM and CPL files successfully generated and verified.</done>
</task>

</tasks>

<verification>
Check `output/Fab/` for:
1. `polski_fc-BOM-JLCPCB.csv` - Should have columns: Designator, Value, Footprint, Quantity, LCSC Part # (or similar JLCPCB set).
2. `polski_fc-CPL-JLCPCB.csv` - Should have columns: Designator, Mid X, Mid Y, Layer, Rotation.
</verification>

<success_criteria>
- KiBot run completes without errors.
- JLCPCB-compatible BOM and CPL files are present in the output directory.
- BOM includes LCSC Part numbers (if defined in the schematic).
- CPL includes rotation corrections.
</success_criteria>
