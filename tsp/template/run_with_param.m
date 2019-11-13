function run_with_param()

NIND=50;		% Number of individuals
MAXGEN=100;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.95;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=1;      % local loop removal
CROSSOVER = 'xalt_edges';  % default crossover operator

% load the data sets
datasetslist = dir('datasets/');datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);datasets=cell( size(datasetslist,1)-2 ,1);
for i=1:size(datasets,1);
    datasets{i} = datasetslist(i+2).name;
end

% start with first dataset
data = load(['datasets/' datasets{11}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);
figure;
title("Population: " + NIND);
hold on;
for jump1= [90,95,97,99]
        PR_CROSS = jump1/100;
        [fit,min,best] = cust_run(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP);
        %cust_visualize_results(best,fit);
        sparsemean = sparse(fit);
        sizesparse = nnz(sparsemean);
        plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"Crossover rate: " + num2str(PR_CROSS));
        xlabel("Generation");
        ylabel("Mean fitness value");
end
hold off;
legend show;
end

