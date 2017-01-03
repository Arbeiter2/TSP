% Sequential constructive crossover operator (SCX)
%
% Low-level core function which performs crossover.
%
% After Genetic Algorithm for the Traveling Salesman Problem using
% Sequential Constructive Crossover Operator - Zakir H. Ahmed
%
% Step 1: - Start from 'node 1’ (i.e., current node p =1).
% 
% Step 2: - Sequentially search both of the parent chromosomes and 
% consider the first ‘legitimate node' (the node that is not yet visited) 
% appeared after 'node p’ in each parent. If no 'legitimate node' after 
% 'node p’ is present in any of the parent, search sequentially the nodes 
% {2, 3, …, n} and consider the first 'legitimate' node, and go to Step 3.
% 
% Step 3: Suppose the 'node A' and the 'node ?' are found in 1st and 2nd 
% parent respectively, then for selecting the next node go to Step 4.
% 
% Step 4: If Dist(p, A) < Dist(p, B) then select 'node A', otherwise, 
% 'node B' as the next node and concatenate it to the partially constructed 
% offspring chromosome. If the offspring is a complete chromosome, stop, 
% otherwise, rename the present node as 'node p' and go to Step 2.
%
% Input parameters:
%   ChromSub: chromosome subset in path representation
%   RecOpt: probability of crosszover
%   Dist: matrix of inter-node costs
%

function NewChrom = xovscx(OldChrom, Px, Dist)

% Identify the population size (Nind) and the chromosome length (Lind)
[Nind,Lind] = size(OldChrom);
NewChrom = zeros(size(OldChrom));

if Lind < 2, NewChrom = OldChrom; return; end

Xops = floor(Nind/2);
DoCross = rand(Xops,1) < Px;
odd = 1:2:Nind-1;
even = 2:2:Nind;
top = 1:Xops;
bottom = Xops+1:(2*Xops);

for p=1:Xops
    if DoCross(p)
        % sequential cross produces one offspring, so create two through
        % combination of different parents
        
        % first use even/odd pair
        NewChrom(p,:) = xovscx_inner(OldChrom(odd(p),:), OldChrom(even(p),:), Dist);
        % then use top half/bottom half pair
        NewChrom(Xops + p,:) = xovscx_inner(OldChrom(top(p),:), OldChrom(bottom(p),:), Dist);
    else
        % copy odd and even entries unchanged
        NewChrom(p,:) = OldChrom(odd(p),:);
        NewChrom(Xops + p,:) = OldChrom(even(p),:);
    end
end

% If the number of individuals is odd, the last individual cannot be mated
% but must be included in the new population
if rem(Nind,2),
  NewChrom(Nind,:)=OldChrom(Nind,:);
end
% end function