baseCommand: [mdtscripts.py, isolate_protein]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - {class: DockerRequirement, dockerImageId: mdtscripts}
inputs:
- id: mdtfile
  inputBinding: {position: 1}
  type: File
label: strip nonprotein residues
outputs:
- id: mol
  outputBinding: {glob: out.pkl}
  type: File
