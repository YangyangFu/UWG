function [opt,out,frontpop]=sorting(opt,combinepop)
% Function SORT: sort individuals based on given rank techniques.

sortingfun=opt.sortingfun{1,1};


switch sortingfun
    case 'nds'
        % Fast non dominated sort

        [opt, combinepop,frontpop] = ndsort(opt, combinepop);
      
        out{1}=combinepop;
    case 'dis'
        % Deterministic infeasibility sort

        [opt,feaspop,infeaspop,frontpop]=infeasort(opt,combinepop);

        out{1}=feaspop;
        out{2}=infeaspop;
    otherwise
        error('sorting function does not exsit!');
end
end