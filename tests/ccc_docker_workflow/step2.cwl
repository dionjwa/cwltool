baseCommand: ["cp"]
class: CommandLineTool
cwlVersion: v1.0
requirements:
  - class: DockerRequirement
    dockerPull: "docker.io/busybox:latest"
successCodes: [0]
inputs:
  - id: "infile2"
    inputBinding:
      position: 1
    type: File
arguments:
  - id: pipe
    position: 2
    valueFrom: "outfile2"
outputs:
  - id: outfile2
    outputBinding: {glob: outfile2}
    type: File