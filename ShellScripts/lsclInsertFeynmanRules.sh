#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# /ShellScripts/lsclInsertFeynmanRules.sh MyProject MyProject MyModel 3 1
# /ShellScripts/lsclInsertFeynmanRules.sh MyProject MyProject MyModel 3 1 --force
# /ShellScripts/lsclInsertFeynmanRules.sh MyProject MyProject MyModel 3 --fromto 1 10
# /ShellScripts/lsclInsertFeynmanRules.sh MyProject MyProject MyModel 3 --fromto 1 all --force

# Stop if any of the commands fails
set -e

export LSCL_SCRIPT_NAME="lsclInsertFeynmanRules"

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


if [ ${SLURM_CLUSTER_NAME} ]; then
    if [ ${SLURM_ARRAY_TASK_ID} ]; then
      # Single diagram via SLURM_ARRAY_TASK_ID
      lsclDiaNumber=${SLURM_ARRAY_TASK_ID}
    else
      # Single diagram via command line argument
      lsclDiaNumber="$5"
    fi
else
  lsclDiaNumber="$5"
  lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  lsclRepoDir="$(dirname $lsclScriptDir)"
fi

lsclExtraFormScriptArguments=()
lsclBasicArguments=()

if [[ -z "${LSCL_FLAG_FORCE+x}" ]]; then
  LSCL_FLAG_FORCE=0
fi


if [[ -z "${LSCL_PARALLEL_JOBLOG_PATH+x}" ]]; then
  export LSCL_PARALLEL_JOBLOG_PATH="${lsclRepoDir}/Logs/${LSCL_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}"
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

export LSCL_FORM_SCRIPT_NAME="lsclInsertFeynmanRules.frm"
export LSCL_CREATE_DIR_IF_NOT_PRESENT_1="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops}"

if [[ ${LSCL_FLAG_FORCE} -eq 0 ]] && [[ ${lsclOptFromTo} -ne 1 ]]; then
      export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/dia${lsclDiaNumber}L${lsclNLoops}.frm"
fi

if [[ ${lsclOptFromTo} -eq 1 ]] ; then
    # Process multiple diagrams in parallel
    export LSCL_SCRIPT_TO_RUN_IN_PARALLEL="lsclInsertFeynmanRules.sh"
    export LSCL_RUN_IN_PARALLEL="1"
    export LSCL_DIAGRAM_RANGE="1"

    if [[ ${lsclDiaNumberTo} == "all" ]]; then
      lsclNumDias=$(grep -o '\#\[ d' ${lsclRepoDir}/Projects/${lsclProjectName}/QGRAF/Output/${lsclProcessName}.${lsclModelName}.${lsclNLoops}.amps | wc -l)
      lsclDiaNumberTo=${lsclNumDias}

      if [[ ${lsclNumDias} -eq "0" ]]; then
        echo "$LSCL_SCRIPT_NAME}: There are no input files to process!"
        exit 1;
      fi

    fi
    echo "${LSCL_SCRIPT_NAME}: Running in parallel."
    ${lsclScriptDir}/lsclTemplateScriptForm.sh ${lsclBasicArguments[@]:0:4} ${lsclDiaNumberFrom} ${lsclDiaNumberTo} ${lsclExtraFormScriptArguments}
 else
    # Process a single diagrams
    ${lsclScriptDir}/lsclTemplateScriptForm.sh ${lsclBasicArguments[@]} ${lsclExtraFormScriptArguments[@]}
fi
