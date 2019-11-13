function NewChrom = crossover_pmx_path_repsentation(OldChrom)
    Parent1 = OldChrom(1,:);
    Parent2 = OldChrom(2,:);
    [~,Chromsize] = size(Parent1);
    CrossPoint = randi(Chromsize);
    NewKid1 = Parent1;
    NewKid2 = Parent2;
    for c=1:CrossPoint;
        Sw1 = Parent1(c);
        Sw2 = Parent2(c);       
        NewKid1 = swap(NewKid1,Sw1,Sw2);       
    end
    for c=1:CrossPoint;
        Sw1 = Parent1(c);
        Sw2 = Parent2(c);       
        NewKid2 = swap(NewKid2,Sw1,Sw2);       
    end
    NewChrom = [NewKid1;NewKid2];
end

