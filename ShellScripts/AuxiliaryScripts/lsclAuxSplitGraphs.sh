#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -ne 2 ]] ; then
    echo 'You must specify the project name and the graph file.'
    exit -1
fi

lsclProjectName="$1"
lsclGraphFile="$2"

if [ ! -f "${lsclRepoDir}/Projects/${lsclProjectName}/QGRAF/Output/Files/${lsclGraphFile}" ]; then
    echo "lsclAuxSplitGraphs: Error: The graph file ${lsclGraphFile} does not exist!"
    exit 1
fi

cd ${lsclRepoDir}/Projects/${lsclProjectName}/QGRAF/

mkdir -p Output/Graphs/${lsclGraphFile} 2>/dev/null;
find Output/Graphs/${lsclGraphFile} -name 'graph.*' -type f -delete
csplit -b %d --prefix Output/Graphs/${lsclGraphFile}/graph. Output/Files/${lsclGraphFile} '//===//' {*} > /dev/null 2>&1;
rm Output/Graphs/${lsclGraphFile}/graph.0