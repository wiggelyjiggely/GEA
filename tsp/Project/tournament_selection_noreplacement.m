function Selch = tournament_selection_noreplacement(chrom,fitv,lambda,k)
    [mu,chromsize] = size(chrom);
    Selch = zeros(lambda,chromsize);
    for v=1:lambda;
        Tournament = zeros(k,chromsize);
        TempFit = zeros(1,mu);
        Indexes =zeros(1,mu);
        Randx = randperm(lambda);
        Rand = Randx(1:k);
        for c=1:k;
            Tournament(c,:) = chrom(Rand(c),:);
            TempFit(c) = fitv(Rand(c));
            Indexes(c) = Rand(c);
        end
        Ind = find(max(TempFit) == TempFit);
        Selch(v,:) =  Tournament(Ind,:);
        chrom(Indexes(Ind),:) = [];
        mu = mu-1;
        if (mu < lambda) lambda = lambda - 1;
    end
end