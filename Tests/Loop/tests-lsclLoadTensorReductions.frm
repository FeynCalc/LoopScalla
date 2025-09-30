off statistics;
on HighFirst;

#include lsclDeclarations.h
#include lsclDefinitions.h
#$testID=0;

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 L lsclTestExp = 0;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=3;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=3;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
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
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop()*lsclTensRedRank(0)*lsclTensRedNLegs(2)*lsclTensRedType();
 .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=3;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=3;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
 moduleoption notinparallel;
 .sort
 L lsclExpectedExp = 1;
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 S q1q1,q1q2,q2q2,k1q1,k1q2;
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop(k1(lsclMu))*lsclTensRedRank(1)*lsclTensRedNLegs(2)*lsclTd1;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=1;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=2;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
.sort
id lsclTensorStructure(lsclS?) = lsclTdNum(lsclS*q1(lsclMu));
argument;
id q1.q1=q1q1;
id q1.q2=q1q2;
id q2.q2=q2q2;
id k1.q1=k1q1;
id k1.q2=k1q2;
endargument;
#call lsclApplyPolyRatFun(lsclTdNum,lsclTdDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
 moduleoption notinparallel;
 .sort
 L lsclExpectedExp = lsclRat(k1q1,1)*lsclTensRedRank(1)*lsclTensRedNLegs(2);
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort
 
*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 S q1q1,q1q2,q2q2,k1q1,k1q2,k1k1;
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop(k1(lsclMu1),k1(lsclMu2))*lsclTensRedRank(2)*lsclTensRedNLegs(2)*lsclTd11;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=2;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=2;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
.sort
id lsclTensorStructure(lsclS?) = lsclTdNum(lsclS*q1(lsclMu1)*q1(lsclMu2));
argument;
id k1.k1=k1k1;
id q1.q1=q1q1;
id q1.q2=q1q2;
id q2.q2=q2q2;
id k1.q1=k1q1;
id k1.q2=k1q2;
endargument;
#call lsclApplyPolyRatFun(lsclTdNum,lsclTdDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
 moduleoption notinparallel;
 .sort
 L lsclExpectedExp =lsclRat(k1q1^2,1)*lsclTensRedRank(2)*lsclTensRedNLegs(2);
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 S q1q1,q1q2,q2q2,k1q1,k1q2,k1k1;
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop(k1(lsclMu1),k1(lsclMu2))*lsclTensRedRank(2)*lsclTensRedNLegs(2)*lsclTd11;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=2;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=2;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
.sort
id lsclTensorStructure(lsclS?) = lsclTdNum(lsclS*q1(lsclMu1)*q2(lsclMu2));
argument;
id k1.k1=k1k1;
id q1.q1=q1q1;
id q1.q2=q1q2;
id q2.q2=q2q2;
id k1.q1=k1q1;
id k1.q2=k1q2;
endargument;
#call lsclApplyPolyRatFun(lsclTdNum,lsclTdDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
 moduleoption notinparallel;
 .sort
 L lsclExpectedExp =lsclRat(k1q1*k1q2,1)*lsclTensRedRank(2)*lsclTensRedNLegs(2);
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 S q1q1,q1q2,q2q2,k1q1,k1q2,k1k1;
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop(k1(lsclMu1),k1(lsclMu2),k1(lsclMu3))*lsclTensRedRank(3)*lsclTensRedNLegs(2)*lsclTd111;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=3;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=2;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
.sort
id lsclTensorStructure(lsclS?) = lsclTdNum(lsclS*q1(lsclMu1)*q2(lsclMu2)*q1(lsclMu3));
argument;
id k1.k1=k1k1;
id q1.q1=q1q1;
id q1.q2=q1q2;
id q2.q2=q2q2;
id k1.q1=k1q1;
id k1.q2=k1q2;
endargument;
#call lsclApplyPolyRatFun(lsclTdNum,lsclTdDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
 moduleoption notinparallel;
 .sort

 L lsclExpectedExp =lsclRat(k1q1^2*k1q2,1)*lsclTensRedRank(3)*lsclTensRedNLegs(2);
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort


