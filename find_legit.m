%
% find index of first legitimate node in unvisited list
%
% Used as a helper functin for xovscx_inner
%
% Path: parent tour
% After: node to follow in tour
% Visited: list of visited nodes
%
function Index = find_legit(Path, After, Visited)

len = size(Path,2);

% find index of After in Path
Index = find(Path == After, 1);
Index = Index + 1;
if Index > len
    Index = 1;
end

% check whether node has been visited
while Visited(Path(Index)) == 1
    % increment
    Index = Index + 1;
    if Index > len
        Index = 1;
    end
end

% end function