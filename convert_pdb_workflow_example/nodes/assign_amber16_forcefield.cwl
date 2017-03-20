baseCommand: [mdtscripts.py, assign_amber16_forcefield]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - {class: DockerRequirement, dockerImageId: mdtscripts}
inputs:
- id: mdtfile
  inputBinding: {position: 1}
  type: File
label: Assign amber14 forcefield
outputs:
- id: mol
  outputBinding: {glob: out.pkl}
  type: File
