function result = ga(opt,varargin)
%This is a real coded GA for mixed integer constrained optimization
%problem.
%
%   Author: Yangyang Fu
%   Contact: yangyang.fu@colorado.edu
%   First Implementation: 8/03/2017

tStart = tic();
%*************************************************************************
% Verify the optimization model
%*************************************************************************
opt = verifyOpt(opt);

%*************************************************************************
% variables initialization
%*************************************************************************
nVar    = opt.numVar;
nObj    = opt.numObj;
nCons   = opt.numCons;
popsize = opt.popsize;

% pop : current population
% newpop : new population created by genetic algorithm operators
% combinepop = pop + newpop;
pop = repmat( struct(...
    'var', zeros(1,nVar), ...
    'obj', zeros(1,nObj), ...
    'cons', zeros(1,nCons),...
    'surrfitness',zeros(1,nObj),...
    'surrcons',zeros(1,nCons),...
    'rank', 0,...
    'distance', 0,...
    'prefDistance', 0,...       % preference distance used in R-NSGA-II
    'nViol', 0,...
    'violSum', 0,...
    'nViolSurr',0,...
    'violSumSurr',0,...
    'fitness',0),...
    [1,popsize]);

% state: optimization state of one generation
state = struct(...
    'currentGen', 1,...         % current generation number
    'evaluateCount', 0,...      % number of objective function evaluation
    'totalTime', 0,...          % total time from the beginning
    'firstFrontCount', 0,...    % individual number of first front
    'frontCount', 0,...         % number of front
    'avgEvalTime', 0, ...       % average evaluation time of objective function (current generation)
    'worstFeas',0 ...           % worst feasible solution in current generation, =0 if all solutions are infeasible or nObj>1
    );

result.pops     = repmat(pop, [opt.maxGen, 1]);     % each row is the population of one generation
result.states   = repmat(state, [opt.maxGen, 1]);   % each row is the optimizaiton state of one generation
result.opt      = opt;                              % use for output

% global variables
global STOP_NSGA;   %STOP_NSGA : used in GUI , if STOP_NSGA~=0, then stop the optimizaiton
STOP_NSGA = 0;


%======================================================================
%                   Initialization at generation=0
%======================================================================
ngen = 1;
pop = opt.initfun{1}(opt, pop, opt.initfun{2:end});
[pop, state] = evaluate(opt, pop, state);
% now we need rank the solutions in current generation
% calculate the fitness value for single obejctive
[opt, pop, state] = fitnessValue(opt, pop, state);
%======================================================================
%                   Main Loop
%======================================================================
while( ngen < opt.maxGen && STOP_NSGA==0)
    % 0. Display some information
    ngen = ngen+1;
    state.currentGen = ngen;
    
    fprintf('\n\n************************************************************\n');
    fprintf('*      Current generation %d / %d\n', ngen, opt.maxGen);
    fprintf('************************************************************\n');
    
    % Generate new population through selection, crossover, and mutation
    % operators
    % 1. Make new pop
    %****************************************
    % selection operator
    newpop = selectOp(opt, pop);
    % crossover operator
    newpop = crossoverOp(opt, newpop,state);
    % mutation operator
    newpop = mutationOp(opt, newpop, state);
    % integer variable handling
    newpop = integerOp(opt, newpop);
    % evaluate new pop
    [newpop, state] = evaluate(opt, newpop, state);
     
    % 2. Combine the new population and old population : combinepop = pop + newpop
    combinepop = [pop, newpop];
    
    % 3. Extact n new population from 2n
    % calculate the fitness value for single obejctive
    [opt, combinepop, state] = fitnessValue(opt, combinepop, state);       
    pop = extractPopFit(opt, combinepop);

    
       % 5. Save current generation results
    state.totalTime = toc(tStart);
    state = statpop(pop, state);
    
    result.pops(ngen, :) = pop;
    result.states(ngen)  = state;

    % 6. plot current population and output
    %if( mod(ngen, opt.plotInterval)==0 )
    %    plotnsga(result, ngen);
    %end
    %if( mod(ngen, opt.outputInterval)==0 )
    %    opt = callOutputfuns(opt, state, pop);
    %end
    
end
% call output function for closing file
opt = callOutputfuns(opt, state, pop, -1);

% close worker processes
if( strcmpi(opt.useParallel, 'yes'))
    %parpool close
    delete(gcp('nocreate'))
end

toc(tStart); 
end