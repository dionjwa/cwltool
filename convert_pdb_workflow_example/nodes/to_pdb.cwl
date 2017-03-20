baseCommand: [mdtscripts.py, to_pdb]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - {class: DockerRequirement, dockerImageId: mdtscripts}
inputs:
- id: mdtfile
  inputBinding: {position: 1}
  type: File
label: Create PDB-format output file
outputs:
- id: pdbfile
  outputBinding: {glob: out.pdb}
  type: File
