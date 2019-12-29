% Clear the workspace
clear;clc;

%% Choose methods and datasets
% Choose Methods
%   1: Base 
%   2: Ex3 
%   3: Tournament selection
%   4: Stochastic remainder selection
%   5: Local Search Heuristic Genetic Algorithm
Methods = [1,2,3,4,5];
MethodNames = ["Base","Ex3","Tournament","SRS","LSHGA"];
MethodCrossvers = ["xalt_edges","Ordered_crossover","xalt_edges","xalt_edges",""];
MethodMutations = ["sus","sus","tournament","sus",""];

% Choose the data set
%   1: xbcl380 (NVAR = 380)
%   2: belgium (NVAR = 41)
%   3: rbx711  (NVAR = 711)
%   4: xqf131  (NVAR = 131)
%   5: xql662  (NVAR = 662)
DatasetsToUse = [4,1,5,3];
DatasetNames = ["xbcl380","belgium","rbx711","xqf131","xql662"];
DatasetOptimals = [1621,NaN,3115,564,2513];

%% Set the parameters
% Set the common parameters
MAXGEN=10;
FRACPOP = 2;
PROC = 0.95;
LOOP = 0;

% Set the parameters for base
ELIT(1,1) = 0.1;
CROSSR(1,1) = 0.3;
PR(1,1) = 0.5;

% Set the parameters for ex3
ELIT(1,2) = 0.3;
CROSSR(1,2) = 0.6;
PR(1,2) = 0.5;

% Set the parameters for tournament
ELIT(1,3) = 0.3;
CROSSR(1,3) = 0.2;
PR(1,3) = 0.6;

% Set the parameters for srs
ELIT(1,4) = 0.4;
CROSSR(1,4) = 0.2;
PR(1,4) = 0.6;

% Set the parameters for 
Ke = 0.1;       % Elistism constant
Kc = 1;         % Crossover constant
Pm = 1;

%% Load the data sets
datasetslist = dir('../ex5 benchmarks/benchmarks/');
datasets=cell( size(datasetslist,1)-2,1);
for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
end

%% Run benchmarks and plot results
for i = 1 : size(DatasetsToUse,2)
    % load data
    data = load(['../ex5 benchmarks/benchmarks/' datasets{DatasetsToUse(i)}]);
    x=data(:,1);%/max([bcl380(:,1);bcl380(:,2)]);
    y=data(:,2);%/max([bcl380(:,1);bcl380(:,2)]);
    NVAR=size(data,1); 
    
    % Allocate memory
    time = zeros(1,size(Methods,2));
    best_fitness_values = zeros(size(Methods,2),MAXGEN);
    mean_fitness_values = zeros(size(Methods,2),MAXGEN+1);
    
    % run the GA's
    for j = 1 : size(Methods,2)
        disp("Running " + MethodNames(Methods(j)) + " on dataset " + DatasetNames(DatasetsToUse(i)))
        start = tic;
        if Methods(j) == 5
            [mean_fitness_values(j,1:MAXGEN),best_fitness_values(j,1:MAXGEN)] = lsgha_ours(x, y, round(NVAR*FRACPOP), MAXGEN, NVAR, Kc, Pm, Ke);
        else
            [mean_fitness_values(j,:),~,best_fitness_values(j,:)] = run_ga_custom_wlm(x, y, round(NVAR*FRACPOP), MAXGEN, NVAR, ELIT(1,j), PROC, CROSSR(1,j), PR(1,j), MethodCrossvers(Methods(j)), LOOP,MethodMutations(Methods(j)));
        end
        time(1,j) = toc(start);
        for k = 1 : size(best_fitness_values,2)
            if best_fitness_values(j,k) == 0
                break;
            end
        end

        best = best_fitness_values(j,k-1);
        gen = k-1;
                
        disp(" Time: " + time(1,j) + " Tours: " + best + " at generation: " + gen);
    end
    
    figure;
    X = 1:MAXGEN;
    yplotbests = best_fitness_values;
    yplotbests(yplotbests==0) = NaN;
    for j = 1 : size(Methods,2)
        plot(X,yplotbests(j,1:MAXGEN),'DisplayName',"Method="+MethodNames(Methods(j)));
        hold on;
    end
    yline(DatasetOptimals(DatasetsToUse(i)));
    title("Comparison of methods with population size = " + int2str(round(NVAR*FRACPOP)) + " and for " +int2str(MAXGEN) + " generations")
    xlabel("Generation");
    ylabel("Fitness values");
    legend show
    hold off
    
    time

end