#!/bin/bash

if [[ $# -ne 5 ]] ; then
    echo 'You must specify the model file, the control file, the project name, the output file and the number of loops.'
    exit 0
fi

#lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#lsclRepoDir="$(dirname $lsclScriptDir)"

if [ -z "${lsclEnvSourced}" ]; then
  . "$lsclRepoDir"/environment.sh
fi

lsclModelFile=$1;
lsclQgrafFile=$2;
lsclProjectName=$3;
lsclOutputFile=$4;
lsclNLoops=$5;


cd $lsclRepoDir/Projects/$lsclProjectName/QGRAF

rm -rf qgraf.dat lsclTempAmps.out lsclTempGraphs.out lsclTempTeX.out
cp Input/"$lsclQgrafFile" qgraf.dat
sed -i -e "s|model = 'xxx'|model = 'Models/$lsclModelFile'|" -e "s|loops = xxx|loops = $lsclNLoops|" qgraf.dat

rm -rf $tfmRepoDir/Projects/$projectDir/QgOutput/$outputFile
mkdir -p $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output;
# Execture qgraf
$lsclQgrafPath

mv lsclTempAmps.out $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/$lsclOutputFile.amps
mv lsclTempGraphs.out $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/$lsclOutputFile.graphs
mv lsclTempTeX.out $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/$lsclOutputFile.tex
