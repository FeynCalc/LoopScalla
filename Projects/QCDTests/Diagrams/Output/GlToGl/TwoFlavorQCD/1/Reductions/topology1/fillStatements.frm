*--#[ lsclTopologyNames:
topology1
*--#] lsclTopologyNames:

*--#[ lsclCurrentTopologyDefinitions:

#define LSCLCURRENTTOPO "topology1"
#define LSCLCURRENTNPROPS "2"

*--#] lsclCurrentTopologyDefinitions:

*--#[ lsclFillStatements:
fill tabIBPtopology1(2, 2) = lsclDen(pp^2)*(lsclNum(18) + lsclNum(-9*lsclD) + lsclNum(lsclD^2))*topology1(1, 1);
fill tabIBPtopology1(2, 1) = lsclDen(pp)*(lsclNum(3) + lsclNum(-lsclD))*topology1(1, 1);
fill tabIBPtopology1(1, 2) = lsclDen(pp)*(lsclNum(3) + lsclNum(-lsclD))*topology1(1, 1);
fill tabIBPtopology1(1, 1) = topology1(1, 1);
fill tabIBPtopology1(2, 0) = 0;
fill tabIBPtopology1(2, -1) = 0;
fill tabIBPtopology1(1, 0) = 0;
fill tabIBPtopology1(0, 2) = 0;
fill tabIBPtopology1(0, 1) = 0;
fill tabIBPtopology1(-1, 2) = 0;
*--#] lsclFillStatements:

