baseCommand: [mdtscripts.py, from_file]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - {class: DockerRequirement, dockerImageId: mdtscripts}
inputs:
- id: infile
  inputBinding: {position: 1}
  type: File
label: Read a molecule from a file (format determined by extension)
outputs:
- id: mol
  outputBinding: {glob: out.pkl}
  type: File
