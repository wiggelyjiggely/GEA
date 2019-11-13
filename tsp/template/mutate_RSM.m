function NewChrom = mutate_RSM(OldChrom)
    [~,Chromsize] = size(OldChrom);
    Randx = randperm(Chromsize);
    Rand = Randx(1:3);
    B = sort(Rand);
    NewChrom = OldChrom;
    NewChrom(B(2)) = OldChrom(B(1));
    NewChrom(B(3)) = OldChrom(B(2));
    NewChrom(B(1)) = OldChrom(B(3));
end

