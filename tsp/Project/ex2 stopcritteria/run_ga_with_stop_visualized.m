function [mean_fits,minimum,best,stop,stop_values] = run_ga_with_stop_visualized(x, y, NIND, MAXGEN, NVAR, ELITIST,STOP_PERCENTAGE_INDIVIDUALS, STOP_GEN_AVERAGE, STOP_PERCENTAGE_AVERAGE, STOP_GEN_BEST, STOP_PERCENTAGE_BEST, STOP_PERCENTAGE_RATIO, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, ah1, ah2, ah3)
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
% STOP_GEN_AVERAGE: amount of generations the average fitness does not 
% change (stop criterium)
% STOP_PERCENTAGE_AVERAGE: percentage of change for the average fitness
% stop criterium)
% STOP_GEN_BEST: amount of generations the best fitness does not change
% (stop criterium)
% STOP_PERCENTAGE_BEST: percentage of change for the best fitness (stop 
% criterium)
% STOP_PERCENTAGE_RATIO: percentage for the ratio of the average and best
% fitness (stop criterium)
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
        % boolean matrix that represents the stop conditions of the GA
        % meaning Boolean value:
            % True: The algorithm should stop
            % False: The algorithm should not stop
        % meaning rows
            % stop(1,:): no variation in population
            % stop(2,:): no improving best
            % stop(3,:): no improving average
            % stop(4,:): percentage same
        stop = false(4, MAXGEN);
        % matrix that contains the values for the stop criteria
        % meaning rows
            % stop_values(1,:): percentage of population
            % stop_values(2,:): generations best did not change
            % stop_values(3,:): change in best
            % stop_values(4,:): generations average did not change
            % stop_values(5,:): change in average
            % stop_values(6,:): percantage same
        stop_values = zeros(6,MAXGEN);
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
                  stop(1,gen+1) = true;
            end 
            
            %ratio = (mean_fits(gen+1)-best(gen+1)) / best(gen+1);
            %stop_values(6,gen+1) = ratio;
            %if (ratio<= STOP_PERCENTAGE_RATIO)
            %      stop(4,gen+1) = true;
            %end 
            
            stopnumb = NIND * STOP_PERCENTAGE_RATIO;
            for per=2:NIND
                if (sObjV(1)-sObjV(per) ~= 0)
                    if stopnumb < per 
                        stop(4,gen+1) = true;
                    end
                    stop_values(6,gen+1) = per - 1;
                    break;
                end
            end 
            
            if (gen > 0)
                best_percentage = (best(gen)-best(gen+1)) / best(gen+1);
                stop_values(3, gen+1) = best_percentage;
                %if ( best_percentage <=  STOP_PERCENTAGE_BEST)
                if(best(gen) == best(gen+1))
                    numbBest = numbBest + 1;
                    if (numbBest >= STOP_GEN_BEST)
                        stop(2,gen+1) = true;
                    end
                else
                    numbBest = 0;
                end
                stop_values(2, gen+1) = numbBest;
                
                average_percentage = (mean_fits(gen)-mean_fits(gen+1)) / mean_fits(gen+1);
                stop_values(5, gen+1) = average_percentage;
                if ( average_percentage<=  STOP_PERCENTAGE_AVERAGE)
                    numbAverage = numbAverage + 1;
                    if (numbAverage >= STOP_GEN_AVERAGE)
                        stop(3,gen+1) = true;
                    end
                else
                    numbAverage = 0;
                end
                stop_values(4, gen+1) = numbAverage;
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

