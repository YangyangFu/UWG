%*************************************************************************
% Test Problem : 'CONSTR'
% Description:
%   (1)constrained
%
% Reference : [1] Deb K, Pratap A, Agarwal S, et al. A fast and elitist 
%   multiobjective genetic algorithm NSGA-II[J]. Evolutionary Computation. 
%   2002, 6(2): 182-197.
%*************************************************************************


options = nsgaopt();                    % create default options structure
options.popsize = 50;                   % populaion size
options.maxGen  = 100;                  % max generation

options.numObj = 2;                     % number of objectives
options.numVar = 2;                     % number of design variables
options.numCons = 2;                    % number of constraints
options.lb = [0.1  0];                  % lower bound of x
options.ub = [1    5];                  % upper bound of x
options.objfun = @TP_CONSTR_objfun;     % objective function handle
options.consfun=@TP_CONSTR_consfun;
options.plotInterval = 1;               % interval between two calls of "plotnsga". 

%options.crossover{1,1}='intermediate';
%options.crossover{1,2}=0.8;
%options.crossoverFraction=0.9;
%options.mutation={'gaussian',0.5,0.75};
%options.mutationFraction=1./2;


options.crossover{1,1}='simulatedbinary';
options.crossover{1,2}=20;% crossover operator distribution indices
options.crossoverFraction=0.9;
options.mutation={'polynominal',20};
options.mutationFraction=1./2;


options.sortingfun={'nds',0.2};


options.vartype=[1,2];
options.useParallel='no';
options.poolsize=2;
options.initpop=[0.5 4;0.22,2];%[0.5 4;0.4 4];



options.surrogate.use=1;
miu=options.popsize;
lamda=3*miu;

options.surrogate.miu=miu;
options.surrogate.lamda=lamda;


surrogateOpt=getsurrogateOpt;

nhidden=round(miu/3);
surrogateOpt.numVar=2;
surrogateOpt.numObj=1;
surrogateOpt.model{1,1}='svm';
surrogateOpt.model{1,2}='gs';
surrogateOpt.model{1,3}=nhidden;
surrogateOpt.model{1,5}='euclidean';
surrogateOpt.model{1,6}='kmedoids';

surrogateOpt.consSurrogateIndex=[];

result = nsga2(options,surrogateOpt);                % begin the optimization!


