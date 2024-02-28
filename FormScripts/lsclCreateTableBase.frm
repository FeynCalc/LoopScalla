off statistics;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric


#message lsclCreateTableBase: `lsclProjectName'
#message lsclCreateTableBase: `lsclProcessName'
#message lsclCreateTableBase: `lsclNLoops'
#message lsclCreateTableBase: `lsclTopologyName'

#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/fillStatements.frm #lsclCurrentTopologyDefinitions

CF 
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/fillStatements.frm #lsclTopologyNames
;

#ifndef `LSCLCURRENTNPROPS'
#message lsclCreateTableBase: Error, number of propagators is undefined.
exit;
#endif

Table,sparse,zerofill,strict,tabIBP`lsclTopologyName'(`LSCLCURRENTNPROPS');


#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/fillStatements.frm #lsclFillStatements
.sort 

TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/tablebase.tbl" create;
TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/tablebase.tbl" addto tabIBP`lsclTopologyName';


.sort
#message lsclCreateTableBase: Creation of reduction tables completed successfully.

.end
