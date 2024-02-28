#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 4 ]] ; then
      echo "lsclAuxFireImportResults: You must specify the project, the process name, the model and the number of the loops."
      exit 1
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclTopologyName="$5"

set +e

${lsclMmaPath} -nopromt -script ${lsclRepoDir}/MmaScripts/lsclFireImportResults.m -run lsclProject="\"${lsclProjectName}\"" -run lsclProcessName="\"${lsclProcessName}\"" -run lsclModelName="\"${lsclModelName}\"" -run lsclNLoops="\"${lsclNLoops}\"" -run lsclTopology="\"${lsclTopologyName}\""

lsclStatus=$?

if [[ $lsclStatus -eq 0 ]] ; then
      echo "lsclFireImportResults: Import of reduction tables completed successfully."
else
      echo "lsclFireImportResults: Import of reduction tables failed."
fi

exit $lsclStatus
