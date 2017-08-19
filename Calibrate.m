
options = nsgaopt();                    % create default options structure
options.popsize = 200;                   % populaion size
options.maxGen  = 40;                  % max generation

options.numObj = 1;                     % number of objectives
options.numVar = 8;                     % number of design variables
options.numCons = 0;                    % number of constraints
options.lb = [50,100,0.1,0.1,0.15,800,20,10];                  % lower bound of x
options.ub = [100,200,0.9,0.9,0.35,1200,24,16];                  % upper bound of x
options.objfun = @ObjectiveFunction;     % objective function handle
options.consfun=@ObjectiveFunction;
options.plotInterval = 1;               % interval between two calls of "plotnsga". 

options.crossover={'laplace',0,0.15,0.35};
options.crossoverFraction=0.8;
options.mutation={'power',10,4};
options.mutationFraction=0.005;


options.sortingfun={'fit',0.2};
options.vartype=[1,1,1,2,2,2,2];
options.useParallel='no';
options.poolsize=20;
options.initpop=[80,150,0.5,0.5,0.2,1000,22,13];%[0.5 4;0.4 4];

% options for surrogate model
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
surrogateOpt.consSurrogateIndex=[];

[result,surrogateOpt] = ga(options,surrogateOpt);                % begin the optimization!
