#procedure lsclToFeynCalc(EXPR,FILE)

* lsclToFeynCalc() saves the active expression EXPR to FILE
* such, that it can be loaded into FeynCalc for further investigations

.sort

F lsclDiracGammaOpenHold;
CF SPD,FAD,GFAD,DiracTrace,List,SUNTF,SUNF,SUND, lsclDiracGammaClosed;
F GAD,GSD;
S I, SUNN, D, GaugeXi;
Auto S dummyI;
repeat;
id lsclP1?.lsclP2?^lsclS?!{,0} = SPD(lsclP1,lsclP2)^lsclS;
id lsclFAD(?a) = FAD(List(?a));
id lsclGFAD(?a) = GFAD(?a);



id i_ = I;

id lsclD^lsclS?!{,0} = D^lsclS;

id lsclSUNN^lsclS?!{,0} = SUNN^lsclS;
id lsclSUNF(?a) = SUNF(?a);
id lsclSUND(?a) = SUND(?a);
id lsclSUNTF(?a) = SUNTF(?a);
id lsclGaugeXi = GaugeXi;
endrepeat;

argument;
repeat;
id lsclP1?.lsclP2?^lsclS?!{,0} = SPD(lsclP1,lsclP2)^lsclS;
id lsclSUNN^lsclS?!{,0} = SUNN^lsclS;
id lsclD^lsclS?!{,0} = D^lsclS;
id lsclGaugeXi = GaugeXi;
id N1_? = dummyI1;
endrepeat;
endargument;


if (occurs(g_));
#call lsclToDiracGamma()
id lsclDiracGammaOpen(lsclI?,?a) = lsclDiracGammaOpenHold(?a);
endif;

.sort
print;
.sort

if (occurs(lsclDiracGamma));
repeat id lsclDiracSpinor(?a)*lsclDiracGamma(?b)*lsclDiracSpinor(?c) = lsclDiracGammaClosed(lsclDiracSpinor(?a),?b,lsclDiracSpinor(?c));
endif;


repeat id lsclDiracGammaOpenHold(?a,lsclP?,?b) = lsclDiracGammaOpenHold(?a,GSD(lsclP),?b);
repeat id lsclDiracGammaOpenHold(?a,lsclI?,?b) = lsclDiracGammaOpenHold(?a,GAD(lsclI),?b);


repeat id lsclDiracTrace(?a,lsclP?,?b) = lsclDiracTrace(?a,GSD(lsclP),?b);
repeat id lsclDiracTrace(?a,lsclI?,?b) = lsclDiracTrace(?a,GAD(lsclI),?b);

id lsclDiracTrace(?a) = DiracTrace(?a);
id lsclDiracGammaOpenHold(?a) = DiracTrace(?a);

if (occurs(lsclDiracGamma,g_)) exit "Something went wrong here!";


*multiply replace_(lsclDiracTrace,DiracTrace,i_,I);


.sort

print;

format Mathematica;
#write <`FILE'> "(%E)", `EXPR'


.end

#endprocedure

