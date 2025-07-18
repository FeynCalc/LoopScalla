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
lsclTopology="topology3688";
lsclExpandInEp=1;
lsclEpExpandUpTo=0;
];
*)


lsclScriptName="lsclCreateFillStatements";


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


filesLoaded=Catch[
	fcConfig=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Shared","lsclMmaConfig.m"}]],
	If[lsclExpandInEp===0,
		WriteString["stdout",lsclScriptName,": Loading the reduction rules (no expansion) ..."];
		reductionRulesRaw0=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams",lsclProcessName,lsclModelName, lsclNLoops,"Reductions",lsclTopology,"FireReductionRules.m"}]],
		WriteString["stdout",lsclScriptName,": Loading ep-expanded reduction rules ..."];
		reductionRulesRaw0=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams",lsclProcessName,lsclModelName, lsclNLoops,"Reductions",lsclTopology,"FireReductionRulesExpanded"<>ToString[lsclEpExpandUpTo]<>".m"}]]
	];
	fcTopologies=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];
	,
	$Failed
];
If[filesLoaded===$Failed,
	WriteString["stdout",lsclScriptName,": Error! Cannot load the integral file."];
	QuitAbort[]
];
WriteString["stdout"," done\n"];


fcVariables="FCVariables"/.fcConfig;
If[ToString[fcVariables]=!="fcVariables" && MatchQ[fcVariables,{__Symbol}],
	WriteString["stdout",lsclScriptName,": Symbols to be declared as FCVariable: ", fcVariables,".\n\n"];
	(DataType[#,FCVariable]=True)&/@fcVariables;
];


reductionRulesRaw1=Select[reductionRulesRaw0,(#[[1]][[1]]===lsclTopology)&];
allGLIs=Cases2[reductionRulesRaw1,GLI];
allGLIsConv=Map[#[[1]]@@#[[2]]&,FCLoopTopologyNameToSymbol[allGLIs]];
convRule=Dispatch[Thread[Rule[allGLIs,allGLIsConv]]];


currentTopo=SelectNotFree[fcTopologies,lsclTopology];
If[ Length[currentTopo]=!=1,	
	WriteString["stdout",lsclScriptName,": Error! Cannot find the requested topology in the list."];
	QuitAbort[]
];


nProps=Length[currentTopo[[1]][[2]]];
If[!MatchQ[nProps,_Integer?Positive],
	WriteString["stdout",lsclScriptName,": Error! Cannot determine the number of propagators."];	
	QuitAbort[]
];


topoNames=ToString/@First/@fcTopologies;
formTopoNames="*--#[ lsclTopologyNames:\n"<>StringRiffle[topoNames,",\n"]<>"\n*--#] lsclTopologyNames:\n";


formtabTopoName="*--#[ lsclCurrentTopologyDefinitions:\n\n#define LSCLCURRENTTOPO \""<>lsclTopology<>"\"\n#define LSCLCURRENTNPROPS \""<>ToString[nProps]<>"\""<>"\n\n*--#] lsclCurrentTopologyDefinitions:\n";


WriteString["stdout",lsclScriptName,": Topology definitions:\n\n"];
WriteString["stdout",formtabTopoName];
WriteString["stdout","\n\n"];


WriteString["stdout",lsclScriptName,": Collecting the rules ... "];
ClearAll[lsclNum,lsclDen,togetherHold,togetherHoldF,factFunHold,factFunHoldF];
lsclNum[x_Integer]:=x;
lsclDen[x_Integer]:=1/x;
lsclNum[lsclEpHelpFlag[x_]]:=lsclEpHelpFlag[x];
factFunHoldF[x_]:=togetherHold[Together[x]];
togetherHoldF[x_]:=lsclNumFL[FactorList[Numerator[x]]]*lsclDenFL[FactorList[Denominator[x]]]
lsclNumF[x_List]:=Apply[Times,lsclNum[#[[1]]]^#[[2]]&/@x]
lsclDenF[x_List]:=Apply[Times,lsclDen[#[[1]]]^#[[2]]&/@x]
reductionRulesRaw2=Collect2[reductionRulesRaw1,GLI,lsclEp,Factoring->factFunHold];
WriteString["stdout","done.\n"];
WriteString["stdout",lsclScriptName,": Factoring the unique denominators using Togehter ... "];
reductionRulesRaw3=reductionRulesRaw2/.factFunHold->factFunHoldF;
WriteString["stdout","done.\n"];
WriteString["stdout",lsclScriptName,": Factoring the unique denominators using FactorList ... "];
reductionRulesRaw4=reductionRulesRaw3/.togetherHold->togetherHoldF;
WriteString["stdout","done.\n"];
WriteString["stdout",lsclScriptName,": Introducing lsclNum and lsclDen ... "];
reductionRulesRaw5=reductionRulesRaw4/.lsclNumFL->lsclNumF;
reductionRulesRaw6=reductionRulesRaw5/.lsclDenFL->lsclDenF;
WriteString["stdout","done.\n"];


If[!FreeQ2[reductionRulesRaw6,{factFunHoldF,togetherHoldF,togetherHold,factFunHold}],	
	WriteString["stdout",lsclScriptName,": Error! Failed to isolate loop integral prefactors."];
	QuitAbort[]
];
allNums=Cases2[reductionRulesRaw6,lsclNum];
allDens=Cases2[reductionRulesRaw6,lsclDen];
If[!MatchQ[Union[Denominator@@@allNums],{}|{1}],
	WriteString["stdout",lsclScriptName,": Error! Failed to extract numerators of the prefactors."];
	QuitAbort[]
];
If[!MatchQ[Union[Denominator@@@allDens],{}|{1}],
	WriteString["stdout",lsclScriptName,": Error! Failed to extract denominators of the prefactors."];
	QuitAbort[]
];


allGLIs=Cases2[reductionRulesRaw2,GLI];
allGLIsConv=Map[#[[1]]@@#[[2]]&,FCLoopTopologyNameToSymbol[allGLIs]];
convRule=Dispatch[Thread[Rule[allGLIs,allGLIsConv]]];
reductionRules=reductionRulesRaw6/.convRule;


If[First/@reductionRulesRaw1=!=First/@reductionRulesRaw6,
WriteString["stdout",lsclScriptName,": Something went wrong when simplifying reduction rules.\n\n"];
Abort[]
];


WriteString["stdout",lsclScriptName,": Checking the results ..."];
rulePrimes=Map[Rule[#,RandomPrime[10^6]]&,Join[fcVariables,{lsclD,lsclEp}]];
lhs=((Last/@reductionRulesRaw1)/.rulePrimes);
rhs=(Last/@(reductionRulesRaw6/.{lsclDen[x_]->1/x,lsclNum[x_]:>x})/.rulePrimes);
If[Union[Together[lhs-rhs]]=!={0},
WriteString["stdout",lsclScriptName,": Something went wrong when simplifying reduction rules.\n\n"];
Abort[]
];


WriteString["stdout","done.\n"];


WriteString["stdout",lsclScriptName,": Complexity of numerators (LeafCount, factorized): ",LeafCount[allNums], "\n"];
WriteString["stdout",lsclScriptName,": Complexity of denominators (LeafCount, factorized): ",LeafCount[allDens], "\n"];


tmp=Map["fill tabIBP"<>ToString[#[[1]],InputForm]<>" = "<>ToString[#[[2]],InputForm]<>";"&,reductionRules];
formFillStatements="*--#[ lsclFillStatements:\n"<>StringRiffle[StringReplace[tmp,{"["->"(","]"->")"}],"\n"]<>"\n*--#] lsclFillStatements:\n";


If[!StringQ[formTopoNames]||!StringQ[formtabTopoName]||!StringQ[formFillStatements],
	WriteString["stdout",lsclScriptName,": Something went wrong when generating the strings.\n\n"];
	Abort[]
];


If[lsclExpandInEp===0,		
		file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams",lsclProcessName,lsclModelName, lsclNLoops,"Reductions",lsclTopology,"fillStatements.frm"}]],		
		file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams",lsclProcessName,lsclModelName, lsclNLoops,"Reductions",lsclTopology,"fillStatementsExpanded"<>ToString[lsclEpExpandUpTo]<>".frm"}]]
];
WriteString[file,formTopoNames<>"\n"<>formtabTopoName<>"\n"<>formFillStatements<>"\n"];
Close[file];
WriteString["stdout",lsclScriptName,": All done.","\n"];
