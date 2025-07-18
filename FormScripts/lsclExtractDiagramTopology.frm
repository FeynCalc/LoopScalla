* This file is a part of LoopScalla, a framework for loop calculations
* LoopScalla is covered by the GNU General Public License 3.
* Copyright (C) 2019-2025 Vladyslav Shtabovenko

on shortstats;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h

#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric

.global

#message lsclExtractDiagamTopology: Project: `lsclProjectName'
#message lsclExtractDiagamTopology: Process: `lsclProcessName'
#message lsclExtractDiagamTopology: Model: `lsclModelName'
#message lsclExtractDiagamTopology: Processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)

G s0dia`lsclDiaNumber'L`lsclNLoops' =
  #include Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/dia`lsclDiaNumber'L`lsclNLoops'.frm # dia`lsclDiaNumber'L`lsclNLoops'


#message lsclExtractDiagamTopology: Calling the ExtractDiagramTopology fold : `time_' ...
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclExtractDiagramTopology
#message lsclExtractDiagamTopology: ... done.


#message lsclExtractDiagamTopology: Calling sort : `time_' ...
.sort
#message lsclExtractDiagamTopology: ... done: `time_'

format Mathematica;
#write <Projects/`lsclProjectName'/Diagrams/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/DiagramTopology/Mma/`lsclDiaNumber'L`lsclNLoops'.m> "(%E)", s0dia`lsclDiaNumber'L`lsclNLoops'
	
#message lsclExtractDiagamTopology: Done processing diagram `lsclDiaNumber' at `lsclNLoops' loop(s)
#message lsclExtractDiagamTopology: Extraction completed successfully.

.end

