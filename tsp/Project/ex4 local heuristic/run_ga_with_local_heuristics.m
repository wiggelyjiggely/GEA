function [mean_fits,minimum,best] = run_ga_with_local_heuristics(x, y, NIND, MAXGEN, NVAR, ELITIST, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER, 
%               ah1, ah2, ah3)
%
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
    
    % Generation gap 
    GGAP = 1 - ELITIST;
    % Generation
    gen=0;
    % number of individuals of equal fitness needed to stop
    stopN=ceil(STOP_PERCENTAGE_INDIVIDUALS*NIND);
    
    % Best fitness value of all generations.
    best=zeros(1,MAXGEN);
    % Mean fitness values of all generations.
    mean_fits = zeros(1,MAXGEN+1);
    % Worst fitness value of all generations.
    worst = zeros(1,MAXGEN+1);
    
    % Distance between cities
    Dist = zeros(NVAR,NVAR);
    for i=1:size(x,1)
        for j=1:size(y,1)
            Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        end
    end
    
    % Initialize population
    Chrom=zeros(NIND,NVAR);
    for row=1:NIND
        Chrom(row,:)=randperm(NVAR);            % Path representation is used
        %Chrom(row,:)=path2adj(randperm(NVAR));  % Adjacency representation
    end
    % Evaluate initial population
    ObjV = tspfun2(Chrom,Dist);    
        
    % Generational loop
    while gen<MAXGEN
        
        % Generation statistics
        best(gen+1)=min(ObjV); % The best chromosome 
        mean_fits(gen+1)=mean(ObjV); % Mean fitness value
        worst(gen+1)=max(ObjV); % Worst fitness value
        
        % Louche shit in hun code
        minimum=best(gen+1);
        for t=1:size(ObjV,1)
            if (ObjV(t)==minimum)
                break;
            end
        end
            
        %visualizeTSP(x,y,adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
            
           
        %select individuals for breeding
        
            SelCh=select('sus', Chrom, FitnV, GGAP);
            %recombine individuals (crossover)
            SelCh = recombin(CROSSOVER,SelCh,PR_CROSS);
            SelCh=mutateTSP('inversion',SelCh,PR_MUT);
            %evaluate offspring, call objective function
            ObjVSel = tspfun(SelCh,Dist);
            %reinsert offspring into population
            [Chrom ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
            Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOCALLOOP,Dist);
    
        %increment generation counter
        gen=gen+1;            
    end
end

