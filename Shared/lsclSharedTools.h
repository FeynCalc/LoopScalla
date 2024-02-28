#ifndef `LSCLSHAREDTOOLS'
#define LSCLSHAREDTOOLS

*********************************************************************

*--#[ lsclTiming:

.sort
#ifdef `TIME'
on statistics;
.sort
off statistics;
 #endif

*--#] lsclTiming:

*********************************************************************

*--#[ lsclDebuggingDiracAlgebra:

.sort
b lsclDiracTrace,lsclDiracGamma,lsclDiracSpinor,lsclDiracGammaOpen,lsclDiracChainNC,lsclDiracChainOpen,lsclDiracChain;
print[];
.sort
.end

*--#] lsclDebuggingDiracAlgebra:

#endif
