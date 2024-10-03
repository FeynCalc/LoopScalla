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

lsclAllReductions=()
lsclCompletedReductions=()
readarray -d '' lsclAllDiagramsRaw < <(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/Input/$lsclProcessName/$lsclModelName/$lsclNLoops -type f -name "dia*L$lsclNLoops.frm" -print0 | sort -V);

IFS=$'\n' lsclAllDiagrams=($(sort -V <<<"${lsclAllDiagramsRaw[*]}"))
unset IFS
counter=0
echo Unprocessed diagrams:
for i in "${lsclAllDiagrams[@]}"; do
	
  lsclDiaName=$(basename ${i} .frm)  
  
  if [ ! -f $lsclRepoDir/Projects/$lsclProjectName/Diagrams/Output/$lsclProcessName/$lsclModelName/$lsclNLoops/Stage${lsclStage}/stage${lsclStage}_$lsclDiaName.res ]; then
   echo $lsclDiaName
   counter=$((counter + 1))
  fi
done
echo Total number of unprocessed diagrams: $counter