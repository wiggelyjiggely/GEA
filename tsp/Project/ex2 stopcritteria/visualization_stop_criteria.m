% Clear the workspace
clear;clc;

% Set the parameters
NIND=100;		% Number of individuals
MAXGEN=2000;		% Maximum no. of generations
X=(1:MAXGEN);   % X values for plotting the generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.9;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=0.5;    % percentage of equal fitness individuals for stopping
STOP_GEN_AVERAGE = 10; % amount of generations the average fitness does not change
STOP_PERCENTAGE_AVERAGE = 0.0001; % percentage of change for the average fitness
STOP_GEN_BEST = 100; % amount of generations the best fitness does not change
STOP_PERCENTAGE_BEST = 0.0001; % percentage of change for the best fitness
STOP_PERCENTAGE_RATIO = 0.001; % percentage for the ratio of the average and best
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=1;      % local loop removal
CROSSOVER = 'xalt_edges';  % default crossover operator
UMean = [0.01,0.001,0.0001,0.0001];
UBest = [0.05,0.01, 0.005, 0.001, 0.0005];

% load the data sets
datasetslist = dir('../datasets/');
datasets=cell( size(datasetslist,1)-2,1);
for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
end
data = load(['../datasets/' datasets{11}]);

% Run the experiments 
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);
[fit,min,best,stop,stop_values] = run_ga_with_stop_visualized(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP);
sparsemean = sparse(fit);
sizesparse = nnz(sparsemean);

EMean = efficiency(fit(X));     % Efficiency values for the mean fitness values
SMean = best_stop(EMean,UMean); % The best generations to stop at according to UMean
[~,iSMeanMax] = size(SMean);    % The amount of stop places

EBest = efficiency(best(X));    % Efficiency values for the best fitness values
SBest = best_stop(EBest,UBest); % The best generations to stop at according to UBest
[~,iSBestMax] = size(SBest);    % The amount of stop places

% Visualizing the fitness values of all generations
figure;
plot((1:1:sizesparse),sparsemean(1:sizesparse),X,best(1:MAXGEN));
legend("Best fitness value","Mean fitness value");
xlabel("Generation");
ylabel("Fitness values");

% Visualizing the Efficieny values of all generations
figure;
subplot(5,1,1)
plot(X(1:200),sparsemean(1:200),X(1:200),best(1:200));
legend("Mean fitness value","Best fitness value");
xlabel("Generation");
ylabel("Fitness values");
subplot(5,1,2)
plot(X(1:200),EMean(1,1:200),X(1:200),EBest(1,1:200));
legend("Mean","Best");
xlabel("Generation");
ylabel({"Efficiency values with";"no time penalty"});
subplot(5,1,3)
plot(X(1:200),EMean(2,1:200),X(1:200),EBest(2,1:200));
legend("Mean","Best");
xlabel("Generation");
ylabel({"Efficiency values with";"logarithmic time penalty"});
subplot(5,1,4)
plot(X(1:200),EMean(3,1:200),X(1:200),EBest(3,1:200));
legend("Mean","Best");
xlabel("Generation");
ylabel({"Efficiency values with";"linear time penalty"});
subplot(5,1,5)
plot(X(1:200),EMean(4,1:200),X(1:200),EBest(4,1:200));
legend("Mean","Best");
xlabel("Generation");
ylabel({"Efficiency values with";"exponential time penalty"});

% Visualizing all properties of the stop criteria
figure;
subplot(3,1,1)
plot((1:1:sizesparse),sparsemean(1:sizesparse),X,best(1:MAXGEN));
legend("Mean fitness value","Best fitness value");
xlabel("Generation");
ylabel("Fitness values");
subplot(3,1,2)
plot(X,stop_values(6,:))
legend("Take over of the best chromosome")
xlabel("Generation");
ylabel("Chromosomes");
subplot(3,1,3)
plot(X,stop_values(2,:),X,stop_values(4,:))
legend("Generations best did not improve", "Generations mean did not improve")
xlabel("Generation");
ylabel("Generations");

% Visualizing the tunede stop criteria
figure;
plot((1:1:sizesparse),sparsemean(1:sizesparse),'DisplayName',"Mean Fit");
plot([1:1:MAXGEN],best(1:MAXGEN),'DisplayName',"Best Fit");
x1 = find(stop(1,:),1,"first");
if (~isempty(x1))
    xline(x1,'-.',"Variance threshold reached");
end
x2 = find(stop(2,:),1,"first");
if (~isempty(x2))
    xline(x2,'-.',"No improved mean fitness");
end
x3 = find(stop(3,:),1,"first");
if (~isempty(x3))
    xline(x3,'-.',"No improved best fitness");
end
xlabel("Generation");
ylabel("Mean fitness value");