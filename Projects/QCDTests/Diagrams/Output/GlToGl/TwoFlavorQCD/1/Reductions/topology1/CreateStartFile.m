Get[Environment["lsclFireMmaPath"]];


If[$FrontEnd===Null,
  projectDirectory=DirectoryName[$InputFileName],
  projectDirectory=NotebookDirectory[]
];
SetDirectory[projectDirectory];
Print["Working directory: ", projectDirectory];
LaunchKernels[4];


Internal={k1};
External={p1};
Propagators={k1^2, k1^2 - 2*k1*p1 + pp};
Replacements={p1^2 -> pp};
PrepareIBP[];
Quiet[Prepare[AutoDetectRestrictions -> True,Parallel -> True,LI -> True], LaunchKernels::nodef];
TransformRules[FileNameJoin[{Directory[],"LR"}],"topology1.lbases",4242];
SaveSBases["topology1"];
