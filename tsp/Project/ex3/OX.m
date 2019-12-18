function NewChrom = OX(OldChrom)
%EX3_ORDERED_CROSSOVER implements ordered based crossover for the path
%presentation in the tsp.

    [Parents,GenSize]=size(OldChrom);
    NewChrom = zeros(Parents,GenSize); % Allocate memory for the offspring

    RandPerms = randperm(GenSize);
    CrossP1 = RandPerms(1,1); %Random crossover point 1
    CrossP2 = RandPerms(1,2); %Random crossover point 2

    if CrossP1 > CrossP2 
        Temp = CrossP1;
        CrossP1 = CrossP2;
        CrossP2 = Temp;
    end

    MidPart1 = OldChrom(1,CrossP1:CrossP2);
    MidPart2 = OldChrom(2,CrossP1:CrossP2);

    %Set the inner parts
    NewChrom(1,CrossP1:CrossP2) = MidPart1;
    NewChrom(2,CrossP1:CrossP2) = MidPart2;

    tmp = [1:1:GenSize];

    restOf1 = [OldChrom(1,CrossP2+1 : GenSize)  OldChrom(1,1 : CrossP2)];
    restOf2 = [OldChrom(2,CrossP2+1 : GenSize)  OldChrom(2,1 : CrossP2)];
    
    %Set the rest
    for index = CrossP2+1:GenSize;
        if NewChrom(1,index) == 0 
            for ind = 1 : length(restOf2)
                if (~ismember(NewChrom(1,:),restOf2(ind)))
                    NewChrom(1,index) = restOf2(ind); 
                    restOf2 = restOf2(ind:end);
                    break;
                end                                 
            end
        end
    end
    for index = CrossP2+1:GenSize;
        if NewChrom(2,index) == 0 
            for ind = 1 : length(restOf1)
                if (~ismember(NewChrom(2,:),restOf1(ind)))
                    NewChrom(2,index) = restOf1(ind); 
                    restOf1 = restOf1(ind:end);
                    break;
                end                                 
            end
        end
    end
    
    for index = 1:CrossP1;
        if NewChrom(1,index) == 0 
            for ind = 1 : length(restOf2)
                if (~ismember(NewChrom(1,:),restOf2(ind)))
                    NewChrom(1,index) = restOf2(ind); 
                    restOf2 = restOf2(ind:end);
                    break;
                end                                 
            end
        end
    end
    for index = 1:CrossP1;
        if NewChrom(2,index) == 0 
            for ind = 1 : length(restOf1)
                if (~ismember(NewChrom(2,:),restOf1(ind)))
                    NewChrom(2,index) = restOf1(ind); 
                    restOf1 = restOf1(ind:end);
                    break;
                end                                 
            end
        end
    end
end

