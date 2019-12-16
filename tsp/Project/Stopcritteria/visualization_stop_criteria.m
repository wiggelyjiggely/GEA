clear;clc;

NIND=50;		% Number of individuals
MAXGEN=1000;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.95;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
STOP_GEN_AVERAGE = 10; % amount of generations the average fitness does not change
STOP_PERCENTAGE_AVERAGE = 0.0001; % percentage of change for the average fitness
STOP_GEN_BEST = 100; % amount of generations the best fitness does not change
STOP_PERCENTAGE_BEST = 0.0001; % percentage of change for the best fitness
STOP_PERCENTAGE_RATIO = 0.001; % percentage for the ratio of the average and best
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=1;      % local loop removal
CROSSOVER = 'xalt_edges';  % default crossover operator

% load the data sets
datasetslist = dir('../datasets/');
datasets=cell( size(datasetslist,1)-2,1);
for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
end

% start with first dataset
data = load(['../datasets/' datasets{11}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);
figure;
title("Population: " + NIND);
hold on;
[fit,min,best,stop,stop_values] = run_ga_with_stop_visualized(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP);
sparsemean = sparse(fit);
sizesparse = nnz(sparsemean);
subplot(5,2,1)
plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"Mean Fit");
x1 = find(stop(1,:),1,"first");
if (~isempty(x1))
    xline(x1,'-.',"Stopcriterium 1");
end
x2 = find(stop(2,:),1,"first");
if (~isempty(x2))
    xline(x2,'-.',"Stopcriterium 2");
end
x3 = find(stop(3,:),1,"first");
if (~isempty(x3))
    xline(x3,'-.',"Stopcriterium 3");
end
x4 = find(stop(4,:),1,"first");
if (~isempty(x4))
    xline(x4,'-.',"Stopcriterium 4");
end
xlabel("Generation");
ylabel("Mean fitness value");

EMean = efficiency(fit(1:MAXGEN));
X = [1:1:MAXGEN];
subplot(5,2,3)
plot(X,EMean(1,:),'DisplayName',"Best Fit");
legend("Time is not penaltized")
xlabel("Generation");
ylabel("Efficiency value of the mean");

subplot(5,2,5)
plot(X,EMean(2,:),'DisplayName',"Best Fit");
legend("Time is penaltized is a logarithmic manner")
xlabel("Generation");
ylabel("Efficiency value of the mean");

subplot(5,2,7)
plot(X,EMean(3,:),'DisplayName',"Best Fit");
legend("Time is penaltized is a square linear manner")
xlabel("Generation");
ylabel("Efficiency value of the mean");

subplot(5,2,9)
plot(X,EMean(4,:),'DisplayName',"Best Fit");
legend("Time is penaltized in a quadratic manner")
xlabel("Generation");
ylabel("Efficiency value of the mean");

subplot(5,2,2)
plot([1:1:MAXGEN],best(1:MAXGEN),'DisplayName',"Best Fit");
x1 = find(stop(1,:),1,"first");
if (~isempty(x1))
    xline(x1,'-.',"Stopcriterium 1");
end
x2 = find(stop(2,:),1,"first");
if (~isempty(x2))
    xline(x2,'-.',"Stopcriterium 2");
end
x3 = find(stop(3,:),1,"first");
if (~isempty(x3))
    xline(x3,'-.',"Stopcriterium 3");
end
x4 = find(stop(4,:),1,"first");
if (~isempty(x4))
    xline(x4,'-.',"Stopcriterium 4");
end
xlabel("Generation");
ylabel("Best fitness value");


EBest = efficiency(best(1:MAXGEN));
X = [1:1:MAXGEN];

subplot(5,2,4)
plot(X,EBest(1,:),'DisplayName',"Best Fit");
legend("Time is not penaltized")
xlabel("Generation");
ylabel("Efficiency value of the best");

subplot(5,2,6)
plot(X,EBest(2,:),'DisplayName',"Best Fit");
legend("Time is penaltized is a logarithmic manner")
xlabel("Generation");
ylabel("Efficiency value of the best");

subplot(5,2,8)
plot(X,EBest(3,:),'DisplayName',"Best Fit");
legend("Time is penaltized is a linear manner")
xlabel("Generation");
ylabel("Efficiency value of the best");

subplot(5,2,10)
plot(X,EBest(4,:),'DisplayName',"Best Fit");
legend("Time is penaltized in a quadratic manner")
xlabel("Generation");
ylabel("Efficiency value of the best");

hold off;