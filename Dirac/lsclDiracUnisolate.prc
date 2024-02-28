#procedure lsclDiracUnisolate(NAME1,NAME2)

* lsclDiracUnisolate() is the inverse of lsclDiracIsolate() in
* the sense that it reveals the previously hidden terms 
* free of Dirac related symbols.

id `NAME1'(lsclS?) = lsclS;
id `NAME2'(lsclS?) = lsclS;
FromPolynomial;

#endprocedure

