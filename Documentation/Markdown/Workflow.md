## Workflow

### See also

[Overview](LoopScalla.md).


```
./ShellScripts/lscl[Slurm]ProcessInputStage0.sh MyProject MyProcess MyModel nLoops OPTIONS
```

Populates `Projects/MyProject/Diagrams/MyProcess/MyModel/nLoops/Stage0` with .res files

```
./ShellScripts/lscl[Slurm]ExtractTopology.sh MyProject MyProcess MyModel nLoops OPTIONS
```

Populates `Projects/MyProject/Diagrams/MyProcess/MyModel/nLoops/ExtractedTopologies` with .m files

```
./ShellScripts/lscl[Slurm]FindTopologies.sh MyProject MyProcess MyModel nLoops OPTIONS
```

Populates `Projects/MyProject/Diagrams/MyProcess/MyModel/nLoops/Topologies`

```
./ShellScripts/lscl[Slurm]IdentifyTopology.sh MyProject MyProcess MyModel nLoops OPTIONS
```

Populates `Projects/MyProject/Diagrams/MyProcess/MyModel/nLoops/Stage1` and
`Projects/MyProject/Diagrams/MyProcess/MyModel/nLoops/LoopIntegrals/Form/`

```
./ShellScripts/lscl[Slurm]CreateJointIntegralFile.sh MyProject MyProcess MyModel nLoops OPTIONS
```

Creates `Projects/MyProject/Diagrams/MyProcess/MyModel/nLoops/LoopIntegrals/allLoopIntegrals.res`

```
./ShellScripts/lscl[Slurm]CreateIntegralFiles.sh MyProject MyProcess MyModel nLoops OPTIONS
```

Populates `Projects/MyProject/Diagrams/MyProcess/MyModel/nLoops/LoopIntegrals/Mma/`

```
./ShellScripts/lscl[Slurm]FirePrepareReduction.sh MyProject MyProcess MyModel nLoops OPTIONS
 ./ShellScripts/lscl[Slurm]FireCreateLiteRedFiles.sh MyProject MyProcess MyModel nLoops OPTIONS
./ShellScripts/lscl[Slurm]FireCreateStartFiles.sh MyProject MyProcess MyModel nLoops OPTIONS
```

Populates `Projects/MyProject/Diagrams/MyProcess/MyModel/nLoops/Reductions`
