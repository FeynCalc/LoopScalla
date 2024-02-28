#procedure lsclColorChainJoin()

* lsclDiracChainJoin() joins color chains

repeat;

* d^ij d^jk
id lsclSUNFDelta(lsclCFi1?,lsclCFi2?)*lsclSUNFDelta(lsclCFi2?,lsclCFi3?) = lsclSUNFDelta(lsclCFi1,lsclCFi3);
* d^AB d^BC
id lsclSUNDelta(lsclCAi1?,lsclCAi2?)*lsclSUNDelta(lsclCAi2?,lsclCAi3?) = lsclSUNDelta(lsclCAi1,lsclCAi3);
* T^A_ij d^AB
id lsclSUNDelta(lsclCAi1?,lsclCAi2?)*lsclSUNTF(?a,lsclCAi1?,?b) = lsclSUNTF(?a,lsclCAi2,?b);
* T^A_ij d^jk
id lsclSUNFDelta(lsclCFi1?,lsclCFi2?)*lsclSUNTF(?a,lsclCFi1?,?b) = lsclSUNTF(?a,lsclCFi2,?b);

* id lsclSUNFDelta(lsclCFi1?,lsclCFi2?)*lsclSUNTF(?a,lsclCFi2?,?b) = lsclSUNTF(?a,lsclCFi1,?b);
* T^A_ij T^A_jk
* id lsclSUNTF(?a,lsclCFi1?,lsclCFi2?)*lsclSUNTF(?b,lsclCFi2?,lsclCFi3?) = lsclSUNTF(?a,?b,lsclCFi1,lsclCFi3);
endrepeat;


#endprocedure
