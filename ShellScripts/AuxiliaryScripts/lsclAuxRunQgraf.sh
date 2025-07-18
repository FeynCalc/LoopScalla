#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -ne 5 ]] ; then
    echo 'You must specify the model file, the control file, the project name, the output file and the number of loops.'
    exit 0
fi

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
mkdir -p $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/Files;
# Execture qgraf
$lsclQgrafPath

mv lsclTempAmps.out $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/Files/$lsclOutputFile.amps
mv lsclTempGraphs.out $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/Files/$lsclOutputFile.graphs
mv lsclTempTeX.out $lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/Files/$lsclOutputFile.tex
