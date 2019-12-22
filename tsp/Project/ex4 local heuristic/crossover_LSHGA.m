function [Child,Distance] = crossover_LSHGA(Dist,Parent,Distance)
%CROSSOVER_LSHGA is the crossover operator that is described in
%[Zhang,Tong]. 
%   Parent: the path representation of the single parent selected for
%   crossover.
%   Child: the path representation of the single child that is produced by
%   applying the crossover operator.
%   Dist: the matrix that represent the distance between the cities.
    
    %% Step 0: preperations 
    [~,cities] = size(Parent);% Number of cities to visist
    
    %% STEP 1: choose a random city to visist first in the cycle
    % The random city to put first in the path.
    i = randi(cities);
    % Switch the order of the cities such that the i-th city appears first 
    % in the path. 
    ParentX = [Parent(1,i+1:cities),Parent(1,1:i)]; 
    % j is the last city in the path.
    
    for n = 1: cities
        %% STEP 2: Search the city that is the closest to the last city
        % The distance between the city that is the closest to j.
        shortest2j = Dist(2,cities);
        % The index of the city that is the closest to j
        s2ji = 2;
        % determine the closest city to j and the distance to j
        for i = 3:cities-1
            if Dist(i,cities) < shortest2j
                shortest2j = Dist(i,cities);
            end
        end

        %% STEP3: Rearange the tour
        Child = [ParentX(1,1:s2ji-1), ParentX(1,s2ji+1,cities),ParentX(1,s2ji)];

        %% STEP4: Evaluation step
        DeltaDistance = Dist(1,s2ji)+Dist(s2ji-1,s2ji+1)+Dist(s2ji,cities)-Dist(1,cities)-Dist(s2ji-1,s2ji)-Dist(s2ji,s2ji+1);
        if DeltaDistance < 0
            Distance = Distance + DeltaDistance;
            return; 
        end
        
        %% STEP5: Repeat until child is found or cities are exhausted
        ParentX = [ParentX(1,cities),ParentX(1,1:cities-1)];
        
    end
    Child = Parent;
end

