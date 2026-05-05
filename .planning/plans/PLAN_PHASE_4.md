---
phase: 04-docs
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - .kibot/docs.kibot.yaml
  - polski_fc.kibot.yaml
autonomous: true
requirements:
  - DOCS-01
  - DOCS-02
  - DOCS-03

must_haves:
  truths:
    - "Schematic PDF exists and contains all sheets"
    - "Interactive BOM HTML exists and is functional"
    - "3D STEP model exists and includes components"
  artifacts:
    - path: ".kibot/docs.kibot.yaml"
      provides: "Documentation and 3D output definitions"
    - path: "polski_fc.kibot.yaml"
      provides: "Main entry point importing the docs module"
  key_links:
    - from: "polski_fc.kibot.yaml"
      to: ".kibot/docs.kibot.yaml"
      via: "import directive"
---

<objective>
Automate the generation of readable schematics, interactive assembly guides, and mechanical models.

Purpose: Provide developers and mechanical engineers with easy access to visual and technical project documentation without requiring KiCad installation.
Output: .kibot/docs.kibot.yaml, updated polski_fc.kibot.yaml, and verified files in output/Docs/ and output/3D/.
</objective>

<execution_context>
The project uses KiBot 1.8.5 via Docker (kibot.sh wrapper).
Phase 1, 2, and 3 are complete.
The board is an 8-layer design.
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@polski_fc.kibot.yaml
@.kibot/base.kibot.yaml
</context>

<tasks>

<task type="auto">
  <name>Task 1: Create Documentation & 3D Configuration</name>
  <files>.kibot/docs.kibot.yaml</files>
  <action>
Create a new KiBot configuration file `.kibot/docs.kibot.yaml`.
This file should define three outputs:
1. `schematic_pdf`: Generates a PDF of the schematic.
2. `ibom`: Generates an Interactive HTML BOM using the `ibom` plugin.
3. `step_3d`: Generates a 3D STEP model of the board.

Example structure:
```yaml
kibot:
  version: 1

outputs:
  - name: 'schematic_pdf'
    comment: 'PDF of the schematic'
    type: 'pdf_sch'
    dir: 'Docs'
    options:
      output: '%f-schematic.%e'

  - name: 'ibom'
    comment: 'Interactive HTML BOM'
    type: 'ibom'
    dir: 'Docs'
    options:
      output: '%f-ibom.%e'

  - name: 'step_3d'
    comment: '3D STEP model'
    type: 'step'
    dir: '3D'
    options:
      output: '%f.%e'
      origin: 'grid'
```
  </action>
  <verify>
    <automated>ls .kibot/docs.kibot.yaml</automated>
  </verify>
  <done>Configuration file created with PDF, iBOM, and STEP output definitions.</done>
</task>

<task type="auto">
  <name>Task 2: Import Documentation Module</name>
  <files>polski_fc.kibot.yaml</files>
  <action>
Update the root `polski_fc.kibot.yaml` to include the newly created documentation module in the `import` section.
```yaml
import:
  - .kibot/base.kibot.yaml
  - .kibot/fab.kibot.yaml
  - .kibot/jlcpcb.kibot.yaml
  - .kibot/docs.kibot.yaml
```
  </action>
  <verify>
    <automated>grep -q ".kibot/docs.kibot.yaml" polski_fc.kibot.yaml</automated>
  </verify>
  <done>Documentation module imported into main configuration.</done>
</task>

<task type="auto">
  <name>Task 3: Generate and Verify Outputs</name>
  <files>output/Docs/polski_fc-schematic.pdf, output/Docs/polski_fc-ibom.html, output/3D/polski_fc.step</files>
  <action>
Run the KiBot automation using the local `kibot.sh` script to generate the new outputs.
Verify that the files are created in their respective directories.
  </action>
  <verify>
    <automated>./kibot.sh && ls output/Docs/*-schematic.pdf output/Docs/*-ibom.html output/3D/polski_fc.step</automated>
  </verify>
  <done>Schematic PDF, iBOM, and STEP model successfully generated and verified.</done>
</task>

</tasks>

<verification>
Check `output/` for:
1. `Docs/polski_fc-schematic.pdf` - Open and verify all schematic pages are present.
2. `Docs/polski_fc-ibom.html` - Open in browser and verify components are highlightable.
3. `3D/polski_fc.step` - Verify file size is reasonable (>1MB usually for this complexity).
</verification>

<success_criteria>
- KiBot run completes without errors.
- Schematic PDF is generated in `output/Docs/`.
- Interactive BOM HTML is generated in `output/Docs/`.
- 3D STEP model is generated in `output/3D/`.
</success_criteria>

<output>
After completion, create `.planning/phases/04-docs/04-01-SUMMARY.md`
</output>
