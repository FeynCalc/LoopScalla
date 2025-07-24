## Notation and conventions

### See also

[Overview](LoopScalla.md).

To streamline the user experience and make calculations more convenient and robust, LoopScalla introduces some conventions on the names of particles, variables, procedures etc.

This makes the behavior of the code more predictable and helps to avoid clashes when combining LoopScalla with other libraries and packages.

The rules for the package notation and conventions are listed below


## QGRAF conventions and particle names

- incoming fields receive odd indices (-1, -3, -5, ...)
- outging fields receive even indices (-2, -4, -6, ...)

### Gauge bosons

- `Ga` - photon
- `Gl` - gluon
- `W` - W boson
- `Z` - Z boson
- `H` - Higgs boson

### Fermions

- `F`, `Fbar` - fermion, antifermion
- `Le`, `Ale` - lepton, antilepton
- `Nle`, `Anle` - lepton neutrino, lepton antineutrino
- `El`, `Mu`, `Tau` - electron, muon, tau
- `Ael`, `Amu`, `Atau` - positron, antimuon, antitau
- `Nel`, `Nmu`, `Ntau`- electron neutrino, muon neutrino, tau neutrino
- `Anel`, `Anmu`, `Antau`- electron antineutrino, muon antineutrino, tau antineutrino

- `Q`, `Qbar` - quark, antiquark
- `Qi`, `Qibar` - `i`-flavor quark, `i`-flavor antiquark
- `Qj`, `Qjbar` - `j`-flavor quark, `j`-flavor antiquark
- `Qh`, `Qhbar` - heavy quark, heavy antiquark
- `Ql`, `Qlbar` - light quark, light antiquark
- `Qut`, `Qutbar` - up-type quark, up-type antiquark
- `Qdt`, `Qdtbar` - down-type quark, down-type antiquark
- `Qu`, `Qd`, `Qc` - up quark, down quark, charm quark
- `Qs`, `Qt`, `Qb` - strange quark, top quark, bottom quark
- `Qubar`, `Qdbar`, `Qcbar` - up antiquark, down antiquark, charm antiquark
- `Qsbar`, `Qtbar`, `Qbbar` - strange antiquark, top antiquark, bottom antiquark

### Auxiliary fields

- `Gh` - ghost
- `Bga` - background photon field
- `Bgl` - background gluon field
- `Bgw` - background W field
- `Bgz` - background Z field


## FORM code naming conventions

These variables are defined in `Shared/lsclDeclarations.h`. For your project-related definitions you should use the fold `lsclGeneric` in `Projects/ProjectName/Shared/ProcessName.h`

The variables with a number suffix are defined from 1 to `LSCLMAXINDEX`. The latter is defined in `Shared/lsclDefinitions.h`. Notice that this file only contains default values for the relevant preprocessor variables. You can override them in your `Projects/ProjectName/Shared/ProcessName.h` file.

## Momenta

The momenta are declared as `vectors`.

- Incoming momenta: `p1`, `p2`, `...`
- Outgoing momenta `q1`, `q2`, `...`
- Loop momenta: `k1`, `k2`, `...`

The code also defines following sets of momenta

- `externalMomenta`: `p1`, `p2`, ..., `q1`, ..., `q2`, ...
- `externalMomentaP`: `p1`, `p2`, ...
- `externalMomentaK`: `q1`, `q2`, ...
- `internalMomenta`: `k1`, `k2`, ...

## Indices

Internal indices are those connecting internal lines. External indices connect vertices to polarization vectors, spinors etc.

- Internal Lorentz indices: `lsclMu`, `lsclMu1`, `lsclMu2`, `...`
- External Lorentz indices: `lsclNu`, `lsclNu1`, `lsclNu2`, `...`
- Internal fundamental color indices: `lsclCFi1`, `lsclCFi2`, `...`
- External fundamental color indices: `lsclCFj1`, `lsclCFj2`, `...`
- Internal adjoint color indices: `lsclCAi1`, `lsclCAi2`, `...`
- External adjoint color indices: `lsclCAj1`, `lsclCAj2`, `...`
- Internal Dirac indices: `lsclDi1`, `lsclDi2`, `...`
- External Dirac indices: `lsclDj1`, `lsclDj2`, `...`
- Generic indices: `lsclRho`, `lsclAl`, `lsclBe`, `lsclI`

## Symbols and vectors

- Generic symbols: `lsclS`, `lsclX`, `lsclY`, `lsclZ`
- Generic vectors: `lsclP`, `lsclQ`, `lsclL`, `lsclV`

## Functions and tensors

- Generic commutative functions: `lsclF`, `lsclG`
- Generic noncommutative functions `lsclNF`, `lsclNG`
- Generic commutative tensors: `lsclT`
- Generic noncommutative tensors: `lsclNT`

## Polarization vectors

- Incoming: `lsclPVIp1`, `lsclPVIp2`, `...`, `lsclPVIq1`, `lsclPVIq2`, `...`
- Outgoing: `lsclPVOp1`, `lsclPVOp2`, `...`, `lsclPVOq1`, `lsclPVOq2`, `...`

## Evaluation stages

* Stage 0 - Dirac and color algebra, expansions, kinematic simplifications. Projectors or
 tensor reduction. The output should be ready for the topology identification step

* Stage 1 - Application of loop momenta shifts and topology mapping, rewriting of scalar propoducts
in terms of inverse propagators. The output should be free of any explicit loop momenta and ready for the IBP reduction

* Stage 2 - Insertion of IBP reduction tables.

## Command line parameters

- Can add `-d LSCLVERBOSITY=1` to the bash scripts to have a more verbose output


## Running jobs on a cluster where we reserve complete nodes
 - The requested memory should be the product of average memory requirement per single task times
   the number of simultaneous GNU parallel jobs. For example, for 4GB per task and 8 jobs we need
   at least 32 GB of RAM.
 - The number slices specifies the total number of jobs to be processed by a node. In general, the total
   number of single tasks divivded by the number of requested nodes should be a good number
