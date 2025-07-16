#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# ./ShellScripts/lsclSync.sh --fromCluster --what OnlyReductions --ProjectProcessModelNLoops MyProject MyProject MyModel 1 --dryrun

# ./ShellScripts/lsclSync.sh --toCluster --what OnlyCode --dryrun


# Stop if any of the commands fails
set -e

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

lsclBasicArguments=()


lsclRsyncOptions="-iva -ogp --progress"
lsclDryRun=0
lsclNoDelete=0
lsclClusterProjectDir=${lsclClusterProjectDirDefault}
lsclSure=0
lsclSpecificDir="/"

while [[ ${#} -gt 0 ]]; do
  case ${1} in
    #Extra shell script parameters
    --fromCluster)
      lsclSyncDir="from"
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
    --IamSure)
      lsclSure=1      
      shift
      ;;  
    --toCluster)
      lsclSyncDir="to"
      shift
      ;;
    --usingCluster)
      eval "lsclClusterProjectDir=\$${2}"
      shift
      shift
      ;;
    --what)
      lsclSyncWhat=${2}
      shift
      shift
      ;;
    --diaNumber)
      lsclDiaNumber=${2}
      shift
      shift
      ;;
    --specificDirectory)
      lsclSpecificDir=${2}
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
  echo "lsclSync: Error: The cluster path is empty."
  exit 1;
fi

if [[ ${lsclSyncDir} == "from" ]]; then
  echo "lsclSync: Sync direction: [Cluster ($lsclClusterProjectDir)] -> [Local ($(hostname))]"
elif [[ ${lsclSyncDir} == "to" ]]; then
  echo "lsclSync: Sync direction: [Local ($(hostname))] -> [Cluster ($lsclClusterProjectDir)]"
else
  echo "lsclSync: Error: Sync direction unspecified!"
  exit 1;
fi

checkProjectProcessModelNLoops () {
    if [[ -z "${lsclProjectName+x}" ]]; then
      echo "lsclSync: Error: You must specify the project name for this sync mode."
      exit 1
    fi
    if [[ -z "${lsclProcessName+x}" ]]; then
      echo "lsclSync: Error: You must specify the process name for this sync mode."
      exit 1
    fi
    if [[ -z "${lsclModelName+x}" ]]; then
      echo "lsclSync: Error: You must specify the model name for this sync mode."
      exit 1
    fi
    if [[ -z "${lsclNLoops+x}" ]]; then
      echo "lsclSync: Error: You must specify the number of loops for this sync mode."
      exit 1
    fi
}

swapFromTo () {
  if [[ ${lsclSyncDir} == "from" ]]; then
    :
  else
    temp=${lsclSyncTo}
    lsclSyncTo=${lsclSyncFrom}
    lsclSyncFrom=${temp}
  fi
}

