function [E] = e1(F)
% Calculate the efficiency as the maximum value of Ft.
    % Number of generations T.
    [~,T] = size(F);
    % Allocate memory for E(T).
    E = zeros(1,T);
    % Assign the max of value F(1,1:t) to E(1,t).
    E(1,1) = F(1,1);
    for t = 2:T
        % For an optimal effciency: compare the previous max value with 
        % the next element of F.
        E(1,t) = max([E(1,t-1),F(1,t)]);
    end
end

