#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ -z "${LSCL_SCRIPT_NAME+x}" ]]; then
  echo "lsclTemplateScriptShell: You need to set the environmental variable LSCL_SCRIPT_NAME that specifies the name of the current script."
  exit 1
fi

if [[ -z "${LSCL_RUN_IN_PARALLEL+x}" ]]; then
  if [[ -z "${LSCL_SHELL_SCRIPT_NAME+x}" ]]; then
    echo "lsclTemplateScriptShell: You need to set the environmental variable LSCL_SHELL_SCRIPT_NAME that specifies the name of the SHELL script."
    exit 1
  fi
else
  if [[ -z "${LSCL_SCRIPT_TO_RUN_IN_PARALLEL+x}" ]]; then
    echo "lsclTemplateScriptShell: You need to set the environmental variable LSCL_SCRIPT_TO_RUN_IN_PARALLEL that specifies the name of the script to be run in parallel."
    exit 1
  fi
fi

# the standard entry is the diagram number, but for reduction related
# scripts we work with topologies, not diagrams


if [ ${SLURM_CLUSTER_NAME} ]; then
  echo
  echo "${LSCL_SCRIPT_NAME}: Running on a cluster, the node is ${SLURMD_NODENAME}"
else
  echo
  echo "${LSCL_SCRIPT_NAME}: Running on a local machine, the hostname is $(hostname)"
  export lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  export lsclRepoDir="$(dirname $lsclScriptDir)"
fi

