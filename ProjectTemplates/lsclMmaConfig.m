{
(*
  Defines variables appearing in propagators or kinematic replacements
  rules that are not loop or external momenta
*)
"FCVariables" -> {},
(*
  Replacement rules for external momenta defining the kinematics of the process
*)
"FinalSubstitutions" -> {},
(*
  In the case of expansions performed on the level of amplitudes, the propagators get rewritten
  as GFADs. For the sake of topology identification they should be mapped back to SFADs or CFADs.
  The following rules facilitate the process of finind proper mappings.
*)
"FromGFAD$InitialSubstitutions"->{}
}
