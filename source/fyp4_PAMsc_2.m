f[count_,omega0_] := Module[{c = count,w0 = omega0},
   l = 4;
   be = 0.5; 
   th = 0; 
   de = 0.1; 
   nISI = 80; 
   snrDB = 8; 
   ts = 1; 
   npts = 100000;
 
   h[t_] := (Sinc[(Pi*t)/ts]*Cos[(Pi*be*t)/ts])/(1 - ((2*be*t)/ts)^2);
   g[kk_, de_] := h[ts*(de + kk)];

   w = Join[RandomChoice[{-3,-1,1,3}, {nISI/2, npts}], {Table[w0, {npts}]}, RandomChoice[{-3,-1,1,3}, {nISI/2, npts}]];
   k = Range[-nISI/2, nISI/2];
   dtiming = Range[0.02,0.3,0.02];
   ndtiming = Length[dtiming];
   gk = Table[g[a,b],{b,dtiming},{a,k}];
   rk = gk.w;

   snr = 10^(snrDB/20);
   var = N[Sqrt[(l^2 - 1)/(6*Log[l, 2]*10^(snrDB/10))]];
   nu = RandomReal[NormalDistribution[0, var], {ndtiming, npts}];
   r = rk + nu;

   histpts = Join[{-Infinity},Range[-2,-1.9,0.001],Range[1.9,2,0.001],{Infinity}];
   newprob = Table[BinCounts[r[[i,All]],{histpts}],{i,1,ndtiming}];
   filename = "output_" <> ToString[w0] <> ".txt";
   If[c==0, oldprob=Array[0&,Dimensions[newprob][[1]]], oldprob=Get[filename]];
   prob = oldprob + newprob;
   Put[prob, filename];
   Print[N[(c+1)/2000,2]];
   ];

For[ic = 0, ic < 2000, ic++, f[ic,-1]]
For[ic = 0, ic < 2000, ic++, f[ic,-3]]
