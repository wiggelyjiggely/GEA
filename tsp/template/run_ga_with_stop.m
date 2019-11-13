function [mean_fits,minimum,best] = run_ga_with_stop(x, y, NIND, MAXGEN, NVAR, ELITIST,STOP_PERCENTAGE_INDIVIDUALS, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER, 
%               ah1, ah2, ah3)
%
%
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE_INDIVIDUALS: percentage of equal fitness (stop criterium)
% STOP_GEN_AVERAGE: amount of generations the average fitness does not change
% STOP_PERCENTAGE_AVERAGE: percentage of change for the average fitness
% STOP_GEN_BEST: amount of generations the best fitness does not change
% STOP_PERCENTAGE_BEST: percentage of change for the best fitness
% STOP_PERCENTAGE_RATIO: percentage for the ratio of the average and best
% fitness
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
{NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE_INDIVIDUALS STOP_GEN_AVERAGE STOP_PERCENTAGE_AVERAGE STOP_GEN_BEST STOP_PERCENTAGE_BEST STOP_PERCENTAGE_RATIO PR_CROSS PR_MUT CROSSOVER LOCALLOOP}


        GGAP = 1 - ELITIST;
        mean_fits=zeros(1,MAXGEN+1);
        worst=zeros(1,MAXGEN+1);
        Dist=zeros(NVAR,NVAR);
        for i=1:size(x,1)
            for j=1:size(y,1)
                Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            end
        end
        % initialize population
        Chrom=zeros(NIND,NVAR);
        for row=1:NIND
        	Chrom(row,:)=path2adj(randperm(NVAR));
            %Chrom(row,:)=randperm(NVAR);
        end
        gen=0;
        % number of individuals of equal fitness needed to stop
        stopN=ceil(STOP_PERCENTAGE_INDIVIDUALS*NIND);
        % number of generations in a row that the average fitness didn't changed.
        numbAverage = 0;
        % number of generations in a row that the best fitness didn't changed.
        numbBest = 0;
        % evaluate initial population
        ObjV = tspfun(Chrom,Dist);
        best=zeros(1,MAXGEN);
        % generational loop
        while gen<MAXGEN
            sObjV=sort(ObjV);
          	best(gen+1)=min(ObjV);
        	minimum=best(gen+1);
            mean_fits(gen+1)=mean(ObjV);
            worst(gen+1)=max(ObjV);
            for t=1:size(ObjV,1)
                if (ObjV(t)==minimum)
                    break;
                end
            end
            
            %visualizeTSP(x,y,adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);

            if (sObjV(stopN)-sObjV(1) <= 1e-15)
                  break;
            end 
            
            if (best(gen+1)-mean_fits(gen+1) / best(gen+1) <= STOP_PERCENTAGE_RATIO)
                  break;
            end 
            if (gen > 0)
                if ((best(gen+1)-best(gen) / best(gen+1)) <=  STOP_PERCENTAGE_BEST)
                    numbBest = numbBest + 1;
                    if (numbBest == STOP_GEN_BEST)
                        break;
                    end
                else
                    numbBest = 0;
                end

                if ((mean_fits(gen+1)-mean_fits(gen) / mean_fits(gen+1)) <=  STOP_PERCENTAGE_AVERAGE)
                    numbAverage = numbAverage + 1;
                    if (numbAverage == STOP_GEN_AVERAGE)
                        break;
                    end
                else
                    numbAverage = 0;
                end
            end          
            
        	%assign fitness values to entire population
        	FitnV=ranking(ObjV);
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
