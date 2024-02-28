#procedure lsclAnti5()

* lsclAnti5() moves all occurrences of chiral matrices to
* the right. Currently only anticommuting g5 is supported

repeat;


id lsclDiracTrace(?a,5,lsclI?!{,5},?b) = - lsclDiracTrace(?a,lsclI,5,?b);

id lsclDiracTrace(?a,5,5,?b) = lsclDiracTrace(?a,?b);

*id lsclDiracGammaChiralOpen(lsclI?,5)*lsclDiracGammaChiralOpen(lsclI?,5) = 1;
*id lsclDiracGammaChiralOpen(lsclI?,6)*lsclDiracGammaChiralOpen(lsclI?,7) = 0;
*id lsclDiracGammaChiralOpen(lsclI?,7)*lsclDiracGammaChiralOpen(lsclI?,6) = 0;
*id lsclDiracGammaChiralOpen(lsclI?,6)*lsclDiracGammaChiralOpen(lsclI?,6) = 2*lsclDiracGammaChiralOpen(lsclI,6);
*id lsclDiracGammaChiralOpen(lsclI?,7)*lsclDiracGammaChiralOpen(lsclI?,7) = 2*lsclDiracGammaChiralOpen(lsclI,7);

*id lsclDiracGammaChiralOpen(lsclI?,5)*lsclDiracGammaOpen(lsclI?,?a) = 
*	sign_(nargs_(?a))*lsclDiracGammaOpen(lsclI,?a)*lsclDiracGammaChiralOpen(lsclI,5);

*id lsclDiracGammaChiralOpen(lsclI?,lsclMu?{6,7}[lsclX])*lsclDiracGammaOpen(lsclI?,?a) = 
*	lsclDiracGammaOpen(lsclI,?a)*(
*	1/2*(1-sign_(nargs_(?a)))*lsclDiracGammaChiralOpen(lsclI,{7,6}[lsclX])+ 
*	1/2*(1+sign_(nargs_(?a)))*lsclDiracGammaChiralOpen(lsclI,{6,7}[lsclX])
*	);
endrepeat;


#endprocedure
