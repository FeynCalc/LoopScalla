#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# /ShellScripts/lsclRunQGRAF.sh MyProject MyProject MyModel 3 1 --force
# /ShellScripts/lsclRunQGRAF.sh MyProject MyProject MyModel 3 1 --nopdf


# Stop if any of the commands fails
set -e

export LSCL_SCRIPT_NAME="lsclRunQGRAF"

if [[ $# -lt 4 ]] ; then
    echo "${LSCL_SCRIPT_NAME}: You must specify the project, the process name, the model, and the number of the loops!"
    echo "${LSCL_SCRIPT_NAME}: Current command line arguments: ${@}"
    exit 0
fi

# Unset these variables to avoid issues when running this via parallel
unset LSCL_SCRIPT_TO_RUN_IN_PARALLEL
unset LSCL_RUN_IN_PARALLEL

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"

if [ ${SLURM_CLUSTER_NAME} ]; then
    if [ ${SLURM_ARRAY_TASK_ID} ]; then      
      :
    else
      :  
    fi
else
  export lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  export lsclRepoDir="$(dirname $lsclScriptDir)"
fi

lsclBasicArguments=()
if [[ -z "${LSCL_FLAG_NO_PDF+x}" ]]; then
  LSCL_FLAG_NO_PDF=0
fi

################################################################################
if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi
################################################################################

while [[ ${#} -gt 0 ]]; do
  case ${1} in
    #Extra shell script parameters
    --nopdf)
      export LSCL_FLAG_NO_PDF=1
      echo "${LSCL_SCRIPT_NAME}: Skipping the generation of the PDF file."
      shift
      ;;    
    #Basic input parameters
    *)
      lsclBasicArguments+=("$1")
      shift;
      ;;
  esac
done

lsclQgrafProjectPath=${lsclRepoDir}/Projects/$lsclProjectName/QGRAF/qgraf

if [ ! -f ${lsclQgrafPath} ]; then
    echo "${LSCL_SCRIPT_NAME}: Error! Missing a QGRAF binary in $lsclQgrafPath"
    exit 1
fi

if [ ! -f ${lsclQgrafProjectPath} ]; then
    
    echo "${LSCL_SCRIPT_NAME}: ${lsclQgrafProjectPath}. Copying the binary from ${lsclQgrafPath}"

    cp ${lsclQgrafPath} ${lsclQgrafProjectPath}
    
    if [ ! -f ${lsclQgrafProjectPath} ]; then
      echo "${LSCL_SCRIPT_NAME}: Error! Failed to copy the binary from ${lsclQgrafPath} to ${lsclQgrafProjectPath}"
      exit 1
    fi
fi

echo "${LSCL_SCRIPT_NAME}: Using QGRAF binary from ${lsclQgrafProjectPath}"

if [ ! -f "${lsclQgrafPath}" ]; then
    echo "${LSCL_SCRIPT_NAME}: Error! Missing a QGRAF binary in ${lsclQgrafPath}"
    exit 1
fi


if [ ! -f "$lsclRepoDir/Projects/$lsclProjectName/QGRAF/Input/qgraf.dat.$lsclProcessName.$lsclNLoops" ]; then
    if [ -f "$lsclRepoDir/Projects/$lsclProjectName/QGRAF/Input/qgraf.dat.$lsclProcessName" ]; then
      echo "${LSCL_SCRIPT_NAME}: Using generic control file qgraf.dat.$lsclProcessName"
      lsclQrafInput="qgraf.dat.$lsclProcessName"
    else
      echo "${LSCL_SCRIPT_NAME}: Error! Missing the control file qgraf.dat.$lsclProcessName.$lsclNLoops"
      exit 1
    fi
  else
    lsclQrafInput="qgraf.dat.$lsclProcessName.$lsclNLoops"
fi

echo "${LSCL_SCRIPT_NAME}: Generating amplitudes with QGRAF"
"$lsclScriptDir"/AuxiliaryScripts/lsclAuxRunQgraf.sh ${lsclModelName} ${lsclQrafInput} ${lsclProjectName} ${lsclProcessName}.${lsclModelName}.${lsclNLoops} ${lsclNLoops};

if [[ ${LSCL_FLAG_NO_PDF} -eq 0 ]]; then

      echo "${LSCL_SCRIPT_NAME}: Splitting graphs into single files"
      ${lsclScriptDir}/AuxiliaryScripts/lsclAuxSplitGraphs.sh $lsclProjectName $lsclProcessName.$lsclModelName.$lsclNLoops.graphs;
      
      if [ -z "$(ls -A $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/Files/$lsclProcessName.$lsclModelName.$lsclNLoops.graphs)" ]; then
        echo "${LSCL_SCRIPT_NAME}: No diagrams were generated, leaving.";
        rmdir $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/Graphs/$lsclProcessName.$lsclModelName.$lsclNLoops.graphs;
        exit 1;
      fi

      echo "${LSCL_SCRIPT_NAME}: Generating PDFs"
      ${lsclScriptDir}/AuxiliaryScripts/lsclAuxDrawGraphs.sh $lsclProjectName $lsclProcessName.$lsclModelName.$lsclNLoops.graphs;
fi




echo "${LSCL_SCRIPT_NAME}: All done."