######################################################################
if [ ${SLURM_CLUSTER_NAME} ]; then
  ############### Running on a cluster ###############
  if [[ -z "${LSCL_DIAGRAM_RANGE+x}" ]]; then

    ############### Single diagram ###############
    if [[ $# -lt 4 ]] ; then
      echo "${LSCL_SCRIPT_NAME}: You must specify the project, the process, the model and the number of the loops."
      exit 1
    fi

    # Single diagram via SLURM_ARRAY_TASK_ID
    if [ ${SLURM_ARRAY_TASK_ID} ]; then

      lsclInputVariable=${SLURM_ARRAY_TASK_ID}

      echo "${LSCL_SCRIPT_NAME}: Processing input ${lsclInputVariable}"
    else
    # Single diagram via command line argument

      lsclInputVariable=${5}

      echo "${LSCL_SCRIPT_NAME}: Processing input ${lsclInputVariable}"
    fi

  else
    ############### Range of diagrams using GNU parallel ###############
      # Tasks from a consecutive set of numbers or a file
      if [[ $# -lt 6 ]] ; then
        echo "${LSCL_SCRIPT_NAME}: You must specify the project, the process, the model and the number of the loops and the diagram range."
        exit 1
      fi

      lsclInputVariableFrom=${5}
      lsclInputVariableTo=${6}

      echo "${LSCL_SCRIPT_NAME}: Processing entries from ${lsclInputVariableFrom} to ${lsclInputVariableTo}"
      if [[ ! -z "${LSCL_TASKS_FROM_FILE+x}" ]]; then
        readarray -t lsclTasksAll < ${LSCL_TASKS_FROM_FILE};
        : "$((lsclInputVariableFrom-=1))"
        lsclSliceSize="$((lsclInputVariableTo-lsclInputVariableFrom))"
        lsclTasks=( "${lsclTasksAll[@]:lsclInputVariableFrom:lsclSliceSize}" )
        #echo "All tasks: ${lsclTasks[*]}"
      fi
  fi

else

  ############### Running locally ###############
  if [[ -z "${LSCL_DIAGRAM_RANGE+x}" ]]; then
    ############### Single diagram ###############
    if [[ $# -lt 5 ]] ; then
        echo "${LSCL_SCRIPT_NAME}: You must specify the project, the process, the model, the number of the loops and the diagram number."
        exit 1
    fi

    lsclInputVariable="$5"
    lsclExtraFormScriptArguments="${@:6}"
    echo "${LSCL_SCRIPT_NAME}: Processing entry ${lsclInputVariable}"
  else
    ############### Range of diagrams using GNU parallel ###############


     # Tasks from a consecutive set of numbers or a file
      if [[ $# -lt 6 ]] ; then
        echo "${LSCL_SCRIPT_NAME}: You must specify the project, the process, the model and the number of the loops and the diagram range."
        exit 1
      fi

      lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
      lsclRepoDir="$(dirname $lsclScriptDir)"
      lsclInputVariableFrom=${5}
      lsclInputVariableTo=${6}

      echo "${LSCL_SCRIPT_NAME}: Processing entries from ${lsclInputVariableFrom} to ${lsclInputVariableTo}"
      if [[ ! -z "${LSCL_TASKS_FROM_FILE+x}" ]]; then
        readarray -t lsclTasksAll < ${LSCL_TASKS_FROM_FILE};
        : "$((lsclInputVariableFrom-=1))"
        lsclSliceSize="$((lsclInputVariableTo-lsclInputVariableFrom))"
        lsclTasks=( "${lsclTasksAll[@]:lsclInputVariableFrom:lsclSliceSize}" )
        #echo "All tasks: ${lsclTasks[*]}"
      fi
  fi
fi

######################################################################

if [[ -z "${lsclEnvSourced}" ]]; then
  . "$lsclRepoDir"/environment.sh
fi

if [[ ! -z "${LSCL_RUN_IN_PARALLEL+x}" ]]; then
  if [[ -z "${LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS+x}" ]]; then
    LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS=${lsclNumOfParallelShellJobsDefault}
  fi
  echo "${LSCL_SCRIPT_NAME}: Setting the number of simultaneous GNU parallel jobs for this script to ${LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS}."
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"

if [[ ! -z "${LSCL_PARALLEL_JOBLOG_PATH+x}" ]]; then
  if [[ ! -d ${LSCL_PARALLEL_JOBLOG_PATH}} ]]; then
      mkdir -p ${LSCL_PARALLEL_JOBLOG_PATH};
  fi
fi

if [[ ! -z "${LSCL_CREATE_DIR_IF_NOT_PRESENT_1+x}" ]]; then
 if [[ ! -d ${LSCL_CREATE_DIR_IF_NOT_PRESENT_1}} ]]; then
    mkdir -p ${LSCL_CREATE_DIR_IF_NOT_PRESENT_1};
  fi
fi

if [[ ! -z "${LSCL_CREATE_DIR_IF_NOT_PRESENT_2+x}" ]]; then
 if [[ ! -d ${LSCL_CREATE_DIR_IF_NOT_PRESENT_2}} ]]; then
    mkdir -p ${LSCL_CREATE_DIR_IF_NOT_PRESENT_2};
  fi
fi

if [[ ! -z "${LSCL_CREATE_DIR_IF_NOT_PRESENT_3+x}" ]]; then
 if [[ ! -d ${LSCL_CREATE_DIR_IF_NOT_PRESENT_3}} ]]; then
    mkdir -p ${LSCL_CREATE_DIR_IF_NOT_PRESENT_3};
  fi
fi

cd ${lsclRepoDir}

if [[ -z "${LSCL_DIAGRAM_RANGE+x}" ]]; then
  #Single diagram
  lsclRunScript () {
     ${lsclScriptDir}/${LSCL_SHELL_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} ${lsclInputVariable}
  }
else
  #Range of diagrams
  if [[ -z "${LSCL_RUN_IN_PARALLEL+x}" ]]; then
   # LSCL_RUN_IN_PARALLEL is not set, meaning that the shell script can evaluate multiple diagrams in parallel
    lsclRunScript () {
      ${lsclScriptDir}/${LSCL_SHELL_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} ${lsclInputVariableFrom} ${lsclInputVariableTo}
    }
  else

    # LSCL_RUN_IN_PARALLEL is set, evaluation of multiple diagrams using GNU parallel
    if [ ${SLURM_CLUSTER_NAME} ]; then
      #Running on a cluster

      if [[ -z "${LSCL_TASKS_FROM_FILE+x}" ]]; then
        lsclRunScript () {
           ${lsclParallelPath} --results ${LSCL_PARALLEL_JOBLOG_PATH}/Parallel/{}.log -j ${LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS} --lb --joblog ${LSCL_PARALLEL_JOBLOG_PATH}/joblog.${lsclInputVariableFrom}-${lsclInputVariableTo}.log ${lsclScriptDir}/${LSCL_SCRIPT_TO_RUN_IN_PARALLEL} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} {} ::: $(seq ${lsclInputVariableFrom} ${lsclInputVariableTo})
        }
      else
        lsclRunScript () {
           ${lsclParallelPath} --results ${LSCL_PARALLEL_JOBLOG_PATH}/Parallel/{}.log -j ${LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS} --lb --joblog ${LSCL_PARALLEL_JOBLOG_PATH}/joblog.${lsclInputVariableFrom}-${lsclInputVariableTo}.log ${lsclScriptDir}/${LSCL_SCRIPT_TO_RUN_IN_PARALLEL} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} {} ::: ${lsclTasks[@]}
        }

      fi
    else
      #Running locally
      if [[ -z "${LSCL_TASKS_FROM_FILE+x}" ]]; then
        lsclRunScript () {
           ${lsclParallelPath} --results ${LSCL_PARALLEL_JOBLOG_PATH}/Parallel/{}.log -j ${LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS} --joblog ${LSCL_PARALLEL_JOBLOG_PATH}/joblog.${lsclInputVariableFrom}-${lsclInputVariableTo}.log --lb --eta --bar ${lsclScriptDir}/${LSCL_SCRIPT_TO_RUN_IN_PARALLEL} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} {} ::: $(seq ${lsclInputVariableFrom} ${lsclInputVariableTo})
        }
      else
        lsclRunScript () {
           ${lsclParallelPath} --results ${LSCL_PARALLEL_JOBLOG_PATH}/Parallel/{}.log -j ${LSCL_NUMBER_OF_PARALLEL_SHELL_JOBS} --joblog ${LSCL_PARALLEL_JOBLOG_PATH}/joblog.${lsclInputVariableFrom}-${lsclInputVariableTo}.log --lb --eta --bar ${lsclScriptDir}/${LSCL_SCRIPT_TO_RUN_IN_PARALLEL} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} {} ::: ${lsclTasks[@]}
        }
      fi
    fi
  fi
fi

if [[ ! -z "${LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT+x}" ]]; then

  # Check if the result file is present
  if [ -f "${LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT}" ]; then
      echo "${LSCL_SCRIPT_NAME}: The result file $(basename -- "${LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT}") already exists, skipping this calculation."
  else
      lsclRunScript
  fi

else
  # Always run the script
  lsclRunScript
fi
