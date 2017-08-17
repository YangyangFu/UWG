function nextpop=extractPopDIS(opt,out)

[feaspop,infeaspop]=split(out);

% determine the popsize of extracted population
if opt.surrogate.use==1
    popsize=opt.surrogate.miu;
else
    
    popsize = opt.popsize;
end
% determine the alpha required in DIS
alpha=opt.sortingfun{1,2};

if alpha>1
    warning ('alpha in DIS is larger than 1, which should be in [0 1].')
    alpha=min(1,alpha);
elseif alpha==0
    error ('alpha in DIS must be larger than 0, which should be in [0 1].')
end

infeasNum=round(alpha*popsize);
feasNum=popsize-infeasNum;

% ranks in infeasible pop,rank from 1;

infeasrank=vertcat(infeaspop.rank) ;


% ranks in feasible pop,rank from 1;

feasrank=vertcat(feaspop.rank) ;

% infeasible pop should rank higher than any feasible pop;

infeasrank=infeasrank+max(feasrank);
for i=1:length(infeasrank)
    infeaspop(i).rank=infeasrank(i);
    
end

if (length(feaspop)+length(infeaspop))==popsize
    nextpop=[feaspop,infeaspop];
else
    % 1. extract a*P infeasible pop
    if length(infeaspop)>=infeasNum %top alpha*popsize infeasible data are selected.
        
        n = 0;          % individuals number of next population
        rank = max(feasrank);       % current rank number
        idx = find(infeasrank== rank);
        numInd = length(idx);       % number of individuals in current front
        while( n + numInd <= infeasNum )
            infeasSet( n+1 : n+numInd ) = infeaspop( idx );
            
            n = n + numInd;
            rank = rank + 1;
            
            idx = find(infeasrank == rank);
            numInd = length(idx);
        end
        
        % If the number of individuals in the next front plus the number of individuals
        % in the current front is greater than the population size, then select the
        % best individuals by corwding distance(NSGA-II) or preference distance(R-NSGA-II).
        if( n < infeasNum )
            if(~isempty(opt.refPoints))
                prefDistance = vertcat(infeaspop(idx).prefDistance);
                prefDistance = [prefDistance, idx];
                prefDistance = sortrows( prefDistance, 1);
                idxSelect  = prefDistance( 1:infeasNum-n, 2);       % Select the individuals with smallest preference distance
                infeasSet(n+1 : infeasNum) = infeaspop(idxSelect);
            else
                distance = vertcat(infeaspop(idx).distance);
                distance = [distance, idx];
                distance = flipud( sortrows( distance, 1) );      % Sort the individuals in descending order of crowding distance in the front.
                idxSelect  = distance( 1:infeasNum-n, 2);           % Select the (popsize-n) individuals with largest crowding distance.
                infeasSet(n+1 : infeasNum) = infeaspop(idxSelect);
            end
        end
        
        
    else
        need=infeasNum-length(infeaspop);
        [~,feasRankIndex]=sort(feasrank);
        infeasSet=[infeaspop,feaspop(feasRankIndex(end-need+1:end))];
        
    end
    
    % 2. extract (1-a) feasible pop
    
    if length(feaspop)>=feasNum %top alpha*popsize infeasible data are selected.
        
        n = 0;          % individuals number of next population
        rank = 1;       % current rank number
        idx = find(feasrank== rank);
        numInd = length(idx);       % number of individuals in current front
        while( n + numInd <= feasNum )
            feasSet( n+1 : n+numInd ) = feaspop( idx );
            
            n = n + numInd;
            rank = rank + 1;
            
            idx = find(feasrank == rank);
            numInd = length(idx);
        end
        
        % If the number of individuals in the next front plus the number of individuals
        % in the current front is greater than the population size, then select the
        % best individuals by corwding distance(NSGA-II) or preference distance(R-NSGA-II).
        if( n < feasNum )
            if(~isempty(opt.refPoints))
                prefDistance = vertcat(feaspop(idx).prefDistance);
                prefDistance = [prefDistance, idx];
                prefDistance = sortrows( prefDistance, 1);
                idxSelect  = prefDistance( 1:feasNum-n, 2);       % Select the individuals with smallest preference distance
                feasSet(n+1 : feasNum) = feaspop(idxSelect);
            else
                distance = vertcat(feaspop(idx).distance);
                distance = [distance, idx];
                distance = flipud( sortrows( distance, 1) );      % Sort the individuals in descending order of crowding distance in the front.
                idxSelect  = distance( 1:feasNum-n, 2);           % Select the (popsize-n) individuals with largest crowding distance.
                feasSet(n+1 : feasNum) = feaspop(idxSelect);
            end
        end
        
    else
        need=feasNum-length(feaspop);
        [~,infeasRankIndex]=sort(infeasrank);
        feasSet=[feaspop,infeaspop(infeasRankIndex(end-need+1:end))];
        
    end
    
    nextpop=[feasSet,infeasSet];
end
end