Readme
========================

##

./ShellScripts/lsclRunQgraf.sh QCDTests GlToGl TwoFlavorQCD 1
./ShellScripts/lsclRunQgraf.sh QCDTests GlToGl TwoFlavorQCD 2

##

./ShellScripts/lsclInsertFeynmanRules.sh QCDTests GlToGl TwoFlavorQCD 1  --fromto 1 all
./ShellScripts/lsclInsertFeynmanRules.sh QCDTests GlToGl TwoFlavorQCD 2  --fromto 1 all

./ShellScripts/lsclCountInputDiagrams.sh QCDTests GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountInputDiagrams.sh QCDTests GlToGl TwoFlavorQCD 2

./ShellScripts/lsclProcessInputStage0.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclProcessInputStage0.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCountProcessedDiagrams.sh QCDTests GlToGl TwoFlavorQCD 1 0
./ShellScripts/lsclCountProcessedDiagrams.sh QCDTests GlToGl TwoFlavorQCD 2 0

./ShellScripts/lsclExtractTopology.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclExtractTopology.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCountExtractedTopologies.sh QCDTests GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountExtractedTopologies.sh QCDTests GlToGl TwoFlavorQCD 2

./ShellScripts/lsclFindTopologies.sh QCDTests GlToGl TwoFlavorQCD 1
./ShellScripts/lsclFindTopologies.sh QCDTests GlToGl TwoFlavorQCD 2

./ShellScripts/lsclIdentifyTopology.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclIdentifyTopology.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCountProcessedDiagrams.sh QCDTests GlToGl TwoFlavorQCD 1 1
./ShellScripts/lsclCountProcessedDiagrams.sh QCDTests GlToGl TwoFlavorQCD 2 1


./ShellScripts/lsclExtractLoopIntegrals.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclExtractLoopIntegrals.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCountExtractedLoopIntegrals.sh QCDTests GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountExtractedLoopIntegrals.sh QCDTests GlToGl TwoFlavorQCD 2

./ShellScripts/lsclCreateJointIntegralFile.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateJointIntegralFile.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCreateIntegralFiles.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateIntegralFiles.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all
 

./ShellScripts/lsclFirePrepareReduction.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFirePrepareReduction.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFireCreateLiteRedFiles.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireCreateLiteRedFiles.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFireCreateStartFiles.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireCreateStartFiles.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFireRunReduction.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireRunReduction.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFireImportResults.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireImportResults.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCreateFillStatements.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateFillStatements.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclCreateTableBase.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateTableBase.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclFindIntegralMappings.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFindIntegralMappings.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclInsertReductionTables.sh QCDTests GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclInsertReductionTables.sh QCDTests GlToGl TwoFlavorQCD 2 --fromto 1 all

./ShellScripts/lsclAddUpDiagrams.sh QCDTests GlToGl TwoFlavorQCD 1  --fromto 1 all
./ShellScripts/lsclAddUpDiagrams.sh QCDTests GlToGl TwoFlavorQCD 2  --fromto 1 all


