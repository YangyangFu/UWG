function [ net,surrogateOpt] = trainsurrogate( trainX,trainY,surrogateOpt,opt)
%CONSTRUCTSURROGATE Summary of this function goes here
%   Detailed explanation goes here

% construct a rbf model

model=surrogateOpt.model{1,1};


vartype=opt.vartype;

% structure parameters
numVar=surrogateOpt.numVar;
numObj=surrogateOpt.numObj;


switch model
    case 'rbf'
        activationFun=surrogateOpt.model{1,2};
        nhidden=surrogateOpt.model{1,3};
        distFun=surrogateOpt.model{1,5};
        outFun=surrogateOpt.model{1,4};
        centermodel=surrogateOpt.model{1,6};
        % Create and initialize network weight and parameter vectors.
        net = rbf(numVar, nhidden, numObj, activationFun,outFun,distFun,centermodel,vartype);
        % Use fast training method
        options = foptions;
        options(1) = 1;		% Display EM training
        options(14) = 10;	% number of iterations of EM
        net = rbftrain(net, options, trainX,trainY);
    case 'svm'
        optimizer=surrogateOpt.model{1,2};
        if ~ischar(optimizer)
            warning ('Optimizer for SVM has not been pre-defined.')
            warning ('Default optimizer GA is used!')
            optimizer='ga';
        end
        options.optimizer=optimizer;
        options.scale=1;
        net=svrtrain(trainX,trainY,options);
    case 'bpann'
        net=bpanntrain(trainX,trainY);
    otherwise
        error('surrogate model do not exist!')
end

end

