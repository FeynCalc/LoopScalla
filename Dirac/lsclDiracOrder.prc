#procedure lsclDiracOrder(MAX,SEED)

* lsclDiracTrickLong() introduces a canonical ordering of Dirac matrices inside a chain.

* Canonical ordering of indices (g^i1 g^i2 g^i3) (g^i3 g^i2 g^i1) -> # (g^i1 g^i2 g^i3) (g^i1 g^i2 g^i3) + #
* No problems for closed chains, need an extra implementation for open chains
chainout lsclDiracGamma;
#do i=1,`MAX'
disorder lsclDiracGamma(lsclMu1?)*lsclDiracGamma(lsclMu2?) = -lsclDiracGamma(lsclMu2)*lsclDiracGamma(lsclMu1) + 2*d_(lsclMu1,lsclMu2);

#if (`LSCLVERBOSITY'>0)
#message lsclDiracOrder: Iteration `i'
#endif

#call lsclDiracIsolate(lsclNonDiracPiece{`SEED'+2*`i'},lsclNonDiracPiece{`SEED'+(2*`i'+1)})
#include lsclSharedTools.h #lsclTiming
#enddo
* endrepeat;
chainin lsclDiracGamma;


#endprocedure
