function [objVal]=GOF(s,m,Trural,w_nmbe)
%input
% x: design variables,
%output
% objVal: objective 
n=length(s);

w_cv=1-w_nmbe;
m_bar = mean(abs(Trural-m));
nmbe = sum(s-m)/(m_bar*n);
cv_rmse=sqrt(sum((s-m).^2)/(n-1))/m_bar;

objVal=sqrt(((w_nmbe*nmbe)^2+(w_cv*cv_rmse)^2)/(w_nmbe^2+w_cv^2));

end
