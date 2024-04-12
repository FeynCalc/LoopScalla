SetDirectory[FileNameJoin[{DirectoryName[Environment["lsclFireMmaPath"]],"extra","LiteRed","Setup"}]];
Get["LiteRed.m"];


Get[Environment["lsclFireMmaPath"]];


If[$FrontEnd===Null,
  projectDirectory=DirectoryName[$InputFileName],
  projectDirectory=NotebookDirectory[]
];
SetDirectory[projectDirectory];
Print["Working directory: ", projectDirectory];


Internal={k1};
External={p1};
Propagators={k1^2, k1^2 - 2*k1*p1 + pp};
Replacements={p1^2 -> pp};
Quiet[CreateNewBasis[topology, Directory->FileNameJoin[{Directory[],"LR"}]], {DiskSave::overwrite,DiskSave::dir}];
Quiet[GenerateIBP[topology], FrontEndObject::notavail];
Quiet[AnalyzeSectors[topology], FrontEndObject::notavail];
Quiet[FindSymmetries[topology, EMs->True], FrontEndObject::notavail];
Quiet[DiskSave[topology], {DiskSave::overwrite,DiskSave::dir}];
