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


[fit,min,best] = run_ga_custom_wlm(x, y, 100, MAXGEN, NVAR, 0.3, STOP_PERCENTAGE, 0.2, 0.6, 'xalt_edges', LOCALLOOP,'tournament');