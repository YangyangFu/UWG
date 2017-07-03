function dis=distrbf(x,c,distFunc,vartype)
% This function calculates the distance between input data and rbf centers

[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
    error('Data dimension does not match dimension of centres')
end

distFunc=lower(distFunc);

switch distFunc
    case 'euclidean'
        fun=@EuclideanDist;
    case 'manhattan'
        fun=@ManhattanDist;
    case 'heom' % heterogenerous euclidean-overlap metric
        fun=@HeomDist;
    case'hamming'
        fun=@HammingDist;
    otherwise
        error('No such distance function in "dist"!');
end

% before using heom distance,the data should be normalized to [0,1];
if strcmp(distFunc,'heom')==1
    [x,ps]=mapminmax(x',0,1);
    x=x';
    c = mapminmax('apply',c',ps);
    c=c';   
end

dis=[];
for i=1:ndata
    for j=1:ncentres
        dis(i,j)=fun(x(i,:),c(j,:),vartype);
    end
end

end

function dis=HeomDist(x,y,vartype)
%HEOMDIST
%Function calculate the heterogenerous euclidean-overlap metric.
% vartype: 1--continious;2--integer;
%Author: Fu Yangyang
%Date:   August,22,2015
%Revision:
%****************************************************************

% BEFORE using this distance, variables should be normalized to [0,1];

if length(x)~=length(y)
    error('Dimensions do not match in EuclideanDist!');
end


distCon=(vartype==1).*abs(x-y); % euclidean distance for continuous variables;
distInt=(vartype==2).*abs(x-y);% integer distance for interger variables;
distCate=(vartype==3).*(x~=y);% hamming distance for categorical variables;

% HEOM suggested in reference: "metamodel-assited mixed integer evolution
% strategies and their application to intravascular ultrasound image
% analysis",2008,IEEE
% BUT I DON'T THINK THIS IS RIGHT, BECASUE THE UNIT FOR DISTANCE IN THIS
% METRIC IS NOT COMPATABLE.

distance=sum(distCon.^2)+sum(distInt)+2/3*sum(distCate);

dis=sqrt(distance);

end



function dis=EuclideanDist(x,y,vartype)

% check the dimension
if length(x)~=length(y)
    error('Dimensions do not match in EuclideanDist!');
end
dis=sqrt(sum((x-y).^2));
end

function dis=ManhattanDist(x,y,vartype)


% check the dimension
if length(x)~=length(y)
    error('Dimensions do not match in ManhattanDist!');
end
dis=sum(abs(x-y));

end

function dis=HammingDist(x,y,vartype)
% check the dimension
if length(x)~=length(y)
    error('Dimensions do not match in EuclideanDist!');
end

index=(x~=y);
distance=index;

dis=sqrt(sum(distance.^2));
end
