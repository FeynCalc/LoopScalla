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
lsclTopology="topology5635";
lsclExpandInEp=1;
lsclNKernels=4;
lsclEpExpandUpTo=0;
lsclUsingKira=0;
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

If[ToString[lsclExpandInEp]==="lsclExpandInEp",
	WriteString["stdout",lsclScriptName,": Error! You did not specify whether the tables should be expanded in ep."];
	QuitAbort[]
];

If[ToString[lsclUsingKira]==="lsclUsingKira",
	WriteString["stdout",lsclScriptName,": Error! You did not specify whether FIRE or KIRA were used."];
	QuitAbort[]
];


If[ !MatchQ[lsclNKernels,_Integer?Positive],
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","number of parallel kernels."];	
	QuitAbort[]
];


If[ (lsclExpandInEp===1) && (!MatchQ[lsclEpExpandUpTo,_Integer] || lsclEpExpandUpTo===999),
	WriteString["stdout",lsclScriptName,": Error! You did not specify the desired order of the ep-expansion."];	
	QuitAbort[],
	If[lsclExpandInEp===1,
		WriteString["stdout",lsclScriptName,": Desired ep-expansion order: ", lsclEpExpandUpTo,"\n\n"],
		WriteString["stdout",lsclScriptName,": No ep-expansion of the reduction tables.\n\n"];
	]
];


If[lsclExpandInEp===1,
WriteString["stdout",lsclScriptName,": Launching ", lsclNKernels, " parallel kernels ..."];
CloseKernels[Kernels[]];
LaunchKernels[ToExpression[lsclNKernels]];
WriteString["stdout"," done\n"];
WriteString["stdout",lsclScriptName,": Available kernels: ", Kernels[]];
If[Kernels[]==={},
	Print["ERROR! Something went wrong when launching parallel kernels."];
	QuitAbort[]
];
$ParallelizeFeynCalc=True;
WriteString["stdout"," done\n"];
];


If[TrueQ[lsclUsingKira===1],
	usingKIRA=True,
	usingKIRA=False
];


WriteString["stdout",lsclScriptName,": Loading the integrals ..."];
filesLoaded=Catch[
	lsclSymbolicTopologyName=ToExpression[lsclTopology];
	file=FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"LoopIntegrals","Mma",lsclTopology<>".m"}];	
	integrals=Cases2[Get[file],lsclSymbolicTopologyName]/. lsclSymbolicTopologyName[inds__Integer]:> GLI[lsclTopology,{inds}];	
	,
	$Failed
];
If[filesLoaded===$Failed,
	Print["ERROR! Cannot load the integrals file."];
	QuitAbort[]
];
WriteString["stdout"," done\n"];


WriteString["stdout",lsclScriptName,": Loading the topologies ..."];
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
If[MatchQ[ExtraReplacementsForTheReduction,{___}],
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


kiraReductionTable=FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,
lsclModelName, lsclNLoops,"Reductions",lsclTopology,"results",lsclTopology,"kira_KiraLoopIntegrals.m"}];


fileKiraMasters=FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,
lsclModelName, lsclNLoops,"Reductions",lsclTopology,"results",lsclTopology,"masters"}];


WriteString["stdout",lsclScriptName,": Loading the reduction tables ..."];


If[!usingKIRA,
reductionRulesRaw=FIREImportResults[lsclTopology,fileReductionTable,FCReplaceD->{d->lsclD}]//Flatten,
reductionRulesRaw=KiraImportResults[lsclTopology,kiraReductionTable,FCReplaceD->{d->lsclD}]//Flatten;
kiraMasters=StringSplit[Import[fileKiraMasters,"Text"],"\n"];
kiraMasters=ToExpression/@StringReplace[kiraMasters,"#"~~__->""]/.id_[ints__Integer]:>GLI[ToString[id],{ints}];
reductionRulesRaw=Join[reductionRulesRaw,Thread[Rule[kiraMasters,kiraMasters]]];
];


