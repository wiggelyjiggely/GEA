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
            % Crossoverrate Pc
            if ObjV(f) < mean_fits(1,gen+1) %f<f_gem
                Pc = Kc;    
            else %f > f_gem
                Pc = Kc * (best(1,gen+1)-ObjV(i))/(best(1,gen+1)-mean_fits(1,gen+1));
            end
            
            if rand() < Pc % Do crossover
                [Child,ChildDistance] = crossover_LSHGA(Dist,Chrom(i,:),Objv(i,1));
                
                % If after crossover a better solution is not found,
                if ChildDistance == Objv(i,1)
                    % Chrom without Chrom(i,:)
                    RestChrom = Chrom;
                    RestChrom(i,:) = [];
                    % Mutation rate Pm
                    Pm = Km * min_distance_LSHGA(Chrom(i,:),RestChrom) / (2 * NVAR);
                    
                    if rand() < Pm
                    % Mutate the parent with mutation rate Pm
                    [MutatedParent,MutatedDistance] = mutation_LSHGA(Dist,Chrom(i,:),Objv(i,1));
                    % Add parent to the Parents pool
                    Parents(i,:) = Chrom(i,:);
                    ParentsObjV(i,1) = Objv(i,1);
                    % Add a child to the Children pool
                    Children(i,:) = MutatedParent;
                    ChildrenObjV(i,1) = MutatedDistance;
                    end
                else
                    % Add parent to the Parents pool
                    Parents(i,:) = Chrom(i,:);
                    ParentsObjV(i,1) = Objv(i,1);
                    % Add a child to the Children pool
                    Children(i,:) = Child;
                    ChildrenObjV(i,1) = ChildDistance;
                end
            else % Don't do crossover
                % Add parent to the Parents pool
                Parents(i,:) = Chrom(i,:);
                ParentsObjV(i,1) = Objv(i,1);
                % Add a random new child to the Children pool
                Children(i,:) = randperm(NVAR);
                ChildrenObjV(i,1) = tspfun2(Children(i,:),Dist);
            end
        end
        
        % The reservation rate Pe
        SquaredMean = mean(ObjV.^2);
        Pe = Ke * (SquaredMean-mean_fits(1,gen+1)^2) / (best(1,gen+1)^2-mean_fits(1,gen+1)^2);
       
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

