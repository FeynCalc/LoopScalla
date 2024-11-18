on shortstats;
on HighFirst;


#message lsclCreateIntegralFiles: `lsclProjectName'
#message lsclCreateIntegralFiles: `lsclProcessName'
#message lsclCreateIntegralFiles: `lsclNLoops'


#ifdef `LSCLADDDIAFILES'

	#message lsclCreateIntegralFiles: `lsclDiaNumberFrom'
	#message lsclCreateIntegralFiles: `lsclDiaNumberTo'

	#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
	load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/Form/dia`i'L`lsclNLoops'.res;
	#enddo


	#message lsclCreateIntegralFiles: All integral files loaded `time_'

	#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
	G ts1dia`i'L`lsclNLoops' = lidia`i'L`lsclNLoops';
	#enddo

	#message lsclCreateIntegralFiles: All defined `time_'

#else

	#message lsclCreateIntegralFiles: `lsclTopologyName'

	load Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/allLoopIntegrals.res;
	G ampL`lsclNLoops' = tampL`lsclNLoops';

	#message lsclCreateIntegralFiles: Joint integral file loaded `time_'

#endif


#message lsclCreateIntegralFiles: Executing .sort and .store
.sort
#ifdef `LSCLADDDIAFILES'
.store
#endif

#message lsclCreateIntegralFiles: .sort and .store done


#include lsclDeclarations.h
#include lsclDefinitions.h
#include Projects/`lsclProjectName'/FeynmanRules/lsclParticles_`lsclModelName'.h
#include Projects/`lsclProjectName'/Shared/`lsclProcessName'.h #lsclGeneric

* #include Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/Topologies/TopologyList.frm

#ifdef `LSCLADDDIAFILES'

	#message lsclCreateIntegralFiles: Creating the file containing all loop integrals for this process.

	#if (`LSCLADDDIAFLAG'==1)
	G tampL`lsclNLoops' = 
	#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
	+ lsclDiaFlag`i'*ts1dia`i'L`lsclNLoops'
	#enddo
	;
	#else
	G tampL`lsclNLoops' = 
	#do i = `lsclDiaNumberFrom', `lsclDiaNumberTo'
	+ ts1dia`i'L`lsclNLoops'
	#enddo
	;
	#endif

	.sort
	delete storage;
	.store

	save Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/allLoopIntegrals.res;
	#message lsclTopologyIdentification: Creation of the joint integral file for the process completed successfully.

#else

	#message lsclCreateIntegralFiles: Creating separate files containing loop integals for each topology	
	CF `lsclTopologyName';
 	if (occurs(`lsclTopologyName')==0) discard;
	.sort
	format Mathematica;
	#write <Projects/`lsclProjectName'/Diagrams/Output/`lsclProcessName'/`lsclModelName'/`lsclNLoops'/LoopIntegrals/Mma/`lsclTopologyName'.m> "(%E)", ampL`lsclNLoops'
	#message lsclTopologyIdentification: Creation of the integral file for the topology `lsclTopologyName' completed successfully.
	
#endif

.end



