
options = nsgaopt();                    % create default options structure
options.popsize = 120;                   % populaion size
options.maxGen  = 100;                  % max generation

options.numObj = 1;                     % number of objectives
options.numVar = 12;                     % number of design variables
options.numCons = 0;                    % number of constraints
options.lb = [50,100,0.1,30,0.1,0.15,800,0.1,2,20,10,15];                  % lower bound of x
options.ub = [100,200,0.9,40,0.9,0.35,1200,0.7,4,24,16,25];                  % upper bound of x
options.objfun = @ObjectiveFunction;     % objective function handle
options.consfun=@ObjectiveFunction;
options.plotInterval = 1;               % interval between two calls of "plotnsga". 

options.crossover={'laplace',0,0.15,0.35};
options.crossoverFraction=0.8;
options.mutation={'power',10,4};
options.mutationFraction=0.01;


options.sortingfun={'fit',0};
options.vartype=[1,1,1,1,1,1,1,1,1,1,1,1];
options.useParallel='no';
options.poolsize=10;
options.initpop=[52.6,153.0,0.1,37.9,0.33,0.345,964.8,0.46,3.998,20.744,13.5,23.2];%[0.5 4;0.4 4];

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

options.configuration={'data'};

[result,surrogateOpt] = ga(options,surrogateOpt);                % begin the optimization!
save result2.mat