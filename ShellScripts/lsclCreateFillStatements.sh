#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# Notice that numbers are related to the positions of the entries in the TopologyList.txt file
# ./ShellScripts/lsclCreateFillStatements.sh MyProject MyProject MyModel 3 topology1
# ./ShellScripts/lsclCreateFillStatements.sh MyProject MyProject MyModel 3 topology1 --force
# ./ShellScripts/lsclCreateFillStatements.sh MyProject MyProject MyModel 3 --fromto 1 2
# ./ShellScripts/lsclCreateFillStatements.sh MyProject MyProject MyModel 3 --fromto 1 all --force

# Stop if any of the commands fails
set -e

export LSCL_SCRIPT_NAME="lsclCreateFillStatements"
export LSCL_SHELL_SCRIPT_NAME="AuxiliaryScripts/lsclAuxCreateFillStatements.sh"

echo
echo

if [[ $# -lt 4 ]] ; then
    echo "${LSCL_SCRIPT_NAME}: You must specify the project, the process name, the model, and the number of the loops!"
    echo "${LSCL_SCRIPT_NAME}: Current command line arguments: ${@}"
    exit 0
fi

# Unset these variables to avoid issues when running this via parallel
unset LSCL_SCRIPT_TO_RUN_IN_PARALLEL
unset LSCL_RUN_IN_PARALLEL
unset LSCL_DIAGRAM_RANGE

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclTopologyName="$5"

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

if [[ -z "${LSCL_FLAG_EXPAND_IN_EP+x}" ]]; then
  export LSCL_FLAG_EXPAND_IN_EP=0
fi

if [[ -z "${LSCL_EP_EXPANSION_ORDER+x}" ]]; then
  export LSCL_EP_EXPANSION_ORDER=999
fi




lsclOptFromTo=0

while [[ ${#} -gt 0 ]]; do
  case ${1} in
    #Extra shell script parameters
    --force)
      export LSCL_FLAG_FORCE=1
      echo "${LSCL_SCRIPT_NAME}: Forcing reevaluation of already computed diagrams."
      shift
      ;;
    --fromto)
      lsclOptFromTo=1
      lsclDiaNumberFrom=${2}
      lsclDiaNumberTo=${3}
      echo "${LSCL_SCRIPT_NAME}: Processing diagrams in the range from ${lsclDiaNumberFrom} to ${lsclDiaNumberTo}."
      echo $lsclOptFromTo
      shift
      shift
      shift
      ;;
    #Expansion in ep
    --epexpand)
      export LSCL_FLAG_EXPAND_IN_EP=1
      export LSCL_EP_EXPANSION_ORDER=${2}
      echo "${LSCL_SCRIPT_NAME}: Reduction tables will be expanded in ep up to order " ${LSCL_EP_EXPANSION_ORDER}
      shift
      shift
      ;;         
    #FORM script arguments
    -d|-D)
      lsclExtraFormScriptArguments+=("${1} ${2}")
      shift
      shift
      ;;
     #Number of requested GNU parallel jobs
    --pjobs)
      export LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS=${2}
      shift
      shift
      ;;
    #Basic input parameters
    *)
      lsclBasicArguments+=("$1")
      shift;
      ;;
  esac
done

if [[ -z "${LSCL_PARALLEL_JOBLOG_PATH+x}" ]]; then
  export LSCL_PARALLEL_JOBLOG_PATH="${lsclRepoDir}/Logs/${LSCL_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}.${LSCL_EP_EXPANSION_ORDER}"
fi

if [[ ${LSCL_FLAG_FORCE} -eq 0 ]] && [[ ${lsclOptFromTo} -ne 1 ]]; then
      if [[ ${LSCL_FLAG_EXPAND_IN_EP} -eq 0 ]]; then
        export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/${lsclTopologyName}/fillStatements.frm"
      else
        export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/${lsclTopologyName}/fillStatementsExpanded${LSCL_EP_EXPANSION_ORDER}.frm"
      fi     
fi



if [[ ${lsclOptFromTo} -eq 1 ]] ; then
    # Process multiple diagrams in parallel

    export LSCL_SCRIPT_TO_RUN_IN_PARALLEL="lsclCreateFillStatements.sh"
    export LSCL_RUN_IN_PARALLEL="1"
    export LSCL_DIAGRAM_RANGE="1"
    export LSCL_TASKS_FROM_FILE="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Topologies/TopologyList.txt"

    if [[ ${lsclDiaNumberTo} == "all" ]]; then
      readarray -t lsclTasksAll < ${LSCL_TASKS_FROM_FILE};
      lsclDiaNumberTo=${#lsclTasksAll[@]}

      if [[ ${lsclDiaNumberTo} -eq "0" ]]; then
        echo "$LSCL_SCRIPT_NAME}: There are no input files to process!"
        exit 1;
      fi
    fi

    echo "${LSCL_SCRIPT_NAME}: Running in parallel from ${lsclDiaNumberFrom} to ${lsclDiaNumberTo}"
    ${lsclScriptDir}/lsclTemplateScriptShell.sh ${lsclBasicArguments[@]:0:4} ${lsclDiaNumberFrom} ${lsclDiaNumberTo}
 else
    echo "${LSCL_SCRIPT_NAME}: Processing a single topology."
    ${lsclScriptDir}/lsclTemplateScriptShell.sh ${lsclBasicArguments[@]:0:4} ${lsclTopologyName}
fi
