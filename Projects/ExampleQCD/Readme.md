# Readme
========================

# Generate Feynman diagrams

```
./ShellScripts/lsclRunQgraf.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclRunQgraf.sh ExampleQCD GlToGl TwoFlavorQCD 2
```
# Insert Feynman rules

```
./ShellScripts/lsclInsertFeynmanRules.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclInsertFeynmanRules.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 1 --what InputDiagrams
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 2 --what InputDiagrams
```

### Algebraic simplifications (creates Stage 0 files)

```
./ShellScripts/lsclProcessInputStage0.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclProcessInputStage0.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 1 --what Stage0
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 2 --what Stage0
```

### Topology reduction

```
./ShellScripts/lsclExtractTopology.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclExtractTopology.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 1 --what ExtractedTopologies
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 2 --what ExtractedTopologies
```

```
./ShellScripts/lsclFindTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 1
./ShellScripts/lsclFindTopologies.sh ExampleQCD GlToGl TwoFlavorQCD 2
```

### Insert topology mappings (creates Stage 1 files)

```
./ShellScripts/lsclIdentifyTopology.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclIdentifyTopology.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 1 --what Stage1
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 2 --what Stage1
```

```
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 1 --what ExtractedLoopIntegrals
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 2 --what ExtractedLoopIntegrals
```

### Extract occurring loop integrals

```
./ShellScripts/lsclCreateJointIntegralFile.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateJointIntegralFile.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCreateIntegralFiles.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclCreateIntegralFiles.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 1 --what ExtractedLoopIntegrals
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 2 --what ExtractedLoopIntegrals
```

### Prepare runcards for KIRA

```
./ShellScripts/lsclKiraPrepareReduction.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclKiraPrepareReduction.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

### Run KIRA to do the IBP reduction

```
./ShellScripts/lsclKiraRunReduction.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all --pjobs 4
./ShellScripts/lsclKiraRunReduction.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all --pjobs 4
```

```
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 1 --what CompletedReductions --kira
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 2 --what CompletedReductions --kira
```

### Import reduction results

```
./ShellScripts/lsclImportReductionResults.sh ExampleQCD GlToGl TwoFlavorQCD 1 --kira --fromto 1 all
./ShellScripts/lsclImportReductionResults.sh ExampleQCD GlToGl TwoFlavorQCD 2 --kira  --fromto 1 all
```

### Create fill statements for tablebases

```
./ShellScripts/lsclCreateFillStatements.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all  --kira
./ShellScripts/lsclCreateFillStatements.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all  --kira
```

### Generate tablebases

```
./ShellScripts/lsclCreateTableBase.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all --kira
./ShellScripts/lsclCreateTableBase.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all --kira
```

### Find one-to-one mappings between master integrals

```
./ShellScripts/lsclFindIntegralMappings.sh ExampleQCD GlToGl TwoFlavorQCD 1 --kira
./ShellScripts/lsclFindIntegralMappings.sh ExampleQCD GlToGl TwoFlavorQCD 2 --kira
```

### Insert reduction tables (creates Stage 2 files)

```
./ShellScripts/lsclInsertReductionTables.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all  --kira
./ShellScripts/lsclInsertReductionTables.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all --pjobs 4 --kira
```

```
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 1 --what Stage2
./ShellScripts/lsclCount.sh ExampleQCD GlToGl TwoFlavorQCD 2 --what Stage2
```

### Add up all diagrams

```
./ShellScripts/lsclAddUpDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 1 --fromto 1 all
./ShellScripts/lsclAddUpDiagrams.sh ExampleQCD GlToGl TwoFlavorQCD 2 --fromto 1 all
```

### Analyze the results

```
mathematica Projects/ExampleQCD/Mathematica/analyzeResults.m
```

