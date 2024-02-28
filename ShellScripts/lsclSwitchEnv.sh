#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

if [[ $# -ne 1 ]] ; then
    echo 'You must specify the name of the environment file to link to'
    exit 0
fi

################################################################################
# Stop if any of the commands fails
set -e

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"

################################################################################

cd "$tfmRepoDir"
rm -rf environment.sh;
ln -s $1 environment.sh;
echo environment.sh is now linked to:
ls -al environment.sh
