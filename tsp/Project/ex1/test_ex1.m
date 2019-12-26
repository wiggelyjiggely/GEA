NIND=100;		% Number of individuals
MAXGEN=400;		% Maximum no. of generations
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
PR_CROSS=0.4;     % probability of crossover
PR_MUT=0.4;       % probability of mutation
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
    for jump1= [90 80 70 60 50 40 30 20 10]
        ELITIST = jump1/100; GGAP = 1 - ELITIST;
        %NIND = jump1;
        %PR_CROSS = jump1/100; 
        %PR_MUT = jump1/100;

        listRuns = zeros(amountOfRuns, MAXGEN);
        listRunsBest = zeros(amountOfRuns, MAXGEN);
        listtime = zeros(amountOfRuns,1);
        for run = 1 : amountOfRuns    

            %perform genetic algorithm: return best,mean and set time it
            %takes to perform algorithm
            t = cputime;
            [fit,min,best] = run_ga_custom_wlm(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP,'sus');
            listtime(run,1) = cputime-t;

            sparsemean = sparse(fit);
            sizesparse = nnz(sparsemean);

            sparsebest = sparse(best);
            sizesbest = nnz(sparsebest);

            for iszero = 1 : MAXGEN
                if sparsemean(iszero) == 0
                    sparsemean(iszero) = sparsemean(iszero-1);
                end
                if sparsebest(iszero) == 0
                    sparsebest(iszero) = sparsebest(iszero-1);
                end
            end

            listRuns(run,:) = sparsemean(1:MAXGEN);
            listRunsBest(run,:) = sparsebest(1:MAXGEN);
        end
        time = mean(listtime);
        sparsemean = mean(listRuns);   

        distbest = 1000;
        ibest = 1;
        for i = 1 : amountOfRuns
           if(listRunsBest(i,end) < distbest)
               distbest = listRunsBest(i,end);
               ibest = i;
           end
        end
        sparsebest = listRunsBest(ibest,:);
        
        fitnesslist(ii,jj) = distbest;
        timinglist(ii,jj) = time(end);
        jj = jj + 1;
        %subplot(1,2,1);
        plot([1:1:sizesbest],sparsebest(1:sizesbest),'DisplayName',"Elitism: " + num2str(ELITIST));
        xlabel("Generation");
        ylabel("Best fitness value");
        title("Population: " + NIND);
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
timinglist
fitnesslist


