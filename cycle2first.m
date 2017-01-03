% low level function for TSP path rewrite
% uses path representation only; 
% moves node 1 to first node in tour 
function NewPath = cycle2first(OldPath);

NewPath = zeros(size(OldPath));
len=size(OldPath,2);

% find index of node 1 in tour
idx=find(OldPath == 1,1);
if idx == 1
    % do nothing if node 1 is first in tour
    NewPath = OldPath;
else
    % copy all nodes from 1 to end of tour to start of tour
    NewPath(1:len-idx+1) = OldPath(idx:len);
    % copy preceding nodes to tail of tour
    NewPath(len-idx+2:len) = OldPath(1:idx-1);
end

% End of function