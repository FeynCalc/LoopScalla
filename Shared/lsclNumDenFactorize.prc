#procedure lsclNumDenFactorize(NUM,DEN,RAT,PULLOUTSYMBOLS)

* lsclNumDenFactorize() applies FactArg to the expressions inside NUM, DEN and RAT
* PULLOUTSYMBOLS must be either an empty set {\,0} or a set of variables that should
* be pulled out of NUM and DEN functions, e.g. {x} or {x\,y}
* The commas have to be escaped because of <https://github.com/vermaseren/form/issues/545>


repeat id `RAT'(lsclS1?,lsclS2?) = `NUM'(lsclS1)*`DEN'(lsclS2);

* Factorize the arguments of NUM and DEN so that e.g. NUM(c1+c2+....) -> NUM(d1,d2,d3,...), 
* where the original result would be d1*d2*d3* ...
 factarg,`NUM',`DEN';

#if (`lsclPprNumDenFactorizeVerbosity'>1)
  print;
  .sort
#endif


* Split arguments of NUM and DEN into products NUM(a,b,c) -> NUM(a)*NUM(b)*NUMs(c).
* Now each NUM and DEN contains only one argument
 chainout `NUM';
 chainout `DEN';

#if (`lsclPprNumDenFactorizeVerbosity'>1)
  print;
  .sort
#endif

* Simplify the output
repeat id `NUM'(lsclS?`PULLOUTSYMBOLS') = lsclS;
repeat id `DEN'(lsclS?`PULLOUTSYMBOLS') = 1/lsclS;
repeat id `NUM'(lsclS?number_) = lsclS;
repeat id `DEN'(lsclS?number_) = 1/lsclS;
repeat id `NUM'(1/lsclS?) = `DEN'(lsclS);
repeat id `NUM'(lsclS?)*`DEN'(lsclS?) = 1;
 
#endprocedure
