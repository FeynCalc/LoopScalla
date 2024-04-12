(* ::Package:: *)

QuitAbort[]:=
If[$FrontEnd===Null,
	Quit[1],
	Abort[]
];
If[$FrontEnd===Null,
	projectDirectory=ParentDirectory@DirectoryName[$InputFileName],
	projectDirectory=ParentDirectory@NotebookDirectory[]
];
SetDirectory[projectDirectory];


$FeynCalcStartupMessages=False;
$LoadAddOns={"FeynHelpers"};
Get[FileNameJoin[{projectDirectory,"FeynCalc","FeynCalc.m"}]];


(*For debugging purposes*)
(*
$lsclDEBUG=True;
If[TrueQ[$lsclDEBUG],
lsclProject="QCDTests";
lsclProcessName="GlToGl";
lsclModelName="TwoFlavorQCD";
lsclNLoops="1";
lsclTopologyName="topology1";
];
*)


If[$FrontEnd===Null && $lsclDEBUG===True,
	Print["ERROR! Detected debugging during the productive run."];
	QuitAbort[]
];

If[ToString[lsclProject]==="lsclProject",
	Print["ERROR! You did not specify the project."];
	QuitAbort[]
];
If[ToString[lsclProcessName]==="lsclProcessName",
	Print["ERROR! You did not specify the process."];
	QuitAbort[]
];
If[ToString[lsclModelName]==="lsclModelName",
	Print["ERROR! You did not specify the model."];
	QuitAbort[]
];
If[ToString[lsclNLoops]==="lsclNLoops",
	Print["ERROR! You did not specify the number of loops."];
	QuitAbort[]
];
If[ToString[lsclNLoops]==="lsclTopologyName",
	Print["ERROR! You did not specify the topology."];
	QuitAbort[]
];


WriteString["stdout","Loading the integrals ..."];
filesLoaded=Catch[
	file=FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"LoopIntegrals","Mma",lsclTopologyName<>".m"}];
	fcConfig=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Shared","lsclMmaConfig.m"}]];
	lsclSymbolicTopologyName=ToExpression[lsclTopologyName];
	integrals=Cases2[Get[file],lsclSymbolicTopologyName]/. lsclSymbolicTopologyName[inds__Integer]:> GLI[lsclTopologyName,{inds}];
	fcTopologies=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];	
	,
	$Failed
];
If[filesLoaded===$Failed,
	Print["ERROR! Cannot load the integrals file."];
	QuitAbort[]
];
WriteString["stdout","done\n"];


WriteString["stdout","lsclFindTopologies: Working with ", lsclTopologyName,".\n\n"]


fcVariables="FCVariables"/.fcConfig;
If[ToString[fcVariables]=!="fcVariables" && MatchQ[fcVariables,{__Symbol}],
	WriteString["stdout","lsclFindTopologies: Symbols to be declared as FCVariable: ", fcVariables,".\n\n"];
	(DataType[#,FCVariable]=True)&/@fcVariables;
];


ExtraReplacementsForTheReduction="ExtraReplacementsForTheReduction"/.fcConfig;
If[MatchQ[ExtraReplacementsForTheReduction,{___}],
	WriteString["stdout","lsclFindTopologies: Extra replacements for the reduction: ", ExtraReplacementsForTheReduction,".\n\n"],
	WriteString["stdout","lsclFindTopologies: Error, something went wrong when loading the additional replacements for the reduction."];
	QuitAbort[]
];


NumberOfCoresForReduction="NumberOfCoresForReduction"/.fcConfig;
If[MatchQ[NumberOfCoresForReduction,Integer_?Positive],
	WriteString["stdout","lsclFindTopologies: Number of cores for the reduction: ", NumberOfCoresForReduction,".\n\n"],
	WriteString["stdout","lsclFindTopologies: Error, something went wrong when setting the number of cores for the reduction."];
	QuitAbort[]
]


fcVariables="FCVariables"/.fcConfig;
If[ToString[fcVariables]=!="fcVariables" && MatchQ[fcVariables,{__Symbol}],
	WriteString["stdout","lsclFindTopologies: Symbols to be declared as FCVariable: ", fcVariables,".\n\n"];
	(DataType[#,FCVariable]=True)&/@fcVariables;
];


dirReductions=FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Reductions"}];


currentTopology=SelectNotFree[fcTopologies,lsclTopologyName];


(*currentTopology=FCLoopSelectTopology[integrals[[1]],fcTopologies];*)


WriteString["stdout","Preparing start files ... "];
FIREPrepareStartFile[currentTopology,dirReductions,Check->False,
FIREPath:>environment["lsclFireMmaPath"],StringReplace->{"environment"->"Environment"},
FIREParallel->4,
FinalSubstitutions->ExtraReplacementsForTheReduction
];
WriteString["stdout","done\n"];


WriteString["stdout","Preparing integral files ...","\n\n"];
FIRECreateIntegralFile[integrals,currentTopology,dirReductions,Check->False];
WriteString["stdout","done\n"];


(*TODO: This should be done via the config files...*)


WriteString["stdout","Preparing config files ... "];
topoNameAsString=ToString[currentTopology[[1]][[1]]];
FIRECreateConfigFile[currentTopology,dirReductions,Variables->fcVariables,
FIREFthreads->2 NumberOfCoresForReduction,
FIRELthreads->8,
FIRESthreads->NumberOfCoresForReduction,
FIREThreads->NumberOfCoresForReduction
];
FIRECreateConfigFile[currentTopology,{FileNameJoin[{dirReductions,topoNameAsString,topoNameAsString<>"-16c.config"}]},
Variables->fcVariables,
FIREFthreads->2*16,
FIRELthreads->8,
FIRESthreads->16,
FIREThreads->16
];
FIRECreateConfigFile[currentTopology,{FileNameJoin[{dirReductions,topoNameAsString,topoNameAsString<>"-KIT-16c.config"}]},
Variables->fcVariables,
FIREFthreads->2*16,
FIRELthreads->8,
FIRESthreads->16,
FIREThreads->16,
FIREDatabase->"/formswap/shtabovenko/"<>topoNameAsString
];
FIRECreateConfigFile[currentTopology,{FileNameJoin[{dirReductions,topoNameAsString,topoNameAsString<>"-KIT-8c.config"}]},
Variables->fcVariables,
FIREFthreads->2*8,
FIRELthreads->4,
FIRESthreads->8,
FIREThreads->8,
FIREDatabase->"/formswap/shtabovenko/"<>topoNameAsString
];
FIRECreateConfigFile[currentTopology,{FileNameJoin[{dirReductions,topoNameAsString,topoNameAsString<>"-KIT-8c-extra.config"}]},
Variables->fcVariables,
FIREOutput->"extra-"<>topoNameAsString<>".tables",
FIREIntegrals->"ExtraLoopIntegrals.m",
FIREFthreads->2*8,
FIRELthreads->4,
FIRESthreads->8,
FIREThreads->8,
FIREDatabase->"/formswap/shtabovenko/"<>topoNameAsString
];
FIRECreateConfigFile[currentTopology,{FileNameJoin[{dirReductions,topoNameAsString,topoNameAsString<>"-KIT-8c-extra2.config"}]},
Variables->fcVariables,
FIREOutput->"extra2-"<>topoNameAsString<>".tables",
FIREIntegrals->"Extra2LoopIntegrals.m",
FIREFthreads->2*8,
FIRELthreads->4,
FIRESthreads->8,
FIREThreads->8,
FIREDatabase->"/formswap/shtabovenko/"<>topoNameAsString
];

WriteString["stdout","done\n"];


WriteString["stdout","All done.\n"];
