function newpop = selectOp(opt, pop)
% Function: newpop = selectOp(opt, pop) 
% Description: Evolutionary strategy selection operator, use binary 
% tournament selection, choosing lamda individuals from miu individuals as parents.
%
% Selection Algorithm: tournament selection with size 2, and the best
% individual goes to mating pool
% 
% Advanced Research: how to determine the best individual especially with
% surrogate model. For single-objective minimization problem, the best
% individual has the smallest objective values; for multi-objective
% minimization problem, the best individual has best parato front ranking;
% for opmization problem with surrogate, new ranking or comparing operator
% should be developed.
%
%    Author: Yangyang Fu
%    Date: 07/03/2017
%*************************************************************************
if opt.surrogate.use==1 % if surrogate is used.
    popsize1=opt.surrogate.miu;% miu individuals will generate lamda individuals in selection operator.
    popsize2 = opt.surrogate.lamda; %lamda offsprings will be generated in the pool.;
else
    popsize1=opt.popsize;
    popsize2=opt.popsize;
end
pool = zeros(1, popsize2);   % pool : the individual index selected

randnum = randi(popsize1, [1, 2 * popsize2]);

j = 1;
for i = 1:2:(2*popsize2)
    p1 = randnum(i);
    p2 = randnum(i+1);
    
    if(~isempty(opt.refPoints))
        % Preference operator (R-NSGA-II)
        result = preferenceComp( pop(p1), pop(p2) );
    else
        % Crowded-comparison operator (NSGA-II)
        result = crowdingComp( pop(p1), pop(p2) );
    end
    
    if(result == 1)
        pool(j) = p1;
    else
        pool(j) = p2;
    end
    
    j = j + 1;
end
newpop = pop( pool );



function result = crowdingComp( guy1, guy2)
% Function: result = crowdingComp( guy1, guy2)
% Description: Crowding comparison operator.
% Return: 
%   1 = guy1 is better than guy2
%   0 = other cases
%
%         LSSSSWC, NWPU
%    Revision: 1.0  Data: 2011-04-20
%*************************************************************************

if((guy1.rank < guy2.rank) || ((guy1.rank == guy2.rank) && (guy1.distance > guy2.distance) ))
    result = 1;
else
    result = 0;
end



function result = preferenceComp(guy1, guy2)
% Function: result = preferenceComp(guy1, guy2)
% Description: Preference operator used in R-NSGA-II
% Return: 
%   1 = guy1 is better than guy2
%   0 = other cases
%
%    Copyright 2011 by LSSSSWC
%    Revision: 1.0  Data: 2011-07-11
%*************************************************************************

if(  (guy1.rank  < guy2.rank) || ...
    ((guy1.rank == guy2.rank) && (guy1.prefDistance < guy2.prefDistance)) )
    result = 1;
else
    result = 0;
end







