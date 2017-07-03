function [centermedoids,index, label,cost] = kmedoids(X,k)
% X: n x d data matrix
% k: number of cluster
% Written by Mo Chen (sth4nth@gmail.com)
% Revised by Fu Yangyang
%*************************************************************

X=X'; % 
v = dot(X,X,1);
D = bsxfun(@plus,v,v')-2*(X'*X);
n = size(X,2);
[~, label] = min(D(randsample(n,k),:),[],1);
last = 0;
while any(label ~= last)
    [~, index] = min(D*sparse(1:n,label,1,n,k,n),[],1);
    last = label;
    [val, label] = min(D(index,:),[],1);
end

centermedoids=X(:,index);
centermedoids=centermedoids';
cost = sum(val);
