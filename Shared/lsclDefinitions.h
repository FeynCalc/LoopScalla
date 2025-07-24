#ifndef `LSCLDEFINITIONS'
#define LSCLDEFINITIONS

S `lsclDim', lsclEp;
Dimension `lsclDim';

* Sets of momenta appearing in the amplitude

auto V q, p, k;
set externalMomenta: p1,...,p`LSCLMAXINDEX', q1,...,q`LSCLMAXINDEX';
set externalMomentaP: p1,...,p`LSCLMAXINDEX';
set externalMomentaK: q1,...,q`LSCLMAXINDEX';
set internalMomenta: k1,...,k`LSCLMAXINDEX';

* Generic indices
I lsclI, lsclI1, ... , lsclI`LSCLMAXINDEX';

* Lorentz indices
I lsclMu, lsclMu1, ... , lsclMu`LSCLMAXINDEX';
I lsclNu, lsclNu1, ... , lsclNu`LSCLMAXINDEX';
I lsclRho, lsclRho1, ... , lsclRho`LSCLMAXINDEX';
I lsclAl, lsclAl1, ... , lsclAl`LSCLMAXINDEX';
I lsclBe, lsclBe1, ... , lsclBe`LSCLMAXINDEX';

* Dirac indices
I lsclDi, lsclDi1, ... , lsclDi`LSCLMAXINDEX';
I lsclDj, lsclDj1, ... , lsclDj`LSCLMAXINDEX';

* Color indices
I lsclCFi, lsclCFi1, ... , lsclCFi`LSCLMAXINDEX';
I lsclCFj, lsclCFj1, ... , lsclCFj`LSCLMAXINDEX';
I lsclCAi, lsclCAi1, ... , lsclCAi`LSCLMAXINDEX';
I lsclCAj, lsclCAj1, ... , lsclCAj`LSCLMAXINDEX';

* Generic symbols
S lsclS, lsclS1, ... , lsclS`LSCLMAXINDEX';
S lsclX, lsclX1, ... , lsclX`LSCLMAXINDEX';
S lsclY, lsclY1, ... , lsclY`LSCLMAXINDEX';
S lsclZ, lsclZ1, ... , lsclZ`LSCLMAXINDEX';

* Generic vectors
V lsclP, lsclP1, ... , lsclP`LSCLMAXINDEX';
V lsclQ, lsclQ1, ... , lsclQ`LSCLMAXINDEX';
V lsclL, lsclL1, ... , lsclL`LSCLMAXINDEX';
V lsclV, lsclV1, ... , lsclV`LSCLMAXINDEX';

* Generic commutative functions
CF lsclF, lsclF1, ... , lsclF`LSCLMAXINDEX';
CF lsclG, lsclG1, ... , lsclG`LSCLMAXINDEX';

* Generic noncommutative functions
CF lsclNF, lsclNF1, ... , lsclNF`LSCLMAXINDEX';
CF lsclNG, lsclNG1, ... , lsclNG`LSCLMAXINDEX';

* Generic commutative tensors
CT lsclT, lsclT1, ... , lsclT`LSCLMAXINDEX';

* Generic noncommutative tensors
CT lsclNT, lsclNT1, ... , lsclNT`LSCLMAXINDEX';

* Polarization vector ep(px)
V lsclPVIp1, ... , lsclPVIp`LSCLMAXINDEX';
V lsclPVIq1, ... , lsclPVIq`LSCLMAXINDEX';

* Polarization vector ep*(px)
V lsclPVOp1, ... , lsclPVOp`LSCLMAXINDEX';
V lsclPVOq1, ... , lsclPVOq`LSCLMAXINDEX';

* Flags
Auto S lsclFlag;
CF lsclEpHelpFlag, lsclDiaFlag;

* Feynman rules
F lsclNCHold, lsclQGPropagator, lsclQGVertex, lsclQGPolarization, 
lsclDiracU, lsclDiracUBar, lsclDiracV, lsclDiracVBar, lsclPolVector;
CF lsclSUNDelta(S), lsclSUNFDelta(S), lsclFunColorIndex, lsclAdjColorIndex,  lsclSUNTF, lsclSUNF, lsclSUND,
lsclMass, lsclHold, lsclDiracChain, lsclDiracChainHold,  lsclFAD, lsclDiracIndex, lsclLorentzIndex,  
lsclVector, lsclMetricTensor(S),  lsclDiracTrace, lsclDiracTraceRotated, lsclGFAD
S lsclGaugeXi;

* Insertion of reduction tables
CF lsclIntegralNumber, lsclIntegral, lsclIsolateFlag;

* When we need to wrap something into something else
Auto CF lsclWrapFun, lsclIsoFun;

* Dirac algebra related variables
F lsclDiracSpinor, lsclDiracChainNC, lsclDiracMatrix;
CF lsclDiracChainOpen, lsclDiracFlag1, lsclDCh; 
nt lsclDiracGammaOpen, lsclDiracGammaChiralOpen, lsclDiracGamma, lsclDiracGammaChiral;
CF lsclDiracGammaHold;
CF lsclAuxHoldFunction;
nt lsclVecFu;
Auto CF lsclNonDiracPiece;

* SU(N) algebra functions
S lsclSUNN,lsclCF,lsclCA,lsclNA;

* Factorization related functions
CF lsclNum, lsclDen, lsclRat, lsclTdNum, lsclTdDen;
CF lsclHoldNum, lsclHoldDen, lsclHoldRat, lsclSkipNum, lsclSkipDen;

* Tensor reduction functions
CF lsclTensRedMomentaRaw, lsclTensRedMomenta(S), lsclTensRedLoopRaw, lsclTensRedLoop(S), 
lsclTensRedHold, lsclTensRedRank, lsclTensRedNLegs, lsclTensRedTypeRaw, lsclTensRedType(S), 
lsclTensorStructure;
Auto S lsclTd;

* Topology identification functions
CF lsclRawTopology,lsclSPD,lsclGLI;
#endif
