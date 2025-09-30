* Standard Feynman rules for external states
#include lsclCommonFeynmanRules.h #lsclFeynmanRulesPolVectors
#include lsclCommonFeynmanRules.h #lsclFeynmanRulesSpinors

* QCD interactions (always involve gluons)
#include lsclPropagatorsQCD.h #lsclFeynmanRulesQCDPropagatorsRXiGauge
#include lsclVerticesQCD.h #lsclFeynmanRulesQCDVertices

* EW interactions (all the remaining SM fields)

#if (`lsclModelName'=="UnitarySM")
#message lsclInsertFeynmanRules: Using unitary gauge propagators for the EW vectors bosons
#include lsclPropagatorsEW.h #lsclFeynmanRulesEWPropagatorsUnitaryGauge
#else
#include lsclPropagatorsEW.h #lsclFeynmanRulesEWPropagatorsRXiGauge
#endif

#include lsclVerticesEW.h #lsclFeynmanRulesLeptonsFFV
#include lsclVerticesEW.h #lsclFeynmanRulesQuarksFFV
#include lsclVerticesEW.h #lsclFeynmanRulesLeptonsFFS
#include lsclVerticesEW.h #lsclFeynmanRulesQuarksFFS
#include lsclVerticesEW.h #lsclFeynmanRulesGaugeBosonsVVV
#include lsclVerticesEW.h #lsclFeynmanRulesGaugeBosonsVVVV
#include lsclVerticesEW.h #lsclFeynmanRulesGoldstoneBosonsSSS
#include lsclVerticesEW.h #lsclFeynmanRulesGoldstoneBosonsSSSS
#include lsclVerticesEW.h #lsclFeynmanRulesGaugeGoldstoneBosonsSVV
#include lsclVerticesEW.h #lsclFeynmanRulesGaugeGoldstoneBosonsSSV
#include lsclVerticesEW.h #lsclFeynmanRulesGaugeGoldstoneBosonsSSVV
#include lsclVerticesEW.h #lsclFeynmanRulesGaugeGhostsGGV
#include lsclVerticesEW.h #lsclFeynmanRulesGhostGoldstonesGGS

* Here one can enter Feynman rules specific to the process that are 
* not already included in the standard set

* #include MyModel.h #lsclFeynmanRulesXYZ

* Standard code for converting QGRAFs notation for indices into proper
* FORM code
#include lsclCommonFeynmanRules.h #lsclConversionRulesTensorsAndIndices
