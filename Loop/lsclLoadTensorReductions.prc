#procedure lsclLoadTensorReductions(MAXRANK,MINRANK,MAXNLEGS,MINNLEGS)

* lsclLoadTensorReductions() loads symmetries between tensor integral numerators
* that were previously generated with FeynCalc. By default, symmetries for integrals
* up to rank 20 and up to 6 loops are already included in Tables/TensorReductions/TdRules.
* When applying the symmetries, each numerator is being mapped to a symbol of the form
* lsclTd1..2..3... The names of all these symbols are then loaded into the corresponding
* dollar variables lsclDollarTdRankXXXLYYYYNZZZ using the files located in 
* Tables/TensorReductions/TdNames.

#message lsclLoadTensorReductions: Loading reduction rules : `time_' ...

* Loading reduction rules

* Outer loop: number of legs
#do i=``MINNLEGS'',``MAXNLEGS''

#message lsclLoadTensorReductions: Processing integrals with `i' legs : `time_' ...

* First we map the number of legs to the corresponding directory
#switch `i'

#case 0
#define LSCLTDECDIRNAME "Tadpole";
#break

#case 1
#define LSCLTDECDIRNAME "Bubble";
#break

#case 2
#define LSCLTDECDIRNAME "Triangle";
#break

#case 3
#define LSCLTDECDIRNAME "Box";
#break

#case 4
#define LSCLTDECDIRNAME "Pentagon";
#break

#case 5
#define LSCLTDECDIRNAME "Hexagon";
#break

#case 6
#define LSCLTDECDIRNAME "Heptagon";
#break

#case 7
#define LSCLTDECDIRNAME "Octagon";
#break

#default
exit "Unsupported number of legs";
#break

#endswitch


* Inner loop: number of loops
#do j=1,`lsclNLoops'

*#if (`lsclPprVerbosity'>0)
#message lsclDoTensorReduction: Loading tensor reduction rules at `j' loop(s)
*#endif

* Inner loop: tensor rank
#do k=``MINRANK'',``MAXRANK''


#if (`j' <= `k')

#do l=1, `$lsclDollarTdRank`k'L`j'NumTotal'
#if (`lsclPprVerbosity'>0)
#message lsclLoadTensorReductions: Loading tensor reduction rule: `LSCLTDECDIRNAME'/`$lsclDollarTdRank`k'L`j'N`l''.frm
#endif
#include Tables/TensorReductions/`LSCLTDECDIRNAME'/`$lsclDollarTdRank`k'L`j'N`l''.frm
label labelTdReductionDone;
.sort
#enddo

#else

#do l=1, `$lsclDollarTdRank`k'L`k'NumTotal'
#if (`lsclPprVerbosity'>0)
#message lsclLoadTensorReductions: Loading tensor reduction rule: `LSCLTDECDIRNAME'/`$lsclDollarTdRank`k'L`k'N`l''.frm
#endif
#include Tables/TensorReductions/`LSCLTDECDIRNAME'/`$lsclDollarTdRank`k'L`k'N`l''.frm
label labelTdReductionDone;
.sort
#enddo

#endif



#enddo
#enddo
#enddo



#message lsclLoadTensorReductions: ... done : `time_'

* Remove the flags multiplying the scalar piece
multiply replace_(lsclTensRedMomenta,lsclTensRedMomentaRaw);
id lsclTensRedLoop()*lsclTensRedRank(0)*lsclTensRedNLegs(lsclS?)*lsclTensRedMomentaRaw(?b)*lsclTensRedType() = 1;



if (occurs(lsclTensRedLoop,lsclTensRedMomenta));
print "lsclLoadTensorReductions: Error, tensor integrals were not reduced, e.g.: %t";
endif;
if (occurs(lsclTensRedLoop,lsclTensRedMomenta)) exit;

#endprocedure
