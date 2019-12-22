function run_with_param()

NIND=100;		% Number of individuals
MAXGEN=200;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.5;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
STOP_GEN_AVERAGE = 5; % amount of generations the average fitness does not change
STOP_PERCENTAGE_AVERAGE = 0.01; % percentage of change for the average fitness
STOP_GEN_BEST = 5; % amount of generations the best fitness does not change
STOP_PERCENTAGE_BEST = 0.01; % percentage of change for the best fitness
STOP_PERCENTAGE_RATIO = 0.01; % percentage for the ratio of the average and best
PR_CROSS=.95;     % probability of crossover
PR_MUT=.05;       % probability of mutation
LOCALLOOP=0;      % local loop removal
CROSSOVER = 'Ordered_crossover';  % default crossover operator

% load the data sets
datasetslist = dir('datasets/');
%datasetslist = dir('datasets/');
datasets=cell( size(datasetslist,1)-2,1);datasets=cell( size(datasetslist,1)-2 ,1);
for i=1:size(datasets,1);
    datasets{i} = datasetslist(i+2).name;
end

% start with first dataset
data = load(['../template/datasets/' datasets{11}]);
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);
figure;
title("Population: " + NIND);
hold on;
amountOfRuns = 10;
timinglist = zeros(3,9);
fitnesslist = zeros(3,9);
ii = 1;

for jump2 = [20 50 100]
    NIND = jump2;
    jj = 1;
    for jump1= [90 80 70 60 50 40 30 20 10]
        ELITIST = jump1/100; GGAP = 1 - ELITIST;
        %NIND = jump1;
        %PR_CROSS = jump1/100; 
        %PR_MUT = 1-PR_CROSS;
        listRuns3 = zeros(amountOfRuns, MAXGEN);
        listtime3 = zeros(amountOfRuns,1);
        for run = 1 : amountOfRuns    

            %stochastic remainder selection
            t = cputime;
            [fit3,min3,best3] = run_once_ex6(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, 'sus');
            listtime3(run,1) = cputime-t;

            sparsemean3 = sparse(fit3);
            sizesparse3 = nnz(sparsemean3);

            for iszero = 1 : MAXGEN
                if sparsemean3(iszero) == 0
                    sparsemean3(iszero) = sparsemean3(iszero-1);
                end
            end

            listRuns3(run,:) = sparsemean3(1:MAXGEN); 
        end
        time3 = mean(listtime3);
        sparsemean3 = mean(listRuns3);   
        
        fitnesslist(ii,jj) = best3(end);
        timinglist(ii,jj) = time3(end);
        jj = jj + 1;
    end
    ii = ii+1;
    
    %plot([1:1:sizesparse3],sparsemean3(1:sizesparse3));
    %plot([1:1:sizesparse3],sparsemean3(1:sizesparse3),'DisplayName',"elitism: " + num2str(ELITIST));
    %plot([1:1:sizesparse3],sparsemean3(1:sizesparse3),'DisplayName',"population: " + num2str(NIND));
    %plot([1:1:sizesparse3],sparsemean3(1:sizesparse3),'DisplayName',"Crossover: " + num2str(PR_CROSS) + " mutation: " + num2str(PR_MUT));
    %xlabel("Generation");
    %ylabel("Mean fitness value");
    %title("Population: " + NIND);
    %legend show;
    %hold on;
    %disp("sus best distance: " + best3(end));

end
timinglist
fitnesslist
end

