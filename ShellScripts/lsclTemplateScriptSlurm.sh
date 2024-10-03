#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ -z "${LSCL_SLURM_SCRIPT_NAME+x}" ]]; then
  echo "lsclTemplateScriptSlurm: You need to set the environmental variable LSCL_SLURM_SCRIPT_NAME that specifies the name of the current script."
  exit 1
fi


if [[ -z "${LSCL_CLUSTER_SCRIPT_NAME+x}" ]]; then
  echo "lsclTemplateScriptSlurm: You need to set the environmental variable LSCL_CLUSTER_SCRIPT_NAME that specifies the name of the script to run on the cluster."
  exit 1
fi

if [[ -z "${LSCL_CLUSTER_CORES_PER_JOB+x}" ]]; then
  echo "lsclTemplateScriptSlurm: You need to set the environmental variable LSCL_CLUSTER_CORES_PER_JOB that specifies the name of cores per job."
  exit 1
fi


if [[ -z "${LSCL_CLUSTER_REQUESTED_TIME+x}" ]]; then
  lsclTimeOption=""
else
  lsclTimeOption="--time ${LSCL_CLUSTER_REQUESTED_TIME}"
fi

if [[ ${lsclSlurmExclusiveNodes} -eq 1 ]] ; then
  if [[ -z "${LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES+x}" ]]; then
    echo "lsclTemplateScriptSlurm: You need to set the environmental variable LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES that specifies the number of nodes requested for  your jobs."
    exit 1
  fi
fi