*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 S q1q1,q1q2,q2q2,k1q1,k1q2,k1k1,k1k2,k2k2,k2q1,k2q2;
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop(k1(lsclMu1),k1(lsclMu2),k2(lsclMu3))*lsclTensRedRank(3)*lsclTensRedNLegs(2)*lsclTd112;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=3;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=2;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
.sort
id lsclTensorStructure(lsclS?) = lsclTdNum(lsclS*q1(lsclMu1)*q2(lsclMu2)*q2(lsclMu3));
argument;
id k1.k1=k1k1;
id k1.k2=k1k2;
id k2.k2=k2k2;
id q1.q1=q1q1;
id q1.q2=q1q2;
id q2.q2=q2q2;
id k1.q1=k1q1;
id k1.q2=k1q2;
id k2.q1=k2q1;
id k2.q2=k2q2;
endargument;
#call lsclApplyPolyRatFun(lsclTdNum,lsclTdDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
 moduleoption notinparallel;
 .sort

 L lsclExpectedExp =lsclRat(k1q1*k1q2*k2q2,1)*lsclTensRedRank(3)*lsclTensRedNLegs(2);
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 S q1q1,q1q2,q2q2,k1q1,k1q2,k1k1,k1k2,k2k2,k2q1,k2q2;
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop(k1(lsclMu1),k1(lsclMu2),k2(lsclMu3))*lsclTensRedRank(3)*lsclTensRedNLegs(2)*lsclTd112;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=3;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=2;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
.sort
id lsclTensorStructure(lsclS?) = lsclTdNum(lsclS*q1(lsclMu1)*q2(lsclMu2)*q1(lsclMu3));
argument;
id k1.k1=k1k1;
id k1.k2=k1k2;
id k2.k2=k2k2;
id q1.q1=q1q1;
id q1.q2=q1q2;
id q2.q2=q2q2;
id k1.q1=k1q1;
id k1.q2=k1q2;
id k2.q1=k2q1;
id k2.q2=k2q2;
endargument;
#call lsclApplyPolyRatFun(lsclTdNum,lsclTdDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
 moduleoption notinparallel;
 .sort

 L lsclExpectedExp =lsclRat(k1q1*k1q2*k2q1,1)*lsclTensRedRank(3)*lsclTensRedNLegs(2);
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort

*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 S q1q1,q1q2,q2q2,k1q1,k1q2,k1k1,k1k2,k2k2,k2q1,k2q2;
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop(k1(lsclMu1),k2(lsclMu2))*lsclTensRedRank(2)*lsclTensRedNLegs(2)*lsclTd12;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=3;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=2;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
.sort
id lsclTensorStructure(lsclS?) = lsclTdNum(lsclS*q1(lsclMu1)*q2(lsclMu2));
argument;
id k1.k1=k1k1;
id k1.k2=k1k2;
id k2.k2=k2k2;
id q1.q1=q1q1;
id q1.q2=q1q2;
id q2.q2=q2q2;
id k1.q1=k1q1;
id k1.q2=k1q2;
id k2.q1=k2q1;
id k2.q2=k2q2;
endargument;
#call lsclApplyPolyRatFun(lsclTdNum,lsclTdDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
 moduleoption notinparallel;
 .sort

 L lsclExpectedExp =lsclRat(k1q1*k2q2,1)*lsclTensRedRank(2)*lsclTensRedNLegs(2);
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort


*********************************************************************
#$testID=`$testID'+1;
.sort
#define LSCLTESTNAME "lsclLoadTensorReductions-`$testID'";
 S q1q1,q1q2,q2q2,k1q1,k1q2,k1k1,k1k2,k2k2,k2q1,k2q2;
 L lsclTestExp = lsclTensRedMomenta(q1,q2)*lsclTensRedLoop(k1(lsclMu1),k2(lsclMu2),k2(lsclMu3))*lsclTensRedRank(3)*lsclTensRedNLegs(2)*lsclTd112;
  .sort 
#define lsclNLoops "2"  
#$lsclDollarMaxTensorRank=3;
#$lsclDollarMinTensorRank=1;
#$lsclDollarMaxNLegs=2;
#$lsclDollarMinNLegs=0;
#call lsclLoadTensorSymmetries($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank)
#call lsclLoadTensorReductions($lsclDollarMaxTensorRank,$lsclDollarMinTensorRank,$lsclDollarMaxNLegs,$lsclDollarMinNLegs)
.sort
id lsclTensorStructure(lsclS?) = lsclTdNum(lsclS*q1(lsclMu1)*q2(lsclMu2)*q1(lsclMu3));
argument;
id k1.k1=k1k1;
id k1.k2=k1k2;
id k2.k2=k2k2;
id q1.q1=q1q1;
id q1.q2=q1q2;
id q2.q2=q2q2;
id k1.q1=k1q1;
id k1.q2=k1q2;
id k2.q1=k2q1;
id k2.q2=k2q2;
endargument;
#call lsclApplyPolyRatFun(lsclTdNum,lsclTdDen,lsclRat,lsclWrapFun1,lsclWrapFun2);
.sort
 moduleoption notinparallel;
 .sort

 L lsclExpectedExp =lsclRat(k1q1*k2q1*k2q2,1)*lsclTensRedRank(3)*lsclTensRedNLegs(2);
 moduleoption notinparallel;
 .sort
 #call lsclCheckTest(`LSCLTESTNAME',lsclTestExp,lsclExpectedExp);
 moduleoption notinparallel;
 .sort  

 



*********************************************************************
.end;
*********************************************************************
