function [opt, pop,frontpop] = ndsort(opt, pop)
% Function: [opt, pop] = ndsort(pop)
% Description: Fast non-dominated sort.
%
%    Author: Yangyang Fu
%    Date: 07/03/2017
%*************************************************************************




%*************************************************************************
% 1. Initialize variables
%   indi.np??number of individuals which dominate this individual
%   indi.sp(:): a set of individuals that this individual dominate
%*************************************************************************
N = length(pop);    %popsize
ind = repmat(struct('np',0, 'sp', []),[1,N]);

for i = 1:N
    pop(i).rank = 0;
    pop(i).distance = 0;
    pop(i).prefDistance = 0;
end


%*************************************************************************
% 2. fast non-dominated sort
%*************************************************************************
% Calculate the domination matrix for improving the efficiency.

% NOTE: The "for" statement is more efficient than "vertcat" statement in my computer
% on Matlab 2010b. I don't know why.
nViol   = zeros(N, 1);
violSum = zeros(N, 1);
for i = 1:N
    nViol(i)    = pop(i).nViol;
    violSum(i)  = pop(i).violSum;
end
% nViol   = vertcat(pop(:).nViol);
% violSum = vertcat(pop(:).violSum);

obj     = vertcat(pop(:).obj);
domMat  = calcDominationMatrix(nViol, violSum, obj); % domination matrix for efficiency


% Compute np and sp of each indivudal
for p = 1:N-1
    for q = p+1:N
        if(domMat(p, q) == 1)          % p dominate q
            ind(q).np = ind(q).np + 1;
            ind(p).sp = [ind(p).sp , q];
        elseif(domMat(p, q) == -1)     % q dominate p
            ind(p).np = ind(p).np + 1;
            ind(q).sp = [ind(q).sp , p];
        end
    end
end


% The first front(rank = 1)
front(1).f = [];    % There are only one field 'f' in structure 'front'.
                    % This is intentional because the number of individuals
                    % in the front is difference.
for i = 1:N
    if( ind(i).np == 0 )
        pop(i).rank = 1;
        front(1).f = [front(1).f, i];
    end
end

% Calculate pareto rank of each individuals, viz., pop(:).rank 
fid = 1;        %pareto front ID
while( ~isempty(front(fid).f) )
    Q = [];
    for p = front(fid).f
        for q = ind(p).sp
            ind(q).np = ind(q).np -1;
            if( ind(q).np == 0 )
                pop(q).rank = fid+1;
                Q = [Q, q];
            end
        end
    end
    fid = fid + 1;
    
    front(fid).f = Q;
end
front(fid) = [];    % delete the last empty front set

frontpop=pop(front(1).f);

%*************************************************************************
% 3. Calculate the distance
%*************************************************************************
if(isempty(opt.refPoints))
    pop = calcCrowdingDistance(opt, pop, front);
else
    [opt, pop] = calcPreferenceDistance(opt, pop, front);
end

function domMat = calcDominationMatrix(nViol, violSum, obj)
% Function: domMat = calcDominationMatrix(nViol, violSum, obj)
% Description: Calculate the domination maxtir which specified the domination
%   releation between two individual using constrained-domination.
%
% Return: 
%   domMat(N,N) : domination matrix
%       domMat(p,q)=1  : p dominates q
%       domMat(p,q)=-1 : q dominates p
%       domMat(p,q)=0  : non dominate
%
%    Copyright 2011 by LSSSSWC
%    Revision: 1.0  Data: 2011-07-13
%*************************************************************************

N       = size(obj, 1);
numObj  = size(obj, 2);

domMat  = zeros(N, N);

for p = 1:N-1
    for q = p+1:N
        %*************************************************************************
        % 1. p and q are both feasible
        %*************************************************************************
        if(nViol(p) == 0 && nViol(q)==0)
            pdomq = false;
            qdomp = false;
            for i = 1:numObj
                if( obj(p, i) < obj(q, i) )         % objective function is minimization!
                    pdomq = true;
                elseif(obj(p, i) > obj(q, i))
                    qdomp = true;
                end
            end

            if( pdomq && ~qdomp )
                domMat(p, q) = 1;
            elseif(~pdomq && qdomp )
                domMat(p, q) = -1;
            end
        %*************************************************************************
        % 2. p is feasible, and q is infeasible
        %*************************************************************************
        elseif(nViol(p) == 0 && nViol(q)~=0)
            domMat(p, q) = 1;
        %*************************************************************************
        % 3. q is feasible, and p is infeasible
        %*************************************************************************
        elseif(nViol(p) ~= 0 && nViol(q)==0)
            domMat(p, q) = -1;
        %*************************************************************************
        % 4. p and q are both infeasible
        %*************************************************************************
        else
            if(violSum(p) < violSum(q))
                domMat(p, q) = 1;
            elseif(violSum(p) > violSum(q))
                domMat(p, q) = -1;
            end
        end
    end
end

domMat = domMat - domMat';











