function run_ex6()

NIND=100;		% Number of individuals
MAXGEN=200;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.6;    % percentage of the elite population
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
CROSSOVER = 'xalt_edges';  % default crossover operator

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
for jump1= [95 90 60 30]
    %ELITIST = jump1/100; GGAP = 1 - ELITIST;
    %NIND = jump1;
    PR_CROSS = jump1/100; 
    PR_MUT = 1-PR_CROSS;
    listRuns = zeros(amountOfRuns, MAXGEN);
    listRuns1 = zeros(amountOfRuns, MAXGEN);
    listRuns2 = zeros(amountOfRuns, MAXGEN);
    listRuns3 = zeros(amountOfRuns, MAXGEN);
    listtime = zeros(amountOfRuns,1);
    listtime1 = zeros(amountOfRuns,1);
    listtime2 = zeros(amountOfRuns,1);
    listtime3 = zeros(amountOfRuns,1);
    for run = 1 : amountOfRuns
    
        %sus
        t = cputime;
        [fit,min,best] = run_once_ex6(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, 'sus');
        listtime(run,1) = cputime-t;
        
        sparsemean = sparse(fit);
        sizesparse = nnz(sparsemean);
        
        for iszero = 1 : MAXGEN
            if sparsemean(iszero) == 0
                sparsemean(iszero) = sparsemean(iszero-1);
            end
        end
        
        listRuns(run,:) = sparsemean(1:MAXGEN);  
        %tournament selection with replacement
        t = cputime;
        [fit1,min1,best1] = run_once_ex6(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, 'tournament');
        listtime1(run,1) = cputime-t;
        
        sparsemean1 = sparse(fit1);
        sizesparse1 = nnz(sparsemean1);
        
        for iszero = 1 : MAXGEN
            if sparsemean1(iszero) == 0
                sparsemean1(iszero) = sparsemean1(iszero-1);
            end
        end
        
        listRuns1(run,:) = sparsemean1(1:MAXGEN);  
        
         %tournament selection without replacement
         t = cputime;
        [fit2,min2,best2] = run_once_ex6(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, 'tournament2');
        listtime2(run,1) = cputime-t;
        
        sparsemean2 = sparse(fit2);
        sizesparse2 = nnz(sparsemean2);
        
        for iszero = 1 : MAXGEN
            if sparsemean2(iszero) == 0
                sparsemean2(iszero) = sparsemean2(iszero-1);
            end
        end
        
        listRuns2(run,:) = sparsemean2(1:MAXGEN); 
        
        %stochastic remainder selection
        t = cputime;
        [fit3,min3,best3] = run_once_ex6(x, y, 200, MAXGEN, NVAR, 0.2, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, 'srs');
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
    time = mean(listtime);
    time1 = mean(listtime1);
    time2 = mean(listtime2);
    time3 = mean(listtime3);
    
    sparsemean = mean(listRuns);
    sparsemean1 = mean(listRuns1);
    sparsemean2 = mean(listRuns2);
    sparsemean3 = mean(listRuns3);
 
    ax = subplot(2,2,1);    
    %plot([1:1:sizesparse],sparsemean(1:sizesparse));
    %plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"elitism: " + num2str(ELITIST));
    %plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"population: " + num2str(NIND));
    plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"Crossover: " + num2str(PR_CROSS) + " mutationn: " + num2str(PR_MUT));
    xlabel("Generation");
    ylabel("Mean fitness value");
    title("Sus");
    hold on;
    
    ax1 = subplot(2,2,2);
    %plot([1:1:sizesparse1],sparsemean1(1:sizesparse1));
    %plot([1:1:sizesparse1],sparsemean1(1:sizesparse1),'DisplayName',"elitism: " + num2str(ELITIST));    
    %plot([1:1:sizesparse1],sparsemean1(1:sizesparse1),'DisplayName',"population: " + num2str(NIND));
    plot([1:1:sizesparse1],sparsemean1(1:sizesparse1),'DisplayName',"Crossover: " + num2str(PR_CROSS) + " mutationn: " + num2str(PR_MUT));
    xlabel("Generation");
    ylabel("Mean fitness value");
    title("tournament replace");
    hold on;
    
    ax2 = subplot(2,2,3);
    %plot([1:1:sizesparse2],sparsemean2(1:sizesparse2));
    %plot([1:1:sizesparse2],sparsemean2(1:sizesparse2),'DisplayName',"elitism: " + num2str(ELITIST)); 
    %plot([1:1:sizesparse2],sparsemean2(1:sizesparse2),'DisplayName',"population: " + num2str(NIND));
    plot([1:1:sizesparse2],sparsemean2(1:sizesparse2),'DisplayName',"Crossover: " + num2str(PR_CROSS) + " mutationn: " + num2str(PR_MUT));
    xlabel("Generation");
    ylabel("Mean fitness value");
    title("tournament no replace");
    hold on;
    
    ax2 = subplot(2,2,4);
    %plot([1:1:sizesparse3],sparsemean3(1:sizesparse3));
    %plot([1:1:sizesparse3],sparsemean3(1:sizesparse3),'DisplayName',"elitism: " + num2str(ELITIST));
    %plot([1:1:sizesparse3],sparsemean3(1:sizesparse3),'DisplayName',"population: " + num2str(NIND));
    plot([1:1:sizesparse3],sparsemean3(1:sizesparse3),'DisplayName',"Crossover: " + num2str(PR_CROSS) + " mutationn: " + num2str(PR_MUT));
    xlabel("Generation");
    ylabel("Mean fitness value");
    title("srs");
    hold on;
end
legend(ax);
disp("Stochastic universal selection best distance: " + best(end));
disp("tournament selection with replacement best distance: " + best1(end));
disp("tournament selection without replacement best distance: " + best2(end));
disp("stochastic remainder selection best distance: " + best3(end));

disp("Stochastic universal selection time: " + time);
disp("tournament selection with replacement time: " + time1);
disp("tournament selection without replacement time: " + time2);
disp("stochastic remainder selection time: " + time3);
end

