*--#[ lsclTopologyNames:
finTopo1,
finTopo2
*--#] lsclTopologyNames:

*--#[ lsclTopologyMappings:

 repeat;
id preTopoDia3(lsclS1?, lsclS3?, lsclS2?, lsclS4?) = replace_(k1, k1 + p1, k2, -k2)*preTopoDia2(lsclS1, lsclS2, lsclS3, lsclS4);
id preTopoDia4(lsclS1?, lsclS2?, lsclS3?, lsclS4?) = replace_(k1, -k1, k2, -k2)*preTopoDia2(lsclS1, lsclS2, lsclS3, lsclS4);
id preTopoDia1(?a) = finTopo1(?a);
id preTopoDia2(?a) = finTopo2(?a);
endrepeat;

*--#] lsclTopologyMappings:
