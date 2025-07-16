#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# Notice that numbers are related to the positions of the entries in the TopologyList.txt file
# ./ShellScripts/lsclFindIntegralMappings.sh MyProject MyProject MyModel 3
# ./ShellScripts/lsclFindIntegralMappings.sh MyProject MyProject MyModel 3 --force

# Stop if any of the commands fails
set -e

export LSCL_SCRIPT_NAME="lsclFindIntegralMappings"
export LSCL_SHELL_SCRIPT_NAME="AuxiliaryScripts/lsclAuxFindIntegralMappings.sh"

echo
echo

if [[ $# -lt 4 ]] ; then
    echo "${LSCL_SCRIPT_NAME}: You must specify the project, the process name, the model, and the number of the loops!"
    echo "${LSCL_SCRIPT_NAME}: Current command line arguments: ${@}"
    exit 0
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"

if [ ${SLURM_CLUSTER_NAME} ]; then  
  :
else  
  lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  lsclRepoDir="$(dirname $lsclScriptDir)"
fi

lsclBasicArguments=()

if [[ -z "${LSCL_FLAG_FORCE+x}" ]]; then
  LSCL_FLAG_FORCE=0
fi


if [[ -z "${LSCL_PARALLEL_JOBLOG_PATH+x}" ]]; then
  export LSCL_PARALLEL_JOBLOG_PATH="${lsclRepoDir}/Logs/${LSCL_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}" 
fi

while [[ ${#} -gt 0 ]]; do
  case ${1} in
    #Extra shell script parameters
    --force)
      export LSCL_FLAG_FORCE=1
      echo "${LSCL_SCRIPT_NAME}: Forcing reevaluation of already computed diagrams."
      shift
      ;;
    #Basic input parameters
    *)      
      lsclBasicArguments+=("$1")
      shift;
      ;;
  esac
done

if [[ ${LSCL_FLAG_FORCE} -eq 0 ]]; then
      export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/LoopIntegrals/MasterIntegralMappings.m"
fi

lsclNumDias=$(find ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops} -type f -name "dia*L${lsclNLoops}.frm" | wc -l)

if [[ ${lsclNumDias} -eq "0" ]]; then
  echo "$LSCL_SCRIPT_NAME}: There are no input files to process!"
  exit 1;
fi

${lsclScriptDir}/lsclTemplateScriptShell.sh ${lsclBasicArguments[@]:0:4} ${lsclNumDias}
