baseCommand: [mdtscripts.py, isolate_ligand_from_chain]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - {class: DockerRequirement, dockerImageId: mdtscripts}
inputs:
- id: chainid
  inputBinding: {position: 1}
  type: string
- id: mdtfile
  inputBinding: {position: 2}
  type: File
label: Return ligand from specified chain
outputs:
- id: mol
  outputBinding: {glob: out.pkl}
  type: File
