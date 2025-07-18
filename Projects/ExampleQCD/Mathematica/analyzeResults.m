(* ::Package:: *)

<<FeynCalc`


SetDirectory[NotebookDirectory[]];


amp1LRaw=Get[FileNameJoin[{ParentDirectory[Directory[]],"Diagrams","GlToGl","TwoFlavorQCD","1","Results","ampL1From1To4.m"}]];
amp2LRaw=Get[FileNameJoin[{ParentDirectory[Directory[]],"Diagrams","GlToGl","TwoFlavorQCD","2","Results","ampL2From1To24.m"}]];


amp1L=amp1LRaw/.{lsclNum[x_]->x,lsclDen[x_]->1/x,lsclQuarkFlavorInvolved[x_]^n_:>lsclQuarkFlavorInvolved[x]};
amp2L=amp2LRaw/.{lsclNum[x_]->x,lsclDen[x_]->1/x,lsclQuarkFlavorInvolved[x_]^n_:>lsclQuarkFlavorInvolved[x]};


ruleMasters={
GLI[topology1, {0, 1, 1, 1, 0}] -> (-pp)^(1 - 2*ep)*(13/8 + 1/(4*ep) + (115*ep)/16 + (49*ep^2)/2 - (ep*Zeta2)/4 - (13*ep^2*Zeta2)/8 + (9*ep^2*(9/4 - 2*Zeta[3]))/8 - (5*ep^2*Zeta[3])/12), 
 GLI[topology1, {1, 1, 1,0, 1}] -> (2 + ep^(-1) + 4*ep + (16*ep^2)/3 - (ep*Zeta2)/2 - ep^2*Zeta2 + (4*ep^2*(2 - 2*Zeta[3]))/3 + (ep^2*Zeta[3])/3)^2/(-pp)^(2*ep)
}


projector=MTD[lsclNu1,lsclNu2]/((D-1)pp)1/(2CA CF)SUNDelta[lsclCAj1,lsclCAj2];


resFinal=SUNDeltaContract[Contract[projector amp2L]]/.FCI@SPD[p1]->pp;


resEpPre=FCReplaceD[resFinal/.ruleMasters,D->4-2ep];


resEp=Series[FCReplaceD[Cancel[resEpPre/(-pp)^(-2ep)],D->4-2ep],{ep,0,0}]//Normal//SUNSimplify[#,SUNNToCACF->False]&//ReplaceAll[#,{GaugeXi->0,
lsclQuarkFlavorInvolved[Qj]->0,lsclQuarkFlavorInvolved[Qi]->1}]&//Collect2[#,ep]&


resLit=(((-5*I)/12)*gs^4*SUNN*(-2 + 5*SUNN))/ep^2 - ((I/72)*gs^4*(36 - 238*SUNN^2 + 583*SUNN^3))/(ep*SUNN) + 
 ((I/432)*gs^4*(-1980 + 5902*SUNN^2 - 14311*SUNN^3 - 360*SUNN^2*Zeta2 + 900*SUNN^3*Zeta2 + 1728*Zeta[3] + 432*SUNN^3*Zeta[3]))/SUNN


FCCompareResults[resLit, resEp, 
     Text -> {"\tCompare to Davydychev, Osland and Tarasov, \
    hep-ph/9801380, Eqs. 6.10-6.11:", "CORRECT.", "WRONG!"}, 
     Interrupt -> {Hold[Quit[1]], Automatic}, 
     Factoring -> Simplify]; 
Print["\tCPU Time used: ", Round[N[TimeUsed[], 4], 0.001], 
     " s."];



