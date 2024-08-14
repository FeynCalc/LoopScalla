off statistics;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#$testID=0;

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
 L lsclTestExp = 0;
 L lsclExpectedExp = 0;
 b lsclF;
 moduleoption notinparallel;
 .sort
 collect lsclWrapFun1,lsclWrapFun2;
 #call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
 moduleoption notinparallel;
 .sort
 L lsclExpectedExp = 0;
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort
 
*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF*(lsclS1/(lsclS+1)+lsclS2/(lsclS-1));
L lsclExpectedExp = 0;
.sort
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = 1/(lsclS - 1)*lsclF*lsclRat(1,1)*lsclS2 + 1/(lsclS + 1)*lsclF*lsclRat(1,1)*lsclS1;
 .sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
 L lsclTestExp = 0;
 L lsclExpectedExp = 0;
.sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF*(lsclS1/(lsclS+1)+lsclS2/(lsclS-1));
L lsclExpectedExp = 0;
b lsclF;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF*lsclRat(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + lsclS2,lsclS^2 - 1);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
 L lsclTestExp = 0;
 L lsclExpectedExp = 0;
.sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF1*lsclS1/(lsclS+1)+lsclF1*lsclS2/(lsclS-1)+lsclF2*lsclS;
L lsclExpectedExp = 0;
b lsclF1, lsclF2;
.sort
collect lsclWrapFun1,lsclWrapFun2;
.sort
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF1*lsclRat(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + lsclS2,lsclS^2 - 1) + 
lsclF2*lsclRat(lsclS,1);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF1*lsclS1/(lsclS+1)+lsclF1*lsclS2*lsclDen(lsclS-1)+lsclF2*lsclS;
L lsclExpectedExp = 0;
b lsclF1, lsclF2;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF1*lsclRat(lsclS*lsclS1 + lsclS*lsclS2 - lsclS1 + lsclS2,lsclS^2 - 1) + 
lsclF2*lsclRat(lsclS,1);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF1*lsclS1/(lsclS+1)+lsclF1*lsclS2*lsclDen(lsclS-1)^2+lsclF2*lsclS;
L lsclExpectedExp = 0;
b lsclF1, lsclF2;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF1*lsclRat(lsclS^2*lsclS1 - 2*lsclS*lsclS1 + lsclS*lsclS2 + lsclS1 + lsclS2,lsclS^3-lsclS^2-lsclS+1) + 
lsclF2*lsclRat(lsclS,1);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
*********************************************************************
#$testID=`$testID'+1;
* #define lsclPprApplyPolyRatFunVerbosity "2"
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF1*lsclNum(1/lsclS1)*lsclS2;
L lsclExpectedExp = 0;
b lsclF1, lsclF2;
.sort
collect lsclWrapFun1,lsclWrapFun2;
*.sort
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF1*lsclRat(lsclS2,lsclS1);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
*********************************************************************
#$testID=`$testID'+1;
* #define lsclPprApplyPolyRatFunVerbosity "2"
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF1*lsclNum(1/lsclS1^3)*lsclS2;
L lsclExpectedExp = 0;
b lsclF1, lsclF2;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF1*lsclRat(lsclS2,lsclS1^3);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
*********************************************************************
#$testID=`$testID'+1;
* #define lsclPprApplyPolyRatFunVerbosity "2"
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF1*lsclNum(1/lsclS1^3)^2*lsclS2^2;
L lsclExpectedExp = 0;
b lsclF1, lsclF2;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF1*lsclRat(lsclS2^2,lsclS1^6);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
*********************************************************************
#$testID=`$testID'+1;
* #define lsclPprApplyPolyRatFunVerbosity "2"
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF1*lsclDen(lsclS1^3)^2*lsclS2^2;
L lsclExpectedExp = 0;
b lsclF1, lsclF2;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF1*lsclRat(lsclS2^2,lsclS1^6);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
*********************************************************************
#$testID=`$testID'+1;
* #define lsclPprApplyPolyRatFunVerbosity "2"
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
L lsclTestExp = lsclF1*lsclDen(1/lsclS1^3)^2*1/lsclS2^2;
L lsclExpectedExp = 0;
b lsclF1, lsclF2;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclF1*lsclRat(lsclS1^6,lsclS2^2);
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort
*********************************************************************
#$testID=`$testID'+1;
* #define lsclPprApplyPolyRatFunVerbosity "2"
.sort
#define LSCLTESTNAME "lsclApplyPolyRatFun-`$testID'";
S lsclSUNN, u0b,lsclEp, gs,la;
CF topology1,topology10;
L lsclTestExp = - 15/32*lsclNum(lsclSUNN - 1)*lsclNum(lsclSUNN + 1)*lsclNum(u0b - 1)*
      lsclDen(u0b)^2*lsclDen(u0b^4)*lsclDen(u0b^4 - 4*u0b^3 + 6*u0b^2 - 4*u0b
       + 1)*lsclWrapFun(topology1(1,0,1,1,0,0,0,0,1,0,0,0),-2)*lsclEp^-6*gs^8*
      la^-4 - 75/128*lsclNum(lsclSUNN - 1)*lsclNum(lsclSUNN + 1)*lsclNum(u0b
       - 1)*lsclDen(u0b)^2*lsclDen(u0b^2)*lsclDen(u0b^4 - 4*u0b^3 + 6*u0b^2 - 
      4*u0b + 1)*lsclWrapFun(topology10(1,1,0,0,1,0,0,1,0,0,0,0),-2)*lsclEp^-6
      *gs^8*la^-4 + 3/32*lsclNum(u0b)*lsclNum(lsclSUNN - 1)*lsclNum(lsclSUNN
       + 1)*lsclNum(u0b - 1)*lsclDen(u0b)^2*lsclDen(u0b^4)*lsclDen(u0b^4 - 4*
      u0b^3 + 6*u0b^2 - 4*u0b + 1)*lsclWrapFun(topology1(1,0,1,1,0,0,0,0,1,0,0
      ,0),-2)*lsclEp^-6*gs^8*la^-4 + 15/128*lsclNum(u0b)*lsclNum(lsclSUNN - 1)
      *lsclNum(lsclSUNN + 1)*lsclNum(u0b - 1)*lsclDen(u0b)^2*lsclDen(u0b^2)*
      lsclDen(u0b^4 - 4*u0b^3 + 6*u0b^2 - 4*u0b + 1)*lsclWrapFun(topology10(1,
      1,0,0,1,0,0,1,0,0,0,0),-2)*lsclEp^-6*gs^8*la^-4;
L lsclExpectedExp = 0;
b lsclWrapFun,lsclEp,gs,la;
.sort
collect lsclWrapFun1,lsclWrapFun2;
#call lsclApplyPolyRatFun(lsclNum,lsclDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
L lsclExpectedExp = lsclRat(3*lsclSUNN^2*u0b - 15*lsclSUNN^2 - 3*u0b + 15,32*u0b^9 - 96*
      u0b^8 + 96*u0b^7 - 32*u0b^6)*lsclWrapFun(topology1(1,0,1,1,0,0,0,0,1,0,0
      ,0),-2)*lsclEp^-6*gs^8*la^-4 + lsclRat(15*lsclSUNN^2*u0b - 75*lsclSUNN^2
       - 15*u0b + 75,128*u0b^7 - 384*u0b^6 + 384*u0b^5 - 128*u0b^4)*
      lsclWrapFun(topology10(1,1,0,0,1,0,0,1,0,0,0,0),-2)*lsclEp^-6*gs^8*la^-4;
.sort
#call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
.sort















*********************************************************************
.end;
*********************************************************************