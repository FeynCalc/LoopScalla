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
lsclProject="BToEtaC";
lsclProcessName="QbQubarToWQQubar";
lsclModelName="BToEtaC";
lsclNLoops="3";
lsclTopology="topology5725";
];
*)


lsclScriptName="lsclFireImportResults";


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

If[ToString[lsclTopology]==="lsclTopology",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","topology."];
	QuitAbort[]
];


WriteString["stdout","Loading the topologies ..."];
filesLoaded=Catch[
	fcConfig=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Shared","lsclMmaConfig.m"}]];
	fcTopologies=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];	
	,
	$Failed
];
If[filesLoaded===$Failed,
	Print["ERROR! Cannot load the integrals file."];
	QuitAbort[]
];
WriteString["stdout"," done\n"];


ExtraReplacementsForTheReduction="ExtraReplacementsForTheReduction"/.fcConfig;
If[MatchQ[ExtraReplacementsForTheReduction,{__}],
	WriteString["stdout",lsclScriptName,": Extra replacements for the reduction: ", ExtraReplacementsForTheReduction,".\n\n"],
	WriteString["stdout",lsclScriptName,": Error, something went wrong when loading the additional replacements for the reduction."];
	QuitAbort[]
];


fileReductionTable=FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,
lsclModelName, lsclNLoops,"Reductions",lsclTopology,lsclTopology<>".tables"}];


fileExtraReductionTable=FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,
lsclModelName, lsclNLoops,"Reductions",lsclTopology,"extra-"<>lsclTopology<>".tables"}];


fileExtra2ReductionTable=FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,
lsclModelName, lsclNLoops,"Reductions",lsclTopology,"extra2-"<>lsclTopology<>".tables"}];


reductionRulesRaw=FIREImportResults[lsclTopology,fileReductionTable,FCReplaceD->{d->lsclD}]//Flatten;


WriteString["stdout","Number of reduction rules: ", Length[reductionRulesRaw] ,".\n"];


If[FileExistsQ[fileExtraReductionTable],
	WriteString["stdout","Loading extra reduction tables ..."];
	reductionRulesExtraRaw=FIREImportResults[lsclTopology,fileExtraReductionTable,FCReplaceD->{d->lsclD}]//Flatten;
	WriteString["stdout"," done\n"];
	WriteString["stdout","Number of extra reduction rules: ", Length[reductionRulesExtraRaw] ,".\n"];
	reductionRulesRaw=Join[reductionRulesRaw,reductionRulesExtraRaw]	
];


If[FileExistsQ[fileExtra2ReductionTable],
	WriteString["stdout","Loading extra 2 reduction tables ..."];
	reductionRulesExtraRaw=FIREImportResults[lsclTopology,fileExtra2ReductionTable,FCReplaceD->{d->lsclD}]//Flatten;
	WriteString["stdout"," done\n"];
	WriteString["stdout","Number of extra reduction rules: ", Length[reductionRulesExtraRaw] ,".\n"];
	reductionRulesRaw=Join[reductionRulesRaw,reductionRulesExtraRaw]	
];


glisRaw=Cases2[Last/@reductionRulesRaw,GLI];


WriteString["stdout","Number of preliminary master integrals: ", Length[glisRaw] ,".\n"];


miRules=FCLoopFindIntegralMappings[glisRaw,fcTopologies];


WriteString["stdout","Number of final master integrals: ", Length[miRules[[2]]] ,".\n"];


aux=Transpose[reductionRulesRaw/.Rule->List];


reductionRules=Rule@@@Transpose[{aux[[1]],aux[[2]]/.Dispatch[miRules[[1]]]}]/.ExtraReplacementsForTheReduction;


tmp=FCLoopTopologyNameToSymbol[miRules[[2]]]//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;
tmp2=StringReplace[ToString[#,InputForm],{"=="->"=","["->"(","]"->")","formAnything"->"?a"}]&/@tmp;
formMIs="*--#[ lsclMasterIntegrals:\n"<>StringRiffle[ToString/@(tmp2),",\n"]<>"\n*--#] lsclMasterIntegrals:\n";


WriteString["stdout",lsclScriptName,": Saving the results ... "];



file=OpenWrite[FileNameJoin[{DirectoryName[fileReductionTable],"FireMasterIntegrals.frm"}]];
WriteString[file,formMIs];
Close[file];


Put[reductionRules,FileNameJoin[{DirectoryName[fileReductionTable],"FireReductionRules.m"}]]
Put[miRules[[2]],FileNameJoin[{DirectoryName[fileReductionTable],"FireMasterIntegrals.m"}]]
WriteString["stdout","done.\n"];


WriteString["stdout","All done.\n"];
