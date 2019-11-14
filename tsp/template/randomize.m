function W = randomize(A)
    [~,L] = size(A);
    RandOrder = randperm(L);
    W = zeros(1,L);
    for c=1:L
       W(1,c) = A(1,RandOrder(c)); 
    end
end