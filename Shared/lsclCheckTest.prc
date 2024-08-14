#procedure lsclCheckTest(LSCLTESTNAME,LSCLTESTEXP,LSCLEXPECTEDEXP);

* lsclCheckTest() compares the two first arguments with each other
* and stop the execution if the difference between them is not 0.

L lsclIntVarCheckTestTmp  = `LSCLTESTEXP'-`LSCLEXPECTEDEXP';
.sort
#if termsin(lsclIntVarCheckTestTmp)>0
   #message lsclCheckTest: Unit test `LSCLTESTNAME' FAILED
   #message lsclCheckTest: Expected value:
   print `LSCLEXPECTEDEXP';
   .sort
   #message lsclCheckTest: Actual value:
   print `LSCLTESTEXP';
   .sort
   #terminate 1;
#else
   #message lsclCheckTest: Unit test `LSCLTESTNAME' PASSED
#endif

#message
#endprocedure

