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

if [[ ! -z "${LSCL_SET_ULIMIT_TO+x}" ]]; then
	echo "lsclEvaluateWithPySecDec: Setting a max memory limit via ulimit."
	ulimit -v ${LSCL_SET_ULIMIT_TO}
	echo "lsclEvaluateWithPySecDec: Current ulimit values:"
	ulimit -a
fi


cd ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${LSCL_MASTER_INTEGRALS_DIRECTORY}/${lsclIntegralName}

if [[ -z "${LSCL_PYSECDEC_ONLY_POLE_STRUCTURE+x}" ]]; then
  LSCL_PYSECDEC_ONLY_POLE_STRUCTURE=0
fi

echo "lsclEvaluateWithPySecDec: Cluster temporary directory: $TMPDIR"

mkdir -p $TMPDIR/${lsclIntegralName}
echo $pwd
cp -a ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${LSCL_MASTER_INTEGRALS_DIRECTORY}/${lsclIntegralName}/* $TMPDIR/${lsclIntegralName};

cd $TMPDIR/${lsclIntegralName};

echo "lsclEvaluateWithPySecDec: Running generate_int.py"

${lsclPythonPath} generate_int.py & psrecord $! --include-children --interval 5 --log ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${LSCL_MASTER_INTEGRALS_DIRECTORY}/${lsclIntegralName}/memory_generate.txt;

if [[ ${LSCL_PYSECDEC_ONLY_POLE_STRUCTURE} -eq 1 ]] ; then
	echo "lsclEvaluateWithPySecDec: Copying loopint_integral.json back"
	cp $TMPDIR/${lsclIntegralName}/loopint/loopint_integral/disteval/loopint_integral.json ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${LSCL_MASTER_INTEGRALS_DIRECTORY}/${lsclIntegralName}
	echo "lsclEvaluateWithPySecDec: Leaving"
	exit
fi

echo "lsclEvaluateWithPySecDec: Running make"

${lsclMakePath} -j${lsclPySecDecNumThreads} -C loopint & psrecord $! --include-children --interval 5 --log ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${LSCL_MASTER_INTEGRALS_DIRECTORY}/${lsclIntegralName}/memory_make.txt;

echo "lsclEvaluateWithPySecDec: Running integrate_int.py"

${lsclPythonPath} integrate_int.py  & psrecord $! --include-children --interval 5 --log ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${LSCL_MASTER_INTEGRALS_DIRECTORY}/${lsclIntegralName}/memory_integrate.txt;

echo "lsclEvaluateWithPySecDec: Copying the results back"

cp $TMPDIR/${lsclIntegralName}/numres* ${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${LSCL_MASTER_INTEGRALS_DIRECTORY}/${lsclIntegralName};

echo "lsclEvaluateWithPySecDec: Leaving"
