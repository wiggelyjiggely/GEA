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

%[fit,min,best] = run_ga_custom_wlm(x, y, 50, MAXGEN, NVAR, 0.4, STOP_PERCENTAGE, 0.2, 0.6, 'xalt_edges', LOCALLOOP,'srs');

% Set the parameters for lshga
MAXGEN=1000;	% Maximum no. of generations

% Run the five benchmarks with the ex3 algorithm
disp("Belgium")
startbel = tic;
[mean_belgium,~,best_belgium] = run_ga_custom_wlm(xbelgium, ybelgium, 50, MAXGEN, Nbelgium, 0.4, 1, 0.2, 0.6, 'xalt_edges', 0,'sus');
t_bel = toc(startbel)
best_belgium = best_belgium(1,size(best_belgium,2))

disp("xqf131")
startxqf131 = tic;
[mean_xqf131,~,best_xqf131] = run_ga_custom_wlm(xxqf131, yxqf131, 50, MAXGEN, Nxqf131, 0.4, 1, 0.2, 0.6, 'xalt_edges', 0,'sus');
t_xqf131 = toc(startxqf131)
best_xqf131 = best_xqf131(1,size(best_xqf131,2))

disp("bcl380")
startbcl380 = tic;
[mean_bcl380,~,best_bcl380] = run_ga_custom_wlm(xbcl380, ybcl380, 50, MAXGEN, Nbcl380, 0.4, 1, 0.2, 0.6, 'xalt_edges', 0,'sus');
t_bcl380 = toc(startbcl380)
best_bcl380 = best_bcl380(1,size(best_bcl380,2))

disp("xql662")
startxql662 = tic;
[mean_xql662,~,best_xql662] = run_ga_custom_wlm(xxql662, yxql662, 50, MAXGEN, Nxql662, 0.4, 1, 0.2, 0.6, 'xalt_edges', 0,'sus');
t_xql662 = toc(startxql662)
best_xql662 = best_xql662(1,size(best_xql662,2))

disp("rbx711")
startrbx711 = tic;
[mean_rbx711,~,best_rbx711] = run_ga_custom_wlm(xrbx711, yrbx711, 50, MAXGEN, Nrbx711, 0.4, 1, 0.2, 0.6, 'xalt_edges', 0,'sus');
t_rbx711 = toc(startrbx711)
best_rbx711 = best_rbx711(1,size(best_rbx711,2))
