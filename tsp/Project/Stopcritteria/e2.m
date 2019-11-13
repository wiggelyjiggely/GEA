function [E] = e2(F)
% Calculate the efficiency as the mean of Ft.
    % Number of generations T.
    [~,T] = size(F);
    % Allocate memory for E(T).
    E = zeros(1,T);
    % Use a variable sum for the sum of f(1,1:t) to reduce the complexity.
    sum = 0;
    % Assign the mean of F(1,1:t) to E(1,t).
    for t = 1 :T
        sum = sum + F(1,t);
        E(1,t) = sum / t;
    end
end

