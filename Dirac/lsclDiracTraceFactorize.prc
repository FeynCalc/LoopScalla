#procedure lsclDiracTraceFactorize(WRAPFUN)
* lsclDiracTraceFactorize() factorizes Dirac traces


* We start to apply linearity to lsclDiracTrace
* First of all, if the arguments contain sums, they will be rewritten as f(a+b+c) -> f(a,b,c)

splitarg lsclDiracTrace;

* Do the splitting f(a,b,c) -> f(a) + f(b) + f(c)
repeat;
id, once lsclDiracTrace(lsclS1?,lsclS2?,?a) = lsclDiracTrace(lsclS1) + lsclDiracTrace(lsclS2,?a);
endrepeat;

* We rewrite f(a*b*c) -> f(a,b,c);
FactArg,lsclDiracTrace;

if (occurs(`WRAPFUN'));
print "lsclDiracTraceFactorize: Error, the input expression already contains `WRAPFUN': %t";
endif;
if (occurs(`WRAPFUN')) exit;

* We pull out all symbolic prefactors multiplying lsclDiracGammaOpen inside lsclDiracTrace
multiply replace_(lsclDiracTrace,`WRAPFUN');
repeat;
id `WRAPFUN'(?a,lsclDiracGammaOpen(?c),?b) = lsclDiracTrace(lsclDiracGammaOpen(?c))*`WRAPFUN'(?a,?b);
endrepeat;

argument `WRAPFUN';
if (occurs(lsclDiracGammaOpen));
exit "lsclDiracTraceFactorize: Error, incorrect argument of `WRAPFUN'.";
endif;
endargument;

repeat;
id `WRAPFUN'(lsclS1?,?a) = lsclS1*`WRAPFUN'(?a);
id `WRAPFUN'()=1;
endrepeat;

if (occurs(`WRAPFUN'));
print "lsclDiracTraceFactorize: Error, the input expression still contains `WRAPFUN' after factoring lsclDiracTrace: %t";
endif;
if (occurs(`WRAPFUN')) exit;

#endprocedure


