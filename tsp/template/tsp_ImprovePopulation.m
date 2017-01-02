% tsp_ImprovePopulation.m
% Author: Mike Matton
% 
% This function improves a tsp population by removing local loops from
% each individual.
%
% Syntax: improvedPopulation = tsp_ImprovePopulation(popsize, ncities, pop, improve, dists, PATH_REP)
%
% Input parameters:
%   popsize           - The population size
%   ncities           - the number of cities
%   pop               - the current population
%   improve           - Improve the population (0 = no improvement, <>0 = improvement)
%   dists             - distance matrix with distances between the cities
%   PATH_REP          - path population representation
%   	1 : adjacency representation
%       2 : path representation
%       3 : ordinal representation%
% Output parameter:
%   improvedPopulation  - the new population after loop removal (if improve
%                          <> 0, else the unchanged population).

function newpop = tsp_ImprovePopulation(popsize, ncities, pop, improve,dists,PATH_REP)

if (improve)
   for i=1:popsize
     
     result = improve_path(ncities, rep2path(pop(i,:), PATH_REP),dists);
  
     pop(i,:) = path2rep(result, PATH_REP);

   end
end

newpop = pop;