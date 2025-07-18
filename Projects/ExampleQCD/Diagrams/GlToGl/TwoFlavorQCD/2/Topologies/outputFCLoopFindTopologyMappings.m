{{{FCTopology["preTopoDia3", {FeynAmpDenominator[
      StandardPropagatorDenominator[Momentum[k2, D], 0, 0, {1, 1}]], 
     FeynAmpDenominator[StandardPropagatorDenominator[Momentum[k1, D], 0, 0, 
       {1, 1}]], FeynAmpDenominator[StandardPropagatorDenominator[
       Momentum[k1 - p1, D], 0, 0, {1, 1}]], FeynAmpDenominator[
      StandardPropagatorDenominator[Momentum[k1 + k2 - p1, D], 0, 0, 
       {1, 1}]]}, {k1, k2}, {p1}, {Pair[Momentum[p1, D], Momentum[p1, D]] -> 
      pp}, {}], {k1 -> k1 + p1, k2 -> -k2}, 
   GLI["preTopoDia3", {n1_, n3_, n2_, n4_}] :> GLI["preTopoDia2", 
     {n1, n2, n3, n4}]}, {FCTopology["preTopoDia4", 
    {FeynAmpDenominator[StandardPropagatorDenominator[Momentum[k2, D], 0, 0, 
       {1, 1}]], FeynAmpDenominator[StandardPropagatorDenominator[
       Momentum[k1, D], 0, 0, {1, 1}]], FeynAmpDenominator[
      StandardPropagatorDenominator[Momentum[k1 - p1, D], 0, 0, {1, 1}]], 
     FeynAmpDenominator[StandardPropagatorDenominator[Momentum[k1 - k2, D], 
       0, 0, {1, 1}]]}, {k1, k2}, {p1}, 
    {Pair[Momentum[p1, D], Momentum[p1, D]] -> pp}, {}], 
   {k1 -> -k1, k2 -> -k2}, GLI["preTopoDia4", {n1_, n2_, n3_, n4_}] :> 
    GLI["preTopoDia2", {n1, n2, n3, n4}]}}, 
 {FCTopology["preTopoDia1", {FeynAmpDenominator[StandardPropagatorDenominator[
      Momentum[k2, D], 0, 0, {1, 1}]], FeynAmpDenominator[
     StandardPropagatorDenominator[Momentum[k1, D], 0, 0, {1, 1}]], 
    FeynAmpDenominator[StandardPropagatorDenominator[Momentum[k2 + p1, D], 0, 
      0, {1, 1}]], FeynAmpDenominator[StandardPropagatorDenominator[
      Momentum[k1 + k2, D], 0, 0, {1, 1}]], FeynAmpDenominator[
     StandardPropagatorDenominator[Momentum[k1 - p1, D], 0, 0, {1, 1}]]}, 
   {k1, k2}, {p1}, {Pair[Momentum[p1, D], Momentum[p1, D]] -> pp}, {}], 
  FCTopology["preTopoDia2", {FeynAmpDenominator[StandardPropagatorDenominator[
      Momentum[k2, D], 0, 0, {1, 1}]], FeynAmpDenominator[
     StandardPropagatorDenominator[Momentum[k1, D], 0, 0, {1, 1}]], 
    FeynAmpDenominator[StandardPropagatorDenominator[Momentum[k1 + p1, D], 0, 
      0, {1, 1}]], FeynAmpDenominator[StandardPropagatorDenominator[
      Momentum[k1 - k2, D], 0, 0, {1, 1}]]}, {k1, k2}, {p1}, 
   {Pair[Momentum[p1, D], Momentum[p1, D]] -> pp}, {}]}}
