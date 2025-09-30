## Creating new project

### See also

[Overview](LoopScalla.md).

In this section we provide an example of using LoopScalla for generating amplitudes describing
a particular particle process at 1 and 2 loops and reducing these amplitudes to linear combinations
of master integrals.This can be regarded as a blueprint for a tractable calculation within the framework that can be carried out in a highly automatized fashion.

LoopScalla is equipped with templates that facilitate the creation of a new project. Following models are already built-in

- Standard model (`SM`)
- Two flavor QCD (`TwoFlavorQCD`)

To create a project for the $g g \to H$ calculation in the SM we can use the script

```
./ShellScripts/lsclAddNewProject.sh MyHiggsProject SM GlGlToH --in Gl,Gl --out H
```

With the options `--in` and `--out` we can readily specify incoming and outgoing particles in the `qgraf.dat` file.

Here we are only interested in QCD corrections to this production process, so we can edit `Projects/MyHiggsProject/QGRAF/Input/qgraf.dat.GlGlToH`

```
nano Projects/MyHiggsProject/QGRAF/Input/qgraf.dat.GlGlToH
```

and add the lines

```
 true = vsum[gs,2,100];
 true = vsum[el,1,1];
```

This way we allow any vertices involving the strong coupling constant but limit the number of vertices involving the electric charge to one, which will be the HFF-vertex.

To generate the diagrams at one and two loops we run

./ShellScripts/lsclRunQgraf.sh MyHiggsProject GlGlToH SM 1
./ShellScripts/lsclRunQgraf.sh MyHiggsProject GlGlToH SM 2

The diagrams are automatically visualized using GraphViz and saved as PDF files located in `Projects/MyHiggsProject/QGRAF/Output/PDFs`.

The quality is not suitable for publications but it is sufficient to understand which diagram types contribute to the process. Furthermore, the generation of such graphic depictions of Feynman diagrams is parallelized and proceeds very fast even when thousands of diagram are involved.

The next step is to insert Feynman rules into the amplitudes. Using our style file, we obtain QGRAF output containing only 2 functions with different arguments: `QGVertex` and `QGPropagator`. The arguments of these quantities determine the corresponding Feynman rule.

Since we already have all SM Feynman rules built in, it is sufficient to run

```
./ShellScripts/lsclInsertFeynmanRules.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all
./ShellScripts/lsclInsertFeynmanRules.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all
```

We can check that the process completed without any errors

```
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 1 --what InputDiagrams
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 2 --what InputDiagrams
```

by verifying that the number of the input diagrams matches the number of the processed diagrams.

It might happen, that we need to filter the input diagrams using their topological properties. To this aim there is a fold called `lsclBeforeInsertingFeynmanRules` in the main process-specific control file `Projects/MyHiggsProject/Shared/GlGlToH.h`. By default, this fold contains a procedure that marks closed fermion loops with `lsclFermionLoop(fermionType)` and a procedure that sets all diagrams containing loop corrections on external legs (where the ingoing and outgoing particle  connected to the blob on the leg are identical) to zero. Notice that mixing external corrections (different ingoing and outgoing particles connected to the blob on the leg) are not set to zero. The user is free to modify the code in that fold or add new filtering routines.



