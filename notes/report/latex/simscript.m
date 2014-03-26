simno = 1;
statefile = StringJoin[$HomeDirectory, "/mathematica_state_", ToString[simno], ".txt"];
nic = 500; (* number of runs *)
npts = 100000; (* symbols sent per run *)

l = 4; (* no. symbols *)
be = 0.5;
th = 0;
de = 0.1;
nISI = 12;
snrDB = 20;
ts = 1;
mean = 1; (* Rayleigh mean *)
nant = 2; (* no. antennae *)

(*RRC*)
h[t_] := (Sinc[(Pi t)/ts] Cos[(Pi be t)/ts])/(1 - ((2 be t)/ts)^2);
g[kk_, de_] := h[ts (de + kk)]; (* with timing offset *)

(*Tikhonov distribution*)
thikfactor[var_] := thikfactor[var] = 1/((2 Pi)^2 var);
thik[var_, y_] := thik[var, y] = Exp[thikfactor[var] Cos[2 Pi y]]/BesselI[0, thikfactor[var]];

(* histogram bins *)
histpts = Join[{-Infinity}, Range[-1, 5, 0.01], {Infinity}];
(*Histogram*)
histoplots = {Table[Array[0 &, Dimensions[histpts][[1]] - 1], {2}]};

Print[AbsoluteTiming[
 Monitor[Do[prob = Array[0 &, {2, Dimensions[histpts][[1]] - 1}];
   Do[sigin = {1, 3}; (*sent symbol*)
    (* update status text file *)
    Put[StringJoin["Simulation ",ToString[simno],", Tikhonov variance: ",ToString[tv],", Block ",ToString[ic]," of ",ToString[nic]],statefile];

    thikdist = ProbabilityDistribution[thik[tv, y], {y, -0.5, 0.5}];
    w = ParallelTable[Join[RandomChoice[{-3, -1, 1, 3}, nISI/2], {w0}, RandomChoice[{-3, -1, 1, 3}, nISI/2]], {w0, sigin}];
    k = Range[-(nISI/2), nISI/2];
    dtiming = N[RandomVariate[thikdist, {nant,npts}], 8];
    ndtiming = Length[dtiming];
    gk = Table[N[ParallelTable[g[a, b], {b, dtiming[[c]]}, {a, k}]],{c,nant}];
    rk = Table[gk[[c]].w[[k]], {k,Length[sigin]}, {c,nant}]; (* received symbol before fading/AWGN *)

    snr = 10^(snrDB/20);
    var = N[Sqrt[(l^2 - 1)/(6 Log[2, l] 10^(snrDB/10))]]; (* AWGN variance *)
    atten = RandomReal[NakagamiDistribution[1, 2 (Sqrt[2/Pi] mean)^2], {nant,npts}]; (* fading *)
    (*atten=ConstantArray[1,{nant,npts}];*) (* no fading *)
    nu = RandomReal[NormalDistribution[0, var], {nant, npts}]; (* AWGN *)
    r = Table[Total[atten*((rk[[k]] atten) + nu)]/((atten[[1]]^2)+(atten[[2]]^2)),{k,Length[sigin]}]; (* received symbol post-EGC *)

    newprob = Table[BinCounts[r[[k]], {histpts}], {k, Length[sigin]}];(*histogram function*)
    prob = prob + newprob;
  , {ic, nic}]; (* repeat 'ic' times *)

  histoplots = Join[histoplots, {prob}]; (* store completed histogram *)

  (* output to parameters file *)
  row1 = ToString[Row[{"w0", "total", "ic", "npts", "nant", "mean", "snrDB", "nISI","tv"}," "]];
  row2 = ToString[Row[{w0, nic*npts, nic, npts, nant, mean, snrDB, nISI, tv}," "]];
  row3 = StringJoin["pts: ",ToString[histpts]," "];
  Put[row1,StringJoin[$HomeDirectory,"/output/",DateString[{"Year","Month","Day","_","Hour24","Minute"}],"_input.txt"]];
  PutAppend[row2,StringJoin[$HomeDirectory,"/output/",DateString[{"Year","Month","Day","_","Hour24","Minute"}],"_input.txt"]];
  PutAppend[row3,StringJoin[$HomeDirectory,"/output/",DateString[{"Year","Month","Day","_","Hour24","Minute"}],"_input.txt"]];
  
  (* output to results file *)
  Put[histoplots,StringJoin[$HomeDirectory,"/output/",DateString[{"Year", "Month", "Day", "_", "Hour24", "Minute"}], ".txt"]];
, {tv,Range[0.001,0.01,0.001]}] (* repeat for each timing error variance *)
, {tv, ic}]]/3600]


