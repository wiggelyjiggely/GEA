
function newpop = tsp_improvePopulationPathrep(popsize, ncities, pop, improve,dists)

if (improve)
   for i=1:popsize
     
     result = improve_path(ncities,pop(i,:),dists);
  
     pop(i,:) = result;

   end
end

newpop = pop;