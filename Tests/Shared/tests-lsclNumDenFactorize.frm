off statistics;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h


*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-1";
 L lsclTestExp = 0;
 L lsclExpectedExp = 0;
 .sort
 #call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{lsclS1\,lsclS2});
 .sort
 L lsclExpectedExp = 0;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 .sort
 
*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-2";
L lsclTestExp = 1/(lsclS - 1)*lsclF*lsclRat(1,1)*lsclS2 + 1/(lsclS + 1)*lsclF*lsclRat(1,1)*lsclS1;
L lsclExpectedExp = 0;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{\,0});
.sort
L lsclExpectedExp = 1/(lsclS - 1)*lsclF*lsclS2 + 1/(lsclS + 1)*lsclF*lsclS1;
 .sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
 
*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-3";
L lsclTestExp = lsclF*lsclRat(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + lsclS2,lsclS^2 - 1);
L lsclExpectedExp = 0;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{\,0});
.sort
L lsclExpectedExp = lsclF*lsclNum(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + lsclS2)*lsclDen(
      lsclS - 1)*lsclDen(lsclS + 1);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
 
*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-4";
L lsclTestExp = lsclF1*lsclRat(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + lsclS2,lsclS^2 - 1) + 
lsclF2*lsclRat(lsclS,1);
L lsclExpectedExp = 0;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{\,0});
.sort
L lsclExpectedExp = lsclF1*lsclNum(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + 
lsclS2)*lsclDen(lsclS - 1)*lsclDen(lsclS + 1) + lsclF2*lsclNum(lsclS);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort

*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-5";
L lsclTestExp = lsclF1*lsclRat(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + lsclS2,lsclS^2 - 1) + 
lsclF2*lsclRat(lsclEp,1);
L lsclExpectedExp = 0;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{lsclEp});
.sort
L lsclExpectedExp = lsclF1*lsclNum(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + lsclS2)*lsclDen(
      lsclS - 1)*lsclDen(lsclS + 1) + lsclF2*lsclEp;
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort

*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-6";
L lsclTestExp = lsclF1*lsclRat(lsclS^2*lsclS1 - 2*lsclS*lsclS1 + lsclS*lsclS2 + lsclS1 + lsclS2,lsclS^3-lsclS^2-lsclS+1) + 
lsclF2*lsclRat(lsclS,lsclEp^2);
L lsclExpectedExp = 0;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{lsclEp});
.sort
L lsclExpectedExp = lsclF1*lsclNum(lsclS^2*lsclS1 - 2*lsclS*lsclS1 + 
    lsclS*lsclS2 + lsclS1 + lsclS2)*lsclDen(lsclS - 1)^2*lsclDen(lsclS + 1) + lsclF2*lsclNum(
    lsclS)*lsclEp^-2;
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort

*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-7";
L lsclTestExp = lsclF1*lsclRat(lsclS2,lsclS1);
L lsclExpectedExp = 0;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{lsclS1\,lsclS2});
.sort
L lsclExpectedExp = lsclF1*lsclS1^-1*lsclS2;
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort

*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-8";
L lsclTestExp = lsclF1*lsclRat(lsclS2,lsclS1^3);
L lsclExpectedExp = 0;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{lsclS1});
.sort
L lsclExpectedExp = lsclF1*lsclNum(lsclS2)*lsclS1^-3;
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort

*********************************************************************
#define LSCLTESTNAME "lsclNumDenFactorize-9";
* #define lsclPprApplyPolyRatFunVerbosity "2"
L lsclTestExp = lsclF1*lsclRat(lsclS2^2,lsclS1^6);
L lsclExpectedExp = 0;
.sort
#call lsclNumDenFactorize(lsclNum,lsclDen,lsclRat,{\,0});
.sort
L lsclExpectedExp = lsclF1*lsclNum(lsclS2)^2*lsclDen(lsclS1)^6;
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort

*********************************************************************
.end;
*********************************************************************