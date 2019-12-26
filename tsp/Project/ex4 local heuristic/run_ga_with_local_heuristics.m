function [mean_fits,minimum,best] = run_ga_with_local_heuristics(x, y, NIND, MAXGEN, NVAR, Kc, Km, Ke)
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
    
    % Generation
    gen=1;
        
    % Best fitness value of all generations.
    best=zeros(1,MAXGEN);
    % Mean fitness values of all generations.
    mean_fits = zeros(1,MAXGEN);
    % Worst fitness value of all generations.
    worst = zeros(1,MAXGEN);
    
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
    while gen<MAXGEN+1
        
        % Generation statistics
        best(gen)=min(ObjV); % The best chromosome 
        mean_fits(gen)=mean(ObjV); % Mean fitness value
        worst(gen)=max(ObjV); % Worst fitness value
        fmax = fitness_LSHGA(best(gen),NVAR);
        fmean = fitness_LSHGA(mean_fits(gen),NVAR);
        
        % Louche shit in hun code
        minimum=best(gen);
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
            if fitness_LSHGA(ObjV(i),NVAR) < fmean % f < f_gem
                Pc = Kc;
            else %f > f_gem
                Pc = Kc * (fmax-fitness_LSHGA(ObjV(i),NVAR))/(fmax-fmean);
            end
            
            if rand() < Pc % Do crossover
                [Child,ChildDistance] = crossover_LSHGA(Dist,Chrom(i,:),ObjV(i,1));
                
                % If after crossover a better solution is not found,
                if ChildDistance == ObjV(i,1)
                    % Chrom without Chrom(i,:)
                    RestChrom = Chrom;
                    RestChrom(i,:) = [];
                    % Mutation rate Pm
                    Pm = Km * min_distance_LSHGA(Chrom(i,:),RestChrom) / (NVAR);
                    
                    if rand() < Pm
                        % Mutate the parent with mutation rate Pm
                        [MutatedParent,MutatedDistance] = mutation_LSHGA(Dist,Chrom(i,:),ObjV(i,1));
                        % Add parent to the Parents pool
                        Parents(i,:) = Chrom(i,:);
                        ParentsObjV(i,1) = ObjV(i,1);
                        % Add a child to the Children pool
                        Children(i,:) = MutatedParent;
                        ChildrenObjV(i,1) = MutatedDistance;
                    else
                        Parents(i,:) = randperm(NVAR);
                        ParentsObjV(i,1) = tspfun2(Parents(i,:),Dist);
                        Children(i,:) = Chrom(i,:);
                        ChildrenObjV(i,1) = ObjV(i,1);
                    end
                else
                    % Add parent to the Parents pool
                    Parents(i,:) = Chrom(i,:);
                    ParentsObjV(i,1) = ObjV(i,1);
                    % Add a child to the Children pool
                    Children(i,:) = Child;
                    ChildrenObjV(i,1) = ChildDistance;
                end
            else % Don't do crossover
                % Add parent to the Parents pool
                % Parents(i,:) = Chrom(i,:);
                % ParentsObjV(i,1) = ObjV(i,1);
                % Add a random new child to the Children pool
                % Children(i,:) = randperm(NVAR);
                % ChildrenObjV(i,1) = tspfun2(Children(i,:),Dist);
                Parents(i,:) = randperm(NVAR);
                ParentsObjV(i,1) = tspfun2(Parents(i,:),Dist);
                Children(i,:) = Chrom(i,:);
                ChildrenObjV(i,1) = ObjV(i,1);
            end
        end
        
        % The reservation rate Pe
        SquaredMean = mean(fitness_LSHGA(ObjV,NVAR).^2);     
        Pe = Ke * (SquaredMean - (fmean^2)) / ((fmax^2) - (fmean^2));
       
        % Select parents
        AmountOfParantsToSelect = ceil(Pe * NIND);
        [SelectedParents,SelectedParentsObjV] = binary_tournament_selection_LSHGA(Parents,ParentsObjV,AmountOfParantsToSelect);
        %ind = sus(ParentsObjV,AmountOfParantsToSelect);
        %SelectedParents(:,:) = Parents(ind,:);
        %SelectedParentsObjV = ParentsObjV(ind);
        
        % Select children
        AmountOfChildrenToSelect = NIND - AmountOfParantsToSelect;
        [SelectedChildren,SelectedChildrenObjV] = binary_tournament_selection_LSHGA(Children,ChildrenObjV,AmountOfChildrenToSelect);
        %ind = sus(ChildrenObjV,AmountOfChildrenToSelect);
        %SelectedChildren(:,:) = Children(ind,:);
        %SelectedChildrenObjV = ChildrenObjV(ind);
        
        % Create the new population
        Chrom = [SelectedParents;SelectedChildren];
        ObjV = [SelectedParentsObjV;SelectedChildrenObjV];
        % Increment generation counter
        gen=gen+1          
    end
end

