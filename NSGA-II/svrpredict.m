function [predY]=svrpredict(model,X,Y)
%Function SVRPREDICT calculate the predicted value of svr model.
%
%****************************************************************


if isempty(Y)
    
    Y=ones(size(X,1),1);
end
[predY] = svmpredict(Y,X, model);
end