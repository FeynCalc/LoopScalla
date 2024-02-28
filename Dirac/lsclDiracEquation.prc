#procedure lsclDiracEquation(MAX1,SEED1,MAX2,SEED2)

* lsclDiracEquation() applies Dirac equation to closed chains

* TODO extend to cases without g5 or other chiral matrices

* Dirac equations for left spinors (borrowed from FormCalc)
#message lsclDiracEquation: Left spinor simplifications: `time_'

#do i=1,`MAX1'
id lsclDiracSpinor(lsclQ?,lsclZ?,lsclS?{1,-1})*lsclDiracGamma(?a,lsclQ?,?b) = lsclDiracSpinor(lsclQ,lsclZ,lsclS)*sign_(nargs_(?a))*(
	-2*distrib_(-1,1,lsclVecFu,lsclDiracGamma,?a)*lsclDiracGamma(lsclQ,?b) +
	lsclS*lsclZ*lsclDiracGamma(?a,?b)
	);

repeat;
id lsclVecFu(lsclMu?)*lsclDiracGamma(?a)*lsclDiracGamma(lsclQ?,?b) = d_(lsclQ,lsclMu)*lsclDiracGamma(?a,?b);
id lsclDiracGamma(?a)*lsclDiracGamma(?b) = lsclDiracGamma(?a,?b);
id lsclDiracGamma()=1;
#call lsclDiracTrickShort()
endrepeat;

#message lsclDiracEquation left: Iteration `i'
#call lsclDiracIsolate(lsclNonDiracPiece{`SEED1'+2*`i'},lsclNonDiracPiece{`SEED1'+(2*`i'+1)})
#include lsclSharedTools.h #lsclTiming

#enddo

* Dirac equations for right spinors (borrowed from FormCalc)
#message lsclDiracEquation: Right spinor simplifications: `time_'

#do i=1,`MAX1'
id lsclDiracGamma(?a,q1?,?b)*lsclDiracGammaChiral(lsclMu?{6,7}[lsclX])*lsclDiracSpinor(lsclQ?,lsclZ?,lsclS?{1,-1}) = (
	lsclDiracGamma(?a,lsclQ)*2*distrib_(-1,1,lsclVecFu,lsclDiracGamma,?b)*lsclDiracGammaChiral({6,7}[lsclX]) +
	sign_(nargs_(?b))*lsclS*lsclZ*lsclDiracGamma(?a,?b)*lsclDiracGammaChiral({7,6}[lsclX])
	)*lsclDiracSpinor(lsclQ,lsclZ,lsclS);

repeat;
id lsclDiracGamma(?a,lsclQ?)*lsclVecFu(lsclMu?)*lsclDiracGamma(?b) = d_(lsclQ,lsclMu)*lsclDiracGamma(?a,?b);
id lsclDiracGamma(?a)*lsclDiracGamma(?b) = lsclDiracGamma(?a,?b);
id lsclDiracGamma()=1;
#call lsclDiracTrickShort()
endrepeat;

#message lsclDiracEquation left: Iteration `i'
#call lsclDiracIsolate(lsclNonDiracPiece{`SEED2'+2*`i'},lsclNonDiracPiece{`SEED2'+(2*`i'+1)})
#include lsclSharedTools.h #lsclTiming

#enddo

if (occurs(lsclVecFu));
 exit "lsclDiracEquation: Something went wrong when applying the Dirac equation.";
endif;

#message lsclDiracEquation: All done: `time_'


#endprocedure
