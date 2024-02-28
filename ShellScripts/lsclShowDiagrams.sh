#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 4 ]] ; then
    echo 'lsclShowDiagrams: You must specify the project, the process name, the model, and the number of the loops'
    exit 0
fi

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"  

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"

${lsclPDFViewer} ${lsclRepoDir}/Projects/${lsclProjectName}/QGRAF/Output/PDFs/${lsclProcessName}.${lsclModelName}.${lsclNLoops}.graphs.pdf &
