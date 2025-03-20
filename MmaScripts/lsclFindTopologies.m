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
lsclProject="MyProject";
lsclProcessName="MyProcess";
lsclModelName="MyModel";
lsclNLoops="MyNumberOfLoops";
lsclNDiagrams="MyNumberOfDiagrams";
lsclNKernels="MyNumberOfParallelKernels";
];
*)


lsclScriptName="lsclFindTopologies";


If[$FrontEnd===Null && $lsclDEBUG===True,
	WriteString["stdout",lsclScriptName,": Error! Detected debugging during the productive run."];
	QuitAbort[]
];

If[ToString[lsclProject]==="lsclProject",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the project."];
	QuitAbort[]
];
If[ToString[lsclProcessName]==="lsclProcessName",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the process."];
	QuitAbort[]
];
If[ToString[lsclModelName]==="lsclModelName",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the model."];
	QuitAbort[]
];
If[ToString[lsclNLoops]==="lsclNLoops",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the number of loops."];
	QuitAbort[]
];

If[ToString[lsclNDiagrams]==="lsclNDiagrams",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the number of the diagrams."];
	QuitAbort[]
];


If[ ToString[lsclNKernels]==="lsclNKernels",
	WriteString["stdout",lsclScriptName,": Error! You did not specify the ","number of parallel kernels."];	
	QuitAbort[]
];


WriteString["stdout",lsclScriptName,": Loading the raw topologies ... "];
filesLoaded=Catch[
	rawTopologies0=Table[Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"ExtractedTopologies","topos_dia"<>ToString[i]<>"L"<>lsclNLoops<>".m"}]],{i,1,
	ToExpression[lsclNDiagrams]}];
	fcConfig=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Shared","lsclMmaConfig.m"}]];
	rawTopologies=Cases2[rawTopologies0,lsclRawTopology];
	,
	$Failed
];
WriteString["stdout","done.\n\n"];


WriteString["stdout",lsclScriptName,": Launching ", lsclNKernels, " parallel kernels ..."];
CloseKernels[Kernels[]];
LaunchKernels[ToExpression[lsclNKernels]];
$ParallelizeFeynCalc=True;
WriteString["stdout"," done\n"];


lmoms=FCMakeSymbols[k,Range[1,ToExpression[lsclNLoops]],List];


WriteString["stdout",lsclScriptName,": Loaded ", Length[rawTopologies], " amplitude topologies.","\n\n"]
WriteString["stdout",lsclScriptName,": Loop momenta: ", lmoms,".\n\n"]