if [[ $# -lt 5 ]] ; then
      echo "${LSCL_SLURM_SCRIPT_NAME}: You must specify the project, the process, the model, the number of the loops and the partition."
      exit 1
fi

if [[ -z "${lsclEnvSourced}" ]]; then
  . "$lsclRepoDir"/environment.sh
fi

if [[ $(readlink -f environment.sh) != $(readlink -f env-cluster.sh) ]] ; then
  echo "${LSCL_SLURM_SCRIPT_NAME}: Submission aborted! environment.sh is not linked to env-cluster.sh! Use lsclSwitchEnv.sh"
  #exit 1
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclSlurmPartition="$5"


if [[ -z "${LSCL_SLURM_JOB_NAME+x}" ]]; then
  LSCL_SLURM_JOB_NAME=${LSCL_SLURM_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}
fi

if [[ -z "${LSCL_SLURM_LOG_DIR+x}" ]]; then
  LSCL_SLURM_LOG_DIR=${lsclRepoDir}/ClusterLogs/${LSCL_SLURM_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}
fi

echo
echo
echo "======================================================================"
echo "${LSCL_SLURM_SCRIPT_NAME}: Submitting jobs to the cluster."

if [[ -z "${LSCL_DIAGRAM_RANGE+x}" ]]; then
  # Single diagram
  lsclExtraFormScriptArguments=${@:6}
  rm -rf ${LSCL_SLURM_LOG_DIR};
else

  if [[ -z "${LSCL_TASKS_FROM_FILE+x}" ]]; then
    #Tasks from a consecutive set of numbers
    lsclDiaNumberFrom=${6}
    lsclDiaNumberTo=${7}
    lsclExtraFormScriptArguments=${@:8}
    lsclAllDiagrams=($(seq ${lsclDiaNumberFrom} ${lsclDiaNumberTo}))
    export LSCL_PARALLEL_JOBLOG_PATH=${LSCL_SLURM_LOG_DIR}

    if [[ ${LSCL_CLUSTER_CLEAR_LOGS} -eq 1 ]] ; then
      echo "${LSCL_SLURM_SCRIPT_NAME}: Removing all logs."
      rm -rf ${LSCL_SLURM_LOG_DIR};
    else
      echo "${LSCL_SLURM_SCRIPT_NAME}: Removing only relevant logs."
      for((i=0; i < ${#lsclAllDiagrams[@]}; i+=1)); do
        rm -rf ${LSCL_SLURM_LOG_DIR}/${lsclAllDiagrams[$i]}.log
      done
    fi
  else
    #Tasks from a file
    lsclDiaNumberFrom=${6}
    lsclDiaNumberTo=${7}
    lsclExtraFormScriptArguments=${@:8}
    readarray -t lsclTasksAll < ${LSCL_TASKS_FROM_FILE};
    lsclSliceSize="$((lsclDiaNumberTo-(lsclDiaNumberFrom-1)))"
    # lsclTasks contains names of relevant tasks extracted from ${LSCL_TASKS_FROM_FILE}
    lsclTasks=( "${lsclTasksAll[@]:$((lsclDiaNumberFrom-1)):lsclSliceSize}" )
    lsclAllDiagrams=($(seq $((lsclDiaNumberFrom)) $((lsclDiaNumberTo)) ))
    export LSCL_PARALLEL_JOBLOG_PATH=${LSCL_SLURM_LOG_DIR}

    if [[ ${LSCL_CLUSTER_CLEAR_LOGS} -eq 1 ]] ; then
      echo "${LSCL_SLURM_SCRIPT_NAME}: Removing all logs."
      rm -rf ${LSCL_SLURM_LOG_DIR};
    else
      echo "${LSCL_SLURM_SCRIPT_NAME}: Removing only relevant logs."
      for((i=0; i < ${#lsclTasks[@]}; i+=1)); do
        rm -rf ${LSCL_SLURM_LOG_DIR}/${lsclTasks[$i]}.log
      done
    fi
  fi
fi


if [[ ! -e ${LSCL_SLURM_LOG_DIR} ]]; then
    mkdir -p ${LSCL_SLURM_LOG_DIR};
fi

if [[ ! -e ${LSCL_SLURM_LOG_DIR}/Parallel ]]; then
    mkdir -p ${LSCL_SLURM_LOG_DIR}/Parallel;
fi




if [[ ${LSCL_FLAG_FORCE} -eq 1 ]] ; then
echo "${LSCL_SLURM_SCRIPT_NAME}: Forcing reevaluation of already computed diagrams."
fi

echo "${LSCL_SLURM_SCRIPT_NAME}: Requested cluster partitions: ${lsclSlurmPartition}."
echo "${LSCL_SLURM_SCRIPT_NAME}: Requested number of cores per job: ${LSCL_CLUSTER_CORES_PER_JOB}."
echo "${LSCL_SLURM_SCRIPT_NAME}: Requested memory per job: ${LSCL_CLUSTER_MEM_PER_JOB} MB."
echo "${LSCL_SLURM_SCRIPT_NAME}: Project: ${lsclProjectName}."
echo "${LSCL_SLURM_SCRIPT_NAME}: Process: ${lsclProcessName} (${lsclModelName}) at ${lsclNLoops} loops."
echo "${LSCL_SLURM_SCRIPT_NAME}: Logs: ${LSCL_SLURM_LOG_DIR}"

if [[ ! -z "${LSCL_DIAGRAM_RANGE+x}" ]]; then
  if [[ -z "${LSCL_TASKS_FROM_FILE+x}" ]]; then
  echo "${LSCL_SLURM_SCRIPT_NAME}: Range of diagrams: ${lsclDiaNumberFrom} - ${lsclDiaNumberTo}."
  else
  echo "${LSCL_SLURM_SCRIPT_NAME}: Tasks from: ${LSCL_TASKS_FROM_FILE}"
  fi
fi

cd ${lsclScriptDir}

if [[ ${lsclSlurmExclusiveNodes} -eq 1 ]] ; then
  # Jobs running on exclusively reserved nodes where on each node we run GNU parallel
  echo "${LSCL_SLURM_SCRIPT_NAME}: Requested number of nodes: ${LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES}."
  echo

  if [[ -z "${LSCL_DIAGRAM_RANGE+x}" ]]; then

    echo "${LSCL_SLURM_SCRIPT_NAME}: Mode: Single job."
    echo
    sbatch --exclusive ${lsclTimeOption} -N${LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES} -p ${lsclSlurmPartition} --exclude=${lsclExcludeNodes} --mem=${LSCL_CLUSTER_MEM_PER_JOB} --export=ALL --job-name=${LSCL_SLURM_JOB_NAME} -o ${LSCL_SLURM_LOG_DIR}/output.log ./${LSCL_CLUSTER_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} ${lsclExtraFormScriptArguments}

  else
    # Multiple jobs
    if [[ -z "${LSCL_RUN_IN_PARALLEL+x}" ]]; then
      echo "${LSCL_SLURM_SCRIPT_NAME}: Mode: Multiple tasks submitted to a single script."
      # LSCL_RUN_IN_PARALLEL is not set, meaning that the shell script can evaluate multiple diagrams in parallel
      sbatch --exclusive ${lsclTimeOption} -N${LSCL_CLUSTER_NUMBER_OF_REQUESTED_NODES} -p ${lsclSlurmPartition} --exclude=${lsclExcludeNodes} --mem=${LSCL_CLUSTER_MEM_PER_JOB} --export=ALL --job-name=${LSCL_SLURM_JOB_NAME}.${lsclDiaNumberFrom}-${lsclDiaNumberTo} -o ${LSCL_SLURM_LOG_DIR}/output.log ./${LSCL_CLUSTER_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} --fromto ${lsclDiaNumberFrom} ${lsclDiaNumberTo} ${lsclExtraFormScriptArguments}
    else
      # LSCL_RUN_IN_PARALLEL is set, evaluation of multiple diagrams using GNU parallel
      echo "${LSCL_SLURM_SCRIPT_NAME}: Slices per node: ${LSCL_CLUSTER_NUMBER_OF_SLICES}."
      echo

      echo "${LSCL_SLURM_SCRIPT_NAME}: Mode: Jobs from a consecutive set of numbers or a file."
      echo
      # All tasks are split into slices of the given size and each of those slices is packed into a separate cluster job
      # to be processed using GNU parallel
      for((i=0; i < ${#lsclAllDiagrams[@]}; i+=LSCL_CLUSTER_NUMBER_OF_SLICES)); do
        lsclTempArray=( "${lsclAllDiagrams[@]:i:LSCL_CLUSTER_NUMBER_OF_SLICES}" )
        echo "${LSCL_SLURM_SCRIPT_NAME}: Submitting diagrams/tasks from ${lsclTempArray[0]} to ${lsclTempArray[-1]}"
        echo
        rm -rf ${LSCL_SLURM_LOG_DIR}/${lsclTempArray[0]}-${lsclTempArray[-1]}.log
        sbatch ${lsclTimeOption} -c ${LSCL_CLUSTER_CORES_PER_JOB} -p ${lsclSlurmPartition} --exclude=${lsclExcludeNodes} --mem=${LSCL_CLUSTER_MEM_PER_JOB} --export=ALL --job-name=${LSCL_SLURM_JOB_NAME}.${lsclTempArray[0]}-${lsclTempArray[-1]} -o ${LSCL_SLURM_LOG_DIR}/${lsclTempArray[0]}-${lsclTempArray[-1]}.log  ./${LSCL_CLUSTER_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} --fromto ${lsclTempArray[0]} ${lsclTempArray[-1]} ${lsclExtraFormScriptArguments}
      done
    fi
  fi
else
  # Jobs running on all availalbe slots
  echo "${LSCL_SLURM_SCRIPT_NAME}: Submitted jobs will be distributed on all available nodes."
  echo

  if [[ -z "${LSCL_DIAGRAM_RANGE+x}" ]]; then

    echo "${LSCL_SLURM_SCRIPT_NAME}: Mode: Single job."
    echo
    sbatch ${lsclTimeOption} -c ${LSCL_CLUSTER_CORES_PER_JOB} -p ${lsclSlurmPartition} --exclude=${lsclExcludeNodes} --mem=${LSCL_CLUSTER_MEM_PER_JOB} --export=ALL --job-name=${LSCL_SLURM_JOB_NAME} -o ${LSCL_SLURM_LOG_DIR}/output.log ./${LSCL_CLUSTER_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops}
  else
    if [[ -z "${LSCL_RUN_IN_PARALLEL+x}" ]]; then
      echo "${LSCL_SLURM_SCRIPT_NAME}: The script will evaluate multiple jobs in parallel."
      # LSCL_RUN_IN_PARALLEL is not set, meaning that the shell script can evaluate multiple diagrams in parallel
      sbatch ${lsclTimeOption} -c ${LSCL_CLUSTER_CORES_PER_JOB} -p ${lsclSlurmPartition} --exclude=${lsclExcludeNodes} --mem=${LSCL_CLUSTER_MEM_PER_JOB} --export=ALL --job-name=${LSCL_SLURM_JOB_NAME}.${lsclDiaNumberFrom}-${lsclDiaNumberTo}  -o ${LSCL_SLURM_LOG_DIR}/output.${lsclDiaNumberFrom}-${lsclDiaNumberTo}.log ./${LSCL_CLUSTER_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} --fromto ${lsclDiaNumberFrom} ${lsclDiaNumberTo} ${lsclExtraFormScriptArguments}
    else
      # LSCL_RUN_IN_PARALLEL is set, evaluation of multiple diagrams using sbatch
      echo "${LSCL_SLURM_SCRIPT_NAME}: Mode: Jobs from a consecutive set of numbers or a file."
      echo
      if [[ -z "${LSCL_TASKS_FROM_FILE+x}" ]]; then
        #Tasks from a consecutive set of numbers
        if [[ ${lsclDiaNumberFrom} -eq ${lsclDiaNumberTo} ]]; then
                echo "${LSCL_SLURM_SCRIPT_NAME}: Log:" ${LSCL_SLURM_LOG_DIR}/${lsclDiaNumberFrom}.log
        fi
        sbatch ${lsclTimeOption} -c ${LSCL_CLUSTER_CORES_PER_JOB} -p ${lsclSlurmPartition} --exclude=${lsclExcludeNodes} --mem=${LSCL_CLUSTER_MEM_PER_JOB} --export=ALL --job-name=${LSCL_SLURM_JOB_NAME} -o ${LSCL_SLURM_LOG_DIR}/%a.log --array=${lsclDiaNumberFrom}-${lsclDiaNumberTo} ./${LSCL_CLUSTER_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} ${lsclExtraFormScriptArguments}
      else
        #Tasks from a file
        for((i=0; i < ${#lsclTasks[@]}; i+=1)); do
          echo "${LSCL_SLURM_SCRIPT_NAME}: Submitting job for ${lsclTasks[$i]}."
          if [[ ${#lsclTasks[@]} -le 10 ]] ; then
            echo "${LSCL_SLURM_SCRIPT_NAME}: Log:" ${LSCL_SLURM_LOG_DIR}/${lsclTasks[$i]}.log
          fi
          sbatch ${lsclTimeOption} -c ${LSCL_CLUSTER_CORES_PER_JOB} -p ${lsclSlurmPartition} --exclude=${lsclExcludeNodes} --mem=${LSCL_CLUSTER_MEM_PER_JOB} --export=ALL --job-name=${LSCL_SLURM_JOB_NAME}.${lsclTasks[$i]} -o ${LSCL_SLURM_LOG_DIR}/${lsclTasks[$i]}.log ./${LSCL_CLUSTER_SCRIPT_NAME} ${lsclProjectName} ${lsclProcessName} ${lsclModelName} ${lsclNLoops} ${lsclTasks[$i]} ${lsclExtraFormScriptArguments}
        done
      fi
    fi
  fi
fi

echo
echo "${LSCL_SLURM_SCRIPT_NAME}: All jobs sumitted."
echo "======================================================================"
echo
echo
