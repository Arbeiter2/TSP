function [gen, minimum] = run_ga(x, y, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, MUTATION_OP, CROSSOVER, LOCALLOOP, ah1, ah2, ah3, SEL_F, PATH_REP, datafile)
% usage: run_ga(x, y, 
%               NIND, MAXGEN, NVAR, 
%               ELITIST, STOP_PERCENTAGE, 
%               PR_CROSS, PR_MUT, CROSSOVER, 
%               ah1, ah2, ah3)
%
%
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% MUTATION_OP: mutation operator
% CROSSOVER: the crossover operator
% calculate distance matrix between each pair of cities
% ah1, ah2, ah3: axes handles to visualise tsp
% SEL_F: selection function 'rws'=roulette wheel, 'sus'=stochastic uniform
% PATH_REP: integer specifying which encoding is used
%	1 : adjacency representation
%	2 : path representation
%   3 : ordinal representation


        GGAP = 1 - ELITIST;
        mean_fits=zeros(1,MAXGEN+1);
        worst=zeros(1,MAXGEN+1);
        Dist=zeros(NVAR,NVAR);
        for i=1:size(x,1)
            for j=1:size(y,1)
                Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
            end
        end
        % initialize population
        Chrom=zeros(NIND,NVAR);
        Paths=zeros(NIND,NVAR);
        for row=1:NIND
            Paths(row,:)=randperm(NVAR);
        	Chrom(row,:)=path2rep(Paths(row,:), PATH_REP);
        end
        gen=0;
        % number of individuals of equal fitness needed to stop
        stopN=ceil(STOP_PERCENTAGE*NIND);
        % evaluate initial population
        ObjV = tspfun(Chrom,Dist,PATH_REP);
        best=zeros(1,MAXGEN);
        bestPathIndex = 0;
        objRange = 0;
        old_mean = 0;
        % generational loop
        while gen<MAXGEN
            sObjV=sort(ObjV);
          	best(gen+1)=min(ObjV);
        	minimum=best(gen+1);
            mean_fits(gen+1)=mean(ObjV);

            if gen > 0 && abs(old_mean - mean_fits(gen+1)) < 1e-5
                break;
            end
            
            worst(gen+1)=max(ObjV);
            for t=1:size(ObjV,1)
                if (ObjV(t)==minimum)
                    bestPathIndex = t;
                    break;
                end
            end
            
            visualizeTSP(x,y,Paths(t,:), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);

            objRange = sObjV(stopN)-sObjV(1);
            if (objRange <= 1e-15)
                  break;
            end          
            old_mean = mean_fits(gen+1);
            %assign fitness values to entire population
        	FitnV=ranking(ObjV);
        	%select individuals for breeding
        	SelCh=select(SEL_F, Chrom, FitnV, GGAP);
            
        	%recombine individuals (crossover)
            SelCh = recombin(CROSSOVER,SelCh,PR_CROSS, 1, Dist);

            % mutate part of selected population
            SelCh=mutateTSP(MUTATION_OP, SelCh,PR_MUT, PATH_REP);
            
            %evaluate offspring, call objective function
        	ObjVSel = tspfun(SelCh,Dist,PATH_REP);
            %reinsert offspring into population
        	[Chrom ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
            
            Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOCALLOOP,Dist, PATH_REP);
            Paths = rep2path(Chrom, PATH_REP);
        	%increment generation counter
        	gen=gen+1;            
        end
        %Chrom(bestPathIndex, :)
        %Paths(bestPathIndex, :)
        {datafile NIND MAXGEN NVAR ELITIST STOP_PERCENTAGE PR_CROSS PR_MUT LOCALLOOP CROSSOVER PATH_REP minimum gen MUTATION_OP SEL_F}
end
