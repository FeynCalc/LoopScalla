# Readme
========================

# Generate Feynman diagrams

```
./ShellScripts/lsclRunQgraf.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclRunQgraf.sh ExampleQCD GlToGl TwoFlavorQCD 2
```
# Insert Feynman rules

```
./ShellScripts/lsclInsertFeynmanRules.sh ExampleQCD GlToGl TwoFlavorQCD 1  --fromto 1 all
./ShellScripts/lsclInsertFeynmanRules.sh ExampleQCD GlToGl TwoFlavorQCD 2  --fromto 1 all
```

```
./ShellScripts/lsclCountInputDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountInputDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2
```

# Do Dirac and color algebra and tensor reduction (creates Stage 0 files)
```
./ShellScripts/lsclProcessInputStage0.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclProcessInputStage0.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCountProcessedDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1 0
./ShellScripts/lsclCountProcessedDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2 0
```

# Extract occurring topologies
```
./ShellScripts/lsclExtractTopology.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclExtractTopology.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCountExtractedTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountExtractedTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 2
```

# Do topology minimization

```
./ShellScripts/lsclFindTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclFindTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 2
```

# Insert topology mappings (creates Stage 1 files)

```
./ShellScripts/lsclIdentifyTopology.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclIdentifyTopology.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCountProcessedDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1 1
./ShellScripts/lsclCountProcessedDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2 1
```

# Extract occurring loop integrals

```
./ShellScripts/lsclCreateJointIntegralFile.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateJointIntegralFile.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCountExtractedLoopIntegrals.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclCountExtractedLoopIntegrals.sh ExampleQCD GlToGl TwoFlavorQCD 2
```

# Create integral files for IBP reduction

```
./ShellScripts/lsclCreateIntegralFiles.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateIntegralFiles.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

# Prepare runcards for FIRE

```
./ShellScripts/lsclFirePrepareReduction.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFirePrepareReduction.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclFireCreateLiteRedFiles.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireCreateLiteRedFiles.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclFireCreateStartFiles.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireCreateStartFiles.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```
# Run FIRE reduction

```
./ShellScripts/lsclFireRunReduction.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireRunReduction.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

# Import reduction results

```
./ShellScripts/lsclFireImportResults.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFireImportResults.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

# Create fill statements for tablebases

```
./ShellScripts/lsclCreateFillStatements.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateFillStatements.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

# Generate tablebases

```
./ShellScripts/lsclCreateTableBase.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateTableBase.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

# Find one-to-one mappings between master integrals

```
./ShellScripts/lsclFindIntegralMappings.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclFindIntegralMappings.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

# Insert reduction tables (creates Stage 2 files)
```
./ShellScripts/lsclInsertReductionTables.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclInsertReductionTables.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

# Add up all diagrams

```
./ShellScripts/lsclAddUpDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1  --fromto 1 all
./ShellScripts/lsclAddUpDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2  --fromto 1 all
```

