#!/usr/bin/env bash
set -e
tar xvf convert.tar
# ls
# echo $PWD
# which cwltool
# ls -la /var/run/docker.sock
# echo "HOST_PWD="
# echo $HOST_PWD
export HOST_PWD=$INPUTS_HOST_MOUNT
echo "env="
env
/usr/local/bin/cwltool workflows/read_and_clean.cwl pdbfile.yml