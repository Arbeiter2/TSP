%
% ObjVal = tsp_path_fun(Phen, Dist)
% Implementation of the TSP fitness function
%	Phen contains the phenocode of the matrix coded in path
%	representation
%	Dist is the matrix with precalculated distances between each pair of cities
%   ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
%

function ObjVal = tsp_path_fun(Phen, Dist);
	ObjVal=zeros(size(Phen,1),1);
	for row=1:size(Phen,1)
        for col=2:size(Phen,2)
        	ObjVal(row)=ObjVal(row) + Dist(Phen(row,col-1), Phen(row,col));
        end
    end
% End of function

