function [objVal]=GOF(s,m,w_nmbe)
%input
% x: design variables,
%output
% objVal: objective 
n=length(s);

w_cv=1-w_nmbe;
nmbe = sum(s-m)/(mean(m)*n);
cv_rmse=sqrt(sum((s-m).^2)/n)/mean(m);

objVal=sqrt(((w_nmbe*nmbe)^2+(w_cv*cv_rmse)^2)/(w_nmbe^2+w_cv^2));

end
