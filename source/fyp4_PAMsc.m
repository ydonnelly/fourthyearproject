f[count_,omega0_] := Module[{c = count,om0 = omega0},
   l = 2; 
   be = 0.5; 
   th = 0; 
   de = 0.1; 
   nISI = 80; 
   snrDB = 8; 
   ts = 1; 
   npts = 100000; 
   h[t_] := (Sinc[(Pi*t)/ts]*
       Cos[(Pi*be*t)/ts])/(1 - ((2*be*t)/ts)^2);
   g[kk_, de_] := h[ts*(de + kk)];
   wk = RandomChoice[{-1, 1}, {nISI, npts}];
   k = Join[Table[x, {x, -nISI/2, -1}], Table[x, {x, 1, nISI/2}] ];
   dd = {10^-15, 0.05, 0.1, 0.15};
   ndd = Length[dd];
   gk = g[k, #] & /@ dd;
   rk = gk.wk;
   snr = 10^(snrDB/20);
   var = N[Sqrt[(l^2 - 1)/(6*Log[l, 2]*10^(snrDB/10))]];
   nu = 
    RandomReal[NormalDistribution[0, var], {ndd , npts}];
   r = om0 + rk + nu;
   newprob = Table[BinCounts[r[[i,All]],{Join[{-Infinity},Range[-2.1,-1.9,0.01],Range[-0.1,0.1,0.01],Range[1.9,2.1,0.01],{Infinity}]}],{i,1,4}];
   filename = "output_" <> ToString[om0] <> ".txt";
   If[c==0, oldprob=Array[0&,Dimensions[newprob][[1]]], oldprob=Get[filename]];
   prob = oldprob + newprob;
   Put[prob, filename];
   ];

For[ic = 0, ic < 1000, ic++, f[ic,3]]
For[ic = 0, ic < 1000, ic++, f[ic,1]]
For[ic = 0, ic < 1000, ic++, f[ic,-1]]
For[ic = 0, ic < 1000, ic++, f[ic,-3]]
