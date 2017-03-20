baseCommand: ["cp"]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - class: DockerRequirement
    dockerPull: "docker.io/busybox:latest"
successCodes: [0]
inputs:
  - id: "infile1"
    inputBinding:
      position: 1
    type: File
arguments:
  - id: pipe
    position: 2
    valueFrom: "outfile1"
outputs:
  - id: outfile1
    outputBinding: {glob: outfile1}
    type: File