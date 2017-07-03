function [opt, pop] = calcPreferenceDistance(opt, pop, front)
% Function: [opt, pop] = calcPreferenceDistance(opt, pop, front)
% Description: Calculate the 'preference distance' used in R-NSGA-II.
% Return: 
%   opt : This structure may be modified only when opt.refUseNormDistance=='ever'.
%
%    Author: Yangyang Fu
%    Date: 07/03/2017
%*************************************************************************

%*************************************************************************
% 1. Initialization
%*************************************************************************
numObj = length( pop(1).obj );  % number of objectives

refPoints = opt.refPoints;
refWeight = opt.refWeight;      % weight factor of objectives
if(isempty(refWeight))
    refWeight = ones(1, numObj);
end
epsilon = opt.refEpsilon;
numRefPoint = size(refPoints, 1);

% Determine the normalized factors
bUseFrontMaxMin = false;    % bUseFrontMaxMin : If use the maximum and minimum value in the front as normalized factor.
if( strcmpi(opt.refUseNormDistance, 'ever') )
    % 1) Find possiable (not current population) maximum and minimum value
    %     of each objective.
    obj = vertcat(pop.obj);
    if( ~isfield(opt, 'refObjMax_tmp') )
        opt.refObjMax_tmp = max(obj);
        opt.refObjMin_tmp = min(obj);
    else
        objMax = max(obj);
        objMin = min(obj);
        for i = 1:numObj
            if(opt.refObjMax_tmp(i) < objMax(i))
                opt.refObjMax_tmp(i) = objMax(i);
            end
            if(opt.refObjMin_tmp(i) > objMin(i))
                opt.refObjMin_tmp(i) = objMin(i);
            end
        end
        clear objMax objMin
    end
    objMaxMin = opt.refObjMax_tmp - opt.refObjMin_tmp;
    clear obj
elseif( strcmpi(opt.refUseNormDistance, 'front') )
    % 2) Do not use normalized Euclidean distance.
    bUseFrontMaxMin = true;
elseif( strcmpi(opt.refUseNormDistance, 'no') )
    % 3) Do not use normalized Euclidean distance.
    objMaxMin = ones(1,numObj);
else
    % 3) Error
    error('NSGA2:ParamError', ...
        'No support parameter: options.refUseNormDistance="%s", only "yes" or "no" are supported',...
        opt.refUseNormDistance);
end


%*************************************************************************
% 2. Calculate preference distance pop(:).prefDistance
%*************************************************************************
for fid = 1:length(front)
    % Step1: Calculate the weighted Euclidean distance in each front
    idxFront = front(fid).f;            % idxFront : index of individuals in current front
    numInd = length(idxFront);          % numInd : number of individuals in current front
    popFront = pop(idxFront);           % popFront : individuals in front fid

    objFront = vertcat(popFront.obj);   % objFront : the whole objectives of all individuals

    if(bUseFrontMaxMin)
        objMaxMin = max(objFront) - min(objFront); % objMaxMin : the normalized factor in current front
    end

    % normDistance : weighted normalized Euclidean distance
    normDistance = calcWeightNormDistance(objFront, refPoints, objMaxMin, refWeight);
    
    
    % Step2: Assigned preference distance
    prefDistanceMat = zeros(numInd, numRefPoint);
    for ipt = 1:numRefPoint
        [~,ix] = sort(normDistance(:, ipt));
        prefDistanceMat(ix, ipt) = 1:numInd;
    end
    prefDistance = min(prefDistanceMat, [], 2);
    clear ix

    
    % Step3: Epsilon clearing strategy
    idxRemain = 1:numInd;           % idxRemain : index of individuals which were not processed
    while(~isempty(idxRemain))
        % 1. Select one individual from remains
        objRemain = objFront( idxRemain, :);
        selIdx = randi( [1,length(idxRemain)] );
        selObj = objRemain(selIdx, :);

        % 2. Calc normalized Euclidean distance
        % distanceToSel : normalized Euclidean distance to the selected points
        distanceToSel = calcWeightNormDistance(objRemain, selObj, objMaxMin, refWeight);
        

        % 3. Process the individuals within a epsilon-neighborhood
        idx = find( distanceToSel <= epsilon );     % idx : index in idxRemain
        if(length(idx) == 1)    % the only individual is the selected one
            idxRemain(selIdx)=[];
        else
            for i=1:length(idx)
                if( idx(i)~=selIdx )
                    idInIdxRemain = idx(i);     % idx is the index in idxRemain vector
                    id = idxRemain(idInIdxRemain);
                    
                    % *Increase the preference distance to discourage the individuals
                    % to remain in the selection.
                    prefDistance(id) = prefDistance(id) + round(numInd/2);
                end
            end
            idxRemain(idx) = [];
        end
        
    end

    % Save the preference distance
    for i=1:numInd
        id = idxFront(i);
        pop(id).prefDistance = prefDistance(i);
    end
end


function distance = calcWeightNormDistance(points, refPoints, maxMin, weight)
% Function: calcWeightNormDistance(points, refPoints, maxMin, weight)
% Description: Calculate the weighted Euclidean distance from "points" to "refPoints"
% Parameters: 
%   points(nPoint, N)       : each row is a point in N dimension space.
%   refPoints(nRefPoint, N) : each row is a reference point.
%   maxMin(1, N)            : normalized factor.
%   weight(1, N)            : weights
%
% Return: 
%   distance(nPoint, nRefPoint)
%
%    Copyright 2011 by LSSSSWC
%    Revision: 1.0  Data: 2011-07-14
%*************************************************************************

nRefPoint = size(refPoints, 1);     % number of reference points
nPoint = size(points, 1);           % number of points

distance = zeros(nPoint, nRefPoint);
for ipt = 1:nRefPoint
    refpt = refPoints(ipt, :);
    for i = 1:nPoint
        weightNormDist = ((points(i, :)-refpt) ./ maxMin).^2 .* weight;
        distance(i, ipt) = sqrt(sum(weightNormDist));
    end
end
