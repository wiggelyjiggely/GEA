% Clear the workspace
clear;clc;

% Load the data sets
datasetslist = dir('../ex5 benchmarks/benchmarks/');
datasets=cell( size(datasetslist,1)-2,1);
for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
end
% Data for the bcl380 tour
bcl380 = load(['../ex5 benchmarks/benchmarks/' datasets{1}]);
xbcl380=bcl380(:,1);%/max([bcl380(:,1);bcl380(:,2)]);
ybcl380=bcl380(:,2);%/max([bcl380(:,1);bcl380(:,2)]);
Nbcl380=size(bcl380,1);
% Data for the belgium tour
belgium = load(['../ex5 benchmarks/benchmarks/' datasets{2}]);
xbelgium=belgium(:,1);%/max([belgium(:,1);belgium(:,2)]);
ybelgium=belgium(:,2);%/max([belgium(:,1);belgium(:,2)]);
Nbelgium=size(belgium,1);
% Data for the rbx711 tour
rbx711 = load(['../ex5 benchmarks/benchmarks/' datasets{3}]);
xrbx711=rbx711(:,1);%/max([rbx711(:,1);rbx711(:,2)]);
yrbx711=rbx711(:,2);%/max([rbx711(:,1);rbx711(:,2)]);
Nrbx711=size(rbx711,1);
% Data for the xqf131 tour
xqf131 = load(['../ex5 benchmarks/benchmarks/' datasets{4}]);
xxqf131=xqf131(:,1);%/max([xqf131(:,1);xqf131(:,2)]);
yxqf131=xqf131(:,2);%/max([xqf131(:,1);xqf131(:,2)]);
Nxqf131=size(xqf131,1);
% Data for the xql662 tour
xql662 = load(['../ex5 benchmarks/benchmarks/' datasets{5}]);
xxql662=xql662(:,1);%/max([xql662(:,1);xql662(:,2)]);
yxql662=xql662(:,2);%/max([xql662(:,1);xql662(:,2)]);
Nxql662=size(xql662,1);


% Set the parameters for lshga
NIND=20;		% Number of individuals
MAXGEN=5000;	% Maximum no. of generations
PRECI=1;		% Precision of variables
Ke = 0.1;       % Elistism constant
Kc = 1;         % Crossover constant
Km = 0.5;       % Mutation constant
TNIB = 5;       % Stop criterium
% Run the five benchmarks with the lshga algorithm
disp("Belgium_20")
startbel = tic;
[mean_belgium_20,best_belgium_20] = run_ga_with_local_heuristics_and_stop(xbelgium, ybelgium, NIND, MAXGEN, Nbelgium, Kc, Km, Ke,TNIB);
t_bel_20 = toc(startbel)
best_bel_20 = best_belgium_20(1,size(best_belgium_20,2))

disp("xqf131_20")
startxqf131 = tic;
[mean_xqf131_20,best_xqf131_20] = run_ga_with_local_heuristics_and_stop(xxqf131, yxqf131, NIND, MAXGEN, Nxqf131, Kc, Km, Ke,TNIB);
t_xqf131_20 = toc(startxqf131)
best_xqf131_20 = best_xqf131_20(1,size(best_xqf131_20,2))

disp("bcl380_20")
startbcl380 = tic;
[mean_bcl380_20,best_bcl380_20] = run_ga_with_local_heuristics_and_stop(xbcl380, ybcl380, NIND, MAXGEN, Nbcl380, Kc, Km, Ke,TNIB);
t_bcl380_20 = toc(startbcl380)
best_bcl380_20 = best_bcl380_20(1,size(best_bcl380_20,2))

disp("xql662_20")
startxql662 = tic;
[mean_xql662_20,best_xql662_20] = run_ga_with_local_heuristics_and_stop(xxql662, yxql662, NIND, MAXGEN, Nxql662, Kc, Km, Ke,TNIB);
t_xql662_20 = toc(startxql662)
best_xql662_20 = best_xql662_20(1,size(best_xql662_20,2))

disp("rbx711_20")
startrbx711 = tic;
[mean_rbx711_20,best_rbx711_20] = run_ga_with_local_heuristics_and_stop(xrbx711, yrbx711, NIND, MAXGEN, Nrbx711, Kc, Km, Ke,TNIB);
t_rbx711_20 = toc(startrbx711)
best_rbx711_20 = best_rbx711_20(1,size(best_rbx711_20,2))

% Set the parameters for lshga
NIND=50;		% Number of individuals
disp("belgium_50")
startbel = tic;
[mean_belgium_50,best_belgium_50] = run_ga_with_local_heuristics_and_stop(xbelgium, ybelgium, NIND, MAXGEN, Nbelgium, Kc, Km, Ke,TNIB);
t_bel_50 = toc(startbel)
best_belgium_50 = best_belgium_50(1,size(best_belgium_50,2))

disp("xqf131_50")
startxqf131 = tic;
[mean_xqf131_50,best_xqf131_50] = run_ga_with_local_heuristics_and_stop(xxqf131, yxqf131, NIND, MAXGEN, Nxqf131, Kc, Km, Ke,TNIB);
t_xqf131_50 = toc(startxqf131)
best_xqf131_50 = best_xqf131_50(1,size(best_xqf131_50,2))

disp("bcl380_50")
startbcl380 = tic;
[mean_bcl380_50,best_bcl380_50] = run_ga_with_local_heuristics_and_stop(xbcl380, ybcl380, NIND, MAXGEN, Nbcl380, Kc, Km, Ke,TNIB);
t_bcl380_50 = toc(startbcl380)
best_bcl380_50 = best_bcl380_50(1,size(best_bcl380_50,2))

disp("xql662_50")
startxql662 = tic;
[mean_xql662_50,best_xql662_50] = run_ga_with_local_heuristics_and_stop(xxql662, yxql662, NIND, MAXGEN, Nxql662, Kc, Km, Ke,TNIB);
t_xql662_50 = toc(startxql662)
best_xql662_50 = best_xql662_50(1,size(best_xql662_50,2))

disp("rbx711_50")
startrbx711 = tic;
[mean_rbx711_50,best_rbx711_50] = run_ga_with_local_heuristics_and_stop(xrbx711, yrbx711, NIND, MAXGEN, Nrbx711, Kc, Km, Ke,TNIB);
t_rbx711_50 = toc(startrbx711)
best_rbx711_50 = best_rbx711_50(1,size(best_rbx711_50,2))

