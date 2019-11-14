
function NewChrom = ex3_Ordered_crossover(OldChrom)
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


DiffVals1 = randomize(setdiff([1:1:GenSize],MidPart1))
DiffVals2 = randomize(setdiff([1:1:GenSize],MidPart2))

%Set the rest
for index = 1:GenSize;
    if NewChrom(1,index) == 0 
        NewChrom(1,index) = DiffVals1(1,1);
        NewChrom(2,index) = DiffVals2(1,1);
        DiffVals1 = DiffVals1(2:end);
        DiffVals2 = DiffVals2(2:end);
    end
end
NewChrom
end

