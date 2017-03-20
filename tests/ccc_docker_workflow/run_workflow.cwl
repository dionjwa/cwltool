cwlVersion: v1.0
class: Workflow
inputs:
  - id: infile
    type: File

steps:
  - id: step1
    run: ./step1.cwl
    in:
      - id: infile1
        source: "#infile"
    out:
      - id: outfile1

  - id: step2
    run: ./step2.cwl
    in:
      - id: infile2
        source: "#step1/outfile1"
    out:
      - id: outfile2

outputs:
  - id: outfileFinal
    type: File
    outputSource: "#step2/outfile2"

