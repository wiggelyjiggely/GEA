function [Mutation,Distance] = mutation_LSHGA(Dist,Chromosome,Distance)
% Mutate the Chromosome with a MUT3 operator
%   Dist: the matrix that represent the distance between the cities.
%   Chromosome: the chromosome to mutate.
%   Distance: the distance of the tour of the given chromosome. 
%   Mutation: the mutated chromosome.
    
    % The amount of cities in the tour
    [~,cities] = size(Chromosome);
    % Two random points to use the MUT3 operator on
    indices = sort(randi(cities-1,1,2));
    
    % a = Chromosome(1,1:indices(1));
    % b = Chromosome(1,indices(1)+1:indices(2));
    % c = Chromosome(1,indices(2)+1:cities);
    % Mutation = [b,flip(c),a];
    Mutation = [Chromosome(1,indices(1)+1:indices(2)),flip(Chromosome(1,indices(2)+1:cities)),Chromosome(1,1:indices(1))];

    % The difference in distance between the old chromosome and the
    % mutation
    deltaDistance = Dist(Chromosome(indices(2)),Chromosome(cities)) + Dist(Chromosome(indices(2)+1),Chromosome(1)) - Dist(Chromosome(indices(2)),Chromosome(indices(2)+1)) - Dist(Chromosome(cities),Chromosome(1));
    % The distance of the mutation
    Distance = Distance + deltaDistance;
end

