function [E] = evaluation(F)
%Calculate the eficiency as the ratio of the solution quality to the 
% delivered computational effort.

    % Number of generations T.
    [~,T] = size(F);
    % Allocate memory for E(T).
    E = zeros(4,T);

    for t = 1:T-1
        E(1,t+1) = F(1,t) - F(1,t+1);
        E(2,t+1) = (F(1,t) - F(1,t+1)) / log(t+1);
        E(3,t+1) = (F(1,t) - F(1,t+1)) / sqrt(t+1);
        E(4,t+1) = (F(1,t) - F(1,t+1)) / (t+1);
    end
end

