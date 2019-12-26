% Clear the workspace
clear;clc;

% load the data sets
datasetslist = dir('../datasets/');
datasets=cell( size(datasetslist,1)-2,1);
for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
end
data = load(['../datasets/' datasets{11}]);
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);

% Set the parameters that are fixed
NINDM= [5,10,20,50,100];		% Number of individuals
MAXGEN=1000;		% Maximum no. of generations
X=(1:MAXGEN);   % X values for plotting the generations
PRECI=1;		% Precision of variables
Ke = 0.1;       % Elistism constant
Kc = 1;         % Crossover constant
Km = 0.5;       % Mutation constant
TNIB = 10;

[~,iMax] = size(NINDM);

% Allocate memory
bestBestsOfRuns = zeros(MAXGEN,iMax);
%bestMeansOfRuns = zeros(MAXGEN,iMax);
timesOfbestRuns = zeros(1,iMax);

% Loop over the population size
for i = 1 : iMax
    NIND = NINDM(1,i);
    bests = zeros(MAXGEN,10);
    %means = zeros(MAXGEN,10);
    times = zeros(1,10);
    for j = 1 : 10
        start = tic;
        [M,B] = run_ga_with_local_heuristics_and_stop(x, y, NIND, MAXGEN, NVAR, Kc, Km, Ke,TNIB);
        times(1,j) = toc(start);
        [~,length] = size(M);
        bests(1:length,j) = B';
        %means(1:length,j) = M';
    end
    yplotbests = bests;
    yplotbests(yplotbests==0) = NaN;
    figure;
    for j = 1 : 10
        plot(X,yplotbests(1:MAXGEN,j));
        hold on;
    end
    title("Population size of: " + int2str(NINDM(i)))
    xlabel("Generation");
    ylabel("Fitness values");
    hold off
    BestValues = zeros(1,10);
    for j = 1:10
        BestValues = min(yplotbests(1:MAXGEN,j));
    end
    BestRun = find(BestValues==min(BestValues),1);
    bestBestsOfRuns(:,i) = yplotbests(1:MAXGEN,BestRun);
    timesOfbestRuns(1,i) = times(1,BestRun);
end
figure;
for i = 1 : iMax
    plot(X,bestBestsOfRuns(1:MAXGEN,i),'DisplayName',"PopSize="+int2str(NINDM(i)));
    hold on;
end
title("Best run of each population size")
xlabel("Generation");
ylabel("Fitness values");
legend show
hold off

    
