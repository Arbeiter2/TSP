%
% ord2path(Ord)
% function to convert between ordinal and path representation for TSP
% Ord, Path are row vectosr
%

function Path = ord2path(Ord)

	Path=zeros(size(Ord));
    for row=1:size(Ord,1)
        Unvisited = 1:size(Path, 2);
        for col=1:size(Ord,2)        
            Path(row, col)=Unvisited(Ord(row, col));
            Unvisited(Ord(row, col)) = [];
        end
    end


% End of function

