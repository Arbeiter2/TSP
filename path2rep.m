%
% path2rep(Path, Representation)
% function to convert between path and tour representation for TSP
% Path is a matrix of row vectors
% Representation  - path representation
%   	1 : adjacency representation
%       2 : path representation
%       3 : ordinal representation

function Rep = path2rep(Path, Representation)
    if Representation == 1
        Rep = path2adj(Path);
    elseif Representation == 2
        Rep = Path;
    elseif Representation == 3
        Rep = path2ord(Path);
    end
% End of function

