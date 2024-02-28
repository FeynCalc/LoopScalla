#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 1 ]] ; then
      echo 'lsclPySecDecGenerate: You must specify the path'
      exit 0
fi

if [ ${SLURM_JOB_ID} ]; then
  echo "lsclPySecDecGenerate: Running on a cluster."
else
  echo "lsclPySecDecGenerate: Running on a local machine"
  lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  lsclRepoDir="$(dirname $lsclScriptDir)"
fi

echo "Here"
lsclIntegralsDir=${1}
echo ${lsclIntegralsDir}
cd ${lsclIntegralsDir}

${lsclPythonPath} generate_int.py