Let us first adjust several configuration variables needed for the Mathematica part of the calculation by editing `Projects/MyHiggsProject/Shared/lsclMmaConfig.m`. 

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
"FCVariables" -> {s,mqt},
"FinalSubstitutions" -> {Hold[SPD][p1]->0,Hold[SPD][p2]->0,Hold[SPD][p1,p2]->1/2*s},
"KiraMassDimensions" -> {s->2,mqt->1},
...
```
We will set all quark masses except the top quark mass to zero, so that our result will only depend on the center of mass energy squared `s` and `mqt`. The kinematics correspond to the incoming gluons being onshell.


The next step is to edit the file `Projects/MyHiggsProject/Shared/GlGlToH.h` that contains process-specific FORM code for evaluating this reaction. The standard steps such as simplifying Dirac and color algebra as well as doing tensor reduction and inserting the IBP-reduction tables are already built-in.

However, there are some important process-specific bits and pieces that must be implemented before running the script.

```
nano Projects/MyHiggsProject/Shared/GlGlToH.h
```

### lsclGeneric fold

First of all, let us examine the `lsclGeneric` fold. If there are any special variables that are needed for this calculation, we should define them here, because the definitions from this fold are loaded every time the amplitude is being processed by FORM scripts of LoopScalla. Here we introduce the CM energy variable `s` via `S s;`.

There we need to set the number of initial (`lsclPprNumOfInParticles`) and final (`lsclPprNumOfOutParticles`) states to `2` and `1` respectively.

Since we will be using tensor reduction, we leave `lsclPprInsertProjector` set to `0`.

We do not plan to truncate external polarization vectors either, so `lsclPprTruncatePolVectors` set to `0` is also fine.

Adjusting `lsclPprNumOfLoopIntsToReduceAtOnce` may be useful for complicated IBP reductions, but
here the reduction tables are not particularly complicated and we stick to the default value of `100`, i.e. when inserting the reduction tables we will be doing this in batches of 100 integrals per batch.

Now the setting `lsclPprNumDenFactorizeArguments` is important. Here we should list all symbols  that will appear in the amplitude as relative factors, e.g. coupling constants and masses. When
calling `lsclNumDenFactorize` and wrapping all factorized terms in the numerators and denominators
into `lsclNum` and `lsclDen` respectively, those symbols will be released, e.g. `lsclDen(gs)`
will be converted to `1/gs`. We set this preprocessor variable as follows
```
#define lsclPprNumDenFactorizeArguments "{gs\,el\,mw\,sW\,cW\,s\,mqt\,lsclGaugeXi\,}"
```

Regarding `lsclPprFactorizationVariables`, this list defines trigger variables for the 
factorization of `lsclNum` and `lsclDen` using FORM's `polyratfun`. All `lsclNum` or `lsclDen` containing trigger variables will be taken into account by `polyratfun`, while all the remaining
numerators and denominators will be ignored. Here we need to add `s` and `mqt` since those
will appear in various polynomials via tensor reduction and the IBPs. Hence,
```
#define lsclPprFactorizationVariables "lsclD,lsclSUNN,lsclNA,lsclCF,lsclCA,lsclCRmCA2,s,mqt,"
```

Then `lsclPprAdditionalBracketArguments` list additional variables w.r.t which we can collect 
our expressions when doing factorization at different stages of calculations. The coupling
constants `gs` and `el` as well as `lsclGaugeXi` are already sufficient here.

### lsclKinematics fold

The `lsclKinematics` fold is one of the most crucial parts of the calculation, since this
is where all kinematic constraints such as momentum conservation and values of the scalar
products and masses must be defined.

In our case we are dealing with a 2->1 on-shell process (remember that all `qi` are incoming and all `pi` are outgoing), so that we can replace the outgoing Higgs momentum `q1` by the sum of `p1` and `p2`. We set the gluons to be on-shell, specify that `p1.p2` equals `(1/2*s)` and define the masses of all particles involved, that are currently being written as `lsclMass(particleName)`. Here is the relevant code between `repeat;` and `endrepeat;`

```
id q1 = p1+p2;
id p1.p1^lsclS?pos_ = 0;
id p2.p2^lsclS?pos_ = 0;
id p1.p2^lsclS?pos_ = (1/2*s)^lsclS;
id lsclMass(Qu) = 0;
id lsclMass(Qd) = 0;
id lsclMass(Qs) = 0;
id lsclMass(Qc) = 0;
id lsclMass(Qb) = 0;
id lsclMass(Qt) = mqt;
id lsclMass(Z) = mz;

