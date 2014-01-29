simno = 3;
statefile = StringJoin[$HomeDirectory,"/mathematica_state_",ToString[simno],".txt"];
nic = 1000;
npts = 100000;
histpts = Join[{-Infinity}, Range[-1, 1.5, 0.1], Range[1.6, 1.9, 0.01], Range[2.0, 5, 0.1], {Infinity}];
l = 4;
be = 0.5;
th = 0;
de = 0.1;
nISI = 20;
snrDB = 8;
ts = 1;
mean = 1; (* Rayleigh mean *)
nant = 4; (* no. antennae *)
prob = Array[0 &, Dimensions[histpts][[1]] - 1];

(* RRC *)
h[t_] := (Sinc[(Pi t)/ts] Cos[(Pi be t)/ts])/(1 - ((2 be t)/ts)^2);
(* RRC w/ timing offset *)
g[kk_, de_] := h[ts (de + kk)];


(* Tikhonov distribution *)
thikfactor[var_] := thikfactor[var] = 1/((2 Pi)^2 var);
thik[var_, y_] := thik[var, y] = Exp[thikfactor[var] Cos[2 Pi y]]/BesselI[0, thikfactor[var]];

(* Histogram *)
histoplots = {Array[0 &, Dimensions[histpts][[1]] - 1]};

AbsoluteTiming[Monitor[Do[prob = Array[0 &, Dimensions[histpts][[1]] - 1]; 
 Do[w0 = 3; (* sent symbol *)
    Put[StringJoin["Simulation ",ToString[simno],", Tikhonov variance: ",ToString[tv],", Block ",ToString[ic]," of ",ToString[nic]],statefile];

    thikdist = ProbabilityDistribution[thik[tv, y], {y, -0.5, 0.5}]; 

    w = Join[RandomChoice[{-3, -1, 1, 3}, nISI/2], {w0}, RandomChoice[{-3, -1, 1, 3}, nISI/2]]; 
    k = Range[-(nISI/2), nISI/2]; 
    dtiming = N[RandomVariate[thikdist, {npts}], 8]; 
    ndtiming = Length[dtiming]; 
    gk = N[ParallelTable[g[a, b], {b, dtiming}, {a, k}]]; 
    rk = Table[gk.w, {nant}]; (* received symbol before fading/AWGN *)

    snr = 10^(snrDB/20); 
    var = N[Sqrt[(l^2 - 1)/(6 Log[2, l] 10^(snrDB/10))]]; 
    atten = RandomReal[NakagamiDistribution[1, 2 (Sqrt[2/Pi] mean)^2], {nant, npts}]; (* fading *)
    (*atten = ConstantArray[1, {nant,npts}];*) (* no fading *)

    nu = RandomReal[NormalDistribution[0, var], {nant, npts}]; (* AWGN *)

    r = Mean[(rk atten) + nu]; (* received symbol post-EGC *)

    newprob = BinCounts[r, {histpts}]; (* histogram function *)
    prob = prob + newprob;
  , {ic, nic}];

  histoplots = Join[histoplots, {prob}];

  row1 = ToString[Row[{"w0", "total", "ic", "npts", "nant", "mean", "snrDB", "nISI","tv"}," "]];
  row2 = ToString[Row[{w0, nic*npts, nic, npts, nant, mean, snrDB, nISI, tv}," "]];
  row3 = StringJoin["pts: ",ToString[histpts]," "];
  Put[row1,StringJoin[$HomeDirectory,"/output/",DateString[{"Year","Month","Day","_","Hour24","Minute"}],"_input.txt"]];
  PutAppend[row2,StringJoin[$HomeDirectory,"/output/",DateString[{"Year","Month","Day","_","Hour24","Minute"}],"_input.txt"]];
  PutAppend[row3,StringJoin[$HomeDirectory,"/output/",DateString[{"Year","Month","Day","_","Hour24","Minute"}],"_input.txt"]];
  
  Put[histoplots,StringJoin[$HomeDirectory,"/output/",DateString[{"Year", "Month", "Day", "_", "Hour24", "Minute"}], ".txt"]];
, {tv,{0.002,0.005,0.008}}], {tv, ic}]];
%[[1]]/3600; (* runtime in hrs *)
