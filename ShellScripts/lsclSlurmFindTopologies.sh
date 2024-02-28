#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# Notice that numbers are related to the positions of the entries in the TopologyList.txt file
# ./ShellScripts/lsclSlurmFindTopologies.sh MyProject MyProject MyModel 1 clusterPartitions
# ./ShellScripts/lsclSlurmFindTopologies.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --force
# ./ShellScripts/lsclSlurmFindTopologies.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500
# ./ShellScripts/lsclSlurmFindTopologies.sh MyProject MyProject MyModel 1 clusterPartitions --mem 2500 --clearlogs

# Stop if any of the commands fails
set -e

export LSCL_SLURM_SCRIPT_NAME="lsclSlurmFindTopologies"

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


export LSCL_CLUSTER_SCRIPT_NAME="lsclFindTopologies.sh"
export LSCL_CLUSTER_CORES_PER_JOB=1
export LSCL_CLUSTER_MEM_PER_JOB=2000
export LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES=1
export LSCL_CLUSTER_NUMBER_OF_SLICES=1
export LSCL_CLUSTER_CLEAR_LOGS=0

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"

lsclBasicArguments=()

if [[ -z "${LSCL_FLAG_FORCE+x}" ]]; then
  LSCL_FLAG_FORCE=0
fi

LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES=1

while [[ ${#} -gt 0 ]]; do
  case ${1} in
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

${lsclScriptDir}/lsclTemplateScriptSlurm.sh ${lsclBasicArguments[@]:0:5}
