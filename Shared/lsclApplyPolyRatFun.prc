#procedure lsclApplyPolyRatFun(NUM,DEN,RAT,WRAP1,WRAP2)

* lsclApplyPolyRatFun() applies PolyRatFun to the expressions inside WRAP1 and WRAP2
* At the end PolyRatFun is deactivated but the expressions still remain wrapped in RAT

* Change the denominator function to DEN, but only inside WRAP1 and WRAP2
argument `WRAP1',`WRAP2';
denominators `DEN';
endargument;


* Factorize the arguments of WRAP1 and WRAP2 so that e.g. WRAP1(c1+c2+....) -> WRAP1(d1,d2,d3,...), 
* where the original result would be d1*d2*d3* ...
factarg,`WRAP1',`WRAP2';

* Split arguments of WRAP1 and WRAP2 into products WRAP1(a,b,c) -> WRAP1(a)*WRAP1(b)*WRAP1(c).
* Now each WRAP1 and WRAP2 contains only one argument
 chainout `WRAP1';
 chainout `WRAP2';

* Another splitting of the arguments of WRAP1 and WRAP2 to decompose the sums into smaller 
* pieces: WRAP1(a+b+c) -> WRAP1(a,b,c). This way we again end up with having WRAP1 and WRAP2 
* having multiple arguments
 splitarg `WRAP1';
 splitarg `WRAP2';

* Now each argument is just a single term, not a sum of terms, so we can split them into
* proper sums: WRAP1(a,b,c) -> WRAP1(a)+WRAP1(b)+WRAP1(c)
 repeat;
 id lsclF?{`WRAP1',`WRAP2'}(lsclS1?,lsclS2?,?a) =  lsclF(lsclS1) + lsclF(lsclS2) + lsclF(?a);
* Very important, without this id statement the final result will be wrong
 id lsclF?{`WRAP1',`WRAP2'}() = 0;
 endrepeat;

 
* Each term is still a product of terms, so we use factarg again to 
* get WRAP1(a*b*c) -> WRAP1(a,b,c)
 factarg `WRAP1',`WRAP2';
 
* Finally, we are in the position to pull out the denominators
 repeat id lsclF?{`WRAP1',`WRAP2'}(?a,`DEN'(?c), ?b) =  `DEN'(?c)*lsclF(?a,?b);
 repeat id lsclF?{`WRAP1',`WRAP2'}() = 1;

* Repeat the splitting WRAP1(a,b,c) -> WRAP1(a)*WRAP1(b)*WRAP1(c). This recovers 
* the original expression if each WRAP1 is set to a unit function
 chainout `WRAP1';
 chainout `WRAP2';

* Check that all denominators were succesfully pulled out
 argument `WRAP1',`WRAP2';
  if (occurs(`DEN')) exit "lsclApplyPolyRatFun: Something went wrong while factoring out the denominators";
 endargument;

 id lsclF?{`WRAP1',`WRAP2'}(lsclS?) = `NUM'(lsclS);

* Sometimes the input expression may already contain NUM and DEN

* Remove vectors from numerators
repeat id `NUM'(lsclV?(lsclMu?)) = lsclV(lsclMu);

* Remove tensor functions from numerators
repeat id `NUM'(lsclT?(?a)) = lsclT(?a);

* Remove symmetric delta functions from numerators, but not other NUM functions!
repeat id `NUM'(lsclF?!{`NUM'}(lsclMu1?,lsclMu2?)) = lsclF(lsclMu1,lsclMu2);

* Remove scalar functions from numerators, but not other NUM functions!
repeat id `NUM'(lsclF?!{`NUM'}(?a)) = lsclF(?a);

* Remove scalar products from numerators
repeat id `NUM'(lsclP1?.lsclP2?^lsclS?!{,0}) = lsclP1.lsclP2^lsclS;

* Remove nested numerators
repeat id `NUM'(`NUM'(?a)) = `NUM'(?a);

* Remove purely numerical numerators and denominators
repeat id `NUM'(lsclS?int_) = lsclS;
repeat id `DEN'(lsclS?int_) = 1/lsclS;


#if (`lsclPprApplyPolyRatFunVerbosity'>1)
  print;
  .sort
#endif


#message lsclApplyPolyRatFun: Activating PolyRatFun : `time_' ...

.sort: lsclApplyPolyRatFun 1;

PolyRatFun `RAT';
id `NUM'(lsclS?) = `RAT'(lsclS,1);
id `DEN'(lsclS?) = `RAT'(1,lsclS);

#if (`lsclPprApplyPolyRatFunVerbosity'>1)
  print;  
#endif


#message lsclApplyPolyRatFun: Deactivating PolyRatFun : `time_' ...


.sort: lsclApplyPolyRatFun 2;

PolyRatFun;

#endprocedure
