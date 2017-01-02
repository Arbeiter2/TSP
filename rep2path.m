%
% rep2path(Tour, Representation)
% function to convert between tour representation and path for TSP
% Tour is a matrix of row vectors
% Representation  - path representation
%   	1 : adjacency representation
%       2 : path representation
%       3 : ordinal representation

function Path = rep2path(Tour, Representation)
    if Representation == 1
        Path = adj2path(Tour);
    elseif Representation == 2
        Path = Tour;
    elseif Representation == 3
        Path = ord2path(Tour);
    end
% End of function

