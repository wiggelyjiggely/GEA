function fitness = fitness_LSHGA(tour,Ncities)
% tour is a nx1 matrix that contains the length of all tours
% Ncities represent the number of cities
% fitness is a nx1 matrix that contains the fitnes evaluation of each tour:
%   f(T) = Ncities /  length(T)

    % Allocate memory for the fitnessvalues
    fitness = zeros(size(tour,1),1);
    % Fitness values for all tours
    for i = 1: size(tour,1)
        fitness(i) = Ncities / tour(i);
    end
end

