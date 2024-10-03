#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# Notice that numbers are related to the positions of the entries in the TopologyList.txt file
# ./ShellScripts/lsclSlurmEvaluateWithPySecDec.sh MyProject MyProject MyModel 1 clusterPartitions --fromto 1 all
# ./ShellScripts/lsclSlurmEvaluateWithPySecDec.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --force
# ./ShellScripts/lsclSlurmEvaluateWithPySecDec.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --force --nodes 2 --slices 1000
# ./ShellScripts/lsclSlurmEvaluateWithPySecDec.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --clearlogs --nodes 2 --slices 1000
# ./ShellScripts/lsclSlurmEvaluateWithPySecDec.sh MyProject MyProject MyModel 1 clusterPartitions --mem 1000 --fromto 1 all --nodes 2 --slices 5 --clearlogs


# Stop if any of the commands fails
set -e

export LSCL_SLURM_SCRIPT_NAME="lsclSlurmEvaluateWithPySecDec"

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


export LSCL_CLUSTER_SCRIPT_NAME="lsclEvaluateWithPySecDec.sh"
export LSCL_CLUSTER_CORES_PER_JOB="${lsclPySecDecNumThreads}"
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

if [[ -z "${LSCL_MASTER_INTEGRALS_DIRECTORY+x}" ]]; then
  LSCL_MASTER_INTEGRALS_DIRECTORY="pySecDec"
fi

if [[ -z "${LSCL_INTEGRALS_LIST+x}" ]]; then
  LSCL_INTEGRALS_LIST="IntegralsList.txt"
fi

lsclOptFromTo=0

while [[ ${#} -gt 0 ]]; do
  case ${1} in
    --fromto)
      export lsclOptFromTo=1
      lsclDiaNumberFrom=${2}
      lsclDiaNumberTo=${3}
      shift
      shift
      shift
      ;;
     #Directory inside MasterIntegrals
    --miDir)
      export LSCL_MASTER_INTEGRALS_DIRECTORY=${2}
      echo "${LSCL_SCRIPT_NAME}: Using the directory ${LSCL_MASTER_INTEGRALS_DIRECTORY}"
      shift
      shift
      ;;  
    #List of integrals to reduce
    --intList)
      export LSCL_INTEGRALS_LIST=${2}
      echo "${LSCL_SCRIPT_NAME}: Using the list of integrals ${LSCL_INTEGRALS_LIST}"
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
    #SLURM time
    --resultFile)
      export LSCL_RESULT_FILE_TO_CHECK=${2}
      shift
      shift
      ;;  
    --setUlimit)
      export LSCL_SET_ULIMIT_TO=${2}
      shift
      shift
      ;;
    --onlyPoleStructures)
      export LSCL_PYSECDEC_ONLY_POLE_STRUCTURE=1      
      shift
      ;;    
    #Basic input parameters
    *)
      lsclBasicArguments+=("$1")
      shift;
      ;;
  esac
done

export LSCL_DIAGRAM_RANGE="1"
export LSCL_RUN_IN_PARALLEL="1"
export LSCL_TASKS_FROM_FILE="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${LSCL_INTEGRALS_LIST}"



if [[ ${#lsclBasicArguments[@]} -eq 6 ]] ; then
  lsclIntegralName=${lsclBasicArguments[5]}
  lsclIntegralIndex=-1
  readarray -t lsclTasksAll < ${LSCL_TASKS_FROM_FILE};
#  echo "${lsclTasksAll[*]}"
  for i in "${!lsclTasksAll[@]}"; do
    if [[ "${lsclTasksAll[$i]}" = "${lsclIntegralName}" ]]; then
      lsclIntegralIndex=${i}
      break;
   fi
  done
  if [[ ${lsclIntegralIndex} -lt 0 ]] ; then
      echo "${LSCL_SLURM_SCRIPT_NAME}: Failed to found the specified integral ${lsclIntegralName} in the list."
      exit 1
  fi
  echo "${LSCL_SLURM_SCRIPT_NAME}: Index for $lsclIntegralName: ${lsclIntegralIndex}."
  : "$((lsclIntegralIndex+=1))"
  lsclDiaNumberFrom=${lsclIntegralIndex}
  lsclDiaNumberTo=${lsclIntegralIndex}
  export lsclOptFromTo=1


fi

# Slurm must always be given a range of diagrams, even for a single diagram
if [[ ${lsclOptFromTo} -ne 1 ]] ; then
      echo "${LSCL_SCRIPT_NAME}: You must specify a range of diagrams to process"
      exit 1
fi


if [[ ${lsclDiaNumberTo} == "all" ]]; then
  readarray -t lsclTasksAll < ${LSCL_TASKS_FROM_FILE};
  lsclDiaNumberTo=${#lsclTasksAll[@]}
  if [[ ${lsclDiaNumberTo} -eq "0" ]]; then
    echo "$LSCL_SLURM_SCRIPT_NAME}: There are no input files to process!"
    exit 1;
  fi
fi

${lsclScriptDir}/lsclTemplateScriptSlurm.sh ${lsclBasicArguments[@]:0:5} ${lsclDiaNumberFrom} ${lsclDiaNumberTo}
