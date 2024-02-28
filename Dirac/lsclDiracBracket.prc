#procedure lsclDiracBracket()

* lsclDiracBracket() puts Dirac algebra related symbols
* outside of the brackets, and uses keep brackets to prevent
* FORM from looking into brackets. This is very useful before
* Dirac algebra simplifications that significantly increase the
* number of terms (e.g. Dirac equation or index contractions)

b lsclDiracGamma, lsclDiracGammaChiral,lsclDiracGammaOpen, lsclDiracGammaChiralOpen, lsclDiracSpinor;
.sort
keep brackets;

#endprocedure
