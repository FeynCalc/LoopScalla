*--#[ lsclFeynmanRulesQCDVertices:


* Quark-gluon vertex
id lsclQGVertex(lsclF1?lsclAntiQuarkFields[lsclS](lsclS1?,lsclP1?), lsclF2?lsclQuarkFields[lsclS](lsclS2?,lsclP2?), Gl(lsclS3?,lsclP3?)) = 
 i_*gs*lsclDiracChain(lsclDiracMatrix(lsclLorentzIndex(lsclS3)),lsclDiracIndex(lsclS1),lsclDiracIndex(lsclS2))*
 lsclSUNTF(lsclAdjColorIndex(lsclS3),lsclFunColorIndex(lsclS1),lsclFunColorIndex(lsclS2));
 
* Gluon-ghost vertex
id lsclQGVertex(Ghbar(lsclS1?,lsclP1?), Gh(lsclS3?,lsclP3?), Gl(lsclS2?,lsclP2?)) = 
	-`lsclPprGhostPropagatorSign'*gs*lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2),lsclAdjColorIndex(lsclS3))*(-lsclVector(lsclP1,lsclLorentzIndex(lsclS2)));

* 3-gluon vertex
id lsclQGVertex(Gl(lsclS1?,lsclP1?), Gl(lsclS2?,lsclP2?), Gl(lsclS3?,lsclP3?)) = 
 gs*(
 	lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2),lsclAdjColorIndex(lsclS3))*
 	(
 	lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclVector(lsclP1-lsclP2,lsclLorentzIndex(lsclS3))+
 	lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))*lsclVector(lsclP2-lsclP3,lsclLorentzIndex(lsclS1))+
 	lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))*lsclVector(lsclP3-lsclP1,lsclLorentzIndex(lsclS2)) 	
 	) 	 
 );

* 4-gluon vertex
repeat;
id, once lsclQGVertex(Gl(lsclS1?,lsclP1?), Gl(lsclS2?,lsclP2?), Gl(lsclS3?,lsclP3?), Gl(lsclS4?,lsclP4?)) = 
 -i_*gs^2*(
 	lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS2),N101_?)*
	lsclSUNF(lsclAdjColorIndex(lsclS3),lsclAdjColorIndex(lsclS4),N101_?)*
	(
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS4))-
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS4))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))
	) +
	lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS3),N101_?)*
	lsclSUNF(lsclAdjColorIndex(lsclS2),lsclAdjColorIndex(lsclS4),N101_?)*
	(
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4))-
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS4))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS3))
	) +
	
	lsclSUNF(lsclAdjColorIndex(lsclS1),lsclAdjColorIndex(lsclS4),N101_?)*
	lsclSUNF(lsclAdjColorIndex(lsclS2),lsclAdjColorIndex(lsclS3),N101_?)*
	(
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS2))*lsclMetricTensor(lsclLorentzIndex(lsclS3),lsclLorentzIndex(lsclS4))-
	 lsclMetricTensor(lsclLorentzIndex(lsclS1),lsclLorentzIndex(lsclS3))*lsclMetricTensor(lsclLorentzIndex(lsclS2),lsclLorentzIndex(lsclS4))
	)
 );
renumber;
endrepeat;


*--#] lsclFeynmanRulesQCDVertices:
