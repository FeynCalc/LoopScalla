off statistics;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#$testID=0;

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclAnti5-`$testID'";
 L lsclTestExp = lsclDiracGammaChiralOpen(1,5)*lsclDiracGammaChiralOpen(1,5);
 L lsclExpectedExp = 0;
 moduleoption notinparallel;
 .sort
 #call lsclAnti5();
moduleoption notinparallel;
 .sort
 L lsclExpectedExp = 1;
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort
 
*********************************************************************



.end









* #define tfmVerbose "1"

#include tfmSwitches.h
#include tfmDeclarations.h

Off Statistics;
Auto V p,q;
Auto I mu,nu;

#define NTESTS "1000"
#define TESTNAME "tfmAnti5";

****************************************************

#define TESTEXP1 "tfmDiracGammaChiralOpen(1,5)*tfmDiracGammaChiralOpen(1,5)"
#define EXPECTED1 "1"

#define TESTEXP2 "tfmDiracGammaChiralOpen(1,6)*tfmDiracGammaChiralOpen(1,6)"
#define EXPECTED2 "2*tfmDiracGammaChiralOpen(1,6)"

#define TESTEXP3 "tfmDiracGammaChiralOpen(1,7)*tfmDiracGammaChiralOpen(1,7)"
#define EXPECTED3 "2*tfmDiracGammaChiralOpen(1,7)"

#define TESTEXP4 "tfmDiracGammaChiralOpen(1,5)*tfmDiracGammaChiralOpen(1,5)*tfmDiracGammaChiralOpen(1,5)"
#define EXPECTED4 "tfmDiracGammaChiralOpen(1,5)"

#define TESTEXP5 "tfmDiracGammaChiralOpen(1,5)*tfmDiracGammaOpen(1,mu1)"
#define EXPECTED5 "-tfmDiracGammaOpen(1,mu1)*tfmDiracGammaChiralOpen(1,5)"

#define TESTEXP6 "tfmDiracGammaChiralOpen(1,5)*tfmDiracGammaOpen(1,mu1,mu2)"
#define EXPECTED6 "tfmDiracGammaOpen(1,mu1,mu2)*tfmDiracGammaChiralOpen(1,5)"

#define TESTEXP7 "tfmDiracGammaChiralOpen(1,5)*tfmDiracGammaOpen(1,mu1,mu2,mu3)"
#define EXPECTED7 "-tfmDiracGammaOpen(1,mu1,mu2,mu3)*tfmDiracGammaChiralOpen(1,5)"

#define TESTEXP8 "tfmDiracGammaChiralOpen(1,5)*tfmDiracGammaOpen(1,mu1,p1,mu3)"
#define EXPECTED8 "-tfmDiracGammaOpen(1,mu1,p1,mu3)*tfmDiracGammaChiralOpen(1,5)"

#define TESTEXP9 "tfmDiracGammaChiralOpen(1,6)*tfmDiracGammaOpen(1,mu1)"
#define EXPECTED9 "tfmDiracGammaOpen(1,mu1)*tfmDiracGammaChiralOpen(1,7)"

#define TESTEXP10 "tfmDiracGammaChiralOpen(1,6)*tfmDiracGammaOpen(1,mu1,mu2)"
#define EXPECTED10 "tfmDiracGammaOpen(1,mu1,mu2)*tfmDiracGammaChiralOpen(1,6)"

#define TESTEXP11 "tfmDiracGammaChiralOpen(1,6)*tfmDiracGammaOpen(1,mu1,mu2,mu3)"
#define EXPECTED11 "tfmDiracGammaOpen(1,mu1,mu2,mu3)*tfmDiracGammaChiralOpen(1,7)"

#define TESTEXP12 "tfmDiracGammaChiralOpen(1,7)*tfmDiracGammaOpen(1,mu1)"
#define EXPECTED12 "tfmDiracGammaOpen(1,mu1)*tfmDiracGammaChiralOpen(1,6)"

#define TESTEXP13 "tfmDiracGammaChiralOpen(1,7)*tfmDiracGammaOpen(1,mu1,mu2)"
#define EXPECTED13 "tfmDiracGammaOpen(1,mu1,mu2)*tfmDiracGammaChiralOpen(1,7)"

#define TESTEXP14 "tfmDiracGammaChiralOpen(1,7)*tfmDiracGammaOpen(1,mu1,mu2,mu3)"
#define EXPECTED14 "tfmDiracGammaOpen(1,mu1,mu2,mu3)*tfmDiracGammaChiralOpen(1,6)"

#define TESTEXP15 "tfmDiracGammaChiralOpen(1,7)*tfmDiracGammaOpen(1,mu1,mu2,mu3,mu4)"
#define EXPECTED15 "tfmDiracGammaOpen(1,mu1,mu2,mu3,mu4)*tfmDiracGammaChiralOpen(1,7)"

#define TESTEXP16 "tfmDiracGammaChiralOpen(1,6)*tfmDiracGammaOpen(1,mu1,mu2,mu3,mu4)"
#define EXPECTED16 "tfmDiracGammaOpen(1,mu1,mu2,mu3,mu4)*tfmDiracGammaChiralOpen(1,6)"

#define TESTEXP17 "tfmDiracGammaChiralOpen(1,7)*tfmDiracGammaOpen(1,mu1,mu2,mu3,mu4,mu5)"
#define EXPECTED17 "tfmDiracGammaOpen(1,mu1,mu2,mu3,mu4,mu5)*tfmDiracGammaChiralOpen(1,6)"

#define TESTEXP18 "tfmDiracGammaChiralOpen(1,6)*tfmDiracGammaOpen(1,mu1,mu2,mu3,mu4,mu5)"
#define EXPECTED18 "tfmDiracGammaOpen(1,mu1,mu2,mu3,mu4,mu5)*tfmDiracGammaChiralOpen(1,7)"

****************************************************

#do i = 1, `NTESTS'
#ifndef `TESTEXP`i''
#breakdo
#endif
#define testname "`TESTNAME'-`i'";
L testexp = `TESTEXP`i'';
#call tfmAnti5();
.sort
L expected = `EXPECTED`i'';
.sort
#call tfmCheckTest(`testname',testexp,expected);

#enddo

.end;
