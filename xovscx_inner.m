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
% Step 3: Suppose the 'node a' and the 'node b' are found in 1st and 2nd 
% parent respectively, then for selecting the next node go to Step 4.
% 
% Step 4: If cost(p,a)? < cost(p,b), then select 'node a', otherwise, 
% 'node b' as the next node and concatenate it to partially constructed 
% offspring chromosome. If the offspring is a complete chromosome, then 
% stop, otherwise, rename the present node as 'node p' and go to Step 2.
%
% Parent1: parent tour of length n (row vector path representation)
% Parent2: parent tour of length n (row vector path representation)
% Dist: cost matrix
%

function Offspring = xovscx_inner(Parent1, Parent2, Dist)

Offspring = zeros(size(Parent1));
len=size(Parent1,2);

% always start tour representation with node 1
p1 = cycle2first(Parent1);
p2 = cycle2first(Parent2);
Offspring(1) = 1;
p = 1;

% all other nodes unvisited
Visited = zeros(len, 1);
VisitedIndex = 1;
Visited(VisitedIndex) = 1;

for pos=2:len
    % find index of first 'legitimate' node after p in both p1 and p2
    legit1 = find_legit(p1, p, Visited);
    legit2 = find_legit(p2, p, Visited);

    % check whether first unvisited node is same in both
    if p1(legit1) == p2(legit2)
        p = p1(legit1);
        % add p to visited nodes
    elseif Dist(p, p1(legit1)) < Dist(p, p2(legit2))
        % p -> Unvisited1(legit1) is lower cost link
        p = p1(legit1);
    else
        % p -> Unvisited2(legit2) is lower cost link
        p = p2(legit2);
    end
    
    % node p has now been visited
    Visited(p) = 1;
    
    % copy better follow-on node to offspring
    Offspring(pos) = p;
end

% end function