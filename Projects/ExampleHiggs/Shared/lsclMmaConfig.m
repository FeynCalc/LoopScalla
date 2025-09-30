{
(*
  Defines variables appearing in propagators or kinematic replacements
  rules that are not loop or external momenta
*)
"FCVariables" -> {s,mqt},
(*
  Replacement rules for external momenta defining the kinematics of the process
*)
"FinalSubstitutions" -> {Hold[SPD][p1]->0,Hold[SPD][p2]->0,Hold[SPD][p1,p2]->1/2*s},
(*
  Mass dimensions of variables in the integral families passed to KIRA
*)
"KiraMassDimensions" -> {s->2,mqt->1},
(*
  In the case of expansions performed on the level of amplitudes, the propagators get rewritten
  as GFADs. For the sake of topology identification they should be mapped back to SFADs or CFADs.
  The following rules facilitate the process of finind proper mappings.
*)
"FromGFAD$InitialSubstitutions"->{},
"NumberOfCoresForReduction"->8,
"ExtraReplacementsForTheReduction"->{}
}
