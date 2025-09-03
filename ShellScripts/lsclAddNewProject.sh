#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Examples:
# /ShellScripts/lsclAddNewProject.sh MyProject MyProject MyModel 3 1
# /ShellScripts/lsclAddNewProject.sh MyProject MyProject MyModel 3 1 --force
# /ShellScripts/lsclAddNewProject.sh MyProject MyProject MyModel 3 --fromto 1 10
# /ShellScripts/lsclAddNewProject.sh MyProject MyProject MyModel 3 --fromto 1 all --force

# Stop if any of the commands fails
set -e


export LSCL_SCRIPT_NAME="lsclAddNewProject"

if [[ $# -lt 3 ]] ; then
    echo "${LSCL_SCRIPT_NAME}: You must specify the project, the process name and the model!"    
    exit 0
fi

lsclProjectName="$1"
lsclModelName="$2"
lsclProcessName="$3"


lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"
lsclFullProjectName=${lsclRepoDir}/Projects/${lsclProjectName}

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

lsclBasicArguments=()
lsclIncomingParticles=""
lsclOutgoingParticles=""

while [[ ${#} -gt 0 ]]; do
  case ${1} in
    #Number of requested GNU parallel jobs
    --in)
      lsclIncomingParticles=${2}
      shift
      shift
      ;;
    #Extra shell script parameters
    --out)
      lsclOutgoingParticles=${2}
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

if [ ! -d ${lsclFullProjectName} ] 
then
    mkdir -p ${lsclFullProjectName};
fi

for subDir in "Shared" "Mathematica" "FeynmanRules" "Diagrams" \
"QGRAF" "QGRAF/Input" "QGRAF/Output" "QGRAF/Models" "QGRAF/Styles"
  do
    if [ ! -d ${lsclFullProjectName}/${subDir} ] 
      then
        echo "${LSCL_SCRIPT_NAME}: Creating directory ${lsclFullProjectName}/${subDir}"
        mkdir -p ${lsclFullProjectName}/${subDir};
      else
        echo "${LSCL_SCRIPT_NAME}: Skipping: Directory ${lsclProjectName}/${subDir} already exists."
  fi
done

if [ ! -f ${lsclFullProjectName}/Shared/lsclMmaConfig.m ]
  then
    echo "${LSCL_SCRIPT_NAME}: Creating a template for ${lsclProjectName}/Shared/lsclMmaConfig.m"
    cp ${lsclRepoDir}/ProjectTemplates/lsclMmaConfig.m ${lsclFullProjectName}/Shared/lsclMmaConfig.m
  else
    echo "${LSCL_SCRIPT_NAME}: Skipping: File lsclMmaConfig.m already exists."  
fi

if [ ! -f ${lsclFullProjectName}/FeynmanRules/lsclFeynmanRules_${lsclModelName}.h ]
  then
    echo "${LSCL_SCRIPT_NAME}: Creating a template for ${lsclProjectName}/FeynmanRules/lsclFeynmanRules_${lsclModelName}.h"
    cp ${lsclRepoDir}/ProjectTemplates/lsclFeynmanRules_ModelName.h ${lsclFullProjectName}/FeynmanRules/lsclFeynmanRules_${lsclModelName}.h
  else
    echo "${LSCL_SCRIPT_NAME}: Skipping: File lsclFeynmanRules_${lsclModelName}.h already exists."  
fi

if [ ! -f ${lsclFullProjectName}/FeynmanRules/lsclParticles_${lsclModelName}.h ]
  then
    echo "${LSCL_SCRIPT_NAME}: Creating a template for ${lsclProjectName}/FeynmanRules/lsclParticles_${lsclModelName}.h"
    cp ${lsclRepoDir}/ProjectTemplates/lsclParticles_ModelName.h ${lsclFullProjectName}/FeynmanRules/lsclParticles_${lsclModelName}.h
  else
    echo "${LSCL_SCRIPT_NAME}: Skipping: File lsclFeynmanRules_${lsclModelName}.h already exists."  
fi

if [ ! -f ${lsclFullProjectName}/QGRAF/Models/${lsclModelName} ]
  then
    echo "${LSCL_SCRIPT_NAME}: Creating a template for ${lsclProjectName}/QGRAF/Models/${lsclModelName}"
    cp ${lsclRepoDir}/ProjectTemplates/QGRAFModels/${lsclModelName} ${lsclFullProjectName}/QGRAF/Models/${lsclModelName}
  else
    echo "${LSCL_SCRIPT_NAME}: Skipping: File Models/${lsclModelName} already exists."  
fi

for styleFile in "feyncalc.sty" "form.sty" "graphviz.sty" "tikz-feynman.sty"
do
  if [ ! -f ${lsclFullProjectName}/QGRAF/Styles/${styleFile} ] 
    then
      echo "${LSCL_SCRIPT_NAME}: Copying ${lsclFullProjectName}/QGRAF/Styles/${styleFile}"
      cp ${lsclRepoDir}/ProjectTemplates/QGRAFStyles/${styleFile} ${lsclFullProjectName}/QGRAF/Styles/${styleFile}
    else
      echo "${LSCL_SCRIPT_NAME}: Skipping: File Styles/${styleFile} already exists."  
fi
done

if [ ! -f ${lsclFullProjectName}/Shared/${lsclProcessName}.h ]
then
  echo "${LSCL_SCRIPT_NAME}: Creating a template for ${lsclProjectName}/Shared/${lsclProcessName}.h"
  cp ${lsclRepoDir}/ProjectTemplates/ProcessName.h ${lsclFullProjectName}/Shared/${lsclProcessName}.h
else
  echo "${LSCL_SCRIPT_NAME}: Skipping: File Shared/${lsclProcessName}.h already exists."
fi

if [ ! -f ${lsclFullProjectName}/QGRAF/Input/qgraf.dat.${lsclProcessName} ]
then
  echo "${LSCL_SCRIPT_NAME}: Creating a template for ${lsclProjectName}/QGRAF/Input/qgraf.dat.${lsclProcessName}"
  cp ${lsclRepoDir}/ProjectTemplates/qgraf.dat.ProcessName ${lsclFullProjectName}/QGRAF/Input/qgraf.dat.${lsclProcessName}
else
  echo "${LSCL_SCRIPT_NAME}: Skipping: File qgraf.dat.${lsclProcessName} already exists."
fi


if [[ -z "${lsclIncomingParticles+x}" ]]; then
  echo
else
  echo "${LSCL_SCRIPT_NAME}: Adjusting incoming and outgoing particles in qgraf.dat.${lsclProcessName}"
  sed -i -e "s|in = CHANGEME|in = $lsclIncomingParticles|" -e "s|out = CHANGEME|out = $lsclOutgoingParticles|" ${lsclFullProjectName}/QGRAF/Input/qgraf.dat.${lsclProcessName}
fi

