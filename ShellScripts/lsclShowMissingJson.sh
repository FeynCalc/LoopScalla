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

lsclAllReductions=()
lsclCompletedReductions=()
readarray -d '' lsclAllReductions < <(find $lsclRepoDir/Projects/$lsclProjectName/Diagrams/$lsclProcessName/$lsclModelName/$lsclNLoops/MasterIntegrals/pySecDec/  -type f -name "generate_int.py" -print0);


echo Unfinished imports:
for i in "${lsclAllReductions[@]}"; do

  lsclTopoDirName=$(dirname ${i})  
  lsclTopoName=$(basename ${lsclTopoDirName})  
   
  if [ ! -f ${lsclTopoDirName}/loopint_integral.json ]; then
   echo "${lsclTopoName}"
  fi
  
done;
