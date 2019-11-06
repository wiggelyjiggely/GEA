function New = swap(Old,A1,A2)
    p1 = find(Old == A1);
    p2 = find(Old == A2);
    New = Old(1,:);
    New(p1) = A2;
    New(p2) = A1;
end

