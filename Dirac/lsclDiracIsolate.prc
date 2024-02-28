#procedure lsclDiracIsolate(NAME1,NAME2)

* lsclDiracIsolate() puts Dirac algebra related symbols
* outside of the brackets and employs argtoextrasymbols
* to prevent FORM from looking into the brackets. This is 
* very useful before Dirac algebra simplifications that 
* significantly increase the  number of terms (e.g. Dirac equation 
* or index contractions)

b lsclDiracGamma, lsclDiracGammaChiral,lsclDiracGammaOpen, lsclDiracGammaChiralOpen, lsclDiracSpinor, lsclDiracTrace, lsclDiracFlag1, lsclDiracChainOpen, lsclPolVector;
.sort
Collect `NAME1', `NAME2';
argtoextrasymbol `NAME1', `NAME2';
#endprocedure
