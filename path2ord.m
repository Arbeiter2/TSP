%
% path2ord(Path)
% function to convert between path and ordinal representation for TSP
% Path and Ord are row vectors
%

function Ord = path2ord(Path)
	Ord = zeros(size(Path));
	for row=1:size(Path,1)
        Unvisited = 1:size(Path, 2);
        for col=1:size(Path,2)
            Elem = Path(row, col);         % get next element in Path
            %{row col Elem}
            Index = find(Unvisited == Elem, 1); % find position of Elem in unvisited list
            %Unvisited
            %{Index Elem}
            Ord(row, col) = Index;         % add position of Elem to ord
            Unvisited(Index) = [];  % Index has now been visited
        end
    end
% End of function

