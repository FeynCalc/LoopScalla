## Creating new project

### See also

[Overview](LoopScalla.md).

LoopScalla is equipped with templates that facilitate the creation of a new project. Following models
are already built-in

- Standard model (`SM`)
- Two flavor QCD (`TwoFlavorQCD`)

To create a project for the $H \to g g$ calculation in the SM we can use the script

```
./ShellScripts/lsclAddNewProject.sh MyHiggsProject SM HToGlGl --in H --out Gl,Gl
```

With the options `--in` and `--out` we can readily specify incoming and outgoing particles in the `qgraf.dat` file.

Here we are only interested in QCD corrections to this decay, so we can edit 
`Projects/MyHiggsProject/QGRAF/Input/qgraf.dat.HToGlGl`

```
nano Projects/MyHiggsProject/QGRAF/Input/qgraf.dat.HToGlGl
```

and add the lines

```
 true = vsum[gs,2,100];
 true = vsum[el,1,1];
```

This way we allow any vertices involving the strong coupling constant but limit the number of 
vertices involving the electric charge to one, which will be the HFF-vertex.

To generate the diagrams at one and two loops we run

./ShellScripts/lsclRunQgraf.sh MyHiggsProject HToGlGl SM 1
./ShellScripts/lsclRunQgraf.sh MyHiggsProject HToGlGl SM 2

The diagrams are automatically visualized using GraphViz and saved to PDF files located in `Projects/MyHiggsProject/QGRAF/Output/PDFs`.

The quality is not suitable for publications but it is sufficient to understand which diagram types contribute to the process. Furthermore, the generation of such graphic depictions of Feynman diagrams is parallelized and proceeds very fast even when thousands of diagram are involved.

The next step is to insert Feynman rules into the amplitudes. Using our style file, we obtain QGRAF output containing only 2 functions with different arguments: `QGVertex` and `QGPropagator`. The arguments of these quantities determine the corresponding Feynman rule.

Since we already have all SM Feynman rules built in, it is sufficient to run

```
./ShellScripts/lsclInsertFeynmanRules.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all
./ShellScripts/lsclInsertFeynmanRules.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all
```

We can check that the process completed without any errors

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what InputDiagrams
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what InputDiagrams
```

by verifying that the number of the input diagrams matches the number of the processed diagrams.

Let us first adjust several configuration variables needed for the Mathematica part of the calculation by
editing `Projects/MyHiggsProject/Shared/lsclMmaConfig.m`. 

```
nano Projects/MyHiggsProject/Shared/lsclMmaConfig.m
```

Here we need to specify the values of
- `"FCVariables"`: list of all variables that may appear in the IBP reduction
- `"FinalSubstitutions"`: values of scalar products of external momenta for the IBP reduction
- `"KiraMassDimensions"`: mass dimensions of kinematic invariants when doing IBP reduction with Kira

The suitable values for this project are 

```
...
"FCVariables" -> {mh,mqu,mqd,mqs,mqc,mqb,mqt},
"KiraMassDimensions" -> {mh->1,mqu->1,mqd->1,mqs->1,mqc->1,mqb->1,mqt->1},
"FinalSubstitutions" -> {SPD[q1]->0,SPD[q2]->0,SPD[q1,q2]->1/2*mh^2},
...
```

The next step is to edit the file `Projects/MyHiggsProject/Shared/HToGlGl.h` that contains process-specific
FORM code for evaluating this process. The standard steps such as simplfying Dirac and color algebra as well
as doing tensor reduction and inserting the IBP-reduction tables are already built-in.

However, there are some important process-specific bits and pieces that must be implemented before running
the script.

```
nano Projects/MyHiggsProject/Shared/HToGlGl.h
```

### lsclGeneric fold

First of all, let us examine the `lsclGeneric` fold. If there are any special variables that are needed for this calculation, 
we should define them here, because the definitions from this fold are loaded every time the amplitude is being
processed by FORM scripts of LoopScalla.

There we need to set the number of initial (`lsclPprNumOfInParticles`) and final (`lsclPprNumOfOutParticles`) states
to `1` and `2` respectively.

Since we will be using tensor reduction, we leave `lsclPprInsertProjector` set to `0`.

We do not plan to truncate external polarization vectors either, so
`lsclPprTruncatePolVectors` set to `0` is also fine.

Adjusting `lsclPprNumOfLoopIntsToReduceAtOnce` may be useful for complicated IBP reductions, but
here the reduction tables are not particularly complicated and we stick to the default value of `100`.

Now the setting `lsclPprNumDenFactorizeArguments` is important. Here we should list all symbols 
that will appear in the amplitude as relative factors, e.g. coupling constants and masses. When
calling `lsclNumDenFactorize` and wrapping all factorized terms in the numerators and denominators
into `lsclNum` and `lsclDen` respectively, those symbols will be released, e.g. `lsclDen(gs)`
will be converted to `1/gs`.

Regarding `lsclPprFactorizationVariables`, this list defines trigger variables for the 
factorization of lsclNum and lsclDen using polyratfun. All lsclNum or lsclDen containing
trigger variables will be taken into account by polyratfun, while all the remaining
numerators and denominatos will be ignored. Here we need to add `mh` and `mqt` since those
will appear in various polynomials via tensor reduction and the IBPs.

Then `lsclPprAdditionalBracketArguments` list additional variables w.r.t which we can collect 
our expressions when doing factorization at different stages of calculations. The coupling
constants `gs` and `el` are already sufficient here.

### lsclKinematics fold

The `lsclKinematics` fold is one of the most crucial parts of the calculation, since this
is where all kinematic constraints such as momentum conservation and values of the scalar
products and masses must be defined.

In our case we are dealing with a 1->2 on-shell process, so that we can replace the incoming
Higgs momentum `p1` by the sum of `q1` and `q2`. We set the gluons to be on-shell, specify
that `q1.q2` equals `(1/2*mh^2)` and define the masses of all particles involved, that are
currently being written as `lsclMass(particleName)`. Here is the relevant code between
`repeat;` and `endrepeat;`

```
id p1 = q1+q2;
id q1.q1^lsclS?pos_ = 0;
id q2.q2^lsclS?pos_ = 0;
id q1.q2^lsclS?pos_ = (1/2*mh^2)^lsclS;
id lsclMass(Qu) = 0;
id lsclMass(Qd) = 0;
id lsclMass(Qs) = 0;
id lsclMass(Qc) = 0;
id lsclMass(Qb) = 0;
id lsclMass(Qt) = mqt;
id lsclMass(Z) = mz;

