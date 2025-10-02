#procedure lsclDiracChainProcess(WRAPFUN,WRAPNFUN,DIRACCHAINNC)
* lsclDiracChainProcess() processes DiracChain objects in the expression,
* ulimately eliminating them in favor of lsclDiracGamma

* lsclDiracChain is a (commutative) container for Dirac matrices with explicit Dirac indices.
* The first argument contains the matrices, while the 2nd and 3rd ones denote the indices.
* All Dirac objects are contained inside the lsclDiracChain container. Calling lsclToDiracGamma 
* replaces g_ with lsclDiracGammaOpen or lsclDiracGammaChiralOpen, so at this point there are no g_'s left!

* First we convert lsclDiracChain it to the noncommutative `DIRACCHAINNC' and pull out the spinors.
* At this point there are no lsclDiracChain objects left in the expression.
* At the end every `DIRACCHAINNC' that had spinors attached to it loses its 2nd and 3rd arguments 
* and has only one argument containing the matrices. Those with explicit Dirac indices still keep
* their 2nd and 3rd arguments.

if (occurs(`DIRACCHAINNC'));
print "lsclDiracChainProcess: Error, the input expression already contains `DIRACCHAINNC': %t";
endif;
if (occurs(`DIRACCHAINNC')) exit;

id lsclDiracChain(?a) = `DIRACCHAINNC'(?a);
id `DIRACCHAINNC'(?a,lsclDiracU(?s)) = `DIRACCHAINNC'(?a,1)*lsclDiracSpinor(?s,1);
id `DIRACCHAINNC'(?a,lsclDiracV(?s)) = `DIRACCHAINNC'(?a,1)*lsclDiracSpinor(?s,-1);
id `DIRACCHAINNC'(?a,lsclDiracUBar(?s),?b) = lsclDiracSpinor(?s,1)*`DIRACCHAINNC'(?a,1,?b);
id `DIRACCHAINNC'(?a,lsclDiracVBar(?s),?b) = lsclDiracSpinor(?s,-1)*`DIRACCHAINNC'(?a,1,?b);
id `DIRACCHAINNC'(?a,1,1) = `DIRACCHAINNC'(?a);

if (occurs(lsclDiracChain,lsclDiracU,lsclDiracV,lsclDiracUBar,lsclDiracVBar));
print "lsclDiracChainProcess: Error, something went wrong while rewriting spinors: %t";
endif;
if (occurs(lsclDiracChain,lsclDiracU,lsclDiracV,lsclDiracUBar,lsclDiracVBar)) exit;

* An `DIRACCHAINNC' with open Dirac indices get converted lsclDiracChainOpen, that also has
* three arguments. 
id `DIRACCHAINNC'(?a,lsclDi1?,lsclDi2?) = lsclDiracChainOpen(?a,lsclDi1,lsclDi2);

* So at this point the structures we can have are of the form
* - lsclDiracSpinor(...)*`DIRACCHAINNC'(...*lsclDiracGammaOpen(...)*...)*lsclDiracSpinor(...)
* - lsclDiracChainOpen(...*lsclDiracGammaOpen(...)*...,i,j)
* - lsclDiracTrace(...*lsclDiracGammaOpen(...)*...)
* Notice that the arguments can still have lsclDiracGammaOpen(...) multiplied with c-numbers.
* We eliminate those in the next step.


#message lsclDiracChainProcess: Calling sort : `time_' ...
.sort
#message lsclDiracChainProcess: ... done: `time_'

* We start to apply linearity to `DIRACCHAINNC' and lsclDiracChainOpen
* First of all, if the arguments contain sums, they will be rewritten as f(a+b+c) -> f(a,b,c)
splitarg `DIRACCHAINNC';
splitarg lsclDiracChainOpen;

* Do the splitting f(a,b,c) -> f(a) + f(b) + f(c)
repeat;
id, once `DIRACCHAINNC'(lsclS1?,lsclS2?,?a) = `DIRACCHAINNC'(lsclS1) + `DIRACCHAINNC'(lsclS2,?a);
id, once lsclDiracChainOpen(lsclS1?,lsclS2?,?a,lsclDi1?,lsclDi2?) = lsclDiracChainOpen(lsclS1,lsclDi1,lsclDi2) + lsclDiracChainOpen(lsclS2,?a,lsclDi1,lsclDi2);
endrepeat;

* We rewrite f(a*b*c) -> f(a,b,c);
FactArg,`DIRACCHAINNC',lsclDiracChainOpen;

if (occurs(`WRAPNFUN'));
print "lsclDiracChainProcess: Error, the input expression already contains `WRAPNFUN': %t";
endif;
if (occurs(`WRAPNFUN')) exit;

* We pull out all symbolic prefactors multiplying lsclDiracGammaOpen inside lsclDiracChainOpen
multiply replace_(lsclDiracChainOpen,`WRAPFUN');
repeat;
id `WRAPFUN'(?a,lsclDiracGammaOpen(?c),?b,lsclDi1?,lsclDi2?) = lsclDiracChainOpen(lsclDiracGammaOpen(?c),lsclDi1,lsclDi2)*`WRAPFUN'(?a,?b,lsclDi1,lsclDi2);
endrepeat;

argument `WRAPFUN';
if (occurs(lsclDiracGammaOpen));
exit "lsclDiracChainProcess: Error, incorrect argument of `WRAPFUN'.";
endif;
endargument;

repeat;
id `WRAPFUN'(lsclS1?,?a) = lsclS1*`WRAPFUN'(?a);
id `WRAPFUN'(lsclDi1?,lsclDi2?)=1;
endrepeat;

if (occurs(`WRAPFUN'));
print "lsclDiracChainProcess: Error, the input expression still contains `WRAPFUN' after factoring lsclDiracChainOpen: %t";
endif;
if (occurs(`WRAPFUN')) exit;


if (occurs(`WRAPNFUN'));
print "lsclDiracChainProcess: Error, the input expression already contains `WRAPNFUN': %t";
endif;
if (occurs(`WRAPNFUN')) exit;


* We pull out all symbolic prefactors multiplying lsclDiracGammaOpen inside `DIRACCHAINNC'
multiply replace_(`DIRACCHAINNC',`WRAPNFUN');
repeat;
id `WRAPNFUN'(?a,lsclDiracGammaOpen(?c),?b) = `DIRACCHAINNC'(lsclDiracGammaOpen(?c))*`WRAPNFUN'(?a,?b);
endrepeat;

argument `WRAPNFUN';
if (occurs(lsclDiracGammaOpen));
exit "lsclDiracChainProcess: Error, incorrect argument of `WRAPNFUN'.";
endif;
endargument;

repeat;
id `WRAPNFUN'(lsclS1?,?a) = lsclS1*`WRAPNFUN'(?a);
id `WRAPNFUN'()=1;
endrepeat;

if (occurs(`WRAPNFUN'));
print "lsclDiracChainProcess: Error, the input expression still contains `WRAPNFUN' after factoring `DIRACCHAINNC': %t";
endif;
if (occurs(`WRAPNFUN')) exit;

#message lsclDiracChainProcess: Calling sort : `time_' ...
.sort
#message lsclDiracChainProcess: ... done: `time_'

* Rebuilding Dirac traces and open Dirac chains

* Finally, we eliminate lsclDiracGammaOpen in favor of lsclDiracGamma that contains only the indices
* as its arguments.

* To that aim we can also get rid of `DIRACCHAINNC'
id lsclDiracSpinor(?a)*`DIRACCHAINNC'(lsclDiracGammaOpen(100,?b))*lsclDiracSpinor(?c) = 
	lsclDiracSpinor(?a)*lsclDiracGamma(?b)*lsclDiracSpinor(?c);

repeat;
* `DIRACCHAINNC'(lsclDiracGammaOpen(...)) is a noncom chain of Dirac  matrices attached to some spinors!
* lsclDiracGammaOpen is noncommutative tensor!
id lsclDiracTrace(lsclDiracGammaOpen(100,?a)) = lsclDiracTrace(?a);
id lsclDiracChainOpen(lsclDiracGammaOpen(100,?a),lsclDi1?,lsclDi2?) = lsclDiracChainOpen(lsclDiracGamma(?a),lsclDi1,lsclDi2);
renumber;
endrepeat;

* At this point all occurences of lsclDiracGammaOpen and `DIRACCHAINNC' should be eliminated. We can only have
* - lsclDiracSpinor(...)*lsclDiracGamma(...)*lsclDiracSpinor(...) 
* - lsclDiracChainOpen(lsclDiracGamma(...),lsclDi1,lsclDi2)
* - lsclDiracTrace(lsclDiracGamma(...));

if (occurs(lsclDiracGammaOpen,`DIRACCHAINNC'));
print "lsclDiracChainProcess: Error, some `DIRACCHAINNC' and lsclDiracGammaOpen functions are still present, e.g.: %t";
endif;
if (occurs(lsclDiracGammaOpen,`DIRACCHAINNC')) exit;

#endprocedure