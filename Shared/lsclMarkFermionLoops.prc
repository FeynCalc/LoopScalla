#procedure lsclMarkFermionLoops(VRT,PROP,FLINE,FLOOP)

* lsclMarkFermionLoops() resolves fermion loops in the daigram and multiplies the
* corresponding diagrams by `FLOOP'(particleName). The function assumes
* that each vertex has two fermion lines (first two arguments of `VRT') and one
* bosonic line (third argument of `VRT'). The function sets of fermion and antifermion
* fields (with correct ordering in both sets) given by lsclFermionFields and lsclAntiFermionFields as well
* as the set of bosonic fields lsclBosonFields.


id (`PROP'(lsclF1?lsclFermionFields[lsclS](lsclS1?,lsclP1?),lsclF2?lsclAntiFermionFields[lsclS](lsclS2?,lsclP2?))) = 
 `FLINE'(lsclF1,lsclS1,lsclS2)*`PROP'(lsclF1(lsclS1,lsclP1),lsclF2(lsclS2,lsclP2));

id (`VRT'(lsclF1?lsclAntiFermionFields[lsclS](lsclS1?,lsclP1?),lsclF2?lsclFermionFields[lsclS](lsclS2?,lsclP2?),lsclF3?lsclBosonFields(lsclS3?,lsclP3?),?a)) = 
 `FLINE'(lsclF2,lsclS1,lsclS2)*`VRT'(lsclF1(lsclS1,lsclP1),lsclF2(lsclS2,lsclP2),lsclF3(lsclS3,lsclP3),?a);


repeat id `FLINE'(lsclF1?,lsclS1?,lsclS2?)*`FLINE'(lsclF1?,lsclS2?,lsclS3?) = `FLINE'(lsclF1,lsclS1,lsclS3);
repeat id `FLINE'(lsclF1?,lsclS1?,lsclS1?) = `FLOOP'(lsclF1);
repeat id `FLINE'(?a)  = 1;
 
#endprocedure
