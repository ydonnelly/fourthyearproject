l = 4;
be = 0.5;
th = 0;
de = 0.1;
nISI = 20;
snrDB = 8;
ts = 1;
npts = 100000;

(* functions *)
h[t_] := (Sinc[(Pi*t)/ts]*Cos[(Pi*be*t)/ts])/(1 - ((2*be*t)/ts)^2);
g[kk_, de_] := h[ts*(de + kk)];
thikfactor[var_] := thikfactor[var] = 1/((2 \[Pi])^2 var);
thik[var_, y_] := thik[var, y] = Exp[thikfactor[var] Cos[2 \[Pi] y]]/BesselI[0, thikfactor[var]];

f[count_, omega0_, tvar_] := Module[{c = count, w0 = omega0, tv = tvar},
   Print[{w0,tv,c}];
           
   thikdist = ProbabilityDistribution[thik[tv, y], {y, -0.5, 0.5}]; 
   
   (* received symbols *)
   w = Join[RandomChoice[{-3, -1, 1, 3}, nISI/2], {w0}, RandomChoice[{-3, -1, 1, 3}, nISI/2]];
   k = Range[-nISI/2, nISI/2];
   dtiming = N[RandomVariate[thikdist, {npts}], 8];
   ndtiming = Length[dtiming];
   gk = N[ParallelTable[g[a, b], {b, dtiming}, {a, k}]];
   rk = gk.w;
   snr = 10^(snrDB/20);
   var = N[Sqrt[(l^2 - 1)/(6*Log[2, l]*10^(snrDB/10))]];
   nu = RandomReal[NormalDistribution[0, var], npts];
   r = rk + nu;
   
   (* histogram *)
   histpts = Range[1.5, 2, 0.002];
   newprob = BinCounts[r, {histpts}];
   filename =     "2/output_" <> ToString[tv] <> "_" <> ToString[w0] <> ".txt";
   If[c == 0, oldprob = Array[0 &, Dimensions[newprob][[1]]], oldprob = Get[filename]];
   prob = oldprob + newprob;
   Put[prob, filename];];

Do[Do[f[ic, 3, tv], {ic, 0, 100}], {tv, 0.001, 0.01, 0.001}] 
Do[Do[f[ic, 1, tv], {ic, 0, 100}], {tv, 0.001, 0.01, 0.001}]
