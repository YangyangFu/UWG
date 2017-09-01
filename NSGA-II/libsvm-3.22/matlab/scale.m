function [y_scaled,x_scaled,model]=scale(y,x,lb,ub)
if nargin < 3
    lb = 0;
    ub = 1;
end
[y_scaled,y_ps]=mapminmax(y',lb,ub);
[x_scaled,x_ps]=mapminmax(x',lb,ub);
y_scaled=y_scaled';
x_scaled=x_scaled';
model.ps.y=y_ps;
model.ps.x=x_ps;