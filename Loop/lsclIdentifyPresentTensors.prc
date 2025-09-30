#procedure lsclIdentifyPresentTensors(MAXRANK,MINRANK,MAXNLEGS,MINNLEGS)

* lsclIdentifyPresentTensors() determines the maximal and minimal tensor
* rank as well as the maximal and minimal number of external legs among all
* present tensor integrals. Those are saved into dollar variables specified 
* via MAXRANK, MINRANK, MAXNLEGS and MINNLEGS.

* Here we determine the highest number of legs and tensor rank in the amplitude
#`MAXRANK'=1;
#`MAXNLEGS'=0;

id lsclTensRedRank(lsclS?) = lsclS30^lsclS*lsclTensRedRank(lsclS);
id lsclTensRedNLegs(lsclS?) = lsclS31^lsclS*lsclTensRedNLegs(lsclS);

if ( count(lsclS30,1) > `MAXRANK' ) `MAXRANK' = count_(lsclS30,1);
if ( count(lsclS31,1) > `MAXNLEGS' ) `MAXNLEGS' = count_(lsclS31,1);

ModuleOption, maximum, `MAXRANK', `MAXNLEGS';

#message lsclIdentifyPresentTensors: Calling sort : `time_' ...
.sort
#message lsclIdentifyPresentTensors: ... done : `time_'

* Here we determine the lowest number of legs and tensor rank in the amplitude
#`MINRANK'=`MAXRANK';
#`MINNLEGS'=`MAXNLEGS';

if ( count(lsclS30,1) < `MINRANK' && count(lsclS30,1)!=0 ) `MINRANK' = count_(lsclS30,1);
if ( count(lsclS31,1) < `MINNLEGS' ) `MINNLEGS' = count_(lsclS31,1);

ModuleOption, minimum, `MINRANK', `MINNLEGS';

#message lsclIdentifyPresentTensors: Calling sort : `time_' ...
.sort
#message lsclIdentifyPresentTensors: ... done : `time_'


id lsclS30^lsclS?!{,0} = 1;
id lsclS31^lsclS?!{,0} = 1;

#endprocedure