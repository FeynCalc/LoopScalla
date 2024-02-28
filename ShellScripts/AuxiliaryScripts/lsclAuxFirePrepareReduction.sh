#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 4 ]] ; then
      echo "lsclAuxPrepareReduction: You must specify the project, the process name, the model and the number of the loops."
      exit 1
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclTopologyName="$5"

set +e

${lsclMmaPath} -nopromt -script ${lsclRepoDir}/MmaScripts/lsclFirePrepareReduction.m -run lsclProject="\"${lsclProjectName}\"" -run lsclProcessName="\"${lsclProcessName}\"" -run lsclModelName="\"${lsclModelName}\"" -run lsclNLoops="\"${lsclNLoops}\"" -run lsclTopologyName="\"${lsclTopologyName}\""

lsclStatus=$?

if [[ $lsclStatus -eq 0 ]] ; then
      echo "lsclAuxPrepareReduction: Preparing reductions completed successfully."
else
      echo "lsclAuxPrepareReduction: Preparing reductions failed."
fi

exit $lsclStatus
