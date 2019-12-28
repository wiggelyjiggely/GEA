function [mean_fits,best] = lsgha_ours(x, y, NIND, MAXGEN, NVAR, Kc, Pm, Ke)
%LSGHA_OURS Summary of this function goes here
%   Detailed explanation goes here
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
    Opt = false(NIND,1);
    for row=1:NIND
        Chrom(row,:)=randperm(NVAR);            % Path representation is used
        %Chrom(row,:)=path2adj(randperm(NVAR));  % Adjacency representation
    end
    % Evaluate initial population
    ObjV = tspfun2(Chrom,Dist);  
    
    bly = 0;
    
    % Generational loop
    while gen<MAXGEN+1
        
        % Generation statistics
        best(gen)=min(ObjV); % The best chromosome 
        mean_fits(gen)=mean(ObjV); % Mean fitness value
        worst(gen)=max(ObjV); % Worst fitness value
        fmax = fitness_LSHGA(best(gen),NVAR);
        fmean = fitness_LSHGA(mean_fits(gen),NVAR);
        prog = round((gen/MAXGEN)*100);
        msg = [int2str(prog)  repmat('-',1,prog) repmat('_',1,100-prog) num2str(best(gen))];
        fprintf(repmat('\b',1,bly));
        fprintf(msg);
        bly=numel(msg);
        
        % Louche shit in hun code
        minimum=best(gen);
        for t=1:size(ObjV,1)
            if (ObjV(t)==minimum)
                break;
            end
        end
                    
        % Create the selection pool
        Parents = zeros(NIND,NVAR);
        ParentsOpt = false(NIND,1);
        ParentsObjV = zeros(NIND,1);
        Children = zeros(NIND,NVAR);
        ChildrenOpt = false(NIND,1);
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
                if Opt(i,1) == false
                    [Child,ChildDistance] = crossover_LSHGA(Dist,Chrom(i,:),ObjV(i,1));
                else 
                    ChildDistance = ObjV(i,1);
                end
                % If after crossover a better solution is not found,
                if ChildDistance == ObjV(i,1)
                    Opt(i,1) = true;
                    if rand() < Pm
                        % Mutate the parent with mutation rate Pm
                        [MutatedParent,MutatedDistance] = mutation_LSHGA(Dist,Chrom(i,:),ObjV(i,1));
                        % Add parent to the Parents pool
                        Parents(i,:) = Chrom(i,:);
                        ParentsOpt(i,1) = Opt(i,1);
                        ParentsObjV(i,1) = ObjV(i,1);
                        % Add a child to the Children pool
                        Children(i,:) = MutatedParent;
                        ChildrenOpt(i,1) = false;
                        ChildrenObjV(i,1) = MutatedDistance;
                    else
                        Parents(i,:) = randperm(NVAR);
                        ParentsOpt(i,1) = false;
                        ParentsObjV(i,1) = tspfun2(Parents(i,:),Dist);
                        Children(i,:) = Chrom(i,:);
                        ChildrenOpt(i,1) = Opt(i,1);
                        ChildrenObjV(i,1) = ObjV(i,1);
                    end
                else
                    % Add parent to the Parents pool
                    Parents(i,:) = Chrom(i,:);
                    ParentsOpt(i,1) = Opt(i,1);
                    ParentsObjV(i,1) = ObjV(i,1);
                    % Add a child to the Children pool
                    Children(i,:) = Child;
                    ChildrenOpt(i,1) = false;
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
                ParentsOpt(i,1) = false;
                ParentsObjV(i,1) = tspfun2(Parents(i,:),Dist);
                Children(i,:) = Chrom(i,:);
                ParentsOpt(i,1) = Opt(i,1);
                ChildrenObjV(i,1) = ObjV(i,1);
            end
        end
        
        % The reservation rate Pe
        SquaredMean = mean(fitness_LSHGA(ObjV,NVAR).^2);     
        Pe = Ke * (SquaredMean - (fmean^2)) / ((fmax^2) - (fmean^2));
       
        % Select parents
        AmountOfParantsToSelect = ceil(Pe * NIND);
        [SelectedParents,SelectedParentsOpt,SelectedParentsObjV] = binary_tournament_selection_LSHGA_ours(Parents,ParentsOpt,ParentsObjV,AmountOfParantsToSelect);
        %ind = sus(ParentsObjV,AmountOfParantsToSelect);
        %SelectedParents(:,:) = Parents(ind,:);
        %SelectedParentsObjV = ParentsObjV(ind);
        
        % Select children
        AmountOfChildrenToSelect = NIND - AmountOfParantsToSelect;
        [SelectedChildren,SelectedChildrenOpt,SelectedChildrenObjV] = binary_tournament_selection_LSHGA_ours(Children,ChildrenOpt,ChildrenObjV,AmountOfChildrenToSelect);
        %ind = sus(ChildrenObjV,AmountOfChildrenToSelect);
        %SelectedChildren(:,:) = Children(ind,:);
        %SelectedChildrenObjV = ChildrenObjV(ind);
        
        % Create the new population
        Chrom = [SelectedParents;SelectedChildren];
        Opt = [SelectedParentsOpt;SelectedChildrenOpt];
        ObjV = [SelectedParentsObjV;SelectedChildrenObjV];
        
        % Increment generation counter
        gen=gen+1;
        
    end
end

