% This function performs selection tournament.
%
% Syntax:  NewChrIx = sus(FitnV, Nsel)
%
% Input parameters:
%    FitnV     - Column vector containing the fitness values of the
%                individuals in the population.
%    Nsel      - number of individuals to be selected
%
% Output parameters:
%    NewChrIx  - column vector containing the indexes of the selected
%                individuals relative to the original population, shuffled.
%                The new population, ready for mating, can be obtained
%                by calculating OldChrom(NewChrIx,:).

% Author:     Hartmut Pohlheim (Carlos Fonseca)
% History:    12.12.93     file created
%             22.02.94     clean up, comments


function NewChrIx = tournament(FitnV,Nsel);
% tournament size
    k = 2;
% Identify the population size (Nind)
   [Nind,anss] = size(FitnV);
    NewChrIx = zeros(Nind,anss);
    listInd = [1:1:Nind];
% Perform tournament selection
    for i = 1 : Nsel
        TempFit = zeros(1,k);
        Indexes = zeros(1,k);
        Randx = listInd(randperm(length(listInd)));
        Rand = Randx(1:k);
        for c=1:k;
            TempFit(c) = FitnV(Rand(1,c));
            Indexes(c) = Rand(1,c);
        end
        Ind = find(max(TempFit) == TempFit);
        NewChrIx(i) = Indexes(Ind);    
        
        listInd(listInd == Indexes(Ind)) = [];
        Nind = Nind-1;
        if (Nind < k) k = k - 1; end
    end
    
% Shuffle new population
   [ans, shuf] = sort(rand(Nsel, 1));
   NewChrIx = NewChrIx(shuf);


% End of function
