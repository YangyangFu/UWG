
function [performance,surrogateOpt]=surrogateperf(target,predTarget,surrogateOpt)
%Performance function
if nargin<3
    performanceFun='spearman';
else
    
    performanceFun=surrogateOpt.perfFun;
end


switch performanceFun
    case 'spearman'
        r=corrcoefficient(target,predTarget,performanceFun);
        
    case 'productmoment'
        
        r=corrcoefficient(target,predTarget,performanceFun);
        
    otherwise
        
        error('performance function do not exist!!');
        
end

performance=r;
end
