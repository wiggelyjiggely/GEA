function NewChrom = mutate_RSM(OldChrom, Representation)
    %implements the reverse sequence mutation operator
    if Representation==1 
        OldChrom=adj2path(OldChrom);
    end
    
    [~,Chromsize] = size(OldChrom);
    i = randi([1 Chromsize]);
    j = randi([i Chromsize]);
    NewChrom = zeros(1,Chromsize);
    for x = 1:Chromsize
        if ( x >= i && x <= j)
            NewChrom(1,x) = OldChrom(j+(i-x));
        else
            NewChrom(1,x) = OldChrom(x);
        end
    end
    if Representation==1
        NewChrom=path2adj(NewChrom);
    end
end

