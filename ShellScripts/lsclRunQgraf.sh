#!/bin/bash
if [[ $# -lt 4 ]] ; then
    echo 'You must specify the project, the process name, the model file  the number of the loops!'
    exit 0
fi

#example ./lsclRunQgraf.sh SCETSoftFun QCDTwoFlavors 1

################################################################################
# Stop if any of the commands fails
set -e

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

################################################################################

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"
lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"

if [ ! -f "$lsclQgrafPath" ]; then
    echo "Fatal error: Missing a QGRAF binary in $lsclQgrafPath"
    exit 1
fi

if [ ! -f "${lsclQgrafPath}lsclRepoDir/Projects/$lsclProjectName/QGRAF/qgraf" ]; then
    echo "FYI: $lsclRepoDir/Projects/$lsclProjectName/QGRAF/qgraf not found. Copying the binary from ${lsclQgrafPath}"
    cp ${lsclQgrafPath} ${lsclRepoDir}/Projects/${lsclProjectName}/QGRAF/qgraf
    if [ ! -f "$lsclRepoDir/Projects/$lsclProjectName/QGRAF/qgraf" ]; then
      echo "Fatal error: Failed to copy the binary from $lsclQgrafPath to $lsclRepoDir/Projects/$lsclProjectName/QGRAF/qgraf"
      exit 1
    fi
fi

echo "Using QGRAF binary from $lsclRepoDir/Projects/$lsclProjectName/QGRAF/qgraf"
echo

if [ ! -f "${lsclQgrafPath}" ]; then
    echo "Fatal error: Missing a QGRAF binary in ${lsclQgrafPath}"
    exit 1
fi


if [ ! -f "$lsclRepoDir/Projects/$lsclProjectName/QGRAF/Input/qgraf.dat.$lsclProcessName.$lsclNLoops" ]; then
    if [ -f "$lsclRepoDir/Projects/$lsclProjectName/QGRAF/Input/qgraf.dat.$lsclProcessName" ]; then
      echo "Using generic control file qgraf.dat.$lsclProcessName"
      qInput="qgraf.dat.$lsclProcessName"
    else
      echo "Fatal error: Missing the control file qgraf.dat.$lsclProcessName.$lsclNLoops"
      exit 1
    fi
  else
    qInput="qgraf.dat.$lsclProcessName.$lsclNLoops"
fi




echo "Generating amplitudes with QGRAF"
"$lsclScriptDir"/lsclAuxRunQgraf.sh "$lsclModelName" "$qInput" "$lsclProjectName" "$lsclProcessName.$lsclModelName.$lsclNLoops" "$lsclNLoops";


echo "Splitting graphs into single files"
"$lsclScriptDir"/lsclSplitGraphs.sh $lsclProjectName $lsclProcessName.$lsclModelName.$lsclNLoops.graphs;

if [ -z "$(ls -A $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/$lsclProcessName.$lsclModelName.$lsclNLoops.graphs)" ]; then
   echo "No diagrams were generated, leaving.";
   rmdir $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/Graphs/$lsclProcessName.$lsclModelName.$lsclNLoops.graphs;
   exit 1;
fi

echo "Drawing graphs"
"$lsclScriptDir"/lsclDrawGraphs.sh $lsclProjectName $lsclProcessName.$lsclModelName.$lsclNLoops.graphs;

echo "All done."
