function [E] = efficiency(F)
%Calculate the eficiency as the ratio of the solution quality to the 
% delivered computational effort.

    % Number of generations T.
    [~,T] = size(F);
    % Allocate memory for E(T).
    E = zeros(4,T);

    new = F(1,1);
    for t = 1:T-1
        old = new;
        if F(1,t+1) < new
            new = F(1,t+1);
        end
        E(1,t+1) = (old - new) / old;
        E(2,t+1) = (old - new) / old / log(t+1);
        E(3,t+1) = (old - new) / old / (t+1);
        E(4,t+1) = (old - new) / old / (t+1)^2;
    end
end

