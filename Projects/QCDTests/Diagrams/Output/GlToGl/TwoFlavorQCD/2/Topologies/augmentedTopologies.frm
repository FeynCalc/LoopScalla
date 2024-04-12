*--#[ lsclTopologyNames:
finTopo2C,
topology1,
topology2
*--#] lsclTopologyNames:

*--#[ lsclTopologyMappings:

 repeat;
id finTopo2(lsclS1?, lsclS2?, lsclS3?, lsclS4?) = finTopo2C(lsclS1, lsclS2, lsclS3, lsclS4, 0);
id finTopo1(?a) = topology1(?a);
id finTopo2C(?a) = topology2(?a);
endrepeat;

*--#] lsclTopologyMappings:
