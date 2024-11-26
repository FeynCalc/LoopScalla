#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

################################################################################
# Stop if any of the commands fails
set -e

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"

# We need to source the env variables again, since some of them are defined
# differently on cluster nodes!
. "$lsclRepoDir"/environment.sh

################################################################################

export FORMPATH=${lsclModules};
#export lsclTformTmpDir="$TMP";
echo lsclRunForm: FORM\'s TempDir is: ${lsclTformTmpDir}
echo
if [ -z ${lsclTformTmpDir} ]; then
    echo lsclRunForm: The directory for FORM\'s temporary files does not exist!
    echo lsclRunForm: Setting it to /tmp
    lsclTformTmpDir="/tmp"
    #exit 1;
fi

if [[ -z "${LSCL_SLURM_LOG_DIR+x}" ]]; then
    lsclPsRecordLogPath=${LSCL_PARALLEL_JOBLOG_PATH}/MemoryUsage
else
    lsclPsRecordLogPath=${LSCL_SLURM_LOG_DIR}/MemoryUsage
fi

if [[ ! -d ${lsclPsRecordLogPath}} ]]; then
      mkdir -p ${lsclPsRecordLogPath};
fi

echo lsclRunForm: Log for psrecord: ${lsclPsRecordLogPath}

if [[ -z "${LSCL_SLURM_LOG_DIR+x}" ]]; then
    time -p ${lsclTformPath} -M -q -Z -t ${lsclTformTmpDir} -w${lsclTformNumWorkers} $*;
else
    time -p ${lsclTformPath} -M -q -Z -t ${lsclTformTmpDir} -w${lsclTformNumWorkers} $* & psrecord $! --include-children --interval 5 --log ${lsclPsRecordLogPath}/${LSCL_FORM_SCRIPT_INPUT_ID}.txt;
fi

