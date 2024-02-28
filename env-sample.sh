#=======================================================#
#                  PATH VARIABLES                       #
#=======================================================#

# By default the setup ships a statically linked binaries for
# QGRAF, TFORM, Q2E and EXP. They are located in Binaries/

# The QGRAF, Q2E and EXP binary should be put to QGRAF/qgraf,
# Q2E/q2e and EXP/exp respectively. The setup will handle this
# automatically when the corresponding script are exectured.
# However, you may wish to use your own binaries instead of
# the default versions. In this case please specify them below
# $lsclRepoDir is a special environmental variable that contains
# the full path to the setup directory

# Path to QGRAF
export lsclQgrafPath="$lsclRepoDir/Binaries/qgraf"
# Path to Q2E
export lsclQ2ePath="$lsclRepoDir/Spares/q2e"
# Path to EXP
export lsclExpPath="$lsclRepoDir/Binaries/exp"

# As for TFORM the setup will run everything using Binaries/tform
# unless you modify the path to point to a different binary

# Path to TFORM
export lsclTformPath="$lsclRepoDir/Binaries/tform"

# Nodes to be excluded when running cluster jobs
#export lsclExcludeNodes="itpalbatros5,itpalbatros6,itpalbatros7,itpalbatros8,itpalbatros10"
export lsclExcludeNodes=""

# Regarding all other required tools, those are expected to be
# installed on your machine. However, you can (and should) modify
# the paths to the corresponding binaries below

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


# Path to Mathematica. It is actually sufficient to specify
# just the executable, not the full path
export lsclMmaPath="math"

# Path to Python. It is actually sufficient to specify
# just the executable, not the full path
export lsclPythonPath="python"

#=======================================================#
#                     CONFIGURATION                     #
#=======================================================#

# Full path to the project directory on a cluster
lsclClusterProjectDirCluster1="user@node:/path";
lsclClusterProjectDirCluster2="user@node:/path";

export lsclClusterProjectDirDefault=lsclClusterProjectDirCluster1;

# Loopscalla modules to be used
export lsclModules="FormScripts:Shared:Dirac:FeynmanRules:SUN:ExportImport";

# Slurm mode to be used
export lsclSlurmExclusiveNodes=0

# Number of gnu parallel threads for TFORM
export lsclTformNumWorkers=4

# Number of gnu parallel jobs for TFORM
export lsclNumOfParallelFormJobsDefault=16

# Number of threads for pySecDec
export lsclPySecDecNumThreads=8

# Number of gnu parallel jobs for FIRE
export lsclNumOfParallelFireJobs=4

# Number of gnu parallel jobs for shell scripts
export lsclNumOfParallelShellJobsDefault=16

# Temporary directory to keep FORM swap files. Use $TMP on the cluster
export lsclTformTmpDir="/tmp"

# Number of gnu parallel threads for runQgraf
export lsclQgrafNumThreads=16

# Number of parallel instances for Kira
export lsclKiraNumThreads=8

# Number of default parallel kernels for FeynCalc
export lsclFeynCalcNumKernels=8

# Whether we need to generate a PDF file containing Qgraf diagrams
# This step usually takes much longer than just generating amplitudes
export lsclQgrafGeneratePDFs=false

# Auxiliary variable for book keeping, please don't change it.
export lsclEnvSourced=1



