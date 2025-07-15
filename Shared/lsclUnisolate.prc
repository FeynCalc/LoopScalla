#procedure lsclUnisolate(NAME1,NAME2)

* lsclUnisolate() is the inverse of various lsclXYZIsolate() in
* the sense that it reveals the previously hidden terms 
* free of certain symbols.

id `NAME1'(lsclS?) = lsclS;
id `NAME2'(lsclS?) = lsclS;
FromPolynomial;

#endprocedure

