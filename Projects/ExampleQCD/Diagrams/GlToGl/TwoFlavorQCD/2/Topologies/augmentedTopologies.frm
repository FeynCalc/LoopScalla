*--#[ lsclTopologyNames:
finTopo2C,
topologyGlToGl2L1,
topologyGlToGl2L2
*--#] lsclTopologyNames:

*--#[ lsclTopologyMappings:

 repeat;
id finTopo2(lsclS1?, lsclS2?, lsclS3?, lsclS4?) = finTopo2C(lsclS1, lsclS2, lsclS3, lsclS4, 0);
id finTopo1(?a) = topologyGlToGl2L1(?a);
id finTopo2C(?a) = topologyGlToGl2L2(?a);
endrepeat;

*--#] lsclTopologyMappings:
