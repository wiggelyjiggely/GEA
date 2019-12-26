function run()

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
times1 = zeros(1,4);
times2 = zeros(1,4);
iddd = 1;
%for jump1= [1, 3, 5, 10]
%for jump1= [40 50 60]
%for jump1= [50, 100, 200, 400]
for jump1= [1]
    listRuns = zeros(amountOfRuns, MAXGEN);
    listRuns2 = zeros(amountOfRuns, MAXGEN);
    listRuns3 = zeros(amountOfRuns, MAXGEN);
    listRuns4 = zeros(amountOfRuns, MAXGEN);
    listTimes1 = zeros(amountOfRuns,1);
    listTimes2 = zeros(amountOfRuns,1);
    for run = 1 : amountOfRuns
        %NIND = jump1; 
        %PR_CROSS = jump1/100; PR_MUT = (1-jump1/100);
        %ELITIST = jump1/100; GGAP = 1-ELITIST;
        
        t1 = cputime;
        [fit,min,best] = run_once(x, y, NIND, MAXGEN, NVAR, 0.5, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, 0.5, 0.5, 'xalt_edges', LOCALLOOP);
        listTimes1(run) = cputime - t1;
        t2 = cputime;
        [fit2,min2,best2] = run_once(x, y, NIND, MAXGEN, NVAR, 0.1, STOP_PERCENTAGE, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, 0.9, 0.1, 'Ordered_crossover', LOCALLOOP);
         listTimes2(run) = cputime - t2;
        
        sparsemean = sparse(fit);
        sizesparse = nnz(sparsemean);
        
        sparsemean2 = sparse(fit2);
        sizesparse2 = nnz(sparsemean2);
        
        sparsemean3 = sparse(best);
        sizesparse3 = nnz(sparsemean3);
        
        sparsemean4 = sparse(best2);
        sizesparse4 = nnz(sparsemean4);
        
        for iszero = 1 : MAXGEN
            if sparsemean(iszero) == 0
                sparsemean(iszero) = sparsemean(iszero-1);
            end
           if sparsemean2(iszero) == 0
                sparsemean2(iszero) = sparsemean2(iszero-1);
           end
            if sparsemean3(iszero) == 0
                sparsemean3(iszero) = sparsemean3(iszero-1);
            end
           if sparsemean4(iszero) == 0
                sparsemean4(iszero) = sparsemean4(iszero-1);
            end
        end
        
        listRuns(run,:) = sparsemean(1:MAXGEN);  
        listRuns2(run,:) = sparsemean2(1:MAXGEN);        
        listRuns3(run,:) = sparsemean3(1:MAXGEN);  
        listRuns4(run,:) = sparsemean4(1:MAXGEN);
    end
    sparsemean = mean(listRuns);
    sparsemean2 = mean(listRuns2);
    
    distbest1 = 1000;
    ibest1 = 1;
    for i = 1 : amountOfRuns
       if(listRuns3(i,end) < distbest1)
           distbest1 = listRuns3(i,end);
           ibest1 = i;
       end
    end
    sparsemean3 = listRuns3(ibest1,:);
    
    distbest2 = 1000;
    ibest2 = 1;
    for i = 1 : amountOfRuns
       if(listRuns4(i,end) < distbest1)
           distbest2 = listRuns4(i,end);
           ibest2 = i;
       end
    end
    sparsemean4 = listRuns4(ibest2,:);
    subplot(1,2,1);
    %plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"MR: " + num2str(PR_MUT) + " CR: " + num2str(PR_CROSS));
    %plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"elitism: " + num2str(ELITIST));
    %plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"Population size: " + num2str(NIND));
    plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName','mean fitness');
    hold on;
    plot([1:1:sizesparse3],sparsemean3(1:sizesparse3),'DisplayName','best fitness');
    xlabel("Generation");
    ylabel("fitness value");
    title("Old operators");
    hold on;
    ax1 = subplot(1,2,2);
    %plot([1:1:sizesparse2],sparsemean2(1:sizesparse2),'DisplayName',"MR: " + num2str(PR_MUT) + " CR: " + num2str(PR_CROSS));
    %plot([1:1:sizesparse2],sparsemean2(1:sizesparse2),'DisplayName',"elitism: " + num2str(ELITIST));
    %plot([1:1:sizesparse2],sparsemean2(1:sizesparse2),'DisplayName',"Population size: " + num2str(NIND));
    plot([1:1:sizesparse2],sparsemean2(1:sizesparse2),'DisplayName','mean fitness');
    hold on;
    plot([1:1:sizesparse4],sparsemean4(1:sizesparse4),'DisplayName','best fitness');
    xlabel("Generation");
    ylabel("fitness value");
    title("New operators");
    hold on;
    distbest1
    distbest2
    mean(listTimes1)
    mean(listTimes2)
    times1(1,iddd) = mean(listTimes1);
    times2(1,iddd) = mean(listTimes2);
    iddd = iddd + 1;
end
%ax2 = subplot(1,3,3);
%plot(times1');
%hold on;
%plot(times2');
%legend(ax1);
%legend(ax2, 'new operators', 'old operators');
%ylabel("average cpu time");
%title("Cpu time");
%hold off;
legend show;
end

