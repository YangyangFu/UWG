function [opt,nextpop,state,surrogatemodel,surrogateOpt,frontpop]=surrogate...
    (opt,pop,state, surrogatemodel,surrogateOpt)
% Function: surrogate
% Description: surrogate model enable the NSGA to approximate fitness and
% to speed up.
%
% Algorithm:
% 1. S=make new pop (P); creat surrogate pop S, where size S>P using selection,crossover and mutation;
% 2. Approximate objectives and constraints in S;
% 3. fast non-dominated sorting in S;
% 4. Extract Q from S as pre-selection
% 5. Evaluate Q in expensive function evalution;
% 6. determine if the surrogate model should be updated.
% 7. repeat.
%************************************************************************

numObj=opt.numObj;
numCons=opt.numCons;
% 1. make new pop: S=new(P)
newpop=selectOp(opt,pop);
newpop=crossoverOp(opt,newpop,state);
newpop=mutationOp(opt,newpop,state);
newpop = integerOp(opt,newpop);

% 2. Evaluate the approximation value of both objectives and constraints
%    testing data
for i=1:length(newpop)
    traindata(i,:)=newpop(i).var;
end

ngen=state.currentGen;

%   2.1 evalutae approximate objectives
surrfitnessS=zeros(length(newpop),numObj);
for i=1:numObj
    net=surrogatemodel{ngen,i};
    [ predY,surrogateOpt] =testsurrogate( net,traindata,[],surrogateOpt );

    surrfitnessS(:,i)=predY;
end

%   2.2 evaluate approximate constraints.
%     (1) evaluate the expensive constraints
consSurrogateIndex=surrogateOpt.consSurrogateIndex;% Only specific constraints need to be approximated
surrconstraintS=zeros(length(newpop),numCons);
if ~isempty(consSurrogateIndex)
    
    for j=1:length(consSurrogateIndex)
        net=surrogatemodel{ngen,numObj+consSurrogateIndex(j)};
        [predY,surrogateOpt]=testsurrogate(net,traindata,[],surrogateOpt);
        surrconstraintS(:,consSurrogateIndex(j))=predY;
    end
end
%     (2) evaluate the inexpensive constraints using the original
%     constaints function.
consfun=opt.consfun;% the function handle of inexpensive constraints
inexpconsIndex=setdiff(1:numCons,consSurrogateIndex);
%inexpsurrogateconstraint=consfun(traindata);% evaluate the inexpensive constraints


% put all the constraints together
if ~isempty(inexpconsIndex)
    for i=1:length(newpop)
        inexpSurrConstraint(i,:)=consfun(traindata(i,:));% evaluate the inexpensive constraints
    end
    if size(inexpconsIndex,2)~=size(inexpSurrConstraint,2)
        error('inexpensive constraints number is not correct!')
    end
    for j=1:length(inexpconsIndex)
        surrconstraintS(:,inexpconsIndex(j))=inexpSurrConstraint(:,j);
    end
end

for j=1:length(newpop)
    
    newpop(j).surrcons=surrconstraintS(j,:);
    newpop(j).surrfitness=surrfitnessS(j,:);
    
    % Save the objective values and constraint violations for surrogate
    % model
    if( ~isempty(newpop(j).surrcons) )
        idx = find( newpop(j).surrcons>0);
        if( ~isempty(idx) )
            newpop(j).nViolSurr = length(idx);
            newpop(j).violSumSurr = sum( abs(newpop(j).surrcons(idx)) );
        else
            newpop(j).nViolSurr = 0;
            newpop(j).violSumSurr = 0;
        end
    end
    % save the objective values and constraints violation for ture
    % model
    newpop(j).obj=newpop(j).surrfitness;
    newpop(j).cons=newpop(j).surrcons;
    
    newpop(j).nViol=newpop(j).nViolSurr;
    newpop(j).violSum=newpop(j).violSumSurr;
end

%3. Fast Non-dominated Sorting
[opt,out]=sorting(opt,newpop);

%4. Extract Q from S;
[opt,nextpop] = extract(opt, out);

%5. Expensive evaluation for both objectives and constraints
[nextpop, state] = evaluate(opt, nextpop, state);

%6. Non-dominated sorting using real fitness
[opt,nextpopout,frontpop]=sorting(opt,nextpop);
[opt,nextpop] = extract(opt, nextpopout);

%7. Determine whether to update the surrogate model based on model
% preciseness.
% calculate the prediction coefficient

truefitnessQ=vertcat(nextpop.obj);
truefitnessP=vertcat(pop.obj);
surrfitnessQ=vertcat(nextpop.surrfitness);
surrfitnessP=vertcat(pop.surrfitness);

%  7.1 check objective model first
for i=1:numObj
    [performance,surrogateOpt]=surrogateperf(truefitnessQ(:,i),surrfitnessQ(:,i),surrogateOpt);
    surrogatemodel{state.currentGen,i}.performance=performance;
    if performance<=0.9 % update model
        %extract the training data
        variableQ=vertcat(nextpop.var);
        variableP=vertcat(pop.var);
        traindatanew=[variableP;variableQ];
        truefitness=[truefitnessP;truefitnessQ];
        % train surrogate
        [netnew,surrogateOpt]=trainsurrogate(traindatanew,truefitness(:,i),surrogateOpt,opt);
        surrogatemodel{state.currentGen+1,i}=netnew;
        
    else% do not update the surrogate model
        surrogatemodel(state.currentGen+1,i)=surrogatemodel(state.currentGen,i);
        continue
    end
end

%  7.2 check constraint model is neccessary
if ~isempty(consSurrogateIndex)
    trueconstraintQ=vertcat(nextpop.cons);
    trueconstraintP=vertcat(pop.cons);
    surrconstraintQ=vertcat(nextpop.cons);
    
    for i= 1:length(consSurrogateIndex)
        % (1) check model performance
        [performance,surrogateOpt]=surrogateperf(trueconstraintQ(:,consSurrogateIndex(i)),...
            surrconstraintQ(:,consSurrogateIndex(i)),surrogateOpt);
        surrogatemodel{state.currentGen,i}.performance=performance;
        
        if performance<=0.9 % update model
            %extract the training data
            variableQ=vertcat(nextpop.var);
            variableP=vertcat(pop.var);
            traindatanew=[variableP;variableQ];
            trueconstraint=[trueconstraintP;trueconstraintQ];
            % train surrogate
            [netnew,surrogateOpt]=trainsurrogate(traindatanew,trueconstraint(:,consSurrogateIndex(i)),surrogateOpt,opt);
            surrogatemodel{state.currentGen+1,consSurrogateIndex(i)+numObj}=netnew;
            
        else% do not update the surrogate model
            surrogatemodel(state.currentGen+1,consSurrogateIndex(i)+numObj)=surrogatemodel...
                (state.currentGen,consSurrogateIndex(i)+numObj);
            continue
        end
        
    end
end