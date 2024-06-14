#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 1 ]] ; then
      echo 'lsclAuxEvaluateWithFiesta: You must specify the path.'
      exit 0
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclIntegralName="$5"


if [ ${SLURM_JOB_ID} ]; then
  echo "lsclAuxEvaluateWithFiesta: Running on a cluster."
else
  echo "lsclAuxEvaluateWithFiesta: Running on a local machine"
  lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  lsclRepoDir="$(dirname $lsclScriptDir)"
  lsclRepoDir="$(dirname $lsclRepoDir)"
  TMPDIR=/tmp
fi

if [[ ! -z "${LSCL_SET_ULIMIT_TO+x}" ]]; then
	echo "lsclAuxEvaluateWithFiesta: Setting a max memory limit via ulimit."
	ulimit -v ${LSCL_SET_ULIMIT_TO}
	echo "lsclAuxEvaluateWithFiesta: Current ulimit values:"
	ulimit -a
fi

cd ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/FIESTA/${lsclIntegralName}

set +e

echo "lsclAuxEvaluateWithFiesta: Running FIESTA"

${lsclMmaPath} -nopromt -script FiestaScript.m


lsclStatus=$?

if [[ $lsclStatus -eq 0 ]] ; then
      echo "lsclAuxEvaluateWithFiesta: Evaluation of the integral ${lsclIntegralName} with FIESTA completed successfully."
else
      echo "lsclAuxEvaluateWithFiesta: Evaluation of the integral ${lsclIntegralName} with FIESTA failed."
fi


echo "lsclAuxEvaluateWithFiesta: Leaving"

exit $lsclStatus
