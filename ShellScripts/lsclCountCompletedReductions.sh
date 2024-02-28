#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

if [[ $# -lt 4 ]] ; then
    echo 'You must specify the project, the process name, the model and the number of the loops!'
    exit 0
fi

################################################################################
# Stop if any of the commands fails
set -e

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

################################################################################

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"

lsclNumDiasInput=$(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/Output/$lsclProcessName/$lsclModelName/$lsclNLoops/Reductions/*/ -type f -name "LoopIntegrals.m" | wc -l)
lsclNumDiasOutput=$(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/Output/$lsclProcessName/$lsclModelName/$lsclNLoops/Reductions/*/ -type f -name "*.tables" | wc -l)

echo
echo Original number of input diagrams: ${lsclNumDiasInput}
echo Number of completed reductions: ${lsclNumDiasOutput}
echo Number of remaining reductions: $((lsclNumDiasInput-lsclNumDiasOutput))
