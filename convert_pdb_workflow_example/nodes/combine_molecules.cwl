baseCommand: [mdtscripts.py, combine_molecules]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - {class: DockerRequirement, dockerImageId: mdtscripts}
inputs:
- id: mdtfile1
  inputBinding: {position: 1}
  type: File
- id: mdtfile2
  inputBinding: {position: 2}
  type: File
label: Assign histidine states
outputs:
- id: mol
  outputBinding: {glob: out.pkl}
  type: File
