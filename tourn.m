% tournament selection

function ChrIx = tourn(Fitness, Count, KVal);

len = size(Fitness, 1);
if nargin < 3 || isnan(KVal)
    KVal = max(ceil(sqrt(len)), 2);
end
ChrIx = zeros(Count, 1);

for i=1:Count
    p = randperm(len, KVal);
    [Min, Ix] = min(Fitness(p, :));
    ChrIx(i) = p(Ix);
end
% End of function
