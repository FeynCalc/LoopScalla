#procedure lsclToDiracGamma()

* lsclToDiracGamma() merely converts all occurences of g_ into
* the internal lscl notation suitable for further Dirac algebra
* manipulations


* #message lsclToDiracGamma: `time_'

id g_(lsclI?,lsclMu?) = lsclDiracGammaOpen(lsclI,lsclMu);
id g_(lsclI?,6_) = lsclDiracGammaChiralOpen(lsclI,6);
id g_(lsclI?,7_) = lsclDiracGammaChiralOpen(lsclI,7);
id g_(lsclI?,5_) = lsclDiracGammaChiralOpen(lsclI,5);


if (occurs(g_));
exit "lsclToDiracGamma: Fatal error: Failed to eliminate all occurrences of g_.";
endif;

repeat;
id lsclDiracGammaOpen(lsclI?,?a)*lsclDiracGammaOpen(lsclI?,?b) = lsclDiracGammaOpen(lsclI,?a,?b);
endrepeat;

* #message lsclToDiracGamma: `time_'

#endprocedure
