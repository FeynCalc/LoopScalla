#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:


# ./ShellScripts/lsclSlurmSplitInsertReductionTables.sh MyProject MyProject MyModel 1 clusterPartitions --fromto 1 all --diaNumber=379
# ./ShellScripts/lsclSlurmSplitInsertReductionTables.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --force --diaNumber=379
# ./ShellScripts/lsclSlurmSplitInsertReductionTables.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --force --nodes 2 --slices 1000 --diaNumber 379
# ./ShellScripts/lsclSlurmSplitInsertReductionTables.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --clearlogs --nodes 2 --slices 1000 --diaNumber 379
# ./ShellScripts/lsclSlurmSplitInsertReductionTables.sh MyProject MyProject MyModel 1 clusterPartitions --mem 1000 --fromto 1 all --nodes 2 --slices 5 --clearlogs --diaNumber 379


# Stop if any of the commands fails
set -e

export LSCL_SLURM_SCRIPT_NAME="lsclSlurmSplitInsertReductionTables"

if [[ $# -lt 5 ]] ; then
    echo "${LSCL_SLURM_SCRIPT_NAME}: You must specify the project, the process name, the model, the number of the loops and the partition!"
    echo "${LSCL_SLURM_SCRIPT_NAME}: Current command line arguments: ${@}"
    exit 1
fi


export lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export lsclRepoDir="$(dirname $lsclScriptDir)"

if [[ -z "${lsclEnvSourced}" ]]; then
  . "$lsclRepoDir"/environment.sh
fi


export LSCL_CLUSTER_SCRIPT_NAME="lsclSplitInsertReductionTables.sh"
export LSCL_CLUSTER_CORES_PER_JOB="${lsclTformNumWorkers}"
export LSCL_CLUSTER_MEM_PER_JOB=2000

export LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES=1
export LSCL_CLUSTER_NUMBER_OF_SLICES=100
export LSCL_CLUSTER_CLEAR_LOGS=0

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"

lsclExtraFormScriptArguments=()
lsclBasicArguments=()

if [[ -z "${LSCL_FLAG_FORCE+x}" ]]; then
  LSCL_FLAG_FORCE=0
fi

lsclOptFromTo=0

while [[ ${#} -gt 0 ]]; do
  case ${1} in
    #FORM script arguments
    -d|-D)
      lsclExtraFormScriptArguments+=("${1} ${2}")
      shift
      shift
      ;;
    --fromto)
      export lsclOptFromTo=1
      lsclIntNumberFrom=${2}
      lsclIntNumberTo=${3}
      shift
      shift
      shift
      ;;
    #Dia
    --diaNumber)
      lsclExtraFormScriptArguments+=("-d lsclDiaNumber=${2}")
      export LSCL_DIA_NUMBER=${2}
      shift
      shift
      ;;
    #Expansion in ep
    --epexpand)
      echo "${LSCL_CLUSTER_SCRIPT_NAME}: Using reduction tables expanded in ep."
      lsclExtraFormScriptArguments+=("-D LSCLEPEXPAND -D LSCLEPEXPANDORDER=${2}")
      lsclEpExpandOrder=${2}
      shift
      shift
      ;;
    #Extra shell script parameters
    --force)
      export LSCL_FLAG_FORCE=1
      shift
      ;;
    #Remove all existing logs for this job type
    --clearlogs)
      export LSCL_CLUSTER_CLEAR_LOGS=1
      shift
      ;;
    #Number of requested GNU parallel jobs
    --pjobs)
      export LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS=${2}
      shift
      shift
      ;;
    #Memory request for each job
    --mem)
      export LSCL_CLUSTER_MEM_PER_JOB=${2}
      shift
      shift
      ;;
    #Number of requested nodes for the jobs
    --nodes)
      export LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES=${2}
      shift
      shift
      ;;
    #Number of requested cores for the jobs
    --cores)
      export LSCL_CLUSTER_CORES_PER_JOB=${2}
      shift
      shift
      ;;
    #Number of requested slices per node
    --slices)
      export LSCL_CLUSTER_NUMBER_OF_SLICES=${2}
      shift
      shift
      ;;
    #SLURM time
    --time)
      export LSCL_CLUSTER_REQUESTED_TIME=${2}
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

export LSCL_SLURM_JOB_NAME=${LSCL_SLURM_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}.${LSCL_DIA_NUMBER}.${lsclEpExpandOrder}
export LSCL_SLURM_LOG_DIR=${lsclRepoDir}/ClusterLogs/${LSCL_SLURM_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}.${LSCL_DIA_NUMBER}.${lsclEpExpandOrder}





# Slurm must always be given a range of diagrams, even for a single diagram
if [[ ${lsclOptFromTo} -ne 1 ]] ; then
      echo "${LSCL_SCRIPT_NAME}: You must specify a range of integrals to process"
      exit 1
fi

export LSCL_DIAGRAM_RANGE="1"
export LSCL_RUN_IN_PARALLEL="1"

if [[ ${lsclIntNumberTo} == "all" ]]; then
  lsclNumInts=$(find ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage1/${LSCL_DIA_NUMBER} -type f -name "stage1_dia${LSCL_DIA_NUMBER}L${lsclNLoops}_p*.res" | wc -l)
  lsclIntNumberTo=${lsclNumInts}

  if [[ ${lsclNumInts} -eq "0" ]]; then
    echo "$LSCL_SLURM_SCRIPT_NAME}: There are no input files to process!"
    exit 1;
  fi
fi

#echo "${LSCL_SLURM_SCRIPT_NAME}: Processing diagrams in the range from ${LSCL_DIA_NUMBERFrom} to ${LSCL_DIA_NUMBERTo}."

${lsclScriptDir}/lsclTemplateScriptSlurm.sh ${lsclBasicArguments[@]:0:5} ${lsclIntNumberFrom} ${lsclIntNumberTo} ${lsclExtraFormScriptArguments[@]}
