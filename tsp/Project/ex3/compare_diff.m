NIND=100;		% Number of individuals
MAXGEN=400;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.4;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=1;    % percentage of equal fitness individuals for stopping
STOP_GEN_AVERAGE = 5; % amount of generations the average fitness does not change
STOP_PERCENTAGE_AVERAGE = 0.01; % percentage of change for the average fitness
STOP_GEN_BEST = 5; % amount of generations the best fitness does not change
STOP_PERCENTAGE_BEST = 0.01; % percentage of change for the best fitness
STOP_PERCENTAGE_RATIO = 0.01; % percentage for the ratio of the average and best
PR_CROSS=0.9;     % probability of crossover
PR_MUT=0.1;       % probability of mutation
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

for jump2 = [1]
%for jump2 = [90 80 70 60 50 40 30 20 10]
%for jump2 = [50 100 150]
    %NIND = jump2;
    %PR_CROSS = jump2/100; 
    %PR_MUT = 1-PR_CROSS;
    jj = 1;
    %for jump1= [90 80 70 60 50 40 30 20 10]
    for jump1= [1]
        %ELITIST = jump1/100; GGAP = 1 - ELITIST;
        %NIND = jump1;
        %PR_CROSS = jump1/100; 
        %PR_MUT = jump1/100;

        listRuns = zeros(amountOfRuns, MAXGEN);
        listRunsBest = zeros(amountOfRuns, MAXGEN);
        listtime = zeros(amountOfRuns,1);
        
        listRuns1 = zeros(amountOfRuns, MAXGEN);
        listRunsBest1 = zeros(amountOfRuns, MAXGEN);
        listtime1 = zeros(amountOfRuns,1);
        
        listRuns2 = zeros(amountOfRuns, MAXGEN);
        listRunsBest2 = zeros(amountOfRuns, MAXGEN);
        listtime2 = zeros(amountOfRuns,1);
        for run = 1 : amountOfRuns    

            %perform genetic algorithm: return best,mean and set time it
            %takes to perform algorithm
            t = cputime;
            [fit,min,best] = run_ga_custom_wlm(x, y, 100, MAXGEN, NVAR, 0.3, STOP_PERCENTAGE, PR_CROSS, PR_MUT, 'xalt_edges', LOCALLOOP,'tournamnent');
            listtime(run,1) = cputime-t;
            
            sparsemean = sparse(fit);
            sizesparse = nnz(sparsemean);

            sparsebest = sparse(best);
            sizesbest = nnz(sparsebest);
            
            %perform genetic algorithm: return best,mean and set time it
            %takes to perform algorithm
            t1 = cputime;
            [fit1,min1,best1] = run_ga_custom_wlm(x, y, 100, MAXGEN, NVAR, 0.4, STOP_PERCENTAGE, 0.4, 0.4, 'xalt_edges', LOCALLOOP,'tournament2');
            listtime1(run,1) = cputime-t1;

            sparsemean1 = sparse(fit1);
            sizesparse1 = nnz(sparsemean1);

            sparsebest1 = sparse(best1);
            sizesbest1 = nnz(sparsebest1);
            
            %perform genetic algorithm: return best,mean and set time it
            %takes to perform algorithm
             t2 = cputime;
            [fit2,min2,best2] = run_ga_custom_wlm(x, y, 500, MAXGEN, NVAR, 0.3, STOP_PERCENTAGE, 0.4, 0.4, 'xalt_edges', LOCALLOOP,'srs');
            listtime2(run,1) = cputime2-t1;

            sparsemean2 = sparse(fit2);
            sizesparse2 = nnz(sparsemean2);

            sparsebest2 = sparse(best2);
            sizesbest2 = nnz(sparsebest2);

            for iszero = 1 : MAXGEN
                if sparsemean(iszero) == 0
                    sparsemean(iszero) = sparsemean(iszero-1);
                end
                if sparsebest(iszero) == 0
                    sparsebest(iszero) = sparsebest(iszero-1);
                end
                if sparsemean1(iszero) == 0
                    sparsemean1(iszero) = sparsemean1(iszero-1);
                end
                if sparsebest1(iszero) == 0
                    sparsebest1(iszero) = sparsebest1(iszero-1);
                end
                if sparsemean2(iszero) == 0
                    sparsemean2(iszero) = sparsemean2(iszero-1);
                end
                if sparsebest2(iszero) == 0
                    sparsebest2(iszero) = sparsebest2(iszero-1);
                end
            end

            listRuns(run,:) = sparsemean(1:MAXGEN);
            listRunsBest(run,:) = sparsebest(1:MAXGEN);
            
            listRuns1(run,:) = sparsemean1(1:MAXGEN);
            listRunsBest1(run,:) = sparsebest1(1:MAXGEN);
            
            listRuns2(run,:) = sparsemean2(1:MAXGEN);
            listRunsBest2(run,:) = sparsebest2(1:MAXGEN);
        end
        time = mean(listtime);
        sparsemean = mean(listRuns);   
        
        time1 = mean(listtime1);
        sparsemean1 = mean(listRuns1);
        
        time2 = mean(listtime2);
        sparsemean2 = mean(listRuns2);

        distbest = 1000;
        ibest = 1;
        for i = 1 : amountOfRuns
           if(listRunsBest(i,end) < distbest)
               distbest = listRunsBest(i,end);
               ibest = i;
           end
        end
        sparsebest = listRunsBest(ibest,:);
        
        distbest1 = 1000;
        ibest1 = 1;
        for i = 1 : amountOfRuns
           if(listRunsBest1(i,end) < distbest1)
               distbest1 = listRunsBest1(i,end);
               ibest1 = i;
           end
        end
        sparsebest1 = listRunsBest1(ibest1,:);
        
        distbest2 = 1000;
        ibest2 = 1;
        for i = 1 : amountOfRuns
           if(listRunsBest2(i,end) < distbest2)
               distbest2 = listRunsBest2(i,end);
               ibest2 = i;
           end
        end
        sparsebest2 = listRunsBest2(ibest2,:);
        
        jj = jj + 1;
        %subplot(1,2,1);
        plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"Mean fitness tournament wh sel");
        hold on;
        plot([1:1:sizesbest],sparsebest(1:sizesbest),'DisplayName',"Best fitness tournament wh sel");
        hold on;
        plot([1:1:sizesparse1],sparsemean1(1:sizesparse1),'DisplayName',"Mean fitness tournament w sel");
        hold on
        plot([1:1:sizesbest1],sparsebest1(1:sizesbest1),'DisplayName',"Best fitness tournament w sel");
        hold on;
        plot([1:1:sizesparse2],sparsemean2(1:sizesparse2),'DisplayName',"Mean fitness srs");
        hold on
        plot([1:1:sizesbest2],sparsebest2(1:sizesbest2),'DisplayName',"Best fitness srs");
        xlabel("Generation");
        ylabel("Fitness value");
        %title("Population: " + NIND);
        legend show;
        hold on;
        %plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"Mutation rate: " + num2str(PR_MUT));
        %xlabel("Generation");
        %ylabel("Mean fitness value");
        %title("Population: " + NIND);
        %legend show;
        %hold on;
    end
    ii = ii+1;

end



