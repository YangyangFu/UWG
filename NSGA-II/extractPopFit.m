function nextpop = extractPopFit( opt,pop )
%EXTRACTPOPFIT Extract new poppulation by comparing fitness value. Use only
%for single-objective optimization
%   The best several indiviudals are selected for next population
%
%   Author: Yangyang Fu
%   First Implementation: Aug 04, 2017
%   Revisions:
%
%=========================================================================

fitnessValue = vertcat(pop.fitness);

[~,index] = sort(fitnessValue);

nextpop=pop(index(1:opt.popsize));

end

