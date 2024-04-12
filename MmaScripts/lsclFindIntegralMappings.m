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
(*$lsclDEBUG=True;
If[TrueQ[$lsclDEBUG],
lsclProject="BToEtaC";
lsclProcessName="QbQubarToWQQubar";
lsclModelName="BToEtaC";
lsclNLoops="3";
lsclNKernels="8";
];*)


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


WriteString["stdout",lsclScriptName,": Final number of master integrals: ", Length[mappings[[2]]] ,".\n"];


WriteString["stdout",lsclScriptName,": Final number of contributing topologies: ", Length[Union[First/@mappings[[2]]]] ,".\n"];


tmp=FCLoopTopologyNameToSymbol[mappings[[1]]]//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;
tmp2=StringReplace["id "<>ToString[#,InputForm]<>";",{"->"->"=","["->"(","]"->")","formAnything"->"?a"}]&/@tmp;
formMappings="*--#[ lsclMasterIntegralMappings:\n"<>StringRiffle[ToString/@(tmp2),"\n"]<>"\n*--#] lsclMasterIntegralMappings:\n";


file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappings.frm"}]];
WriteString[file,formMappings];
Close[file];


Put[mappings,FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappings.m"}]];


mappings=Get[FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","MasterIntegralMappings.m"}]];


Put[mappings[[2]],FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"LoopIntegrals","FinalMasterIntegrals.m"}]];


Quiet[CreateDirectory[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName,
lsclNLoops,"MasterIntegrals"}]]];


WriteString[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName,
lsclNLoops,"MasterIntegrals","IntegralsList.txt"}],StringRiffle[ToString/@FCLoopGLIToSymbol/@mappings[[2]],"\n"]]


(*FCReloadAddOns[{"FeynHelpers"}]
AbsoluteTiming[PSDCreatePythonScripts[mappings[[2]],fcTopologies,FileNameJoin[{Directory[],"Projects",lsclProject,
	"Diagrams","Output",lsclProcessName,lsclModelName,lsclNLoops,"MasterIntegrals","pySecDec"}],
	PSDRealParameterRules->{u0b->11,meta->1,gkin->1},OverwriteTarget->True,Check->False,FCVerbose->0,PSDRequestedOrder->-1];]*)


WriteString["stdout","All done.\n"];
