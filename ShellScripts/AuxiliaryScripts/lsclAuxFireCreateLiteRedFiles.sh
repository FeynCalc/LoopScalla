#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 5 ]] ; then
      echo 'lsclAuxFireCreateLiteRedFiles: You must specify the project, the process name, the model, the number of the loops and the topology.'
      exit 0
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclTopologyName="$5"

set +e

${lsclMmaPath} -nopromt -script ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/${lsclTopologyName}/CreateLiteRedFiles.m


lsclStatus=$?

if [[ $lsclStatus -eq 0 ]] ; then
      echo "lsclAuxFireCreateLiteRedFiles: Creation of LiteRed files for ${lsclTopologyName} completed successfully."
else
      echo "lsclAuxFireCreateLiteRedFiles: Creation of LiteRed files for ${lsclTopologyName} failed."
fi

exit $lsclStatus







