function [opt,pop]=extract(opt,out)
% Function EXTRACT: extract populations from combined populations, for
% example, combined parents and children.

sortingfun=opt.sortingfun{1,1};


switch sortingfun
    case 'nds'

        pop = extractPop(opt, out);
        
    case 'dis'

        % Extract the next population
        pop=extractPopDIS(opt,out);
        
    otherwise
        error('sorting function does not exsit!');
end
end