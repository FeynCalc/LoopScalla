#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# Notice that numbers are related to the positions of the entries in the TopologyList.txt file
# ./ShellScripts/lsclSlurmCreateTablebase.sh MyProject MyProject MyModel 1 clusterPartitions --fromto 1 all
# ./ShellScripts/lsclSlurmCreateTablebase.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --force
# ./ShellScripts/lsclSlurmCreateTablebase.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --force --nodes 2 --slices 1000
# ./ShellScripts/lsclSlurmCreateTablebase.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --fromto 1 all --clearlogs --nodes 2 --slices 1000
# ./ShellScripts/lsclSlurmCreateTablebase.sh MyProject MyProject MyModel 1 clusterPartitions --mem 1000 --fromto 1 all --nodes 2 --slices 5 --clearlogs


# Stop if any of the commands fails
set -e

export LSCL_SLURM_SCRIPT_NAME="lsclSlurmCreateTableBase"

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


export LSCL_CLUSTER_SCRIPT_NAME="lsclCreateTableBase.sh"
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
      lsclDiaNumberFrom=${2}
      lsclDiaNumberTo=${3}
      shift
      shift
      shift
      ;;
    #Expansion in ep
    --epexpand)      
      echo "${LSCL_SCRIPT_NAME}: Using reduction tables expanded in ep."
      lsclExtraFormScriptArguments+=("-D LSCLEPEXPAND")
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

export LSCL_DIAGRAM_RANGE="1"
export LSCL_RUN_IN_PARALLEL="1"
export LSCL_TASKS_FROM_FILE="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Topologies/TopologyList.txt"



if [[ ${#lsclBasicArguments[@]} -eq 6 ]] ; then
  lsclTopoName=${lsclBasicArguments[5]}
  lsclTopoIndex=-1
  readarray -t lsclTasksAll < ${LSCL_TASKS_FROM_FILE};
  for i in "${!lsclTasksAll[@]}"; do
    if [[ "${lsclTasksAll[$i]}" = "${lsclTopoName}" ]]; then
      lsclTopoIndex=${i}
      break;
   fi
  done
  if [[ ${lsclTopoIndex} -lt 0 ]] ; then
      echo "${LSCL_SCRIPT_NAME}: Failed to found the specified topology ${lsclTopoName} in the list."
      exit 1
  fi
  echo "${LSCL_SLURM_SCRIPT_NAME}: Index for $lsclTopoName: ${lsclTopoIndex}."
  : "$((lsclTopoIndex+=1))"
  lsclDiaNumberFrom=${lsclTopoIndex}
  lsclDiaNumberTo=${lsclTopoIndex}
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

${lsclScriptDir}/lsclTemplateScriptSlurm.sh ${lsclBasicArguments[@]:0:5} ${lsclDiaNumberFrom} ${lsclDiaNumberTo} ${lsclExtraFormScriptArguments}
