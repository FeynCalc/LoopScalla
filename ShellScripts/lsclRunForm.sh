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
# echo "$*"
time -p ${lsclTformPath} -M -q -Z -t ${lsclTformTmpDir} -w${lsclTformNumWorkers} $*
