% low level function for TSP mutation
% reciprocal exchange : two random cities in a tour are swapped
% Representation is an integer specifying which encoding is used
%	1 : adjacency representation
%	2 : path representation
%   3 : ordinal representation

function NewChrom = inversion2(OldChrom,Representation);

NewChrom=OldChrom;

% turn tour representation into path
NewChrom=rep2path(NewChrom, Representation);

% select two positions in the tour
rndi = randperm(size(NewChrom, 2));
rndi = sort(rndi(1:2));
fragment = fliplr(NewChrom(rndi(1:2)));

NewChrom(rndi(1:2)) = fragment;


NewChrom = path2rep(NewChrom, Representation);

% End of function
