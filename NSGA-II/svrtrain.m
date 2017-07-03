function model=svrtrain(trainX,trainY,options)
%Function SVRTRAIN trains support vector regression model.
%
%*********************************************************

if nargin < 3

    options.optimizer = 'ga';
end


%OPTIMIZER FOR SVR Parameter c and g.
optimizer=options.optimizer;
switch optimizer
    case 'ga'
        ga_option.maxgen = 100;
        ga_option.sizepop = 20;
        ga_option.cbound = [0,100];
        ga_option.gbound = [0,100];
        ga_option.v = 5;
        ga_option.ggap = 0.9;
        [bestCVmse,bestc,bestg] = ...
            gaSVMcgForRegress(trainY,trainX,ga_option);
        cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg),' -s 3 -p 0.01'];
    case 'gs'
        [bestCVmse,bestc,bestg] = SVMcgForRegress(trainY,trainX,-8,8,-8,8,5,0.4,0.4);
        cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg),' -s 3 -p 0.01'];
    case 'pso'
        pso_option.c1 = 1.5;
        pso_option.c2 = 1.7;
        pso_option.maxgen = 100;
        pso_option.sizepop = 20;
        pso_option.k = 0.6;
        pso_option.wV = 1;
        pso_option.wP = 1;
        pso_option.v = 3;
        pso_option.popcmax = 100;
        pso_option.popcmin = 0.1;
        pso_option.popgmax = 100;
        pso_option.popgmin = 0.1;
        
        [bestCVmse,bestc,bestg] = psoSVMcgForRegress(trainY,trainX,pso_option);
        cmd = ['-c ',num2str(bestc),' -g ',num2str(bestg),' -s 3 -p 0.01'];
    otherwise
        error('user-provided optimizer in svr do not exist!')
end

%% Train the SVR Model

model = svmtrain(trainY,trainX,cmd);


end