function Selch = cust_tournament_selection_stochastic(chrom,fitv,lambda,k,p)
    %[fit,sortIdx] = sort(fit,'descend');
    %chrom = chrom(sortIdx,:);
    [mu,chromsize] = size(chrom);
    Selch = zeros(lambda,chromsize);
    for v=1:lambda;
        Tournament = zeros(k,chromsize);
        TempFit = zeros(1,k);
        Randx = randperm(lambda);
        Randy = Randx(1:k);
        for c=1:k;
            Tournament(c,:) = chrom(Randy(c),:);
            TempFit(c) = fitv(Randy(c));
        end
        
        [TempFit,sortIdx] = sort(TempFit,'descend');
        Tournament = Tournament(sortIdx,:);
        
        for rc = 1:k
            if rc == 0 
                propab = p;
            else
                probab = p*((1-p)^(rc-1));
            end
            if rand() < probab
                Selch(v,:) =  Tournament(rc,:);
                break;
            end
        end         
    end
    %TODO remove tempfit list 
    
end

