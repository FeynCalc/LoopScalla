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
Get[FileNameJoin[{projectDirectory,"FeynCalc","FeynCalc.m"}]];


(*For debugging purposes*)
(*
$lsclDEBUG=True;
If[TrueQ[$lsclDEBUG],
lsclProject="BToEtaC";
lsclProcessName="QbQubarToWQQubar";
lsclModelName="BToEtaC";
lsclNLoops="3";
lsclNKernels="8";
];
*)


lsclScriptName="lsclFindIntegralMappings";


If[ $FrontEnd===Null && $lsclDEBUG===True,	
	WriteString["stdout",lsclScriptName,": Error! Detected debugging during the productive run."];
	QuitAbort[]
];

If[ ToString[lsclProject]==="lsclProject",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","project."];
	QuitAbort[]
];

If[ ToString[lsclProcessName]==="lsclProcessName",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","process."];
	QuitAbort[]
];

If[ ToString[lsclModelName]==="lsclModelName",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","model."];	
	QuitAbort[]
];

If[ ToString[lsclNLoops]==="lsclNLoops",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","number of loops."];	
	QuitAbort[]
];


If[ ToString[lsclNKernels]==="lsclNKernels",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","number of parallel kernels."];	
	QuitAbort[]
];


WriteString["stdout",lsclScriptName,": Loading the topologies and master integrals ..."];
filesLoaded=Catch[
	fcTopologies=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];
	fcMasters=Get/@FileNames["FireMasterIntegrals.m",{FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Reductions","*"}]}];
	,
	$Failed
];
If[filesLoaded===$Failed,
	Print["ERROR! Cannot load the integrals file."];
	QuitAbort[]
];
WriteString["stdout"," done\n"];


glis=Cases2[fcMasters,GLI];


WriteString["stdout",lsclScriptName,": Naive number of master integrals: ", Length[glis] ,".\n"];


WriteString["stdout",lsclScriptName,": Launching ", lsclNKernels, " parallel kernels ..."];
CloseKernels[Kernels[]];
LaunchKernels[ToExpression[lsclNKernels]];
$ParallelizeFeynCalc=True;
WriteString["stdout"," done\n"];


AbsoluteTiming[mappings=FCLoopFindIntegralMappings[glis,fcTopologies,FCVerbose->1];]


Put[mappings,FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappings.m"}]];
WriteString["stdout","All done.\n"];
