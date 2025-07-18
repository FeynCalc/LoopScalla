#!/bin/bash
if [[ $# -lt 3 ]] ; then
    echo 'You must specify the project, a model and at least one process name'
    exit 0
fi

################################################################################
# Stop if any of the commands fails
set -e

lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

################################################################################

lsclProjectName="$1"
lsclModelName="$2"
lsclProcessNames="${@:3}"
lsclFullProjectName=${lsclRepoDir}/Projects/${lsclProjectName}

if [ ! -d ${lsclFullProjectName} ] 
then
    mkdir -p ${lsclFullProjectName};
fi

for subDir in "Shared" "Mathematica" "FeynmanRules" "Diagrams" \
"QGRAF" "QGRAF/Input" "QGRAF/Output" "QGRAF/Models" "QGRAF/Styles"

do
  if [ ! -d ${lsclFullProjectName}/${subDir} ] 
then
    echo Creating directory ${lsclFullProjectName}/${subDir}
    mkdir -p ${lsclFullProjectName}/${subDir};
fi
done

if [ ! -f ${lsclFullProjectName}/Shared/lsclMmaConfig.m ]
then
  echo Creating a template for ${lsclProjectName}/Shared/lsclMmaConfig.m
  cp ${lsclRepoDir}/ProjectTemplates/lsclMmaConfig.m ${lsclFullProjectName}/Shared/lsclMmaConfig.m
fi



if [ ! -f ${lsclFullProjectName}/FeynmanRules/lsclFeynmanRules_${lsclModelName}.h ]
then
  echo Creating a template for ${lsclProjectName}/FeynmanRules/lsclFeynmanRules_${lsclModelName}.h
  cp ${lsclRepoDir}/ProjectTemplates/lsclFeynmanRules_ModelName.h ${lsclFullProjectName}/FeynmanRules/lsclFeynmanRules_${lsclModelName}.h
fi

if [ ! -f ${lsclFullProjectName}/FeynmanRules/lsclParticles_${lsclModelName}.h ]
then
  echo Creating a template for ${lsclProjectName}/FeynmanRules/lsclParticles_${lsclModelName}.h
  cp ${lsclRepoDir}/ProjectTemplates/lsclParticles_ModelName.h ${lsclFullProjectName}/FeynmanRules/lsclParticles_${lsclModelName}.h
fi


if [ ! -f ${lsclFullProjectName}/QGRAF/Models/${lsclModelName}.h ]
then
  echo Creating a template for ${lsclProjectName}/QGRAF/Models/${lsclModelName}
  cp ${lsclRepoDir}/ProjectTemplates/ModelTwoFlavorQCD ${lsclFullProjectName}/QGRAF/Models/${lsclModelName}
fi

for styleFile in "feyncalc.sty" "form.sty" "graphviz.sty"

do
  if [ ! -f ${lsclFullProjectName}/QGRAF/Styles/${styleFile} ] 
then
    echo Creating a symlink for ${lsclFullProjectName}/QGRAF/Styles/${styleFile}
    ln -s ${lsclRepoDir}/QGRAF/Styles/${styleFile} ${lsclFullProjectName}/QGRAF/Styles/${styleFile}
    
fi
done

for processName in ${lsclProcessNames}
do
  if [ ! -f ${lsclFullProjectName}/Shared/${processName}.h ]
  then
    echo Creating a template for ${lsclProjectName}/Shared/${processName}.h
    cp ${lsclRepoDir}/ProjectTemplates/ProcessName.h ${lsclFullProjectName}/Shared/${processName}.h
  fi

  if [ ! -f ${lsclFullProjectName}/QGRAF/Input/qgraf.dat.${processName} ]
  then
    echo Creating a template for ${lsclProjectName}/QGRAF/Input/qgraf.dat.${processName}
    cp ${lsclRepoDir}/ProjectTemplates/qgraf.dat.ProcessName ${lsclFullProjectName}/QGRAF/Input/qgraf.dat.${processName}
  fi
done

