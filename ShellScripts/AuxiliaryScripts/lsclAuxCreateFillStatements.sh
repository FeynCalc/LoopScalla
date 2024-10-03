#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 5 ]] ; then
      echo 'lsclAuxCreateFillStatements: You must specify the project, the process name, the model, the number of the loops and the topology.'
      exit 0
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclTopologyName="$5"

set +e

${lsclMmaPath} -nopromt -script ${lsclRepoDir}/MmaScripts/lsclCreateFillStatements.m -run lsclProject="\"$lsclProjectName\"" \
-run lsclProcessName="\"$lsclProcessName\"" -run lsclModelName="\"$lsclModelName\"" -run lsclNLoops="\"$lsclNLoops\""  \
-run lsclTopology="\"$lsclTopologyName\"" -run lsclExpandInEp="${LSCL_FLAG_EXPAND_IN_EP}"  -run lsclExpandInEp="${LSCL_FLAG_EXPAND_IN_EP}" \
-run lsclEpExpandUpTo=${LSCL_EP_EXPANSION_ORDER}

lsclStatus=$?

if [[ $lsclStatus -eq 0 ]] ; then
      echo "lsclCreateFillStatements: Creation of fill statements for ${lsclTopologyName} completed successfully."
else
      echo "lsclCreateFillStatements: Creation of fill statements for ${lsclTopologyName} failed."
fi

exit $lsclStatus
