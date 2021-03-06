
options = nsgaopt();                    % create default options structure
options.popsize = 80;                   % populaion size
options.maxGen  = 100;                  % max generation

options.numObj = 1;                     % number of objectives
options.numVar = 1;                     % number of design variables
options.numCons = 0;                    % number of constraints
options.lb =  -20;                  % lower bound of x
options.ub = 150;                  % upper bound of x
options.objfun = @P1;     % objective function handle
options.consfun=@P1;
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


options.sortingfun={'fit'};


options.vartype=[1,2];
options.useParallel='no';
options.poolsize=20;
options.initpop=[100;30];%[0.5 4;0.4 4];



options.surrogate.use=0;
miu=options.popsize;
lamda=miu;

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

result = ga(options,surrogateOpt);                % begin the optimization!
