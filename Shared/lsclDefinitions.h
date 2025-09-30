#ifndef `LSCLDEFINITIONS'
#define LSCLDEFINITIONS

S lsclD, lsclEp;
Dimension lsclD;

* Sets of momenta appearing in the amplitude

auto V q, p, k;
set externalMomenta: p1,...,p`lsclPprMaxIndex', q1,...,q`lsclPprMaxIndex';
set externalMomentaP: p1,...,p`lsclPprMaxIndex';
set externalMomentaK: q1,...,q`lsclPprMaxIndex';
set internalMomenta: k1,...,k`lsclPprMaxIndex';

* Generic indices
I lsclI, lsclI1, ... , lsclI`lsclPprMaxIndex';

* Lorentz indices
I lsclMu, lsclMu1, ... , lsclMu`lsclPprMaxIndex';
I lsclNu, lsclNu1, ... , lsclNu`lsclPprMaxIndex';
I lsclRho, lsclRho1, ... , lsclRho`lsclPprMaxIndex';
I lsclAl, lsclAl1, ... , lsclAl`lsclPprMaxIndex';
I lsclBe, lsclBe1, ... , lsclBe`lsclPprMaxIndex';

* Dirac indices
I lsclDi, lsclDi1, ... , lsclDi`lsclPprMaxIndex';
I lsclDj, lsclDj1, ... , lsclDj`lsclPprMaxIndex';

* Color indices
I lsclCFi, lsclCFi1, ... , lsclCFi`lsclPprMaxIndex';
I lsclCFj, lsclCFj1, ... , lsclCFj`lsclPprMaxIndex';
I lsclCAi, lsclCAi1, ... , lsclCAi`lsclPprMaxIndex';
I lsclCAj, lsclCAj1, ... , lsclCAj`lsclPprMaxIndex';

* Generic symbols
S lsclS, lsclS1, ... , lsclS`lsclPprMaxIndex';
S lsclX, lsclX1, ... , lsclX`lsclPprMaxIndex';
S lsclY, lsclY1, ... , lsclY`lsclPprMaxIndex';
S lsclZ, lsclZ1, ... , lsclZ`lsclPprMaxIndex';

* Generic vectors
V lsclP, lsclP1, ... , lsclP`lsclPprMaxIndex';
V lsclQ, lsclQ1, ... , lsclQ`lsclPprMaxIndex';
V lsclL, lsclL1, ... , lsclL`lsclPprMaxIndex';
V lsclV, lsclV1, ... , lsclV`lsclPprMaxIndex';

* Generic commutative functions
CF lsclF, lsclF1, ... , lsclF`lsclPprMaxIndex';
CF lsclG, lsclG1, ... , lsclG`lsclPprMaxIndex';

* Generic noncommutative functions
CF lsclNF, lsclNF1, ... , lsclNF`lsclPprMaxIndex';
CF lsclNG, lsclNG1, ... , lsclNG`lsclPprMaxIndex';

* Generic commutative tensors
CT lsclT, lsclT1, ... , lsclT`lsclPprMaxIndex';

* Generic noncommutative tensors
CT lsclNT, lsclNT1, ... , lsclNT`lsclPprMaxIndex';

* Polarization vector ep(px)
V lsclPVIp1, ... , lsclPVIp`lsclPprMaxIndex';
V lsclPVIq1, ... , lsclPVIq`lsclPprMaxIndex';

* Polarization vector ep*(px)
V lsclPVOp1, ... , lsclPVOp`lsclPprMaxIndex';
V lsclPVOq1, ... , lsclPVOq`lsclPprMaxIndex';

* Flags
Auto S lsclFlag;
CF lsclEpHelpFlag, lsclDiaFlag;

* Feynman rules
F lsclNCHold, lsclQGPropagator, lsclQGVertex, lsclQGPolarization,
lsclDiracU, lsclDiracUBar, lsclDiracV, lsclDiracVBar, lsclPolVector;
CF lsclSUNDelta(S), lsclSUNFDelta(S), lsclFunColorIndex, lsclAdjColorIndex,  lsclSUNTF, lsclSUNF, lsclSUND,
lsclMass, lsclHold, lsclDiracChain, lsclDiracChainHold,  lsclFAD, lsclDiracIndex, lsclLorentzIndex,  
lsclVector, lsclMetricTensor(S),  lsclDiracTrace, lsclDiracTraceRotated, lsclGFAD,
lsclPropagatorLine(S),lsclVertexBlob,lsclVertexBlobExternal;
S lsclGaugeXi;

* Insertion of reduction tables
CF lsclIntegralNumber, lsclIntegral, lsclIsolateFlag;

* When we need to wrap something into something else
Auto CF lsclWrapFun, lsclIsoFun;
CF lsclNonColorPiece1, lsclNonColorPiece2;

CF lsclFermionLine,lsclFermionLoop;

* Dirac algebra related variables
F lsclDiracSpinor, lsclDiracChainNC, lsclDiracMatrix;
CF lsclDiracChainOpen, lsclDiracFlag1, lsclDCh; 
nt lsclDiracGammaOpen, lsclDiracGammaChiralOpen, lsclDiracGamma, lsclDiracGammaChiral;
CF lsclDiracGammaHold;
CF lsclAuxHoldFunction;
nt lsclVecFu;
Auto CF lsclNonDiracPiece;

* SU(N) algebra functions
S lsclSUNN,lsclCF,lsclCA,lsclNA,lsclCRmCA2;

* Factorization related functions
CF lsclNum, lsclDen, lsclRat, lsclTdNum, lsclTdDen;
CF lsclHoldNum, lsclHoldDen, lsclHoldRat, lsclSkipNum, lsclSkipDen;

* Tensor reduction functions
F lsclDontIsolateF;
CF lsclDontIsolateCF;
CF lsclTensRedMomentaRaw, lsclTensRedMomenta(S), lsclTensRedLoopRaw, lsclTensRedLoop(S), 
lsclTensRedHold, lsclTensRedRank, lsclTensRedNLegs, lsclTensRedTypeRaw, lsclTensRedType(S), 
lsclTensorStructure;
Auto S lsclTd;

* Special tensors
ct lsclEps(A);

* Topology identification functions
CF lsclRawTopology,lsclSPD,lsclGLI;
#endif
