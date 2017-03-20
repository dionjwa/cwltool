baseCommand: [mdtscripts.py, from_pdb]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - {class: DockerRequirement, dockerImageId: mdtscripts}
inputs:
- id: pdbcode
  inputBinding: {position: 1}
  type: string
label: Download molecule from the PDB
outputs:
- id: mol
  outputBinding: {glob: out.pkl}
  type: File
