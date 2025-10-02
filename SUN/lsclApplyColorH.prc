#procedure lsclApplyColorH()

* lsclApplyColorH() simplifies color algebra using color.h

#include color.h

* Redeclare color indices here, cf. https://github.com/vermaseren/form/issues/414
I lsclCFi=NR, <lsclCFi1=NR> , ... ,<lsclCFi`lsclPprMaxIndex'=NR>;
I lsclCFj=NR, <lsclCFj1=NR>, ... , <lsclCFj`lsclPprMaxIndex'=NR>;
I lsclCAi=NA, <lsclCAi1=NA>, ... , <lsclCAi`lsclPprMaxIndex'=NA>;
I lsclCAj=NA, <lsclCAj1=NA>, ... , <lsclCAj`lsclPprMaxIndex'=NA>; 


repeat;
id lsclSUNDelta(lsclCAi?,lsclCAj?) = d_(lsclCAi,lsclCAj);
id lsclSUNFDelta(lsclCFi?,lsclCFj?) = d_(lsclCFi,lsclCFj);
id lsclSUNTF(lsclCAi?,lsclCFi?,lsclCFj?) = T(lsclCFi,lsclCFj,lsclCAi);
id lsclSUNF(lsclCAi1?,lsclCAi2?,lsclCAi3?) = f(lsclCAi1,lsclCAi2,lsclCAi3);
endrepeat;


if (occurs(lsclSUNDelta,lsclSUNFDelta,lsclSUNTF,lsclSUNF,lsclSUND));
print "lsclApplyColorH: Error, some quantities were not converted to the color.h notation, e.g.: %t";
endif;
if (occurs(lsclSUNDelta,lsclSUNFDelta,lsclSUNTF,lsclSUNF,lsclSUND)) exit;

#call docolor

repeat;
id NA = lsclNA;
id NR = lsclSUNN;
id I2R = 1/2;
id cR = lsclCF;
id cA = lsclCA;
id [cR-cA/2] = lsclCRmCA2;
id d_(lsclCAi?,lsclCAj?) = lsclSUNDelta(lsclCAi,lsclCAj);
id d_(lsclCFi?,lsclCFj?) = lsclSUNFDelta(lsclCFi,lsclCFj);
id T(lsclCFi?,lsclCFj?,lsclCAi?,?a) = lsclSUNTF(lsclCAi,?a,lsclCFi,lsclCFj);
id f(lsclCAi1?,lsclCAi2?,lsclCAi3?) = lsclSUNF(lsclCAi1,lsclCAi2,lsclCAi3);
endrepeat;

#message lsclApplyColorH: Calling sort : `time_' ...
.sort
#message lsclApplyColorH: ... done : `time_'

* Fix the dimension upon using color.h
Dimension lsclD;

* Redeclare color indices again
I lsclCFi, lsclCFi1, ... , lsclCFi`lsclPprMaxIndex';
I lsclCFj, lsclCFj1, ... , lsclCFj`lsclPprMaxIndex';
I lsclCAi, lsclCAi1, ... , lsclCAi`lsclPprMaxIndex';
I lsclCAj, lsclCAj1, ... , lsclCAj`lsclPprMaxIndex';



if (occurs(T,f,NA,NR,I2R,cR,cA,[cR-cA/2]));
print "lsclApplyColorH: Error, some quantities were not converted from the color.h notation, e.g.: %t";
endif;
if (occurs(T,f,NA,NR,I2R,cR,cA,[cR-cA/2])) exit;

#endprocedure
