function Selch = tournament_selection_replacement(chrom,fitv,lambda,k)
    [mu,chromsize] = size(chrom);
    Selch = zeros(lambda,chromsize);
    for v=1:lambda;
        Tournament = zeros(k,chromsize);
        TempFit = zeros(1,mu);
        Randx = randperm(lambda);
        Randy = Randx(1:k);
        for c=1:k;
            I = Randy(c);
            Tournament(c,:) = chrom(Randy(c),:);
            TempFit(c) = fitv(Randy(c));
        end
        Selch(v,:) =  Tournament((find(max(TempFit) == TempFit)),:);   
    end
end

