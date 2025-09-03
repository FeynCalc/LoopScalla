#procedure lsclLoadTensorSymmetries(MAXRANK,MINRANK)

* lsclLoadTensorSymmetries() loads symmetries between tensor integral numerators
* that were previously generated with FeynCalc. By default, symmetries for integrals
* up to rank 20 and up to 6 loops are already included in Tables/TensorReductions/TdRules.
* When applying the symmetries, each numerator is being mapped to a symbol of the form
* lsclTd1..2..3... The names of all these symbols are then loaded into the corresponding
* dollar variables lsclDollarTdRankXXXLYYYYNZZZ using the files located in 
* Tables/TensorReductions/TdNames.

#do i=1,`lsclNLoops'

#include Tables/TensorReductions/TdRules/lsclRulesRedTypeToTdRank1To10L`i'.frm

#if (``MAXRANK'' > 10)
#include Tables/TensorReductions/TdRules/lsclRulesRedTypeToTdRank11To20L`i'.frm
#endif

#do j=``MINRANK'',``MAXRANK''
#if (`lsclPprVerbosity'>0)
#message lsclDoTensorReduction: Loading tensor reduction names, rank `j' and `i' loop(s)
#endif

#if (`i' <= `j')
#include Tables/TensorReductions/TdNames/lsclAllTdNamesRank`j'L`i'.frm
#else 
#include Tables/TensorReductions/TdNames/lsclAllTdNamesRank`j'L`j'.frm
#endif


label labelTdMappingDone;
.sort

#enddo

#enddo

#endprocedure