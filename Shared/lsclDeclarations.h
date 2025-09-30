#ifndef `LSCLDECLARATIONS'
#define LSCLDECLARATIONS

* Increases the output verbosity of the main code
#ifndef `lsclPprVerbosity'
#define lsclPprVerbosity "0"
#endif

* Allows to export intermediate results to compare 
* them with a FeynCalc calculation
#ifndef `lsclPprDebugWithFeynCalc'
#define lsclPprDebugWithFeynCalc "0"
#endif

* Define whether each contribution from a separate diagram should
* be multiplied by lsclDiaFlag(diaNumber)
#ifndef `lsclPprAddDiaFlag'
#define lsclPprAddDiaFlag "0"
#endif

* Defines the maximal index of each variable that has a suffix number,
* e.g. p1,p2, ... p100 etc.
#ifndef `lsclPprMaxIndex'
#define lsclPprMaxIndex "100"
#endif

* Defines the max number of propagators that may appear in an amplitude.
* Used by the topology identification code when merging propagators into
* integral families.
#ifndef `lsclPprMaxPropagators'
#define lsclPprMaxPropagators "16"
#endif

* Specifies whether lsclIsolate should isolate loop momenta k1,k2,... in addition
* to the variables specified in the function call. This is needed e.g. for the
* tensor reduction helper functions
#ifndef `lsclPprIsolateLoopMomenta'
#define lsclPprIsolateLoopMomenta "0"
#endif

* Increases the output verbosity of lsclApplyPolyRatFun
#ifndef `lsclPprApplyPolyRatFunVerbosity'
#define lsclPprApplyPolyRatFunVerbosity "0"
#endif

* Increases the output verbosity of lsclNumDenFactorize
#ifndef `lsclPprNumDenFactorizeVerbosity'
#define lsclPprNumDenFactorizeVerbosity "0"
#endif

#ifndef `lsclPprMaxDiracGammaLengthSimplification'
#define lsclPprMaxDiracGammaLengthSimplification "0"
#endif

#ifndef `lsclPprGhostPropagatorSign'
#define lsclPprGhostPropagatorSign "1"
#endif


#endif
