#ifndef `LSCLDEFINITIONS'
#define LSCLDEFINITIONS

S `lsclDim';
Dimension `lsclDim';

* Sets of momenta appearing in the amplitude

auto V q, p, k;
set externalMomenta: p1,...,p`LSCLMAXINDEX', k1,...,k`LSCLMAXINDEX';
set externalMomentaP: p1,...,p`LSCLMAXINDEX';
set externalMomentaK: k1,...,k`LSCLMAXINDEX';
set internalMomenta: q1,...,q`LSCLMAXINDEX';

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

* Generic commutative tensors
CT lsclT, lsclT1, ... , lsclT`LSCLMAXINDEX';


* Generic noncommutative functions
CF lsclNF, lsclNF1, ... , lsclNF`LSCLMAXINDEX';
CF lsclNG, lsclNG1, ... , lsclNG`LSCLMAXINDEX';

* Generic noncommutative tensors
CT lsclNT, lsclNT1, ... , lsclNT`LSCLMAXINDEX';

* Topologies



S lsclFlagExplicitDenominator;
S lsclGaugeXi;
F lsclQGPropagator, lsclQGVertex, lsclQGPolarization, lsclDiracU, lsclDiracUBar, lsclDiracV, lsclDiracVBar, lsclPolVector;

CF lsclSUNDelta(S), lsclSUNFDelta(S), lsclFunColorIndex, lsclAdjColorIndex,  lsclSUNTF, lsclSUNF, lsclSUND;

CF lsclMass, lsclHold, lsclDiracChain, lsclDiracChainHold,  lsclFAD, lsclDiracIndex, lsclLorentzIndex,  
lsclVector, lsclMetricTensor(S),  lsclDiracTrace, lsclDiracTraceRotated, lsclGFAD,
lsclIntegralNumber, lsclIntegral, lsclDiaFlag;

F lsclNCHold;

* When we need to wrap something into something else
Auto CF lsclWrapFun;

Auto CF lsclIsoFun;

Auto S lsclFlag;

* Polarization vector ep(px)
V lsclPVIp1, ... , lsclPVIp`LSCLMAXINDEX';
V lsclPVIq1, ... , lsclPVIq`LSCLMAXINDEX';
* Polarization vector ep*(px)
V lsclPVOp1, ... , lsclPVOp`LSCLMAXINDEX';
V lsclPVOq1, ... , lsclPVOq`LSCLMAXINDEX';


Auto CF lsclNonColorPiece;

* Dirac algebra functions

* representa a position dependent Dirac spinor, second argument distinguishes between
* U and V
F lsclDiracSpinor, lsclDiracChainNC;
CF lsclDiracChainOpen; 

* open chains of d-dimensional Dirac matrices, first argument denotes the chain
nt lsclDiracGammaOpen, lsclDiracGammaChiralOpen, lsclDiracGammaOpen2;
* closed chains of d-dimensional Dirac matrices, always sandwiched between two spinors
nt lsclDiracGamma, lsclDiracGammaChiral;

F lsclDiracMatrix;


CF lsclDiracGammaHold;
CF lsclAuxHoldFunction;
* auxiliary variables for Dirac algebra simplifications
nt lsclVecFu;

Auto CF lsclNonDiracPiece;
CF lsclDiracFlag1, lsclDCh;

S lsclEp;

* SU(N) algebra functions

S lsclSUNN,lsclCF,lsclCA,lsclNA, lsclCRmCA2;
S lsclIsolateFlag;
CF lsclRawTopology,lsclTopoID;

S lsclFlagSPRule;
CF lsclTopoConvert;

CF lsclNum, lsclDen, lsclRat, lsclTdNum, lsclTdDen;

CF lsclHoldNum, lsclHoldDen, lsclHoldRat, lsclSkipNum, lsclSkipDen;


CF lsclEpHelpFlag;

* Tensor reduction functions

CF lsclTensRedMomentaRaw, lsclTensRedMomenta(S), lsclTensRedLoopRaw, lsclTensRedLoop(S), lsclTensRedHold, lsclTensRedRank, lsclTensRedNLegs, lsclTensRedTypeRaw, lsclTensRedType(S), lsclTensorStructure;
Auto S lsclTd;

* Must go to FeynCalc Definitions!
CF lsclSPD,lsclGLI;

Auto S lsclDiaFlag;

#endif
