#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# Notice that numbers are related to the positions of the entries in the TopologyList.txt file
# ./ShellScripts/lsclFireRunReduction.sh MyProject MyProject MyModel 3 topology1
# ./ShellScripts/lsclFireRunReduction.sh MyProject MyProject MyModel 3 topology1 --force
# ./ShellScripts/lsclFireRunReduction.sh MyProject MyProject MyModel 3 --fromto 1 2
# ./ShellScripts/lsclFireRunReduction.sh MyProject MyProject MyModel 3 --fromto 1 all --force

# Stop if any of the commands fails
set -e

export LSCL_SCRIPT_NAME="lsclFireRunReduction"
export LSCL_SHELL_SCRIPT_NAME="AuxiliaryScripts/lsclAuxFireRunReduction.sh"

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


if [[ -z "${LSCL_PARALLEL_JOBLOG_PATH+x}" ]]; then
  export LSCL_PARALLEL_JOBLOG_PATH="${lsclRepoDir}/Logs/${LSCL_SCRIPT_NAME}.${lsclProjectName}.${lsclProcessName}.${lsclModelName}.${lsclNLoops}"
fi

lsclOptFromTo=0

while [[ ${#} -gt 0 ]]; do
  case ${1} in
	#Extra config suffix
    --configsuffix)
      export LSCL_CONFIG_SUFFIX=${2}
      echo "$LSCL_SLURM_SCRIPT_NAME}: Suffix for FIRE config files: ${LSCL_CONFIG_SUFFIX}"
      shift
      ;;  
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

# Check if the precondition is met
if [ ! -f "${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/${lsclTopologyName}/${lsclTopologyName}${LSCL_CONFIG_SUFFIX}.config" ]; then
	echo "${LSCL_SCRIPT_NAME}: The config file ${lsclTopologyName}${LSCL_CONFIG_SUFFIX}.config is missing, aborting the calculation."
	exit 1;
fi



if [[ ${LSCL_FLAG_FORCE} -eq 0 ]] && [[ ${lsclOptFromTo} -ne 1 ]]; then
      export LSCL_RUN_ONLY_IF_RESULT_FILE_NOT_PRESENT="${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/${lsclTopologyName}/${lsclTopologyName}.tables"
fi



if [[ ${lsclOptFromTo} -eq 1 ]] ; then
    # Process multiple diagrams in parallel

    export LSCL_SCRIPT_TO_RUN_IN_PARALLEL="lsclFireRunReduction.sh"
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
