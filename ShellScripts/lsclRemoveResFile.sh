#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

if [[ $# -lt 6 ]] ; then
    echo 'You must specify the project, the process name, the model, the number of the loops, the diagram and the stage!'
    exit 0
fi

################################################################################
# Stop if any of the commands fails
set -e

export lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

################################################################################


lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclDiaNumber="$5"
lsclStage="$6"

lsclFile="stage${lsclStage}_dia${lsclDiaNumber}L${lsclNLoops}.res"
echo ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage${lsclStage}/$lsclFile
if [ -f "${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/$lsclFile" ]
then
    read -p "Are you sure that you want to delete the result file $lsclFile? To continue, please type 'yes':" -n 3 -r
    echo    # (optional) move to a new line
    if [[ $REPLY = "yes" ]]
    then
        echo Deleting...
        rm -rf ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage${lsclStage}/$lsclFile
    fi
else
    echo lsclRemoveResFile: The file $lsclFile does not exist.
fi









