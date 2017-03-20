#!/bin/sh
mkdir -p tmp
cwltool --tmp-outdir-prefix=$PWD/tmp/ --tmpdir-prefix=$PWD/tmp/ tests/ccc_docker_workflow/run_workflow.cwl tests/ccc_docker_workflow/input.yml