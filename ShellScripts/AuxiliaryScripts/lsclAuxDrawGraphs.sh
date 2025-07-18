#!/bin/bash

# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2023 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

if [[ $# -ne 2 ]] ; then
    echo 'You must specify the process name so that the graph file.'
    exit -1
fi

lsclProjectName="$1"
lsclGraphFile="$2" # $lsclModelFile.$lsclNLoops.graphs
lsclGraphDir=$lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/Graphs/$lsclGraphFile
lsclPDFDir=$lsclRepoDir/Projects/$lsclProjectName/QGRAF/Output/PDFs

cd $lsclRepoDir
qOutDir="qOutput"
prName=$1

if [ ! -d $lsclGraphDir ]; then
    echo Directory  $lsclGraphDir does not exist!
    exit;
fi

shopt -s extglob
shopt -s nullglob
allFiles=($lsclGraphDir/graph.+([0-9]))
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later
shopt -u extglob
allFiles=($(printf "%s\n" "${allFiles[@]}" | sort -V))

if [ ${#allFiles[@]} -eq 0 ]; then
    echo "No graphs, so nothing to do."
    exit;
fi

#echo ${allFiles[@]}

# allGraphs looks like (9 10 24 30 ...)
allGraphs=()
for i in "${allFiles[@]}"; do
  allGraphs+=("${i##*.}")  
done
nfiles=${#allGraphs[@]}

#echo ${allFiles[@]}



rm -rf $lsclGraphDir/*.pdf
"$lsclParallelPath" -j "$lsclQgrafNumThreads" -u --eta --bar "$lsclDotPath" -Kneato -O -Tpdf $lsclGraphDir/graph.{} ::: ${allGraphs[@]}

#bash arrays start at 0, zsh arrays start at 1

sliceSize=100
nSlices=$(($nfiles / $sliceSize))
nRest=$(($nfiles % $sliceSize))

if [ "$nRest" -eq 0 ]; then
    nSlices=$((nSlices-1))
fi

for i in `seq 0 $nSlices`; do
    from=$((($i)*$sliceSize))    
    curFiles=()
    for j in "${allGraphs[@]:$from:$sliceSize}"; do
      curFiles="${curFiles} $lsclGraphDir/graph.$j.pdf"
    done
    "$lsclPdfunitePath" $curFiles $lsclGraphDir/temp."$i".pdf
done

# Final gluing
curFiles=()
for i in `seq 0 $nSlices`; do
    curFiles="${curFiles} $lsclGraphDir/temp."$i".pdf"
done
mkdir -p $lsclPDFDir
"$lsclPdfunitePath" $curFiles $lsclPDFDir/"$lsclGraphFile".pdf

# Final cleanup
find ${lsclGraphDir} -name 'graph.*.pdf' -type f -delete
find ${lsclGraphDir} -name 'temp.*.pdf' -type f -delete
