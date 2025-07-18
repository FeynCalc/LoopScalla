Readme
========================

##

./ShellScripts/lsclRunQgraf.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclRunQgraf.sh ExampleQCD GlToGl TwoFlavorQCD 2

##

./ShellScripts/lsclInsertFeynmanRules.sh ExampleQCD GlToGl TwoFlavorQCD 1  --fromto 1 all
./ShellScripts/lsclInsertFeynmanRules.sh ExampleQCD GlToGl TwoFlavorQCD 2  --fromto 1 all

./ShellScripts/lsclCountInputDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountInputDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2

# Creates Stage 0 files
./ShellScripts/lsclProcessInputStage0.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclProcessInputStage0.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCountProcessedDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1 0
./ShellScripts/lsclCountProcessedDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2 0

./ShellScripts/lsclExtractTopology.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclExtractTopology.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCountExtractedTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountExtractedTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 2

./ShellScripts/lsclFindTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclFindTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 2

# Creates Stage 1 files
./ShellScripts/lsclIdentifyTopology.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclIdentifyTopology.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCountProcessedDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1 1
./ShellScripts/lsclCountProcessedDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2 1

./ShellScripts/lsclCreateJointIntegralFile.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateJointIntegralFile.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCountExtractedLoopIntegrals.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountExtractedLoopIntegrals.sh ExampleQCD GlToGl TwoFlavorQCD 2

./ShellScripts/lsclCreateIntegralFiles.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateIntegralFiles.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
 
./ShellScripts/lsclFirePrepareReduction.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFirePrepareReduction.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFireCreateLiteRedFiles.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireCreateLiteRedFiles.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFireCreateStartFiles.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireCreateStartFiles.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFireRunReduction.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireRunReduction.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFireImportResults.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireImportResults.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCreateFillStatements.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateFillStatements.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCreateTableBase.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateTableBase.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFindIntegralMappings.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFindIntegralMappings.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

# Creates Stage 2 files
./ShellScripts/lsclInsertReductionTables.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclInsertReductionTables.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclAddUpDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1  --fromto 1 all
./ShellScripts/lsclAddUpDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2  --fromto 1 all


