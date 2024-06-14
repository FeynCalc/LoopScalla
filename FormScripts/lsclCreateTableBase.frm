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

#ifdef `LSCLEPEXPAND'
#message lsclCreateTableBase: Using reduction tables expanded in ep
#define LSCLFILLSTATEMENTSFILENAME "fillStatementsExpanded.frm"
#define LSCLTBLFILENAME "tablebaseExpanded.tbl"
#else
#message lsclCreateTableBase: Using ep-exact reduction tables
#define LSCLFILLSTATEMENTSFILENAME "fillStatements.frm"
#define LSCLTBLFILENAME "tablebase.tbl"
#endif

#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLFILLSTATEMENTSFILENAME' #lsclCurrentTopologyDefinitions

CF 
#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLFILLSTATEMENTSFILENAME' #lsclTopologyNames
;

#ifndef `LSCLCURRENTNPROPS'
#message lsclCreateTableBase: Error, number of propagators is undefined.
exit;
#endif

Table,sparse,zerofill,strict,tabIBP`lsclTopologyName'(`LSCLCURRENTNPROPS');


#include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLFILLSTATEMENTSFILENAME' #lsclFillStatements
.sort 

TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLTBLFILENAME'" create;
TableBase "Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLTBLFILENAME'" addto tabIBP`lsclTopologyName';


.sort
#message lsclCreateTableBase: Creation of reduction tables completed successfully.

.end
