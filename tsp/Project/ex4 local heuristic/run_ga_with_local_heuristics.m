function [mean_fits,minimum,best] = run_ga_with_local_heuristics(x, y, NIND, MAXGEN, NVAR, Kc, Km, Ke, ah1, ah2, ah3)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER, 
%               ah1, ah2, ah3)
%
% x, y: coordinates of the cities
% NIND: number of individuals
% NVAR: number of cities
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
    
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
                    
        % Create the selection pool
        Parents = zeros(NIND,NVAR);
        ParentsObjV = zeros(NIND,1);
        Children = zeros(NIND,NVAR);
        ChildrenObjV = zeros(NIND,1);
        
        % For each chromosome in the population 
        for i = 1 : NIND
            % Do crossover with rate Pc:
            %   Pc = Kc * (f_max−f_chrom)/(f_max−f_gem)    f>f_gem
            %   Pc = Kc                                    f<f_gem 
            
            % If after crossover a better solution is not found,
            % mutate the parent with mutation rate Pm:
            %   Pm = 0.5 * min(distance_LSHGA) / 2N
            
            % Iff not mutated: add parent and child to selesction pool.
            % Else: Add mutation and random new chromosome to pool.
            
        end
        
        % The reservation rate Pe
        SquaredMean = mean(ObjV.^2);
        Pe = Ke * (SquaredMean-mean_fits(gen+1)^2) / (best(gen+1)^2-mean_fits(gen+1)^2);
       
        % Select parents
        AmountOfParantsToSelect = Pe * NVAR;
        [SelectedParents,SelectedParentsObjV] = binary_tournament_selection_LSHGA(Parents,ParentsObjV,AmountOfParantsToSelect);
        
        % Select children
        AmountOfChildrenToSelect = NVAR - AmountOfParantsToSelect;
        [SelectedChildren,SelectedChildrenObjV] = binary_tournament_selection_LSHGA(Children,ChildrenObjV,AmountOfChildrenToSelect);
        
        % Create the new population
        Chrom = [SelectedParents;SelectedChildren];
        ObjV = [SelectedParentsObjV;SelectedChildrenObjV];
        
        % Increment generation counter
        gen=gen+1;            
    end
end

