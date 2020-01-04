% Clear the workspace
clear;clc;

% Set the parameters
NIND=200;		% Number of individuals
MAXGEN=400;		% Maximum no. of generations
X=(1:MAXGEN);   % X values for plotting the generations
PRECI=1;		% Precision of variables
Ke = 0.1;       % Elistism constant
Kc = 1;         % Crossover constant
Km = 0.5;       % Mutation constant

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

% Run the experiments 
start = tic;
[mean_fits,minimum,best] = run_ga_with_local_heuristics(x, y, NIND, MAXGEN, NVAR, Kc, Km, Ke);
sparsemean = sparse(mean_fits);
sizesparse = nnz(sparsemean);
time = toc(start)
best(MAXGEN)

% Visualizing the fitness values of all generations
figure;
plot((1:1:sizesparse),sparsemean(1:sizesparse),X,best(1:MAXGEN));
legend("Mean fitness value","Best fitness value");
xlabel("Generation");
ylabel("Fitness values");