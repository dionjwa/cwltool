$namespaces:
  edam: http://edamontology.org/
$schemas:
  - EDAM.owl
class: CommandLineTool
cwlVersion: v1.0.dev4
doc: "Reverse each line using the `rev` command"

inputs:
  input:
    type: File
    inputBinding: {}
    format: edam:format_2330

outputs:
  output:
    type: File
    outputBinding:
      glob: output.txt
    format: $(inputs.input.format)

baseCommand: rev
stdout: output.txt