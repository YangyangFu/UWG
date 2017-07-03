function pop = calcCrowdingDistance(opt, pop, front)
% Function: pop = calcCrowdingDistance(opt, pop, front)
% Description: Calculate the 'crowding distance' used in the original NSGA-II.
% Syntax:
% Parameters: 
% Return: 
%
%    Author: Yangyang Fu
%    Date: 07/03/2017
%*************************************************************************

numObj = length( pop(1).obj );  % number of objectives
for fid = 1:length(front)
    idx = front(fid).f;
    frontPop = pop(idx);        % frontPop : individuals in front fid
    
    numInd = length(idx);       % nInd : number of individuals in current front
    
    obj = vertcat(frontPop.obj);
    obj = [obj, idx'];          % objctive values are sorted with individual ID
    for m = 1:numObj
        obj = sortrows(obj, m);

        colIdx = numObj+1;
        pop( obj(1, colIdx) ).distance = Inf;         % the first one
        pop( obj(numInd, colIdx) ).distance = Inf;    % the last one
        
        minobj = obj(1, m);         % the maximum of objective m
        maxobj = obj(numInd, m);    % the minimum of objective m
        
        for i = 2:(numInd-1)
            id = obj(i, colIdx);
            pop(id).distance = pop(id).distance + (obj(i+1, m) - obj(i-1, m)) / (maxobj - minobj);
        end
    end
end

