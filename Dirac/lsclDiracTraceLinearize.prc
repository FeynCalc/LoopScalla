#procedure lsclDiracTraceLinearize()

* lsclDiracTraceLinearize() linearizes Dirac traces


splitarg lsclDiracTrace;
** Now each argument is just a single term, not a sum of terms so we can split them into proper sums
** f(a,b,c)-> f(a)+f(b)+f(c)
repeat;
id lsclDiracTrace(lsclS1?,lsclS2?,?a) =  lsclDiracTrace(lsclS1) + lsclDiracTrace(lsclS2) + lsclDiracTrace(?a);
* Very important, without this id statement the final result will be wrong
id lsclDiracTrace() = 0;
id lsclDiracTrace(0) = 0;
endrepeat;
#endprocedure
