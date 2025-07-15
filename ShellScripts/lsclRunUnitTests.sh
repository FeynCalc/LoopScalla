#!/bin/bash

# Stop if any of the commands fails
set -e

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi


if [[ -z "${LSCL_PARALLEL_JOBLOG_PATH+x}" ]]; then
  export LSCL_PARALLEL_JOBLOG_PATH="${lsclRepoDir}/Logs/UnitTests"
fi

cd ${lsclRepoDir}

for file in `ls -d -1 ${lsclRepoDir}/Tests/*/tests-*.frm`; do
  echo ""
  echo "Running unit tests from"
  echo "$file"
  echo ""
  ${lsclRepoDir}/ShellScripts/lsclRunForm.sh "$file";
done


#if [ -z "$2" ]
  #then
   # outtxt="Finished running unit tests for LoopScalla."
  #else
    #outtxt="Finished running unit tests for LoopScalla ($2)."
#fi

#notify-send --urgency=low -i "$([ $? = 0 ] && echo sunny || echo error)" "$outtxt"
