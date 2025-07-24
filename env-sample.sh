# This file is a part of LoopScalla, a framework for loop calculations
# Loopscalla is covered by the GNU General Public License 3.
# Copyright (C) 2019-2025 Vladyslav Shtabovenko


#=======================================================#
#                     TOOLS  		                    #
#=======================================================#

# Path to QGRAF
export lsclQgrafPath="$lsclRepoDir/Binaries/qgraf"

# Path to TFORM
export lsclTformPath="$lsclRepoDir/Binaries/tform"

# Path to GNU parallel
export lsclParallelPath="/usr/bin/parallel"

# Path to the FIRE6 Mathematica file
export lsclFireMmaPath="$HOME/.Mathematica/Applications/FIRE6/FIRE6.m"

# Path to the FIRE6 C++ binary
export lsclFireCppPath="$HOME/.Mathematica/Applications/FIRE6/bin/FIRE6"

# Path to pdfunite
export lsclPdfunitePath="/usr/bin/pdfunite"

# Path to dot
export lsclDotPath="/usr/bin/dot"

# Path to GNU make
export lsclMakePath="/usr/bin/make"

# Path to the preferred PDF viewer
export lsclPDFViewer="evince"

# Path to Mathematica. It is sufficient to specify just 
# the executable, not the full path
export lsclMmaPath="math"

# Path to Python. It is sufficient to specify just the 
# executable, not the full path
export lsclPythonPath="python"

#=======================================================#
#                     CONFIGURATION                     #
#=======================================================#

# Full path to the project directory on a cluster
lsclClusterProjectDirCluster1="user@node:/path";
lsclClusterProjectDirCluster2="user@node:/path";

export lsclClusterProjectDirDefault=lsclClusterProjectDirCluster1;

# Loopscalla modules to be used
export lsclModules="FormScripts:Shared:Dirac:FeynmanRules:SUN:ExportImport:External:Loop";

# Slurm mode to be used
export lsclSlurmExclusiveNodes=0

# Number of GNU parallel threads for TFORM
export lsclTformNumWorkers=4

# Number of GNU parallel jobs for TFORM
export lsclNumOfParallelFormJobsDefault=16

# Number of threads for pySecDec
export lsclPySecDecNumThreads=8

# Number of GNU parallel jobs for FIRE
export lsclNumOfParallelFireJobs=4

# Number of GNU parallel jobs for shell scripts
export lsclNumOfParallelShellJobsDefault=16

# Temporary directory to keep FORM swap files. Use $TMP on the cluster
export lsclTformTmpDir="/tmp"

# Number of GNU parallel threads for runQgraf
export lsclQgrafNumThreads=16

# Number of parallel instances for Kira. This is what gets passed
# to the KIRA binary via the --parallel option
export lsclKiraNumThreads=8

# Number of default parallel kernels for FeynCalc. This concerns 
# e.g. topology minimization, processing of the reduction tables and
# the determinations of loop integral mappings
export lsclFeynCalcNumKernels=8

# Auxiliary variable for book keeping, please don't change it.
export lsclEnvSourced=1

# Nodes to be excluded when running cluster jobs
#export lsclExcludeNodes="hpcnode1,hpcnode2"
export lsclExcludeNodes=""


