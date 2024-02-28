#!/bin/bash

if [[ $# -ne 2 ]] ; then
    echo 'You must specify the project name and the graph file.'
    exit -1
fi
# example ./ShellScripts/lsclSplitGraphs.sh SCETSoftFun QCDTwoFlavors.1.graphs

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
lsclGraphFile="$2"

if [ ! -f "$lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/$lsclGraphFile" ]; then
    echo "Fatal error: The graph file $lsclGraphFile does not exist!"
    exit 1
fi

cd $lsclRepoDir/Projects/$lsclProjectName/QGRAF

mkdir -p Output/Graphs/$lsclGraphFile 2>/dev/null;
find Output/Graphs/$lsclGraphFile -name 'graph.*' -type f -delete
csplit -b %d --prefix Output/Graphs/$lsclGraphFile/graph. Output/$lsclGraphFile '//===//' {*} > /dev/null 2>&1;
rm Output/Graphs/$lsclGraphFile/graph.0
