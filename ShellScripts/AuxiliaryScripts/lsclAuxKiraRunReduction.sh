#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 5 ]] ; then
      echo 'lsclAuxKiraRunReduction: You must specify the project, the process name, the model, the number of the loops and the topology.'
      exit 0
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclTopologyName="$5"

cd ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/${lsclTopologyName};

set +e

if [[ -z "${LSCL_CONFIG_SUFFIX+x}" ]]; then
  LSCL_CONFIG_SUFFIX=""
fi


${lsclKiraPath} --parallel=${lsclKiraNumThreads} job.yaml & psrecord $! --include-children --interval 5 --log memory.txt

lsclStatus=$?

if [[ $lsclStatus -eq 0 ]] ; then
      echo "lsclAuxKiraRunReduction: IBP reduction for ${lsclTopologyName} completed successfully."
else
      echo "lsclAuxKiraRunReduction: IBP reduction for ${lsclTopologyName} failed."
fi
#rm -rf ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/${lsclTopologyName}/tmp;
exit $lsclStatus
