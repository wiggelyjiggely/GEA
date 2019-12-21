function ObjVal = tspfun2(Phen, Dist);
    % Changed fitness function to work with path representation
    adjrep = zeros(size(Phen));
    for i = 1 : size(Phen)
        adjrep(i,:) = path2adj(Phen(i,:));
    end
	ObjVal=Dist(Phen(:,1),1);
	for t=2:size(Phen,2)
    	ObjVal=ObjVal+Dist(Phen(:,t),t);
	end