case ${lsclSyncWhat} in

  All)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=env-*.sh --exclude=environment.sh --exclude=Logs --exclude=ClusterLogs --exclude=ClusterErrors"
    lsclSyncFrom=${lsclClusterProjectDir}/
    lsclSyncTo=${lsclRepoDir}/
    swapFromTo
    ;;
    
  OnlyProjects)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=env-*.sh"
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/
    lsclSyncTo=${lsclRepoDir}/Projects/
    swapFromTo
    ;;  

  OnlyProjectsNoLiteRed)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=env-*.sh --exclude=env-*.tmp --exclude=LR"
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/
    lsclSyncTo=${lsclRepoDir}/Projects/
    swapFromTo
    ;;    

  OnlyCode)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=loopint --exclude=.git --exclude=env-*.sh --exclude=environment.sh --exclude=Projects/*/Diagrams --exclude=Projects/*/QGRAF --exclude=Logs --exclude=ClusterLogs --exclude=ClusterErrors --exclude=FeynCalc"
    lsclSyncFrom=${lsclClusterProjectDir}/
    lsclSyncTo=${lsclRepoDir}/
    swapFromTo
    ;;

  OnlyFeynCalc)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=Examples --exclude=Documentation --exclude=AddOns/FeynHelpers/Documentation --exclude=AddOns/FeynHelpers/Examples --exclude=AddOns/PHI --exclude=AddOns/PrivateCalc"
    lsclRsyncOptions="${lsclRsyncOptions} -L"
    lsclSyncFrom=${lsclClusterProjectDir}/FeynCalc/
    lsclSyncTo=${lsclRepoDir}/FeynCalc/
    swapFromTo
    ;;

  OnlyQGRAF)
    lsclExclude=""
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/QGRAF/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/QGRAF/
    swapFromTo
    ;;
    
  OnlyDiagramsInput)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/
    swapFromTo
    ;;  

  OnlyFinalResults)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Results/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Results/
    swapFromTo
    ;;

  OnlyInput)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/Input/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/
    swapFromTo
    ;;

  OnlyIntegrals)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/LoopIntegrals/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/LoopIntegrals/
    swapFromTo
    ;;
    
  OnlyMasterIntegrals)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=loopint --exclude=memory*.txt"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${lsclSpecificDir}/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/${lsclSpecificDir}/
    swapFromTo
    ;;  

  OnlyReductions)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp --exclude=memory.txt"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/
    swapFromTo
    ;;

    OnlyDiagramTopology)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp --exclude=memory.txt"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/DiagramTopology/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/DiagramTopology/
    swapFromTo
    ;;  
    
  OnlyReductionsNoLiteRed)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp --exclude=memory.txt --exclude=LR" 
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Reductions/
    swapFromTo
    ;;  

  OnlyTopologies)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Topologies/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Topologies/
    swapFromTo
    ;;

  OnlyExtractedTopologies)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git --exclude=temp"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/ExtractedTopologies/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/ExtractedTopologies/
    swapFromTo
    ;;

  OnlyPySecDec)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=environment.sh --exclude=ClusterLogs --exclude=ClusterErrors --exclude=loopint"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/MasterIntegrals/pySecDec/
    swapFromTo
    ;;

  OnlyResultsStage0)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage0/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage0/
    swapFromTo
    ;;

  OnlyResultsStage1)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage1/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage1/
    swapFromTo
    ;;

  OnlyResultsSplitStage1)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    if [ -z "$lsclDiaNumber" ]; then
      lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage1/
      lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage1/
    else 
      lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage1/${lsclDiaNumber}/
      lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage1/${lsclDiaNumber}/
    fi    
    swapFromTo
    ;;  

  OnlyResultsStage2)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage2/
    lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/Stage2/
    swapFromTo
    ;;

  OnlyResultsSplitStage2)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    checkProjectProcessModelNLoops
    if [ -z "$lsclDiaNumber" ]; then
      lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage2/
      lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage2/
    else 
      lsclSyncFrom=${lsclClusterProjectDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage2/${lsclDiaNumber}/
      lsclSyncTo=${lsclRepoDir}/Projects/${lsclProjectName}/Diagrams/${lsclProcessName}/${lsclModelName}/${lsclNLoops}/SplitStage2/${lsclDiaNumber}/
    fi
    swapFromTo
    ;;  

  OnlyClusterLogs)
    lsclExclude="--exclude={*.tmp,*.str,*.log} --exclude=.git"
    lsclSyncFrom=${lsclClusterProjectDir}/ClusterLogs/
    lsclSyncTo=${lsclRepoDir}/ClusterLogs/
    swapFromTo
    ;;

  *)
    echo "lsclSync: Error: Unknown sync mode!"
    exit 1;
    ;;
esac

if [[ ${lsclDryRun} -eq "1" ]]; then
  echo "lsclSync: Dry run mode (no changes!)."
fi

echo "lsclSync: Source: ${lsclSyncFrom}"
echo "lsclSync: Destination: ${lsclSyncTo}"

echo "lsclSync: Options: ${lsclRsyncOptions}"

if [[ ${lsclSure} -eq "0" ]]; then
  read -p "Sure? " -n 1 -r
  echo

  if [[ $REPLY = "y" ]] || [[ $REPLY = "j" ]]; then
    rsync ${lsclRsyncOptions} ${lsclExclude} ${lsclSyncFrom} ${lsclSyncTo}
  else
    echo "lsclSync: Sync aborted."
  fi
else
  rsync ${lsclRsyncOptions} ${lsclExclude} ${lsclSyncFrom} ${lsclSyncTo}
fi





