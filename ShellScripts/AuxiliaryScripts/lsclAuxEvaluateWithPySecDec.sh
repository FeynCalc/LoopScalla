#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -lt 1 ]] ; then
      echo 'lsclEvaluateWithPySecDec: You must specify the path.'
      exit 0
fi

lsclProjectName="$1"
lsclProcessName="$2"
lsclModelName="$3"
lsclNLoops="$4"
lsclIntegralName="$5"


if [ ${SLURM_JOB_ID} ]; then
  echo "lsclEvaluateWithPySecDec: Running on a cluster."
else
  echo "lsclEvaluateWithPySecDec: Running on a local machine"
  lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
  lsclRepoDir="$(dirname $lsclScriptDir)"
  lsclRepoDir="$(dirname $lsclRepoDir)"
  TMPDIR=/tmp
fi

cd ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/${lsclIntegralName}



echo "lsclEvaluateWithPySecDec: Cluster temporary directory: $TMPDIR"

mkdir -p $TMPDIR/${lsclIntegralName}
echo $pwd
cp -a ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/${lsclIntegralName}/* $TMPDIR/${lsclIntegralName};

cd $TMPDIR/${lsclIntegralName};

echo "lsclEvaluateWithPySecDec: Running generate_int.py"

${lsclPythonPath} generate_int.py & psrecord $! --include-children --interval 5 --log ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/${lsclIntegralName}/memory_generate.txt;

echo "lsclEvaluateWithPySecDec: Running make"

${lsclMakePath} -j${lsclPySecDecNumThreads} -C loopint & psrecord $! --include-children --interval 5 --log ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/${lsclIntegralName}/memory_make.txt;

echo "lsclEvaluateWithPySecDec: Running integrate_int.py"

${lsclPythonPath} integrate_int.py  & psrecord $! --include-children --interval 5 --log ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/${lsclIntegralName}/memory_integrate.txt;

echo "lsclEvaluateWithPySecDec: Copying the results back"

cp $TMPDIR/${lsclIntegralName}/numres* ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/${lsclIntegralName};

echo "lsclEvaluateWithPySecDec: Leaving"
