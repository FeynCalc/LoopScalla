# LoopScalla

[![license: GPLv3](https://img.shields.io/badge/license-GPLv3-brightgreen.svg)](https://github.com/FeynCalc/LoopScalla/blob/master/LICENSE)

LoopScalla is a software framework that uses FORM, Mathematica and FeynCalc to calculate multiloop diagrams.

In its current stage it is merely a preview not ready for productive usage.


# QGRAF conventions

- incoming fields receive odd indices (-1, -3, -5, ...)
- outging fields receive even indices (-2, -4, -6, ...)

# Loopscalla conventions

- p1, p2, ... denote incoming momenta
- q1, q2, ... denote outgoing momenta
- k1, k2, ... denote loop momenta

- lsclMu1, lsclMu2, ... denote internal Lorentz indices
- lsclNu1, lsclNu2, ... denote external Lorentz indices

- lsclCFi1, lsclCFi2, ... denote internal fundamental color indices
- lsclCFj1, lsclCFj2, ... denote external fundamental color indices

- lsclCAi1, lsclCAi2, ... denote internal adjoint color indices
- lsclCAj1, lsclCAj2, ... denote external adjoint color indices

- lsclDi1, lsclDi2, ... denote internal Dirac indices
- lsclDj1, lsclDj2, ... denote external Dirac indices

# Available shell scripts

# Evaluation stages

* Stage 0 - Dirac and color algebra, expansions, kinematic simplifications. Projectors or
 tensor reduction. The output should be ready for the topology identification step

* Stage 1 - Application of loop momenta shifts and topology mapping, rewriting of scalar propoducts
in terms of inverse propagators. The output should be free any explicit loop momenta.

* Stage 2 - Insertion of IBP reduction tables.

# Command line parameters

Can add `-d LSCLVERBOSITY=1` to the bash scripts to have a more verbose output

# Creating new project

./ShellScripts/lsclExtractTopologyAll.sh MyProject MyModel MyProcess1 MyProcess2 ...

# Script naming

Most scripts will have following suffixes attached to their names:

 - All: meaning that all diagrams will be processed
 - FromTo: only the given range of diagrams will be processed
 - Force: force the recalculation of diagrams that have already been processed
 
 
# Running jobs on a cluster where we reserve complete nodes
 - The requested memory should be the product of average memory requirement per single task times
   the number of simultaneous GNU parallel jobs. For example, for 4GB per task and 8 jobs we need
   at least 32 GB of RAM.
 - The number slices specifies the total number of jobs to be processed by a node. In general, the total
   number of single tasks divivded by the number of requested nodes should be a good number