id p1.lsclPVIp1^lsclS?pos_ = 0;
id p2.lsclPVIp2^lsclS?pos_ = 0;
```
where `lsclPVIpi` defines the incoming polarization vector of `pi`. The corresponding outgoing polarization vector would be `lsclPVOpi`.

At this point we are done with editing `GlGlToH.h` in the sense that the proposed changes are the bare minimum needed to make the calculation of the amplitude go through without generating errors. Of course, depending on what we are trying to do and how complicated things can get, one might need to implement much more changes in the code.

## Running the code

### Algebraic simplifications (creates Stage 0 files)

Having adjusted all the needed parameters, we can run the code via

```
./ShellScripts/lsclProcessInputStage0.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all
```

The 2-loop calculation requires somewhat more resources, so it is better to limit the number of parallel processes to 8.


```
./ShellScripts/lsclProcessInputStage0.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all --pjobs 8
```

Notice that there is no guarantee whatsoever, that every process tractable using LoopScalla can be calculated on a laptop or workstation. For realistic complicated calculations it is highly advisable to switch to a SLURM cluster using the supplied LoopScalla scripts.

It is easy to check that the diagrams were evaluated without errors

```
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 1 --what Stage0
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 2 --what Stage0
```
In case of errors we can always run the evaluation code on a single diagram, e.g.

```
./ShellScripts/lsclProcessInputStage0.sh MyHiggsProject GlGlToH SM 2 56
```
to investigate what happens with the diagram 56 at 2 loops. If this diagram has already been evaluated, the script will automatically skip it. Nevertheless, we can enforce repeated evaluation using the parameter `--force`
```
./ShellScripts/lsclProcessInputStage0.sh MyHiggsProject GlGlToH SM 2 56 --force
```

### Topology reduction

The next step is to do the topology identification and minimization. To this aim we first need to extract lists of propagators appearing in every diagram


```
./ShellScripts/lsclExtractTopology.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all
./ShellScripts/lsclExtractTopology.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 1 --what ExtractedTopologies
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 2 --what ExtractedTopologies
```

Then we convert these propagator sets to proper integral families, ensuring there are no incomplete or over-determined propagator bases. This step is done in Mathematica using the multiloop capabilities of FeynCalc

```
./ShellScripts/lsclFindTopologies.sh MyHiggsProject GlGlToH SM 1
./ShellScripts/lsclFindTopologies.sh MyHiggsProject GlGlToH SM 2
```

### Insert topology mappings (creates Stage 1 files)

Once this step has been completed we can insert the mappings into our amplitudes and rewrite them into linear combinations of scalar loop integrals. The same script will also extract the unique loop integral from each diagram.

```
./ShellScripts/lsclIdentifyTopology.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all
./ShellScripts/lsclIdentifyTopology.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all  --pjobs 8
```

```
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 1 --what Stage1
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 2 --what Stage1
```

```
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 1 --what ExtractedLoopIntegrals
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 2 --what ExtractedLoopIntegrals
```

### Extract occurring loop integrals

The next step is to write all the loop integrals occurring in the amplitude into one single file and then sort them into their integral families.

```
./ShellScripts/lsclCreateJointIntegralFile.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all
./ShellScripts/lsclCreateJointIntegralFile.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all
```

```
./ShellScripts/lsclCreateIntegralFiles.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all
./ShellScripts/lsclCreateIntegralFiles.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all
```

```
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 1 --what ExtractedLoopIntegrals
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 2 --what ExtractedLoopIntegrals
```

### Prepare runcards for KIRA

Now that we have a list of families and a lists of integrals belonging to each of these families, we can set up an IBP reduction. Here we use KIRA, although reduction using FIRE is supported as well.


```
./ShellScripts/lsclKiraPrepareReduction.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all
./ShellScripts/lsclKiraPrepareReduction.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all
```

### Run KIRA to do the IBP reduction

All reductions can be started with one command. Here we limit the number of families reduced at once to 4.

```
./ShellScripts/lsclKiraRunReduction.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all --pjobs 4
./ShellScripts/lsclKiraRunReduction.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all --pjobs 4
```

```
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 1 --what CompletedReductions --kira
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 2 --what CompletedReductions --kira
```


### Import reduction results

Having completed the reductions, we use FeynCalc to import the reduction results. If needed, already at this stage one can expand the reduction tables in `ep` to the desired order.

```
./ShellScripts/lsclImportReductionResults.sh MyHiggsProject GlGlToH SM 1 --kira --fromto 1 all
./ShellScripts/lsclImportReductionResults.sh MyHiggsProject GlGlToH SM 2 --kira  --fromto 1 all
```

### Create fill statements for tablebases

To use the reduction results in FORM, we first need to write them as so- called fill statement. Using Mathematica we factorize the coefficient of master integrals, wrapping them with `lsclNum` (for numerators) and `lsclDen` (for denominators). This greatly helps to control the complexity of the potentially very large reduction tables.


```
./ShellScripts/lsclCreateFillStatements.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all  --kira
./ShellScripts/lsclCreateFillStatements.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all  --kira
```

### Generate tablebases

The fill statements are then converted to tablebases, the built-in FORM databases for an efficient insertion of large expressions

```
./ShellScripts/lsclCreateTableBase.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all --kira
./ShellScripts/lsclCreateTableBase.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all --kira
```

### Find one-to-one mappings between master integrals

Before inserting the reduction tables into the amplitude, we identify all one-to-one mappings between master integrals from different families. This is done using FeynCalc.

```
./ShellScripts/lsclFindIntegralMappings.sh MyHiggsProject GlGlToH SM 1 --kira
./ShellScripts/lsclFindIntegralMappings.sh MyHiggsProject GlGlToH SM 2 --kira
```

### Insert reduction tables (creates Stage 2 files)

Finally, we can insert the tables into the amplitudes to obtain each diagram written in terms of master integrals

```
./ShellScripts/lsclInsertReductionTables.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all  --kira
./ShellScripts/lsclInsertReductionTables.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all --pjobs 4 --kira
```

```
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 1 --what Stage2
./ShellScripts/lsclCount.sh MyHiggsProject GlGlToH SM 2 --what Stage2
```

### Add up all diagrams

In the last step we add up all diagrams to a single expression and collect it w.r.t. the occurring master integrals

```
./ShellScripts/lsclAddUpDiagrams.sh MyHiggsProject GlGlToH SM 1 --fromto 1 all
./ShellScripts/lsclAddUpDiagrams.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all
```

If the results look weird or obviously wrong, it is also possible to multiply the contribution from each diagram with a flag, so that one can easily trace the origin of questionable terms

```
./ShellScripts/lsclAddUpDiagrams.sh MyHiggsProject GlGlToH SM 2 --fromto 1 all -D lsclPprAddDiaFlag=1
```

At this point LoopScalla's job is essentially done. We started with an unrenormalized amplitude generated for the given process and managed to express in terms of some master integrals. The operations required to  arrive at this form were done in a highly automatized fashion.