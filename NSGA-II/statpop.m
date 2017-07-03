function state = statpop(pop, state)
% Function: state = statpop(pop, state)
% Description: Statistic Population.
%
%    Author: Yangyang Fu
%    Date: 07/03/2017
%*************************************************************************


N = length(pop);
rankVec = vertcat(pop.rank);
rankVec = sort(rankVec);

state.frontCount = rankVec(N);
state.firstFrontCount = length( find(rankVec==1) );



