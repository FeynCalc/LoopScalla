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
lsclTopology="topology6267";
lsclExpandInEp=1;
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
		WriteString["stdout","Loading the reduction rules (no expansion) ..."];
		reductionRulesRaw0=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Reductions",lsclTopology,"FireReductionRules.m"}]],
		WriteString["stdout","Loading ep-expanded reduction rules ..."];
		reductionRulesRaw0=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Reductions",lsclTopology,"FireReductionRulesExpanded.m"}]]
	];
	fcTopologies=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];
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


WriteString["stdout","Collecting the rules ... "];
ClearAll[factFun,factFunHold,lsclNum,lsclDen,lsclNumF,lsclDenF];
factFun[0]:=0;
factFun[1]:=1;
lsclNum[0]:=0;
lsclNum[1]:=1;
lsclNum[x_Integer y_.]:=x lsclNum[y];
lsclNum[lsclEp^n_. x_.]:=lsclEp^n lsclNum[x];
lsclNum[x_ y_]:=lsclNum[x] lsclNum[y];
lsclNumF[x_]:=lsclNum[Factor2[x]];
lsclDen[lsclEp^n_. x_.]:=1/lsclEp^n lsclDen[x];
lsclDen[x_Integer y_.]:=1/x lsclDen[y];
lsclDen[1]:=1;
lsclDen[x_ y_]:=lsclDen[x] lsclDen[y];
lsclDenF[x_]:=lsclDen[Factor2[x]];
factFun[x_Plus]:=Distribute[factFunHold[x]]/.factFunHold->factFun;
factFun[x_]:=lsclNum[Numerator[x]]lsclDen[Denominator[x]]/;Head[x]=!=Plus;
lsclNum[x_Plus]:=Distribute[factFunHold[x]]/.factFunHold->factFun;
reductionRulesRaw2=Collect2[reductionRulesRaw1,GLI,Factoring->factFun];
WriteString["stdout","done.\n"];
WriteString["stdout",lsclScriptName,": Factoring the unique denominators ... "];
reductionRulesRaw2=reductionRulesRaw2/.lsclDen->lsclDenF;
WriteString["stdout","done.\n"];
WriteString["stdout",lsclScriptName,": Factoring the unique numerators ... "];
reductionRulesRaw2=reductionRulesRaw2/.lsclNum->lsclNumF;
WriteString["stdout","done.\n"];
If[!FreeQ[reductionRulesRaw2,factFun],	
	WriteString["stdout",lsclScriptName,": Error! Failed to isolate loop integral prefactors."];
	QuitAbort[]
];
allNums=Cases2[reductionRulesRaw2,lsclNum];
allDens=Cases2[reductionRulesRaw2,lsclDen];
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
reductionRules=reductionRulesRaw2/.convRule;


If[First/@reductionRulesRaw1=!=First/@reductionRulesRaw2,
WriteString["stdout",lsclScriptName,": Something went wrong when simplifying reduction rules.\n\n"];
Abort[]
];


WriteString["stdout",lsclScriptName,": Checking the results ..."];


rulePrimes=Map[Rule[#,RandomPrime[10^6]]&,Join[fcVariables,{lsclD}]];


If[Union[Together[((Last/@reductionRulesRaw1)/.rulePrimes)-
(Last/@(reductionRulesRaw2/.{lsclDen[x_]->1/x,lsclNum[x_]:>x})/.rulePrimes)]]=!={0},
WriteString["stdout",lsclScriptName,": Something went wrong when simplifying reduction rules.\n\n"];
Abort[]
];


WriteString["stdout","done.\n"];


WriteString["stdout",lsclScriptName,": Complexity of numerators (Leafcount, unfactorized): ",LeafCount[allNums], "\n"];
WriteString["stdout",lsclScriptName,": Complexity of denominators (Leafcount, unfactorized): ",LeafCount[allDens], "\n"];


tmp=Map["fill tabIBP"<>ToString[#[[1]],InputForm]<>" = "<>ToString[#[[2]],InputForm]<>";"&,reductionRules];
formFillStatements="*--#[ lsclFillStatements:\n"<>StringRiffle[StringReplace[tmp,{"["->"(","]"->")"}],"\n"]<>"\n*--#] lsclFillStatements:\n";


If[!StringQ[formTopoNames]||!StringQ[formtabTopoName]||!StringQ[formFillStatements],
	WriteString["stdout",lsclScriptName,": Something went wrong when generating the strings.\n\n"];
	Abort[]
];


If[lsclExpandInEp===0,		
		file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Reductions",lsclTopology,"fillStatements.frm"}]],		
		file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Reductions",lsclTopology,"fillStatementsExpanded.frm"}]]
];
WriteString[file,formTopoNames<>"\n"<>formtabTopoName<>"\n"<>formFillStatements<>"\n"];
Close[file];
WriteString["stdout",lsclScriptName,": All done.","\n"];
