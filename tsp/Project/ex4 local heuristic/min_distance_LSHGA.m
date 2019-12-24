function [distance] = min_distance_LSHGA(S,ChromWithoutS)
% MIN_DISTANCE_LSHGA return the LSHGA-distance between tour S and the set T
% of tours that is minimal

    % Size
    [Ninv,Nvar] = size(ChromWithoutS);
    
    distance = Nvar;
    
    for i = 1:Ninv
        iDistance = Nvar;
        chromosome = ChromWithoutS(i,:);
        for j = 1 : Nvar-1
            s1 = find(chromosome==S(1,j));
            s2 = find(chromosome==S(1,j+1));
            if abs(s1-s2) == 1
                iDistance = iDistance - 1;
            elseif abs(s1-s2) == Nvar - 1
                iDistance = iDistance - 1;
            end
        end
        s1 = find(chromosome==S(1,1));
        s2 = find(chromosome==S(1,Nvar));
        if abs(s1-s2) == 1
            iDistance = iDistance - 1;
        elseif abs(s1-s2) == Nvar - 1
            iDistance = iDistance - 1;
        end
        if iDistance < distance
            distance = iDistance;
        end
    end
end

