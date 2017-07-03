function result = nsga2(opt, surrogateOpt,varargin)
% Function: result = nsga2(opt, varargin)
% Description: The main flowchart of of NSGA-II. Note:
%   All objectives must be minimization. If a objective is maximization, the
%   objective should be multipled by -1.
%
% Syntax:
%   result = nsga2(opt): 'opt' is generated by function nsgaopt().
%   result = nsga2(opt, param): 'param' can be any data type, it will be
%       pass to the objective function objfun().
%
%   Then ,the result structure can be pass to plotnsga to display the
%   population:  plotnsga(result);
%
% Parameters:
%   opt : A structure generated by funciton nsgaopt().
%   varargin : Additional parameter will be pass to the objective functions.
%       It can be any data type. For example, if you call: nsga2(opt, param),
%       then objfun would be called as objfun(x,param), in which, x is the
%       design variables vector.
% Return:
%   result : A structure contains optimization result.
%
%    Author: Yangyang Fu
%    Date: 07/03/2017
%*************************************************************************
global GStartDate

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
    'violSumSurr',0),...
    [1,popsize]);

% state: optimization state of one generation
state = struct(...
    'currentGen', 1,...         % current generation number
    'evaluateCount', 0,...      % number of objective function evaluation
    'totalTime', 0,...          % total time from the beginning
    'firstFrontCount', 0,...    % individual number of first front
    'frontCount', 0,...         % number of front
    'avgEvalTime', 0 ...        % average evaluation time of objective function (current generation)
    );

result.pops     = repmat(pop, [opt.maxGen, 1]);     % each row is the population of one generation
result.states   = repmat(state, [opt.maxGen, 1]);   % each row is the optimizaiton state of one generation
result.opt      = opt;                              % use for output

% global variables
global STOP_NSGA;   %STOP_NSGA : used in GUI , if STOP_NSGA~=0, then stop the optimizaiton
STOP_NSGA = 0;



%*************************************************************************
% initialize the P0 population
%*************************************************************************

ngen = 1;
pop = opt.initfun{1}(opt, pop, opt.initfun{2:end});
[pop, state] = evaluate(opt, pop, state);
[opt, pop,frontpop] = ndsort(opt, pop);



% if surrogate model is set to use, then train surrogate models for each
% objective and constraints, if neccessary.
if opt.surrogate.use
    
    surrogatemodel=cell(opt.maxGen,nObj+nCons);
    %surrogateperf=zeros(opt.maxGen,nObj+nCons);
    for i=1:length(pop)
        traindata(i,:)=pop(i).var;
        truefitness(i,:)=pop(i).obj;
        trueconstraints(i,:)=pop(i).cons;
    end
    
    % train surrogate model for objective functions
    for j=1:nObj
        
        [net,surrogateOpt]=trainsurrogate(traindata,truefitness(:,j),surrogateOpt,opt);
        surrogatemodel{ngen,j}=net;
        %surrogateperf(ngen,j)=surrogateOpt.performance;
    end
    
    % train surrogate model for constraint functions. since, in this case,
    % constraints computation is simple,only some of them need to be
    % fitted.
    consSurrogateIndex=surrogateOpt.consSurrogateIndex;
    if ~isempty(consSurrogateIndex)
        for j=1:length(consSurrogateIndex)
            [net,surrogateOpt]=trainsurrogate(traindata,trueconstraints(:,consSurrogateIndex(j)),...
                surrogateOpt,opt);
            surrogatemodel{ngen,consSurrogateIndex(j)+nObj}=net;
        end
    end
    
    for i=1:length(pop)
    
    pop(i).surrcons=pop(i).cons;
    pop(i).nViolSurr=pop(i).nViol;
    pop(i).violSumSurr=pop(i).violSum;
    end
    
    surrogatemodel(ngen+1,:)=surrogatemodel(ngen,:);
    
    
end
% state
state.currentGen = ngen;
state.totalTime = toc(tStart);
state = statpop(pop, state);

result.pops(1, :) = pop;
result.states(1)  = state;

archiveFront=frontpop;

% output
plotnsga(result, ngen);
opt = callOutputfuns(opt, state, pop);


%*************************************************************************
% NSGA2 iteration
%*************************************************************************
while( ngen < opt.maxGen && STOP_NSGA==0)
    % 0. Display some information
    ngen = ngen+1;
    state.currentGen = ngen;
    
    fprintf('\n\n************************************************************\n');
    fprintf('*      Current generation %d / %d\n', ngen, opt.maxGen);
    fprintf('************************************************************\n');
    
    if (~opt.surrogate.use) % don't use surrogate
        % 1. Create new population
        newpop = selectOp(opt, pop);
        newpop = crossoverOp(opt, newpop, state);
        newpop = mutationOp(opt, newpop, state);
        % integer variable handling
        newpop = integerOp(opt,newpop);
        [newpop, state] = evaluate(opt, newpop, state);
        
        % 2. Combine the new population and old population : combinepop = pop + newpop
        combinepop = [pop, newpop];
        
        % 3.  Fast non dominated sort
        [opt, out,frontpop] = sorting(opt, combinepop);
        
        % 4. Extract the next population
        [opt,pop] = extract(opt, out);
        
        
    else % use surrogate
        [opt,pop,state,surrogatemodel,surrogateOpt,frontpop]=surrogate...
            (opt,pop,state, surrogatemodel,surrogateOpt);
    end
    
    % 5. Save current generation results
    state.totalTime = toc(tStart);
    state = statpop(pop, state);
    
    result.pops(ngen, :) = pop;
    result.states(ngen)  = state;
    
    archiveFront=[archiveFront,frontpop];
    % 6. plot current population and output
    if( mod(ngen, opt.plotInterval)==0 )
        plotnsga(result, ngen);
    end
    if( mod(ngen, opt.outputInterval)==0 )
        opt = callOutputfuns(opt, state, pop);
    end
    
end

if opt.surrogate.use==1
    result.surrogatemodel=surrogatemodel;
end

[opt,~,archiveFront]=ndsort(opt,archiveFront);

result.archiveFront=archiveFront;

% plot front from archive front set
figure;
frontobj=vertcat(archiveFront(:).obj);
scatter(frontobj(:,1),frontobj(:,2));

% call output function for closing file
opt = callOutputfuns(opt, state, pop, -1);

% close worker processes
if( strcmpi(opt.useParallel, 'yes'))
    matlabpool close
end

toc(tStart);


