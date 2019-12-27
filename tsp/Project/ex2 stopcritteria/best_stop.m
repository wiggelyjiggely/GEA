function [S] = best_stop(E,U)
% BEST_STOP determines the best generation to stop at, given the efficiency 
% E of each generation and the hyperparameter U.

    % Number of efficiency evaluations N and number of generations T.
    [N,T] = size(E);
    % The number of stops to calculate.
    [~,M] = size(U);
    % Allocate memory for the best Stops.
    S = zeros(N,M);

    for i = 1 : T
        for j = 1 : N
            for k = 1 : M
                if E(j,i) >= U(1,k) 
                    S(j,k) = i; 
                end
            end
        end
    end
end

