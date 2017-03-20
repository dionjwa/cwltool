import subprocess
import io
import os
import tempfile
import glob
import json
import logging
import sys
import requests
from . import docker
from .process import get_feature
from .errors import WorkflowException
import shutil
import stat
import re
import shellescape
import string
from .builder import Builder
from typing import (Any, Callable, Union, Iterable, Mapping, MutableMapping,
        IO, cast, Text, Tuple)
from .pathmapper import PathMapper
import functools

_logger = logging.getLogger("cwltool")

def run_ccc_job(**kwargs):
    inputfiles = kwargs.get("input_files")
    url = os.environ['CCC']

    print("run_ccc_job %s" % kwargs)
    print("ccc url=%s" % url)

    params = {"wait":True}
    params['cmd'] = kwargs.get("command")
    params['image'] = kwargs.get("image")
    params['appendStdOut'] = True
    params['appendStdErr'] = True
    params['workingDir'] = kwargs.get("workdir")
    params['meta'] = {"type": "workflow", "job-type": "workflow-job", "workflow-parent":os.environ['CCC_JOB_ID']}

    files = [
        ('jsonrpc', (None, json.dumps({"jsonrpc":"2.0", "method":"cloudcomputecannon.run", "params":params}), None))
    ]

    if inputfiles:
        for f in inputfiles.iterkeys():
            files.append((f, (None, open(inputfiles[f], 'rb'), None)))

    r = requests.post(url, files=files)
    print('url=%s job text=%s' % (url, r.text))
    jobResult = r.json()
    return (r.status_code, jobResult['result'])

def download_file(url, local_filename):
    parent_dir = os.path.dirname(local_filename)
    if not os.path.exists(parent_dir):
        os.makedirs(parent_dir)
    # NOTE the stream=True parameter
    r = requests.get(url, stream=True)
    with open(local_filename, 'wb') as f:
        for chunk in r.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)
                #f.flush() commented by recommendation from J.F.Sebastian
    return local_filename

def get_ccc_outputs(cccResult, target):
    outputs = cccResult.get('outputs')
    outputBaseUrl = cccResult.get('outputsBaseUrl')

    if outputs:
        for outputFileName in outputs:
            download_file(outputBaseUrl + outputFileName, os.path.join(target, outputFileName))

if __name__ == "__main__":
    test_job_data = {}
    sys.exit(run_ccc_job(test_job_data))

class CloudCommandLineJob(object):

    def __init__(self):  # type: () -> None
        self.builder = None  # type: Builder
        self.joborder = None  # type: Dict[Text, Union[Dict[Text, Any], List, Text]]
        self.stdin = None  # type: Text
        self.stderr = None  # type: Text
        self.stdout = None  # type: Text
        self.successCodes = None  # type: Iterable[int]
        self.temporaryFailCodes = None  # type: Iterable[int]
        self.permanentFailCodes = None  # type: Iterable[int]
        self.requirements = None  # type: List[Dict[Text, Text]]
        self.hints = None  # type: Dict[Text,Text]
        self.name = None  # type: Text
        self.command_line = None  # type: List[Text]
        self.pathmapper = None  # type: PathMapper
        self.collect_outputs = None  # type: Union[Callable[[Any], Any], functools.partial[Any]]
        self.output_callback = None  # type: Callable[[Any, Any], Any]
        self.outdir = None  # type: Text
        self.tmpdir = None  # type: Text
        self.environment = None  # type: MutableMapping[Text, Text]
        self.generatefiles = None  # type: Dict[Text, Union[List[Dict[Text, Text]], Dict[Text, Text], Text]]
        self.stagedir = None  # type: Text

    def run(self, dry_run=False, pull_image=True, rm_container=True,
            rm_tmpdir=True, move_outputs="move", **kwargs):

        if not os.path.exists(self.outdir):
            os.makedirs(self.outdir)

        input_files = {}
        for src in self.pathmapper.files():
            vol = self.pathmapper.mapper(src)
            if vol.type == "File":
                input_files[os.path.basename(vol.resolved)] = vol.resolved

        docker_image = None
        (docker_req, docker_is_req) = get_feature(self, "DockerRequirement")
        if docker_req:
            docker_image = docker_req.get("dockerImageId") or docker_req.get("dockerPull")
        docker_image = 'docker.io/busybox:latest'

        if not docker_image:
            raise WorkflowException("Docker is required for running this tool, and requires an image specified.")
        self.environment['TMPDIR'] = '/tmp'
        self.environment['HOME'] = '/outputs'

        if dry_run:
            return (self.outdir, {})

        command = self.command_line

        (status_code, job_result) = run_ccc_job(image=docker_image, input_files=input_files, environment=self.environment, workdir='/outputs', command=command)

        print('status_code=%s job result=%s' % (status_code, json.dumps(job_result, indent=4)))

        get_ccc_outputs(job_result, self.outdir)
        outputs = {}  # type: Dict[Text,Text]

        if status_code == 200:
            if job_result["exitCode"] == 0:
                processStatus = "success"
            else:
                processStatus = "permanentFail"
        else:
            processStatus = "temporaryFail"

        outputs = self.collect_outputs(self.outdir)

        self.output_callback(outputs, processStatus)
