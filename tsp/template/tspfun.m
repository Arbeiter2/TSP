%
% ObjVal = tspfun(Phen, Dist)
% Implementation of the TSP fitness function
%	Chrom contains the chromosome of the matrix
%	Dist is the matrix with precalculated distances between each pair of cities
%   PATH_REP: integer specifying which encoding is used
%	1 : adjacency representation
%	2 : path representation
%   3 : ordinal representation	
%   ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
%

function ObjVal = tspfun(Phen, Dist, PATH_REP);
    if PATH_REP == 1
        ObjVal=Dist(Phen(:,1),1);
        for t=2:size(Phen,2)
            ObjVal=ObjVal+Dist(Phen(:,t),t);
        end
    elseif PATH_REP == 2
        ObjVal = tsp_path_fun(Phen, Dist);
    elseif PATH_REP == 3
        ObjVal = tsp_path_fun(ord2path(Phen), Dist);
    end


% End of function

