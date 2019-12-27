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
MAXGEN=10000;	
PROC = 0.7;         
LOOP = 0;
FRACPOP = 0.5;
ELIT = 0.4;
CROSSR = 0.6;
PR = 0.5;

% Run the five benchmarks with the lshga algorithm

%disp("Belgium")
%startbel = tic;
%[mean_belgium,~,best_belgium] = run_ga_custom_wlm(xbelgium, ybelgium, 100, MAXGEN, Nbelgium, 0.1, 1, 0.3, 0.5, 'xalt_edges', 0,'sus');
%t_bel = toc(startbel)
%best_belgium = best_belgium(1,size(best_belgium,2))

disp("xqf131")
startxqf131 = tic;
[mean_xqf131,~,best_xqf131] = run_ga_custom_wlm(xxqf131, yxqf131, round(Nxqf131*FRACPOP), MAXGEN, Nxqf131, ELIT, PROC, CROSSR, PR, 'Orderd_crossover', LOOP,'sus');
t_xqf131 = toc(startxqf131);
for i = 1 : size(best_xqf131,2)
   if (best_xqf131(1,i) == 0)
        break;
   end
end
best_xqf131 = best_xqf131(1,i-1);
gen_xqf131 = i-1;

disp("Time: " + t_xqf131 + " Tours: " + best_xqf131 + " at generation: " + gen_xqf131);

disp("bcl380")
startbcl380 = tic;
[mean_bcl380,~,best_bcl380] = run_ga_custom_wlm(xbcl380, ybcl380, round(Nbcl380*FRACPOP), MAXGEN, Nbcl380,  ELIT, PROC, CROSSR, PR, 'Orderd_crossover', LOOP,'sus');
t_bcl380 = toc(startbcl380);
for i = 1 : size(best_bcl380,2)
   if (best_bcl380(1,i) == 0)
        break;
   end
end
best_bcl380 = best_bcl380(1,i-1);
gen_bcl380 = i-1;

disp("Time: " + t_bcl380 + " Tours: " + best_bcl380 + " at generation: " + gen_bcl380);

disp("xql662")
startxql662 = tic;
[mean_xql662,~,best_xql662] = run_ga_custom_wlm(xxql662, yxql662, round(Nxql662*FRACPOP), MAXGEN, Nxql662,  ELIT, PROC, CROSSR, PR, 'Orderd_crossover', LOOP,'sus');
t_xql662 = toc(startxql662);
for i = 1 : size(best_xql662,2)
   if (best_xql662(1,i) == 0)
        break;
   end
end
best_xql662 = best_xql662(1,i-1);
gen_xql662 = i-1;

disp("Time: " + t_xql662 + " Tours: " + best_xql662 + " at generation: " + gen_xql662);

disp("rbx711")
startrbx711 = tic;
[mean_rbx711,~,best_rbx711] = run_ga_custom_wlm(xrbx711, yrbx711, round(Nrbx711*FRACPOP), MAXGEN, Nrbx711,  ELIT, PROC, CROSSR, PR, 'Orderd_crossover', LOOP,'sus');
t_rbx711 = toc(startrbx711);
for i = 1 : size(best_rbx711,2)
   if (best_rbx711(1,i) == 0)
        break;
   end
end
best_rbx711 = best_rbx711(1,i-1);
gen_rbx771 = i-1;

disp("Time: " + t_rbx711 + " Tours: " + best_rbx711 + " at generation: " + gen_rbx771);