(*reductionRulesRaw=KiraImportResults[lsclTopology,
"/media/Data/Projects/VS/LoopScalla/Projects/BToEtaC/Diagrams/Output/QbQubarToWQQubar/BToEtaC/3/Reductions/"<>lsclTopology<>"/results/"<>lsclTopology<>"/kira_KiraLoopIntegrals.m",FCReplaceD->{d->lsclD}]//Flatten;*)


(*aux1=StringSplit[Import["/media/Data/Projects/VS/LoopScalla/Projects/BToEtaC/Diagrams/Output/QbQubarToWQQubar/BToEtaC/3/Reductions/"<>lsclTopology<>"/results/"<>lsclTopology<>"/masters","Text"],"\n"];
masters=ToExpression/@StringReplace[aux1,"#"~~__->""]/.id_[ints__Integer]:>GLI[ToString[id],{ints}];*)





WriteString["stdout"," done\n"];


WriteString["stdout",lsclScriptName,": Number of reduction rules: ", Length[reductionRulesRaw] ,".\n"];


If[FileExistsQ[fileExtraReductionTable] && !usingKIRA,
	WriteString["stdout",lsclScriptName,": Loading extra reduction tables ..."];
	reductionRulesExtraRaw=FIREImportResults[lsclTopology,fileExtraReductionTable,FCReplaceD->{d->lsclD}]//Flatten;
	WriteString["stdout"," done\n"];
	WriteString["stdout",lsclScriptName,": Number of extra reduction rules: ", Length[reductionRulesExtraRaw] ,".\n"];
	reductionRulesRaw=Join[reductionRulesRaw,reductionRulesExtraRaw]	
];


If[FileExistsQ[fileExtra2ReductionTable] && !usingKIRA,
	WriteString["stdout",lsclScriptName,": Loading extra 2 reduction tables ..."];
	reductionRulesExtraRaw=FIREImportResults[lsclTopology,fileExtra2ReductionTable,FCReplaceD->{d->lsclD}]//Flatten;
	WriteString["stdout"," done\n"];
	WriteString["stdout",lsclScriptName,": Number of extra reduction rules: ", Length[reductionRulesExtraRaw] ,".\n"];
	reductionRulesRaw=Join[reductionRulesRaw,reductionRulesExtraRaw]	
];


checkLHS=Union[integrals];
checkRHS=Union[First/@reductionRulesRaw];


If[!usingKIRA,
	If[Complement[checkLHS,checkRHS]=!={},
		Print["ERROR! Some of the original integrals were not reduced:", Complement[checkLHS,checkRHS]];
		QuitAbort[]
	],
	If[Complement[Complement[checkLHS,checkRHS],kiraMasters]=!={},
		Print["ERROR! Some of the original integrals were not reduced:", Complement[checkLHS,checkRHS]];
		QuitAbort[]
	]
];


glisRaw=Cases2[Last/@reductionRulesRaw,GLI];


WriteString["stdout",lsclScriptName,": Number of preliminary master integrals: ", Length[glisRaw] ,".\n"];


miRules=FCLoopFindIntegralMappings[glisRaw,fcTopologies];


WriteString["stdout",lsclScriptName,": Number of final master integrals: ", Length[miRules[[2]]] ,".\n"];


aux=Transpose[reductionRulesRaw/.Rule->List];


reductionRules=Rule@@@Transpose[{aux[[1]],aux[[2]]/.Dispatch[miRules[[1]]]}]/.ExtraReplacementsForTheReduction;


lhsIntegrals=First/@reductionRules;


mastersToMasterRules=Map[If[FreeQ[lhsIntegrals,#],#->#,Unevaluated[Sequence[]]]&,miRules[[2]]];


reductionRules=Join[reductionRules,mastersToMasterRules];


If[lsclExpandInEp===1,
	WriteString["stdout",lsclScriptName,": Extracting unique prefactors of master integrals ... "];
	AbsoluteTiming[aux1=Collect2[reductionRules,GLI,Factoring->pref,FCParallelize->True];];
	ClearAll[pref];
	pref[x_Integer]:=x;
	uniquePrefs=Cases2[aux1,pref];
	WriteString["stdout","done.\n"];
	WriteString["stdout",lsclScriptName,": Number of prefactors: ", Length[uniquePrefs],".\n"];
	WriteString["stdout",lsclScriptName,": Their leafcount: ", LeafCount[uniquePrefs],".\n"];
	
	WriteString["stdout",lsclScriptName,": Expanding each prefactor using Series ... "];
	uniquePrefsEval = uniquePrefs/.pref->Identity/. lsclD-> 4- 2 lsclEp;
	DistributeDefinitions[lsclEpExpandUpTo];
	AbsoluteTiming[uniquePrefsEval=ParallelMap[(Normal[Series[#,{lsclEp,0,lsclEpExpandUpTo}]]+lsclEpHelpFlag[lsclEpExpandUpTo+1]*lsclEp^(lsclEpExpandUpTo+1))&,
	uniquePrefsEval,DistributedContexts -> None,Method->"ItemsPerEvaluation"->Ceiling[N[Length[uniquePrefsEval]/ToExpression[lsclNKernels]]/10]];];
	
	WriteString["stdout","done.\n"];
	WriteString["stdout",lsclScriptName,": New leafcount: ", LeafCount[uniquePrefsEval],".\n"];
	
	WriteString["stdout",lsclScriptName,": Inserting the replacement rule ... "];
(*	
	AbsoluteTiming[reductionRulesExpanded=aux1/.Dispatch[repRule];];	
*)	
repRule=Thread[Rule[uniquePrefs,uniquePrefsEval]];
With[{xxx = Compress[repRule]}, ParallelEvaluate[compressedRule = xxx;, DistributedContexts -> None]];
AbsoluteTiming[ParallelEvaluate[repRuleParallel = Dispatch[Uncompress[compressedRule]];, DistributedContexts -> None];];
reductionRulesExpanded=ParallelMap[(#/. repRuleParallel)&,aux1,
					DistributedContexts->None, Method->"ItemsPerEvaluation"->Ceiling[N[Length[aux1]/Length[Kernels[]]]/10]];
WriteString["stdout","done.\n"];
	WriteString["stdout","Saving results to ","FireReductionRulesExpanded"<>ToString[lsclEpExpandUpTo]<>".m",".\n"];
	Put[reductionRulesExpanded,FileNameJoin[{DirectoryName[fileReductionTable],"FireReductionRulesExpanded"<>ToString[lsclEpExpandUpTo]<>".m"}]]
];


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


WriteString["stdout",lsclScriptName,": All done.\n"];