id q1.lsclPVOq1^lsclS?pos_ = 0;
id q2.lsclPVOq2^lsclS?pos_ = 0;
```

At this point we are done with editing `HToGlGl.h` in the sense that the proposed changes
are the bare minimum needed to make the calculation of the amplitude go through without
generating errors. Of course, depending on what we are trying to do and how complicated things
can get, one might need to implement much more changes in the code.

## Running the code

Having adjusted all the needed parameters, we can run the code via

```
./ShellScripts/lsclProcessInputStage0.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all
```

The 2-loop calculation requires more resources even on a powerful laptop, so it is better to limit the number
of parallel processes to 8 or ideally switch to the SLURM cluster.

```
./ShellScripts/lsclProcessInputStage0.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all --pjobs 8
```

Check that the diagrams were evaluated without errors

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what Stage0
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what Stage0
```

Before topo minimization


```
./ShellScripts/lsclExtractTopology.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all
./ShellScripts/lsclExtractTopology.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what ExtractedTopologies
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what ExtractedTopologies
```

# Do topology minimization

```
./ShellScripts/lsclFindTopologies.sh MyHiggsProject HToGlGl SM 1
./ShellScripts/lsclFindTopologies.sh MyHiggsProject HToGlGl SM 2
```

# Insert topology mappings (creates Stage 1 files)

```
./ShellScripts/lsclIdentifyTopology.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all
./ShellScripts/lsclIdentifyTopology.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all  --pjobs 8
```

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what Stage1
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what Stage1
```

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what ExtractedLoopIntegrals
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what ExtractedLoopIntegrals
```

# Extract occurring loop integrals

```
./ShellScripts/lsclCreateJointIntegralFile.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all
./ShellScripts/lsclCreateJointIntegralFile.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all
```

```
./ShellScripts/lsclCreateIntegralFiles.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all
./ShellScripts/lsclCreateIntegralFiles.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what ExtractedLoopIntegrals
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what ExtractedLoopIntegrals
```

# Prepare runcards for KIRA
```
./ShellScripts/lsclKiraPrepareReduction.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all
./ShellScripts/lsclKiraPrepareReduction.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all
```

# Run KIRA reduction
```
./ShellScripts/lsclKiraRunReduction.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all --pjobs 2
./ShellScripts/lsclKiraRunReduction.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all --pjobs 2
```


```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what CompletedReductions --kira
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what CompletedReductions --kira
```


# Import reduction results

```
./ShellScripts/lsclImportReductionResults.sh MyHiggsProject HToGlGl SM 1 --kira --fromto 1 all
./ShellScripts/lsclImportReductionResults.sh MyHiggsProject HToGlGl SM 2 --kira  --fromto 1 all
```

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what ImportedReductionTables --kira
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what ImportedReductionTables --kira
```


# Create fill statements for tablebases

```
./ShellScripts/lsclCreateFillStatements.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all  --kira
./ShellScripts/lsclCreateFillStatements.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all  --kira
```

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what FillStatements --kira
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what FillStatements --kira
```

# Generate tablebases

```
./ShellScripts/lsclCreateTableBase.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all --kira
./ShellScripts/lsclCreateTableBase.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all --kira
```

```
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 1 --what TableBases --kira
./ShellScripts/lsclCount.sh MyHiggsProject HToGlGl SM 2 --what TableBases --kira
```

# Find one-to-one mappings between master integrals

```
./ShellScripts/lsclFindIntegralMappings.sh MyHiggsProject HToGlGl SM 1 --kira
./ShellScripts/lsclFindIntegralMappings.sh MyHiggsProject HToGlGl SM 2 --kira
```

# Insert reduction tables (creates Stage 2 files)
```
./ShellScripts/lsclInsertReductionTables.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all  --kira
./ShellScripts/lsclInsertReductionTables.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all --pjobs 2 --kira
```

# Add up all diagrams

```
./ShellScripts/lsclAddUpDiagrams.sh MyHiggsProject HToGlGl SM 1 --fromto 1 all
./ShellScripts/lsclAddUpDiagrams.sh MyHiggsProject HToGlGl SM 2 --fromto 1 all
```