fcVariables="FCVariables"/.fcConfig;
If[ToString[fcVariables]=!="fcVariables" && MatchQ[fcVariables,{__Symbol}],
	WriteString["stdout",lsclScriptName,": Symbols to be declared as FCVariable: ", fcVariables,".\n\n"];
	(DataType[#,FCVariable]=True)&/@fcVariables;
	With[{xxx=fcVariables},
	ParallelEvaluate[(DataType[#,FCVariable]=True)&/@xxx,DistributedContexts->False];
	];	
	If[Union[Flatten[ParallelEvaluate[DataType[#,FCVariable],DistributedContexts->False]&/@fcVariables]]=!={True},
		WriteString["stdout",lsclScriptName,": Error! Something went wrong when declaring FCVariable datatype on parallel kernels."];
		QuitAbort[]
	]
];


finalSubstitutions="FinalSubstitutions"/.fcConfig;
If[ToString[finalSubstitutions]==="finalSubstitutions",
	finalSubstitutions={}
];
WriteString["stdout",lsclScriptName,": Kinematic constraints: ", finalSubstitutions,".\n\n"];


(*FromGFAD$InitialSubstitutions="FromGFAD$InitialSubstitutions"/.fcConfig;
If[ToString[FromGFAD$InitialSubstitutions]==="FromGFAD$InitialSubstitutions",
	FromGFAD$InitialSubstitutions={}
];
WriteString["stdout",lsclScriptName,": Initial substitutions for FromGFAD: ", FCE@FromGFAD$InitialSubstitutions,".\n\n"];*)


(*preferredTopologies$File="PreferredTopologies"/.fcConfig;
If[ToString[preferredTopologies$File]==="preferredTopologies$File",
	preferredTopologies={},
	preferredTopologies=Get[preferredTopologies$File]
];
WriteString["stdout",lsclScriptName,": Number of loaded preferred topologies: ", Length[preferredTopologies],".\n\n"];*)
preferredTopologies={};


rawTopologiesFC$0=FromGFAD[(rawTopologies/.{lsclSPD->SPD,lsclGFAD->GFAD,
lsclFAD[x__]:>FAD[{x}]}/.lsclRawTopology->Times),LoopMomenta->lmoms,IntermediateSubstitutions->Join[FRH[finalSubstitutions]],FCVerbose->-1];


ClearAll[generateLoopMomSums];
generateLoopMomSums[lmoms_List]:=
Flatten[Table[(Total/@ReleaseHold[Flatten[Outer[Hold[Times],Subsets[lmoms,{i}],Tuples[{1,-1},{i}]/.{-1,__Integer}->Nothing,1]]]),{i,Length[lmoms],2,-1}]];
intSubstsForQuadraticEikonalPropagators=Map[ExpandScalarProduct[SPD[#]] -> SPD[#]&,generateLoopMomSums[lmoms]];


rawTopologiesFC=FCLoopReplaceQuadraticEikonalPropagators[rawTopologiesFC$0, LoopMomenta -> {k1, k2, k3}, 
InitialSubstitutions -> intSubstsForQuadraticEikonalPropagators, IntermediateSubstitutions -> FRH[finalSubstitutions]];


rawTopologiesFC$2=SelectNotFree[#,FeynAmpDenominator]&/@rawTopologiesFC;
rawTopologiesCheck=SelectFree[#,FeynAmpDenominator]&/@rawTopologiesFC;


If[!MatchQ[Union[rawTopologiesFC$2/.FeynAmpDenominator[__]->1],{0}|{1}|{0,1}],
	WriteString["stdout",lsclScriptName,": ERROR! Something went wrong when converting raw topologies to the FeynCalc notation:",
	rawTopologiesFC$2/.FeynAmpDenominator[__]->1,".\n"];
	QuitAbort[]
];
rawTopologiesFC$3=loopHead/@(rawTopologiesFC$2);


If[!MatchQ[rawTopologiesCheck,{1..}],	
	WriteString["stdout",lsclScriptName,": ERROR! The topologies also contain propagators without loop momentum dependence.",".\n"];
	QuitAbort[]
]


(* Checkpoint for FCLoopFindTopologies*)


(* ---------------------------------------------------------- *)


WriteString["stdout",lsclScriptName,": Applying FCLoopFindTopologies.","\n\n"];
aux1=FCLoopFindTopologies[rawTopologiesFC$3,lmoms,FCLoopIsolate->loopHead,FCLoopBasisOverdeterminedQ->True,FinalSubstitutions->finalSubstitutions,
Names->"preTopoDia",Head->Identity,FCVerbose->1,FCLoopGetKinematicInvariants->False,FCLoopScalelessQ->False,FCParallelize->True];


WriteString["stdout","\n",lsclScriptName,": Done applying FCLoopFindTopologies.","\n\n"];


If[!FileExistsQ[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopFindTopologies.m"}]],
WriteString["stdout","\n",lsclScriptName,": Checkpoint: Saving the output of FCLoopFindTopologies.","\n\n"];
Put[aux1,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopFindTopologies.m"}]]
];


(*aux1=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopFindTopologies.m"}]];*)


(* ---------------------------------------------------------- *)


(* Checkpoint for FCLoopGetKinematicInvariants*)


(* ---------------------------------------------------------- *)


WriteString["stdout",lsclScriptName,": Applying FCLoopGetKinematicInvariants.","\n"];
kinInvs=FCLoopGetKinematicInvariants[aux1[[2]],FCVerbose->1,FCParallelize->True];
WriteString["stdout","\n",lsclScriptName,":  Done applying FCLoopFindTopologies.","\n\n"];


If[!FileExistsQ[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopGetKinematicInvariants.m"}]],
WriteString["stdout","\n",lsclScriptName,": Checkpoint: Saving the output of FCLoopGetKinematicInvariants.","\n\n"];
Put[kinInvs,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopGetKinematicInvariants.m"}]]
];


(*kinInvs=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopGetKinematicInvariants.m"}]];*)


(* ---------------------------------------------------------- *)


WriteString["stdout",lsclScriptName,": Kinematic invariants present in the topologies: ", kinInvs,".\n\n"]


If[Complement[Union[kinInvs],Union[fcVariables]]=!={},
	WriteString["stdout",lsclScriptName,": Error! Detected undeclared kinematic invariants in the topologies."];
	QuitAbort[]
]


rawTopologies2=SelectNotFree[#,lsclRawTopology]&/@rawTopologies;


formLHS=FCE[rawTopologies2]/.SPD->lsclSPD/.GFAD->lsclGFAD;
formRHS=aux1[[1]]//FCLoopTopologyNameToSymbol//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;


formRulesRaw=MapThread["id "<>ToString[#1,InputForm]<>" = "<>ToString[#2,InputForm]<>";"&,{formLHS,formRHS}]//
StringReplace[#,{"["->"(","]"->")"}]&//ReplaceAll[#,{"id 0 = 0;":>Unevaluated[Sequence[]]}]&//Union;
formRules=StringJoin[StringRiffle[formRulesRaw,"\n"]];


preTopoDefs="*--#[ lsclTopologyNames:\n"<>StringRiffle[ToString/@(First/@aux1[[2]]),",\n"]<>"\n*--#] lsclTopologyNames:\n";


preTopoRules="*--#[ lsclTopologyRules:\n"<>formRules<>"\n*--#] lsclTopologyRules:\n";


WriteString["stdout",lsclScriptName,": Writing preTopologies.frm ... "];
file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","preTopologies.frm"}]];
WriteString[file,preTopoDefs<>"\n"<>preTopoRules];
Close[file];
WriteString["stdout","done.\n\n"];


If[$ParallelizeFeynCalc,
	WriteString["stdout",lsclScriptName,": Detecting overdetermined topologies in parallel ..."];
	odTopos = ParallelMap[FCLoopBasisOverdeterminedQ[#]&,aux1[[2]], DistributedContexts -> None,
		Method->"ItemsPerEvaluation" -> Ceiling[N[Length[aux1[[2]]]/$KernelCount]/10]];
	overdeterminedToposPre=Extract[aux1[[2]],Position[odTopos,True]],
	WriteString["stdout",lsclScriptName,": Detecting overdetermined topologies ..."];
	overdeterminedToposPre=Select[aux1[[2]],FCLoopBasisOverdeterminedQ];
];
WriteString["stdout","done.\n\n"];


WriteString["stdout",lsclScriptName,": Number of topologies with too many propagators: ", Length[overdeterminedToposPre],"\n\n"];


lsclNum[x_Integer]:=x;
lsclDen[x_Integer]:=1/x;


(* Checkpoint for FCLoopCreatePartialFractioningRules*)


(* ---------------------------------------------------------- *)


WriteString["stdout",lsclScriptName,": Applying FCLoopCreatePartialFractioningRules.","\n\n"];
pfrRules=FCLoopCreatePartialFractioningRules[aux1[[1]],aux1[[2]],FCVerbose->1,Numerator->lsclNum,Denominator->lsclDen,FCParallelize->True];
WriteString["stdout","\nlsclFindTopologies: Done applying FCLoopCreatePartialFractioningRules.","\n\n"];


If[!FileExistsQ[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreatePartialFractioningRules.m"}]],
WriteString["stdout","\n",lsclScriptName,": Checkpoint: Saving the output of FCLoopCreatePartialFractioningRules.","\n\n"];
Put[pfrRules,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreatePartialFractioningRules.m"}]]
];


(*pfrRules=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreatePartialFractioningRules.m"}]];*)


(* ---------------------------------------------------------- *)


pfrToposPre=Union[First/@pfrRules[[2]]];
WriteString["stdout",lsclScriptName,": Number of new topologies after partial fractioning: ", Length[pfrToposPre],"\n\n"];


aux2=aux1/.Dispatch[pfrRules[[1]]];


(* 
	Denominators from original topologies that do not require partial fractioning. Notice that 
	the corresponding topologies themsevles still might be overdetermined! 
*)
remainderDens=Select[aux2[[1]],!FreeQ[#,Alternatives@@First/@overdeterminedToposPre]&]//Union;


(* Determine which topologies related to these denominators are overdetermined *)
overdeterminedTopos=FCLoopSelectTopology[remainderDens,overdeterminedToposPre];


(* Group the remaining denominator together with the corresponding topologies *)
toRemoveList={#,First@SelectNotFree[overdeterminedTopos,#[[1]]],First/@Position[#[[2]],0]}&/@remainderDens;


(* Remove the now irrelevant propagators from the leftover topologies *)
newNoPfrGLIs=(FCLoopRemovePropagator[#[[1]],#[[3]]]&/@toRemoveList);
newNoPfrTopos=(FCLoopRemovePropagator[#[[2]],#[[3]]]&/@toRemoveList);
WriteString["stdout",lsclScriptName,": Number of topologies from denominators that were not partial fractioned: ", Length[newNoPfrTopos],"\n\n"];


(* List of all resulting topologies upon doing partial fractioning *)
pfrTopos=Union[pfrToposPre,First/@newNoPfrTopos];


(* Replacement rule for renaming preTopo-topologies (with PFR-suffixes from partial fractioning) to pfrTopo topologies *)
pfrToposNew=Table["pfrTopo"<>ToString[i],{i,1,Length[pfrTopos]}];
pfrRenRu=Thread[Rule[pfrTopos,pfrToposNew]];


(* An extra rule for mapping the remaining denominators to the corresponding topologies with removed propagators *)
gliRulePfr=Thread[Rule[remainderDens,newNoPfrGLIs]]/.Dispatch[pfrRenRu];


(* Final list of topologies upon doing partial fractioning*)
relevantPFrTopos=Union[Cases[aux2[[1]]/.Dispatch[gliRulePfr],GLI[id_,___]:>id,Infinity]];
finalPreToposPfrRaw=Select[Join[aux1[[2]],pfrRules[[2]],newNoPfrTopos/.Dispatch[pfrRenRu]],!FreeQ[#,Alternatives@@relevantPFrTopos]&]//Union;


WriteString["stdout",lsclScriptName,": Final number of topologies after partial fractioning: ", Length[finalPreToposPfrRaw],"\n\n"]


(* Checkpoint for FCLoopScalelessQ*)


(* ---------------------------------------------------------- *)


If[$ParallelizeFeynCalc,
	WriteString["stdout",lsclScriptName,": Detecting scaleless topologies in parallel ..."];
	scTopos = ParallelMap[FCLoopScalelessQ[#]&,finalPreToposPfrRaw, DistributedContexts -> None,
		Method->"ItemsPerEvaluation" -> Ceiling[N[Length[finalPreToposPfrRaw]/$KernelCount]/10]];
	scalelessPfrTopos=Extract[finalPreToposPfrRaw,Position[scTopos,True]]/.Dispatch[pfrRenRu],
	
	WriteString["stdout",lsclScriptName,": Detecting scaleless topologies ..."];
	scalelessPfrTopos=Select[finalPreToposPfrRaw,FCLoopScalelessQ]/.Dispatch[pfrRenRu]
];
WriteString["stdout","done.\n\n"];


If[!FileExistsQ[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopScalelessQ.m"}]],
WriteString["stdout","\n",lsclScriptName,": Checkpoint: Saving the output of FCLoopScalelessQ.","\n\n"];
Put[scalelessPfrTopos,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopScalelessQ.m"}]]
];


(*scalelessPfrTopos=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopScalelessQ.m"}]];*)


(* ---------------------------------------------------------- *)


WriteString["stdout",lsclScriptName,": Number of scaleless topologies among them: ", Length[scalelessPfrTopos],"\n\n"]


tmp=Join[(Join[pfrRules[[1]]/.Dispatch[pfrRenRu],gliRulePfr]//FCLoopTopologyNameToSymbol//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&)//ReplaceAll[#,Rule->Equal]&,
(#==0)&/@scalelessPfrTopos//FCLoopTopologyNameToSymbol//ReplaceAll[#,FCTopology[id_,props_List,___]:>id[formAnything]]&];
denPfrRule=StringReplace["id "<>ToString[#,InputForm]<>";",{"=="->"=","["->"(","]"->")","formAnything"->"?a"}]&/@tmp;


WriteString["stdout",lsclScriptName,": Number of partial fractioning relations for denominators: ", Length[denPfrRule],"\n\n"]


parFracRules="*--#[ lsclTopologyRules:\n\n"<>StringJoin[StringRiffle[denPfrRule,"\n"]]<>"\n*--#] lsclTopologyRules:\n";


pfrTopoDefs="*--#[ lsclTopologyNames:\n"<>StringRiffle[ToString/@(pfrToposNew),",\n"]<>"\n*--#] lsclTopologyNames:\n";


WriteString["stdout",lsclScriptName,": Writing partialFractioning.frm ... "];
file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","partialFractioning.frm"}]];
WriteString[file,pfrTopoDefs<>"\n"<>parFracRules];
Close[file];
WriteString["stdout","done.\n\n"];


finalPreTopos=Select[finalPreToposPfrRaw/.Dispatch[pfrRenRu],FreeQ[#,Alternatives@@(First/@scalelessPfrTopos)]&]//Union;


WriteString["stdout",lsclScriptName,": Number of final topologies after partial fractioning: ", Length[finalPreTopos],"\n\n"]


If[$ParallelizeFeynCalc,
	WriteString["stdout",lsclScriptName,": Detecting overdetermined topologies among the final pretopologies in parallel ..."];
	check = ParallelMap[FCLoopBasisOverdeterminedQ[#]&,finalPreTopos, DistributedContexts -> None,
		Method->"ItemsPerEvaluation" -> Ceiling[N[Length[finalPreTopos]/$KernelCount]/10]],
	WriteString["stdout",lsclScriptName,": Detecting overdetermined topologies among the final pretopologies ... "];
	check=FCLoopBasisOverdeterminedQ/@finalPreTopos;
];
WriteString["stdout","done.\n\n"];


If[Union[check]=!={False},
	WriteString["stdout",lsclScriptName,": Error! Not all overdetermined topologies were eliminated."];
	QuitAbort[]
]


(*WriteString["stdout",lsclScriptName,": Applying FCLoopFindSubtopologies.","\n"];
subTopos=FCLoopFindSubtopologies[finalPreTopos]//Flatten;
WriteString["stdout",lsclScriptName,": Done applying FCLoopFindSubtopologies.","\n"];*)
subTopos={};


(* Checkpoint for FCLoopFindTopologyMappings*)


(* ---------------------------------------------------------- *)


WriteString["stdout",lsclScriptName,": Applying FCLoopFindTopologyMappings.","\n\n"];
mappedTopos=FCLoopFindTopologyMappings[finalPreTopos,PreferredTopologies->subTopos,FCVerbose->1,FCParallelize->True];


If[!FileExistsQ[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopFindTopologyMappings.m"}]],
WriteString["stdout","\n",lsclScriptName,": Checkpoint: Saving the output of FCLoopFindTopologyMappings.","\n\n"];
Put[mappedTopos,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopFindTopologyMappings.m"}]]
];


(*mappedTopos=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopFindTopologyMappings.m"}]];*)


(* ---------------------------------------------------------- *)


(* An extra rule for introducing new names for the final topologies *)
finTopoNames=First/@mappedTopos[[2]];
finTopoNamesNew=Table["finTopo"<>ToString[i],{i,1,Length[finTopoNames]}];
finRenRu=Thread[Rule[finTopoNames,finTopoNamesNew]];
auxRu=StringReplace["id "<>ToString[#[[1]],InputForm]<>"(?a) = "<>ToString[#[[2]],InputForm]<>"(?a);",
{"->"->"=","["->"(","]"->")","formAnything"->"?a","formReplace"->"replace_","$QM"->"?"}]&/@(finRenRu/.s_String:>ToExpression[s]);


(* Generate FORM id-rules for momentum shifts that implement our mappings *)
tmp=((#[[2;;]]&/@mappedTopos[[1]]));
tmp=tmp//ReplaceAll[#,Pattern->pattern]&//ReplaceAll[#,pattern[x_,Blank[]]:>ToExpression[ToString[x]<>"$QM"]]&//
ReplaceAll[#,RuleDelayed->Equal]&//FCLoopTopologyNameToSymbol//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;
tmp=(#[[2]][[1]]==formReplace@@Flatten[(#[[1]]/.Rule->List)]#[[2]][[2]])&/@tmp;
formTopoIDRuleRaw=StringReplace["id "<>ToString[#,InputForm]<>";",{"=="->"=","["->"(","]"->")",
"formAnything"->"?a","formReplace"->"replace_","$QM"->"?","n"~~x:DigitCharacter..:>"lsclS"<>x}]&/@tmp;
formTopoIDRule="*--#[ lsclTopologyMappings:\n\n repeat;\n"<>StringJoin[StringRiffle[Join[formTopoIDRuleRaw,
auxRu],"\n"]]<>"\nendrepeat;\n\n*--#] lsclTopologyMappings:\n";


(* Names of the final topologies*)
finTopoDefs="*--#[ lsclTopologyNames:\n"<>StringRiffle[ToString/@(finTopoNamesNew),",\n"]<>"\n*--#] lsclTopologyNames:\n";


WriteString["stdout",lsclScriptName,": Writing topologyMappings.frm ... "];
file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","topologyMappings.frm"}]];
WriteString[file,finTopoDefs<>"\n"<>formTopoIDRule];
Close[file];
WriteString["stdout","done.\n\n"];


(* Some of the final topologies might be incomplete, so we need to account for that as well *)
finToposRenamed=mappedTopos[[2]]/.Dispatch[finRenRu];


If[$ParallelizeFeynCalc,
	WriteString["stdout",lsclScriptName,": Detecting incomplete topologies in parallel ..."];
	check = ParallelMap[FCLoopBasisIncompleteQ[#]&,finToposRenamed, DistributedContexts -> None,
		Method->"ItemsPerEvaluation" -> Ceiling[N[Length[finToposRenamed]/$KernelCount]/10]],
	WriteString["stdout",lsclScriptName,": Detecting incomplete topologies ... "];
	check=FCLoopBasisIncompleteQ/@finToposRenamed;
];
incompleteTopos=Extract[finToposRenamed,Position[check,True]];
WriteString["stdout","done.\n\n"];


WriteString["stdout",lsclScriptName,": Number of final topologies that require a basis completion: ", Length[incompleteTopos],"\n\n"];


(* For the basis completion we can use all available propagators *)
allProps=Union[Flatten[#[[2]]&/@finToposRenamed]];


(* Checkpoint for FCLoopBasisFindCompletion*)


(* ---------------------------------------------------------- *)


If[$ParallelizeFeynCalc,
	WriteString["stdout",lsclScriptName,": Applying FCLoopBasisFindCompletion in parallel ..."];
	With[{xxx=allProps},
	ParallelEvaluate[allPropsParallel=xxx,DistributedContexts->False];
	];
	completedTopos = ParallelMap[FCLoopBasisFindCompletion[#,Method->allPropsParallel]&,incompleteTopos, DistributedContexts -> None,
		Method->"ItemsPerEvaluation" -> Ceiling[N[Length[incompleteTopos]/$KernelCount]/10]],
		
	WriteString["stdout",lsclScriptName,": Applying FCLoopBasisFindCompletion ... "];
	completedTopos=FCLoopBasisFindCompletion[incompleteTopos,Method->allProps];
];
WriteString["stdout","done.\n\n"];


If[!FileExistsQ[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopBasisFindCompletion.m"}]],
WriteString["stdout","\n",lsclScriptName,": Checkpoint: Saving the output of FCLoopBasisFindCompletion.","\n\n"];
Put[completedTopos,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopBasisFindCompletion.m"}]]
];


(*completedTopos=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopBasisFindCompletion.m"}]];*)


(* ---------------------------------------------------------- *)


(* Checkpoint for FCLoopCreateRuleGLIToGLI*)


(* ---------------------------------------------------------- *)


If[$ParallelizeFeynCalc,
	WriteString["stdout",lsclScriptName,": Applying FCLoopCreateRuleGLIToGLI in parallel ... "];
	With[{xxx=allProps},
	ParallelEvaluate[allPropsParallel=xxx,DistributedContexts->False];
	];
	basisCompletionRules = ParallelMap[FCLoopCreateRuleGLIToGLI[#[[1]],#[[2]]]&,Transpose[{completedTopos,List/@incompleteTopos}], DistributedContexts -> None,
		Method->"ItemsPerEvaluation" -> Ceiling[N[Length[completedTopos]/$KernelCount]/10]],
		
	WriteString["stdout",lsclScriptName,": Applying FCLoopCreateRuleGLIToGLI ... "];
	basisCompletionRules=FCLoopCreateRuleGLIToGLI[completedTopos,List/@incompleteTopos];
];
WriteString["stdout","done.\n\n"];


If[!FileExistsQ[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreateRuleGLIToGLI.m"}]],
WriteString["stdout","\n",lsclScriptName,": Checkpoint: Saving the output of FCLoopCreateRuleGLIToGLI.","\n\n"];
Put[basisCompletionRules,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreateRuleGLIToGLI.m"}]]
];


(*basisCompletionRules=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreateRuleGLIToGLI.m"}]];*)


(* ---------------------------------------------------------- *)


ClearAll[tmp];
tmp=basisCompletionRules//Flatten//ReplaceAll[#,Pattern->pattern]&//
ReplaceAll[#,pattern[x_,Blank[]]:>ToExpression[ToString[x]<>"$QM"]]&//ReplaceAll[#,RuleDelayed->Equal]&//
FCLoopTopologyNameToSymbol//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;

formTopoIDRuleRaw=StringReplace["id "<>ToString[#,InputForm]<>";",{"=="->"=","["->"(","]"->")","formAnything"->"?a",
"formReplace"->"replace_","$QM"->"?","n"~~x:DigitCharacter..:>"lsclS"<>x}]&/@tmp;


ultimateTopos=finToposRenamed/.Thread[Rule[incompleteTopos,completedTopos]];


ultimateToposNewNames=Table["topology"<>ToString[i],{i,1,Length[finToposRenamed]}];
ultimateToposRenamingRule=Thread[Rule[First/@ultimateTopos,ultimateToposNewNames]];


tmp=StringReplace["id "<>ToString[#[[1]],InputForm]<>"(?a) = "<>ToString[#[[2]],InputForm]<>"(?a);",
{"->"->"=","["->"(","]"->")","formAnything"->"?a","formReplace"->"replace_","$QM"->"?"}]&/@(ultimateToposRenamingRule/.s_String:>ToExpression[s]);


ultimateToposDefs="*--#[ lsclTopologyNames:\n"<>StringRiffle[ToString/@(Join[First/@completedTopos,ultimateToposNewNames]),",\n"]<>"\n*--#] lsclTopologyNames:\n";


(*Final renaming rule for the completed (and other) topologies *)
formUltimateRule="*--#[ lsclTopologyMappings:\n\n repeat;\n"<>StringJoin[StringRiffle[Join[formTopoIDRuleRaw,tmp],"\n"]]<>"\nendrepeat;\n\n*--#] lsclTopologyMappings:\n";


WriteString["stdout",lsclScriptName,": Writing augmentedTopologies.frm ..."];
file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","augmentedTopologies.frm"}]];
WriteString[file,ultimateToposDefs<>"\n"<>formUltimateRule];
Close[file];
WriteString["stdout","done.\n\n"];


(*Finally, we also need rules to eliminate scalar products *)


ultimateToposRenamed=ultimateTopos/.Dispatch[ultimateToposRenamingRule];
ultimateToposRenamedSymb=ultimateToposRenamed//FCLoopTopologyNameToSymbol;


(*ultimateToposRenamed=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];*)


(* Checkpoint for FCLoopCreateRulesToGLI*)


(* ---------------------------------------------------------- *)


If[$ParallelizeFeynCalc,
	WriteString["stdout",lsclScriptName,": Applying FCLoopCreateRulesToGLI in parallel ... "];
	ruGLI = ParallelMap[{#[[1]],FCLoopCreateRulesToGLI[#,Numerator->lsclNum,Denominator->lsclDen]}&,ultimateToposRenamedSymb, DistributedContexts -> None,
		Method->"ItemsPerEvaluation" -> Ceiling[N[Length[ultimateToposRenamedSymb]/$KernelCount]/10]],
		
	WriteString["stdout",lsclScriptName,": Applying FCLoopCreateRulesToGLI ... "];
	ruGLI=Map[{#[[1]],FCLoopCreateRulesToGLI[#,Numerator->lsclNum,Denominator->lsclDen]}&,(ultimateToposRenamed//FCLoopTopologyNameToSymbol)];
];
WriteString["stdout","done.\n\n"];


If[!FileExistsQ[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreateRulesToGLI.m"}]],
WriteString["stdout","\n",lsclScriptName,": Checkpoint: Saving the output of FCLoopCreateRuleGLIToGLI.","\n\n"];
Put[ruGLI,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreateRulesToGLI.m"}]]
];


(*ruGLI=Get[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","outputFCLoopCreateRulesToGLI.m"}]];*)


(* ---------------------------------------------------------- *)


WriteString["stdout",lsclScriptName,": Number of rules for eliminating scalar products: ", Length[ruGLI],"\n\n"];


makeRuleToGLI[{topoName_,rules_List}]:=Map[(#[[1]]topoName[formAnything]==#[[2]]topoName[formAnything])&,rules];
tmp1=(makeRuleToGLI/@ruGLI)//ReplaceAll[#,GLI[s_Symbol,inds_List]:>s@@inds]&;
tmp2=MapIndexed[{
"*--#[ lsclScalarProductRulesFor"<>ToString[ruGLI[[First[#2]]][[1]]]<>" : \n\n",#1,"*--#] lsclScalarProductRulesFor"<>ToString[ruGLI[[First[#2]]][[1]]]<>" : \n\n",
#
}&,tmp1];(*tmp2=tmp1;*)
gliRuleFin=Flatten[tmp2]//FCE//ReplaceAll[#,finalSubstitutions]&//ReplaceAll[#,SPD[a_,b_]:>a[b]]&;


formRuleGLIRaw=If[Head[#]=!=String,StringReplace["id "<>ToString[#[[1]],InputForm]<>" = ("<>ToString[#[[2]],InputForm]<>");\n",{"->"->"=","["->"(","]"->")","formAnything"->"?a",
"formReplace"->"replace_","$QM"->"?","$FORMJUMP"->"->"}],
#]&/@(gliRuleFin/.s_String/;StringFreeQ[s,"#"]:>ToExpression[s]);


formRuleGLI="\n\n\n"<>StringJoin[StringRiffle[formRuleGLIRaw,"\n"]]<>"\n\n\n";


WriteString["stdout",lsclScriptName,": Writing scalarProductRules.frm ... "];
file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","scalarProductRules.frm"}]];
WriteString[file,formRuleGLI<>"\n"];
Close[file];
WriteString["stdout","done.\n\n"];


WriteString["stdout",lsclScriptName,": Writing FCTopologies.m ... "];
Put[ultimateToposRenamed,FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","FCTopologies.m"}]];
WriteString["stdout","done.\n\n"];


fcTopologies=ultimateToposRenamed;


sortedTopologyNames=First/@fcTopologies;
formTopoNames="#define LSCLNTOPOLOGIES \""<>ToString[Length[sortedTopologyNames]]<>"\"\n\n"<>StringRiffle[Table["#define LSCLTOPOLOGY"<>ToString[i]<>" \""<>ToString[sortedTopologyNames[[i]]]<>"\"",{i,1,Length[sortedTopologyNames]}],"\n"];


file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","TopologyList.txt"}]];
WriteString[file,StringRiffle[ToString/@sortedTopologyNames,"\n"]];
Close[file];


file=OpenWrite[FileNameJoin[{Directory[],"Projects",lsclProject,"Diagrams","Output",lsclProcessName,lsclModelName, lsclNLoops,"Topologies","TopologyList.frm"}]];
WriteString[file,formTopoNames];
Close[file];


WriteString["stdout","All done.\n"];
