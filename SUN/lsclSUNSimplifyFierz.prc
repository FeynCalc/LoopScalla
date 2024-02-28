#procedure lsclSUNSimplifyFierz()

* lsclSUNSimplify() simplifies color algebra using Fierz identities

* eliminate f^abc
repeat;
id, once lsclSUNF(lsclCAi1?,lsclCAi2?,lsclCAi3?) = 2/i_*(
	lsclSUNTF(lsclCAi1,N201_?,N202_?)*lsclSUNTF(lsclCAi2,N202_?,N203_?)*lsclSUNTF(lsclCAi3,N203_?,N201_?)-
	lsclSUNTF(lsclCAi1,N201_?,N202_?)*lsclSUNTF(lsclCAi3,N202_?,N203_?)*lsclSUNTF(lsclCAi2,N203_?,N201_?)
	);
renumber;
endrepeat;

* eliminate d^abc
repeat;
id, once lsclSUND(lsclCAi1?,lsclCAi2?,lsclCAi3?) = 2*(
	lsclSUNTF(lsclCAi1,N201_?,N202_?)*lsclSUNTF(lsclCAi2,N202_?,N203_?)*lsclSUNTF(lsclCAi3,N203_?,N201_?)+
	lsclSUNTF(lsclCAi2,N201_?,N202_?)*lsclSUNTF(lsclCAi1,N202_?,N203_?)*lsclSUNTF(lsclCAi3,N203_?,N201_?)
	);
renumber;
endrepeat;

* contract all indices
#call lsclColorChainJoin()

repeat;
id lsclSUNTF(lsclCAi?,lsclCFj1?,lsclCFj2?)*lsclSUNTF(lsclCAi?,lsclCFj3?,lsclCFj4?) = 
	1/2*lsclSUNFDelta(lsclCFj1,lsclCFj4)*lsclSUNFDelta(lsclCFj2,lsclCFj3) - 1/2*1/lsclSUNN*lsclSUNFDelta(lsclCFj1,lsclCFj2)*lsclSUNFDelta(lsclCFj3,lsclCFj4);
endrepeat;


repeat;
id lsclSUNFDelta(lsclCFi?,lsclCFi?) = lsclSUNN;
id lsclSUNDelta(lsclCFi?,lsclCFi?) = lsclSUNN^2-1;
id lsclSUNFDelta(lsclCFi1?,lsclCFi2?)*lsclSUNFDelta(lsclCFi2?,lsclCFi3?) = lsclSUNFDelta(lsclCFi1,lsclCFi3);
id lsclSUNDelta(lsclCFi1?,lsclCFi2?)*lsclSUNDelta(lsclCFi2?,lsclCFi3?) = lsclSUNDelta(lsclCFi1,lsclCFi3);
endrepeat;

#endprocedure
