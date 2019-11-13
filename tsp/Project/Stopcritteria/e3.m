function [E] = e3(F)
% Calculate the efficiency as the ratio of the solution quality to the 
% delivered computational effort.
    % Number of generations T.
    [~,T] = size(F);
    % Allocate memory for E(T).
    E = zeros(1,T);
    % Assign the ratio max(F(1,1:t)/t to E(1,t).
    E(1,1) = F(1,1);
    for t = 2:T
        % For an optimal effciency: compare the previous max value with 
        % the next element of F.
        E(1,t) = max([E(1,t-1),F(1,t)]) / t;
    end
end

