#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

if [[ $# -lt 5 ]] ; then
    echo 'You must specify the project, the process name, the model, the number of the loops and the stage!'
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
lsclStage="$5"

lsclNumDiasInput=$(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/$lsclProcessName/$lsclModelName/$lsclNLoops/Input -type f -name "dia*L$lsclNLoops.frm" | wc -l)
lsclNumDiasOutput=$(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/$lsclProcessName/$lsclModelName/$lsclNLoops/Stage${lsclStage} -type f -name "stage${lsclStage}_dia*L$lsclNLoops.res" | wc -l)

echo
echo Original number of input diagrams: ${lsclNumDiasInput}
echo Number of processed diagrams at stage ${lsclStage}: ${lsclNumDiasOutput}



