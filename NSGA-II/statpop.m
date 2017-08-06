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

% worst feasible solution when nObj==1
popsize=length(pop);
feas=zeros(popsize);
if length(pop(1).obj) == 1
    for i = 1:popsize
      if pop(i).nViol==0 
      feas(i) = pop(i).obj;
      end
    end
   state.worstFeas = max(feas); 
end
end



