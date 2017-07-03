function [pop, state] = evaluate(opt, pop, state)
% Function: [pop, state] = evaluate(opt, pop, state, varargin)
% Description: Evaluate the objective functions of each individual in the
%   population.
%
%    Author: Yangyang Fu
%    Date: 07/03/2017
%*************************************************************************

N = length(pop);
allTime = zeros(N, 1);  % allTime : use to calculate average evaluation times

%*************************************************************************
% Evaluate objective function in parallel
%*************************************************************************

if( strcmpi(opt.useParallel, 'yes') == 1 )
    %curPoolsize = matlabpool('size');
    %matlabpool close
    curPool=gcp('nocreate');
    if isempty(curPool)
        curPoolsize=0;
    else
        curPoolsize =curPool.NumWorkers;
    end
    % There isn't opened worker process
    if(curPoolsize == 0)
        if(opt.poolsize == 0)
            parpool open local
        else
            parpool(opt.poolsize)
        end
    % Close and recreate worker process
    else
        if(opt.poolsize ~= curPoolsize)
            parpool close
            parpool(opt.poolsize)
        end
    end
    
    % add attached objective files to the pool
    p=gcp;
    objectivefun=func2str(opt.objfun);
    addAttachedFiles(p,{objectivefun});
   
    
    parfor i = 1:N
        fprintf('\nEvaluating the objective function... Generation: %d / %d , Individual: %d / %d \n', state.currentGen, opt.maxGen, i, N);
        [pop(i), allTime(i)] = evalIndividual(pop(i), opt.objfun);
    end

%*************************************************************************
% Evaluate objective function in serial
%*************************************************************************
else
    for i = 1:N
        fprintf('\nEvaluating the objective function... Generation: %d / %d , Individual: %d / %d \n', state.currentGen, opt.maxGen, i, N);
        [pop(i), allTime(i)] = evalIndividual(pop(i), opt.objfun);
    end
end

%*************************************************************************
% Statistics
%*************************************************************************
state.avgEvalTime   = sum(allTime) / length(allTime);
state.evaluateCount = state.evaluateCount + length(pop);




function [indi, evalTime] = evalIndividual(indi, objfun)
% Function: [indi, evalTime] = evalIndividual(indi, objfun, varargin)
% Description: Evaluate one objective function.
%
%         LSSSSWC, NWPU
%    Revision: 1.1  Data: 2011-07-25
%*************************************************************************

tStart = tic;
[y, cons] = objfun( indi.var);
indi.cons=cons;
evalTime = toc(tStart);

% Save the objective values and constraint violations
indi.obj = y;
if( ~isempty(indi.cons) )
    idx = find( cons>0 );
    if( ~isempty(idx) )
        indi.nViol = length(idx);
        indi.violSum = sum( abs(cons(idx)) );
    else
        indi.nViol = 0;
        indi.violSum = 0;
    end
end


