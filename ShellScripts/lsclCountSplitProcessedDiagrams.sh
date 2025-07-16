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
#lsclStage="$5"

diaNum=()
diaIntOrig=()
diaIntCompleted=()
counterTotal=0
counterDone=0

readarray -d '' lsclAllDiagramsRaw < <(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/$lsclProcessName/$lsclModelName/$lsclNLoops/SplitStage1 -mindepth 1 -maxdepth 1 -type d -name "*" -print0 | sort -V);

IFS=$'\n' lsclAllDiagrams=($(sort -V <<<"${lsclAllDiagramsRaw[*]}"))
unset IFS
echo "Diagram number | Stage 1 | Stage 2"
for i in "${lsclAllDiagrams[@]}"; do
num=$(basename $i)
lsclNumDiasInput=$(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/$lsclProcessName/$lsclModelName/$lsclNLoops/SplitStage1/$num/ -type f -name "stage1_dia*L$lsclNLoops*.res" 2>/dev/null  | wc -l)
lsclNumDiasOutput=$(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/$lsclProcessName/$lsclModelName/$lsclNLoops/SplitStage2/$num/ -type f -name "stage2_dia*L$lsclNLoops*.res" 2>/dev/null  | wc -l)
echo $num $lsclNumDiasInput $lsclNumDiasOutput
diaNum+=($num)
diaIntOrig+=($lsclNumDiasInput)
diaIntCompleted+=($lsclNumDiasOutput)
counterTotal=$((counterTotal + 1))
done
echo "Total number of diagrams: $counterTotal"

echo
echo



index=0
for i in "${!diaNum[@]}"; do
if [[ "${diaIntOrig[$index]}" == "${diaIntCompleted[$index]}" ]]; then
echo Completed diagram '('${diaNum[$index]}')': ${diaIntOrig[$index]} vs. ${diaIntCompleted[$index]}
counterDone=$((counterDone + 1))
fi
index=$((index + 1))
done
echo "Total number of completed diagrams: $counterDone"

echo
echo

index=0
for i in "${!diaNum[@]}"; do
if [[ "${diaIntOrig[$index]}" != "${diaIntCompleted[$index]}" ]]; then
diff=$(echo ${diaIntOrig[$index]}-${diaIntCompleted[$index]}|bc)
echo Incomplete diagram '('${diaNum[$index]}')': ${diaIntOrig[$index]} vs. ${diaIntCompleted[$index]} - difference: $diff
counterInc=$((counterInc + 1))
fi
index=$((index + 1))
done
echo "Total number of incomplete diagrams: $counterInc"
