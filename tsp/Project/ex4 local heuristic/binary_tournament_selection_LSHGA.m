function [SelectedPopulation,SelectedObjV] = binary_tournament_selection_LSHGA(Population,ObjV)
% BINARY_TOURNAMENT_SELECTION cuts the population in half by doing a binary
% tournament selection.
%   Population: the population to cut in half with BTS.
%   SelectedPopulation: the population selected with BTS.

    % Size of population and amount of cities.
    [PopSize,Cities] = size(Population);
    SelectedPopSize = PopSize / 2;
    
    % Allocate memory for SelectedPopulation and for SelectedObjV.
    SelectedPopulation = zeros(SelectedPopSize,Cities);
    SelectedObjV = zeros(SelectedPopSize,1);
    
    % Use 2k Tournament selection to reduce the population in half
    for i = 1:SelectedPopSize
        sft = randi(PopSize,1,2);
        if ObjV(sft(1)) < ObjV(sft(2))
            SelectedPopulation(i,:) = Population(sft(1),:);
            SelectedObjV(i,1) = ObjV(sft(1),1);
            Population(sft(1),:) = [];
            ObjV(sft(1)) = [];
        else 
            SelectedPopulation(i,:) = Population(sft(2),:);
            SelectedObjV(i,1) = ObjV(sft(2),1);
            Population(sft(2),:) = [];
            ObjV(sft(2)) = [];
        end
        PopSize = PopSize -1;
    end
end

