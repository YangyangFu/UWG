function cons=TP_CONSTR_consfun(x)
% calculate the constraint violations
cons=zeros(size(x,1),2);
c = -(x(:,2) + 9*x(:,1)) + 6;
%if(c<0)
    cons(:,1) = c;%abs(c);
%end

c = -(-x(:,2) + 9*x(:,1)) + 1;
%if(c<0)
    cons(:,2) = c;%abs(c);
%end
end