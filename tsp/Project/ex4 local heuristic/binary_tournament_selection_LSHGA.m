function [SelectedPopulation,SelectedObjV] = binary_tournament_selection_LSHGA(Population,ObjV,ATS)
% BINARY_TOURNAMENT_SELECTION select ATS individuals in a binary
% (k=2) tournament selection.
%   Population: the population to cut in half with BTS.
%   SelectedPopulation: the population selected with BTS.
%   ATS: the amount of individuals to select.
% Example: binary_tournament_selection_LSHGA([1:20]',[1:20]',8)

    % Size of population and amount of cities.
    [PopSize,Cities] = size(Population);
    
    if PopSize == ATS
        SelectedPopulation = Population;
        SelectedObjV = ObjV;
        return;
    end
    
    % Allocate memory for SelectedPopulation and for SelectedObjV.
    SelectedPopulation = zeros(ATS,Cities);
    SelectedObjV = zeros(ATS,1);
    
    % Use 2k Tournament selection to reduce the population in half
    for i = 1:ATS
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

