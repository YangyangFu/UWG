function [opt,combinedpop,frontpop]=infeasort(opt,combinedpop)


%1. Split the combined pop into feasible and infeasible subsets
[feaspop,infeaspop]=split(combinedpop);


%2. sort the feasible subsets using non-dominated sorting;
if ~isempty(feaspop)
[opt,feaspop,frontpopfeas]=ndsort(opt,feaspop);
end

%3. sort the infeasible subsets using DIS;
if ~isempty(infeaspop)
[opt,infeaspop]=DIS(opt,infeaspop);
frontpopinfeas=[];
end
combinedpop=[feaspop,infeaspop];
frontpop=[frontpopfeas,frontpopinfeas];


