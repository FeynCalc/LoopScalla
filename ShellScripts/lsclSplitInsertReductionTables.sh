#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2024 Vladyslav Shtabovenko

# Examples:

# ./ShellScripts/lsclSplitInsertReductionTables.sh MyProject MyProject MyModel 3 --fromto 1 5 --diaNumber=379 --topology=topology6075
# ./ShellScripts/lsclSplitInsertReductionTables.sh MyProject MyProject MyModel 3 5  --diaNumber=379 --topology=topology6075
# ./ShellScripts/lsclSplitInsertReductionTables.sh MyProject MyProject MyModel 3 --fromto 1 5 --diaNumber=379 --topology=topology6075
# ./ShellScripts/lsclSplitInsertReductionTables.sh MyProject MyProject MyModel 3 --fromto 1 all --force --diaNumber=379 --topology=topology6075

# Stop if any of the commands fails
set -e

export LSCL_SCRIPT_NAME="lsclSplitInsertReductionTables"
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

lsclExtraFormScriptArguments=("-d LSCLREDUCESINGLEINTEGRAL")
lsclBasicArguments=()

if [[ -z "${LSCL_FLAG_FORCE+x}" ]]; then
  LSCL_FLAG_FORCE=0
fi

echo ${LSCL_SCRIPT_NAME}: lsclIntNumber: $lsclIntNumber



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
      echo $lsclOptFromTo
      shift
      shift
      shift
      ;;
    #Dia
    --diaNumber)
      lsclExtraFormScriptArguments+=("-d lsclDiaNumber=${2}")
      lsclDiaNumber=${2}
      shift
      shift
      ;;  
    #Topo
    --topology)
      lsclExtraFormScriptArguments+=("-d lsclTopology=${2}")
      lsclTopology=${2}
      shift
      shift
      ;;    
    #FORM script arguments
    -d|-D)
      lsclExtraFormScriptArguments+=("${1} ${2}")
      shift
      shift
      ;;
    #Expansion in ep
    --epexpand)      
      echo "${LSCL_SCRIPT_NAME}: Using reduction tables expanded in ep."
      lsclExtraFormScriptArguments+=("-D LSCLEPEXPAND")
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
  export LSCL_PARALLEL_JOBLOG_PATH="${lsclRepoDir}/Logs/${LSCL_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}.${lsclDiaNumber}"
fi


export LSCL_FORM_SCRIPT_NAME="lsclInsertReductionTables.frm"
export LSCL_CREATE_DIR_IF_NOT_PRESENT_1="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage2/${lsclDiaNumber}"

if [[ ${LSCL_FLAG_FORCE} -eq 0 ]] && [[ ${lsclOptFromTo} -ne 1 ]]; then
      export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage2/${lsclDiaNumber}/stage2_dia${lsclDiaNumber}L${lsclNLoops}T${lsclTopology}I${lsclIntNumber}.res"
fi

if [[ ${lsclOptFromTo} -eq 1 ]] ; then
    # Process multiple diagrams in parallel
    export LSCL_SCRIPT_TO_RUN_IN_PARALLEL="lsclSplitInsertReductionTables.sh"
    export LSCL_RUN_IN_PARALLEL="1"
    export LSCL_DIAGRAM_RANGE="1"

    if [[ ${lsclIntNumberTo} == "all" ]]; then
      lsclNumInts=$(find ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams//Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage1/${lsclDiaNumber} -type f -name "stage1_dia${lsclDiaNumber}L${lsclNLoops}T${lsclTopology}I*.res" | wc -l)
      lsclIntNumberTo=${lsclNumInts}

      if [[ ${lsclNumInts} -eq "0" ]]; then
        echo "$LSCL_SCRIPT_NAME}: There are no input files to process!"
        exit 1;
      fi

    fi
    echo "${LSCL_SCRIPT_NAME}: Running in parallel."
    echo ${lsclScriptDir}/lsclTemplateScriptForm.sh ${lsclBasicArguments[@]:0:4} ${lsclIntNumberFrom} ${lsclIntNumberTo} ${lsclExtraFormScriptArguments[@]}
    ${lsclScriptDir}/lsclTemplateScriptForm.sh ${lsclBasicArguments[@]:0:4} ${lsclIntNumberFrom} ${lsclIntNumberTo} ${lsclExtraFormScriptArguments[@]}
    exit;
 else
    echo "${LSCL_SCRIPT_NAME}: Processing a single entry."    
    echo ${lsclScriptDir}/lsclTemplateScriptForm.sh ${lsclBasicArguments[@]} ${lsclExtraFormScriptArguments[@]}
    ${lsclScriptDir}/lsclTemplateScriptForm.sh ${lsclBasicArguments[@]} ${lsclExtraFormScriptArguments[@]}
fi
