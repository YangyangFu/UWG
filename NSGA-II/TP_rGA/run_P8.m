
options = nsgaopt();                    % create default options structure
options.popsize = 40;                   % populaion size
options.maxGen  = 200;                  % max generation

options.numObj = 1;                     % number of objectives
options.numVar = 7;                     % number of design variables
options.numCons = 9;                    % number of constraints
options.lb = [0,0,0,0,0,0,0];                  % lower bound of x
options.ub = [1.2,1.8,2.5,1,1,1,1];                  % upper bound of x
options.objfun = @P8;     % objective function handle
options.consfun=@P8;
options.plotInterval = 1;               % interval between two calls of "plotnsga". 

%options.crossover{1,1}='intermediate';
%options.crossover{1,2}=0.8;
%options.crossoverFraction=0.9;
%options.mutation={'gaussian',0.5,0.75};
%options.mutationFraction=1./2;


% options.crossover{1,1}='simulatedbinary';
% options.crossover{1,2}=20;% crossover operator distribution indices
% options.crossoverFraction=0.9;
% options.mutation={'polynominal',20};
% options.mutationFraction=1./20;

options.crossover={'laplace',0,0.15,0.35};
options.crossoverFraction=0.8;
options.mutation={'power',10,4};
options.mutationFraction=0.05;


options.sortingfun={'fit',0.0};

options.vartype=[1,1,1,2,2,2,2];
options.useParallel='no';
options.poolsize=20;
options.initpop=[];%[0.5 4;0.4 4];



options.surrogate.use=1;
miu=options.popsize;
lamda=3*miu;

options.surrogate.miu=miu;
options.surrogate.lamda=lamda;


surrogateOpt=getsurrogateOpt;

nhidden=round(miu/3);
surrogateOpt.numVar=options.numVar;
surrogateOpt.numObj=options.numObj;
surrogateOpt.model{1,1}='svm';
surrogateOpt.model{1,2}='gs';
surrogateOpt.model{1,3}=nhidden;
surrogateOpt.model{1,5}='euclidean';
surrogateOpt.model{1,6}='kmedoids';
% % rbf
% surrogateOpt.numVar=options.numVar;
% surrogateOpt.numObj=options.numObj;
% surrogateOpt.model{1,1}='svm';
% surrogateOpt.model{1,2}='gs';
% surrogateOpt.model{1,3}=nhidden;
% surrogateOpt.model{1,5}='euclidean';
% surrogateOpt.model{1,6}='kmedoids';

surrogateOpt.consSurrogateIndex=[];

%configuration path for calling in and out files by simulation software
options.configuration=[];

[result,surrogateOpt] = ga(options,surrogateOpt);                % begin the optimization!
