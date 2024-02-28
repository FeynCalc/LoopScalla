#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

if [[ $# -lt 2 ]] ; then
    echo 'You must specify the path to the integrals and the partition!'
    exit 0
fi

################################################################################
# Stop if any of the commands fails
set -e

export lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
export lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

################################################################################

lsclIntegralsDir=${1}
lsclSlurmPartition=${2}

if [ ${3} ]; then
    echo "Setting the minimal required amount of memory to ${3} MB"
    lsclMinMem=${3}
else
    echo "Setting the minimal required amount of memory to 2000 MB"
    lsclMinMem=2000
fi


if [[ $(readlink -f environment.sh) != $(readlink -f env-cluster.sh) ]] ; then
echo Cannot submit to the grid! environment.sh is not linked to env-cluster.sh! Use lsclSwitchEnv.sh
  exit 0
fi

echo
echo
echo "=========================================================="
echo "lsclSlurmFindTopologies: Submitting the job(s) to the cluster (${lsclSlurmPartition}) using ${lsclTformNumWorkers} nodes."
echo "=========================================================="
echo
echo



cd ${lsclScriptDir}

readarray -d '' lsclPySecDecDirs < <(find ${lsclIntegralsDir} -maxdepth 1 -mindepth 1 -type d -name "*" -print0);

for i in "${lsclPySecDecDirs[@]}"; do

  lsclIntName=$(basename ${i})  
  echo "Submitting integrate jobs for ${lsclIntName}"


  rm -rf ${lsclRepoDir}/ClusterLogs/lsclPySecDecIntegrate.${lsclIntName};
  mkdir -p ${lsclRepoDir}/ClusterLogs/lsclPySecDecIntegrate.${lsclIntName};

  sbatch -c ${lsclPySecDecNumThreads} -p ${lsclSlurmPartition} --exclude=${lsclExcludeNodes} --mem=${lsclMinMem} --export=ALL --job-name=lsclPySecDecIntegrate.${lsclIntName} -o ${lsclRepoDir}/ClusterLogs/lsclPySecDecIntegrate.${lsclIntName}/%a.log ./lsclPySecDecIntegrate.sh ${i}
done;

echo
echo
echo "=========================================================="
echo "Job(s) sumitted."
echo "=========================================================="
echo
echo
