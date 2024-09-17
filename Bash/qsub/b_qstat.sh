#!/bin/bash

process=$1
echo process: $process

qstat -j $process | egrep '^hard|^submission|^job_name|^script_file|^usage|^job-array tasks:'