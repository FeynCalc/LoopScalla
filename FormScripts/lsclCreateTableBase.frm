* This file is a part of LoopScalla, a framework for loop calculations
* LoopScalla is covered by the GNU General Public License 3.
* Copyright (C) 2019-2025 Vladyslav Shtabovenko

off statistics;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric

#message lsclCreateTableBase: Project: `lsclProjectName'
#message lsclCreateTableBase: Process: `lsclProcessName'
#message lsclCreateTableBase: Model: `lsclModelName'
#message lsclCreateTableBase: Processing topology `lsclTopologyName' at `lsclNLoops' loop(s)


#ifdef `LSCLKIRA'

#ifdef `LSCLEPEXPAND'
        #message lsclCreateTableBase: Using the fill statements expanded in ep up to `LSCLEPEXPAND'        
        #define LSCLFILLSTATEMENTSFILENAME "fillStatementsKiraExpanded`LSCLEPEXPAND'.frm"
        #define LSCLTBLFILENAME "tablebaseKiraExpanded`LSCLEPEXPAND'.tbl"        
#else
    #message lsclCreateTableBase: Using ep-exact reduction tables
    #define LSCLFILLSTATEMENTSFILENAME "fillStatementsKira.frm"
    #define LSCLTBLFILENAME "tablebaseKira.tbl"
#endif


#else

#ifdef `LSCLEPEXPAND'
        #message lsclCreateTableBase: Using the fill statements expanded in ep up to `LSCLEPEXPAND'        
        #define LSCLFILLSTATEMENTSFILENAME "fillStatementsFireExpanded`LSCLEPEXPAND'.frm"
        #define LSCLTBLFILENAME "tablebaseFireExpanded`LSCLEPEXPAND'.tbl"        
#else
    #message lsclCreateTableBase: Using ep-exact reduction tables
    #define LSCLFILLSTATEMENTSFILENAME "fillStatementsFire.frm"
    #define LSCLTBLFILENAME "tablebaseFire.tbl"
#endif

#endif


#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLFILLSTATEMENTSFILENAME' #lsclCurrentTopologyDefinitions

CF 
#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLFILLSTATEMENTSFILENAME' #lsclTopologyNames
;

#ifndef `LSCLCURRENTNPROPS'
#message lsclCreateTableBase: Error, number of propagators is undefined.
exit;
#endif

Table,sparse,zerofill,strict,tabIBP`lsclTopologyName'(`LSCLCURRENTNPROPS');


#include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLFILLSTATEMENTSFILENAME' #lsclFillStatements
.sort 

TableBase "Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLTBLFILENAME'" create;
TableBase "Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Reductions/`lsclTopologyName'/`LSCLTBLFILENAME'" addto tabIBP`lsclTopologyName';


.sort
#message lsclCreateTableBase: Creation of reduction tables completed successfully.

.end
