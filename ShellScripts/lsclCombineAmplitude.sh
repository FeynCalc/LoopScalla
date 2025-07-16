#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2024 Vladyslav Shtabovenko

# Examples:

# ./ShellScripts/lsclCombineAmplitude.sh MyProject MyProject MyModel 3 --fromto 1 5 --diaNumber=379
# ./ShellScripts/lsclCombineAmplitude.sh MyProject MyProject MyModel 3 5  --diaNumber=379
# ./ShellScripts/lsclCombineAmplitude.sh MyProject MyProject MyModel 3 --fromto 1 5 --diaNumber=379
# ./ShellScripts/lsclCombineAmplitude.sh MyProject MyProject MyModel 3 --fromto 1 all --force --diaNumber=379

# Stop if any of the commands fails
set -e

export LSCL_SCRIPT_NAME="lsclCombineAmplitude"
export LSCL_FORM_SCRIPT_INPUT_VARIABLE="lsclIntegralNumber"

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

echo "${LSCL_SCRIPT_NAME}: Current command line arguments: ${@}"


if [ ${SLURM_CLUSTER_NAME} ]; then
    if [ ${SLURM_ARRAY_TASK_ID} ]; then
      # Single diagram via SLURM_ARRAY_TASK_ID
      lsclIntNumber=${SLURM_ARRAY_TASK_ID}
    else
      # Single diagram via command line argument
      lsclIntNumber="$5"
    fi
else
  lsclIntNumber="$5"
  lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  lsclRepoDir="$(dirname $lsclScriptDir)"
fi

lsclExtraFormScriptArguments=()
lsclBasicArguments=()

if [[ -z "${LSCL_FLAG_FORCE+x}" ]]; then
  LSCL_FLAG_FORCE=0
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
      lsclIntNumberFrom=${2}
      lsclIntNumberTo=${3}
      echo "${LSCL_SCRIPT_NAME}: Processing integrals in the range from ${lsclIntNumberFrom} to ${lsclIntNumberTo}."      
      shift
      shift
      shift
      ;;
    #Dia
    --diaNumber)
      lsclExtraFormScriptArguments+=("-d lsclDiaNumber=${2}")
      LSCL_DIA_NUMBER=${2}
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
  export LSCL_PARALLEL_JOBLOG_PATH="${lsclRepoDir}/Logs/${LSCL_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}.${LSCL_DIA_NUMBER}"
fi


export LSCL_FORM_SCRIPT_NAME="lsclCombineAmplitude.frm"
export LSCL_CREATE_DIR_IF_NOT_PRESENT_1="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage2"
export LSCL_FORM_SCRIPT_INPUT_VARIABLE_FROM="lsclIntNumberFrom"
export LSCL_FORM_SCRIPT_INPUT_VARIABLE_TO="lsclIntNumberTo"
export LSCL_FORM_SCRIPT_INPUT_VARIABLE="lsclIntNumber"

if [[ ${lsclOptFromTo} -eq 1 ]] ; then
    # Process multiple diagrams without gnu parallel    
    export LSCL_SCRIPT_TO_RUN_IN_PARALLEL="lsclCombineAmplitude.sh"    
    export LSCL_DIAGRAM_RANGE="1"


    if [[ ${LSCL_FLAG_FORCE} -eq 0 ]]; then
      if [[ ${lsclIntNumberFrom} -eq 1 ]] && [[ ${lsclIntNumberTo} == "all" ]]; then      
        export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage2/stage2_dia${LSCL_DIA_NUMBER}L${lsclNLoops}.res"
      else        
        export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage2/stage2_dia${LSCL_DIA_NUMBER}L${lsclNLoops}From${lsclIntNumberFrom}To${lsclIntNumberTo}.res"
      fi
    fi

    if [[ ${lsclIntNumberTo} == "all" ]]; then

      lsclNumInts=$(find ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams//${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage1/${LSCL_DIA_NUMBER} -type f -name "stage1_dia${LSCL_DIA_NUMBER}L${lsclNLoops}_p*.res" | wc -l)
      lsclIntNumberTo=${lsclNumInts}

      if [[ ${lsclNumInts} -eq "0" ]]; then
        echo "$LSCL_SCRIPT_NAME}: There are no input files to process!"
        exit 1;
      fi

    fi

    echo "${LSCL_SCRIPT_NAME}: Running in parallel."

    ${lsclScriptDir}/lsclTemplateScriptForm.sh ${lsclBasicArguments[@]:0:4} ${lsclIntNumberFrom} ${lsclIntNumberTo} ${lsclExtraFormScriptArguments}
 else
    # In the case of a single diagram we still submit a diagram range
    export LSCL_DIAGRAM_RANGE="1"
    lsclIntNumber=${lsclBasicArguments[4]}

    if [[ ${LSCL_FLAG_FORCE} -eq 0 ]]; then
      export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage2/stage2_dia${LSCL_DIA_NUMBER}L${lsclNLoops}From${lsclIntNumber}To${lsclIntNumber}.res"
    fi

    ${lsclScriptDir}/lsclTemplateScriptForm.sh ${lsclBasicArguments[@]:0:4} ${lsclIntNumber} ${lsclIntNumber} ${lsclExtraFormScriptArguments[@]}
fi

