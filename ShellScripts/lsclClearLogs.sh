#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# ./ShellScripts/lsclShowMissing.sh --fromCluster --what OnlyReductions --ProjectProcessModelNLoops MyProject MyProject MyModel 1 --dryrun

# ./ShellScripts/lsclShowMissing.sh --toCluster --what OnlyCode --dryrun


# Stop if any of the commands fails
set -e

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

lsclBasicArguments=()


lsclAllInput=()
lsclProcessedInput=()

lsclClusterProjectDir=${lsclClusterProjectDirDefault}

while [[ ${#} -gt 0 ]]; do
  case ${1} in
    #Extra shell script parameters
    --fromCluster)
      lsclShowMissingDir="from"
      shift
      ;;
    --dryRun)
      lsclDryRun=1
      lsclRsyncOptions="-ivan -ogp --progress"
      shift
      ;;
    --noDelete)
      lsclNoDelete=1
      lsclRsyncOptions="-iva -ogp --progress"
      shift
      ;;
    --toCluster)
      lsclShowMissingDir="to"
      shift
      ;;
    --usingCluster)
      eval "lsclClusterProjectDir=\$${2}"
      shift
      shift
      ;;
    --what)
      lsclShowMissingWhat=${2}
      shift
      shift
      ;;
    --ProjectProcessModelNLoops)
      lsclProjectName=${2}
      lsclProcessName=${3}
      lsclModelName=${4}
      lsclNLoops=${5}
      shift
      shift
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

if [[ ${lsclNoDelete} -eq 1 ]]; then
  :
else
 lsclRsyncOptions="${lsclRsyncOptions} --delete"
fi


if [ -z "$lsclClusterProjectDir" ]; then
  echo "lsclShowMissing: Error: The cluster path is empty."
  exit 1;
fi

if [[ ${lsclShowMissingDir} == "from" ]]; then
  echo "lsclShowMissing: Sync direction: [Cluster ($lsclClusterProjectDir)] -> [Local ($(hostname))]"
elif [[ ${lsclShowMissingDir} == "to" ]]; then
  echo "lsclShowMissing: Sync direction: [Local ($(hostname))] -> [Cluster ($lsclClusterProjectDir)]"
else
  echo "lsclShowMissing: Error: Sync direction unspecified!"
  exit 1;
fi

checkProjectProcessModelNLoops () {
    if [[ -z "${lsclProjectName+x}" ]]; then
      echo "lsclShowMissing: Error: You must specify the project name for this sync mode."
      exit 1
    fi
    if [[ -z "${lsclProcessName+x}" ]]; then
      echo "lsclShowMissing: Error: You must specify the process name for this sync mode."
      exit 1
    fi
    if [[ -z "${lsclModelName+x}" ]]; then
      echo "lsclShowMissing: Error: You must specify the model name for this sync mode."
      exit 1
    fi
    if [[ -z "${lsclNLoops+x}" ]]; then
      echo "lsclShowMissing: Error: You must specify the number of loops for this sync mode."
      exit 1
    fi
}

swapFromTo () {
  if [[ ${lsclShowMissingDir} == "from" ]]; then
    :
  else
    temp=${lsclShowMissingTo}
    lsclShowMissingTo=${lsclShowMissingFrom}
    lsclShowMissingFrom=${temp}
  fi
}

case ${lsclShowMissingWhat} in

  All)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=env-*.sh --exclude=environment.sh --exclude=Logs --exclude=ClusterLogs --exclude=ClusterErrors"
    lsclShowMissingFrom=${lsclClusterProjectDir}/
    lsclShowMissingTo=${lsclRepoDir}/
    swapFromTo
    ;;
    
  OnlyProjects)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=env-*.sh"
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/
    lsclShowMissingTo=${lsclRepoDir}/Projects/
    swapFromTo
    ;;  
    
  OnlyProjectsNoLiteRed)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=env-*.sh --exclude=env-*.tmp --exclude=LR"
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/
    lsclShowMissingTo=${lsclRepoDir}/Projects/
    swapFromTo
    ;;    

  OnlyCode)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=env-*.sh --exclude=environment.sh --exclude=Projects/*/Diagrams --exclude=Projects/*/QGRAF --exclude=Logs --exclude=ClusterLogs --exclude=ClusterErrors --exclude=FeynCalc"
    lsclShowMissingFrom=${lsclClusterProjectDir}/
    lsclShowMissingTo=${lsclRepoDir}/
    swapFromTo
    ;;

  OnlyFeynCalc)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=Examples --exclude=Documentation --exclude=AddOns/FeynHelpers/Documentation --exclude=AddOns/FeynHelpers/Examples --exclude=AddOns/PHI --exclude=AddOns/PrivateCalc"
    lsclRsyncOptions="${lsclRsyncOptions} -L"
    lsclShowMissingFrom=${lsclClusterProjectDir}/FeynCalc/
    lsclShowMissingTo=${lsclRepoDir}/FeynCalc/
    swapFromTo
    ;;

  OnlyQGRAF)
    lsclExclude=""
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/QGRAF/
    lsclShowMissingTo=${lsclClusterProjectDir}/Projects/${lsclProjectName}/QGRAF/
    swapFromTo
    ;;

  OnlyFinalResults)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Results/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Results/
    swapFromTo
    ;;

  OnlyInput)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/
    swapFromTo
    ;;

  OnlyIntegrals)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/LoopIntegrals/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/LoopIntegrals/
    swapFromTo
    ;;
    
  OnlyMasterIntegrals)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=loopint --exclude=memory*.txt"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/
    swapFromTo
    ;;  

  OnlyReductions)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp --exclude=memory.txt"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/
    swapFromTo
    ;;
    
  OnlyReductionsNoLiteRed)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp --exclude=memory.txt --exclude=LR" 
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/
    swapFromTo
    ;;  

  OnlyTopologies)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Topologies/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Topologies/
    swapFromTo
    ;;

  OnlyExtractedTopologies)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/ExtractedTopologies/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/ExtractedTopologies/
    swapFromTo
    ;;

  OnlyPySecDec)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=environment.sh --exclude=ClusterLogs --exclude=ClusterErrors --exclude=loopint"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/
    swapFromTo
    ;;

  OnlyResultsStage0)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage0/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage0/
    swapFromTo
    ;;

  OnlyResultsStage1)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage1/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage1/
    swapFromTo
    ;;

  OnlyResultsStage2)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclShowMissingFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage2/
    lsclShowMissingTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Output/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage2/
    swapFromTo
    ;;

  OnlyClusterLogs)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    lsclShowMissingFrom=${lsclClusterProjectDir}/ClusterLogs/
    lsclShowMissingTo=${lsclRepoDir}/ClusterLogs/
    swapFromTo
    ;;

  *)
    echo "lsclShowMissing: Error: Unknown sync mode!"
    exit 1;
    ;;
esac

if [[ ${lsclDryRun} -eq "1" ]]; then
  echo "lsclShowMissing: Dry run mode (no changes!)."
fi

echo "lsclShowMissing: Source: ${lsclShowMissingFrom}"
echo "lsclShowMissing: Destination: ${lsclShowMissingTo}"

echo "lsclShowMissing: Options: ${lsclRsyncOptions}"

read -p "Sure? " -n 1 -r
echo

if [[ $REPLY = "y" ]] || [[ $REPLY = "j" ]]; then
  rsync ${lsclRsyncOptions} ${lsclExclude} ${lsclShowMissingFrom} ${lsclShowMissingTo}
else
  echo "lsclShowMissing: Sync aborted."
fi




