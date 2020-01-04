NIND=100;		% Number of individuals
MAXGEN=400;		% Maximum no. of generations
NVAR=26;		% No. of variables
PRECI=1;		% Precision of variables
ELITIST=0.1;    % percentage of the elite population
GGAP=1-ELITIST;		% Generation gap
STOP_PERCENTAGE=0.95;    % percentage of equal fitness individuals for stopping
STOP_GEN_AVERAGE = 5; % amount of generations the average fitness does not change
STOP_PERCENTAGE_AVERAGE = 0.01; % percentage of change for the average fitness
STOP_GEN_BEST = 5; % amount of generations the best fitness does not change
STOP_PERCENTAGE_BEST = 0.01; % percentage of change for the best fitness
STOP_PERCENTAGE_RATIO = 0.01; % percentage for the ratio of the average and best
PR_CROSS=0.3;     % probability of crossover
PR_MUT=0.5;       % probability of mutation
LOCALLOOP=1;      % local loop removal
CROSSOVER = 'xalt_edges';  % default crossover operator

datasetslist = dir('../ex5 benchmarks/benchmarks/');
datasets=cell( size(datasetslist,1)-2,1);
for i=1:size(datasets,1)
    datasets{i} = datasetslist(i+2).name;
end

% Data for the bcl380 tour
%bcl380 = load(['../ex5 benchmarks/benchmarks/' datasets{1}]);
%x=bcl380(:,1);%/max([bcl380(:,1);bcl380(:,2)]);
%y=bcl380(:,2);%/max([bcl380(:,1);bcl380(:,2)]);
%NVAR=size(bcl380,1);

% Data for the rbx711 tour
rbx711 = load(['../ex5 benchmarks/benchmarks/' datasets{3}]);
x=rbx711(:,1);%/max([rbx711(:,1);rbx711(:,2)]);
y=rbx711(:,2);%/max([rbx711(:,1);rbx711(:,2)]);
NVAR=size(rbx711,1);

figure;
hold on;
amountOfRuns = 1;
genlist = zeros(5,10);
timinglist = zeros(5,8);
fitnesslist = zeros(5,8);
ii = 1;

%for jump2 = [1]
%for jump2 = [90 80 70 60 50 40 30 20 10]
%for jump2 = [50 100 150]
for jump2 = [10000]
    MAXGEN = jump2;
    %NIND = jump2;
    %PR_CROSS = jump2/100; 
    %PR_MUT = 1-PR_CROSS;
    
    %for jump1= [90 80 70 60 50 40 30 20 10]
    for jump1= [round(NVAR*0.5) NVAR NVAR*2]
     %for jump1= [NVAR]
        %ELITIST = jump1/100; GGAP = 1 - ELITIST;
        NIND = jump1;
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

        jj = 1;
        for c = [500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000 6500 7000 7500 8000 8500 9000 9500 10000]
           	 genlist(ii,jj) = min(1,c);
             fitnesslist(ii,jj) = min(3,c);
             timinglist(ii,jj) = min(2,c);
             jj = jj + 1;
        end      
        
        %subplot(1,2,1);
        plot([1:1:sizesbest],sparsebest(1:sizesbest),'DisplayName',"Population: " + num2str(NIND));
        xlabel("Generation");
        ylabel("Best fitness value");
        legend show;
        hold on;
        %plot([1:1:sizesparse],sparsemean(1:sizesparse),'DisplayName',"Mutation rate: " + num2str(PR_MUT));
        %xlabel("Generation");
        %ylabel("Mean fitness value");
        %title("Population: " + NIND);
        %legend show;
        %hold on;
        ii = ii+1;
    end
    

end
genlist
timinglist
fitnesslist


