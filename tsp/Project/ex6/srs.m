% This function performs stochastic remainder selection.
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

function NewChrIx = srs(FitnV,Nsel);
%FitnV
%Nsel
% Identify the population size (Nind)
   [Nind,anss] = size(FitnV);
    NewChrIx = zeros(Nind,anss);
    expcounts = zeros(Nind,1);
    mantexp = zeros(Nind,1);
 
% Perform stochastic remainder selection
    for i = 1 : Nind
        mantexp(i,1) = FitnV(i,1)*Nind/sum(FitnV);
    end
    [mantexp,order] = sort(mantexp);
    cnt = 1;
    for i = 1: Nind
        while (mantexp(i,1) >= 1 && cnt <= Nsel)
            NewChrIx(cnt,1) = order(i);
            cnt = cnt + 1; 
            mantexp(i,1) = mantexp(i,1) - 1;
        end
    end
    mantisses = zeros(Nind,1);
    for i = 1 : Nind
        mantisses(i,1) = mantexp(i,1) - floor(mantexp(i,1));
    end
    r = randi(100);
    while (cnt <= Nsel)
        i = 1;
        while(mantisses(i,1) < r && i < Nind)
            i = i + 1;
        end
        NewChrIx(cnt,1) = order(i);
        cnt = cnt+1;
    end
   
% Shuffle new population
   [ans, shuf] = sort(rand(Nsel, 1));
   NewChrIx = NewChrIx(shuf);


% End of function

