function [BestMSE,Bestc,Bestg,ga_option] = gaSVMcgForRegress(train_label,train_data,ga_option)
% gaSVMcgForClass
%

%% ������ʼ��
if nargin == 2
    ga_option = struct('maxgen',200,'sizepop',20,'ggap',0.9,...
        'cbound',[0,100],'gbound',[0,1000],'v',5);
end
% maxgen:���Ľ�������,Ĭ��Ϊ200,һ��ȡֵ��ΧΪ[100,500]
% sizepop:��Ⱥ�������,Ĭ��Ϊ20,һ��ȡֵ��ΧΪ[20,100]
% cbound = [cmin,cmax],����c�ı仯��Χ,Ĭ��Ϊ(0,100]
% gbound = [gmin,gmax],����g�ı仯��Χ,Ĭ��Ϊ[0,1000]
% v:SVM Cross Validation����,Ĭ��Ϊ5

%%
MAXGEN = ga_option.maxgen;
NIND = ga_option.sizepop;
NVAR = 2;
PRECI = 20;
GGAP = ga_option.ggap;
trace = zeros(MAXGEN,2);

FieldID = ...
[rep([PRECI],[1,NVAR]);[ga_option.cbound(1),ga_option.gbound(1);ga_option.cbound(2),ga_option.gbound(2)];...
  [1,1;0,0;0,1;1,1]];

Chrom = crtbp(NIND,NVAR*PRECI);

gen = 1;
v = ga_option.v;
BestMSE = inf;
Bestc = 0;
Bestg = 0;
%%
cg = bs2rv(Chrom,FieldID);

for nind = 1:NIND
    cmd = ['-v ',num2str(v),' -c ',num2str(cg(nind,1)),' -g ',num2str(cg(nind,2)),' -s 3 -p 0.01'];
    ObjV(nind,1) = svmtrain(train_label,train_data,cmd);
end
[BestMSE,I] = min(ObjV);
Bestc = cg(I,1);
Bestg = cg(I,2);

%%
while 1  
    FitnV = ranking(ObjV);
    
    SelCh = select('sus',Chrom,FitnV,GGAP);
    SelCh = recombin('xovsp',SelCh,0.7);
    SelCh = mut(SelCh);
    
    cg = bs2rv(SelCh,FieldID);
    for nind = 1:size(SelCh,1)
        cmd = ['-v ',num2str(v),' -c ',num2str(cg(nind,1)),' -g ',num2str(cg(nind,2)),' -s 3 -p 0.01'];
        ObjVSel(nind,1) = svmtrain(train_label,train_data,cmd);
    end
    
    [Chrom,ObjV] = reins(Chrom,SelCh,1,1,ObjV,ObjVSel);   
    
    [NewBestCVaccuracy,I] = min(ObjV);
    cg_temp = bs2rv(Chrom,FieldID);
    temp_NewBestCVaccuracy = NewBestCVaccuracy;
    
    if NewBestCVaccuracy < BestMSE
       BestMSE = NewBestCVaccuracy;
       Bestc = cg_temp(I,1);
       Bestg = cg_temp(I,2);
    end
    
    if abs( NewBestCVaccuracy-BestMSE ) <= 10^(-4) && ...
        cg_temp(I,1) < Bestc
       BestMSE = NewBestCVaccuracy;
       Bestc = cg_temp(I,1);
       Bestg = cg_temp(I,2);
    end    
    
    trace(gen,1) = min(ObjV);
    trace(gen,2) = sum(ObjV)/length(ObjV);
    
    if gen >= MAXGEN/2 && ...
       ( temp_NewBestCVaccuracy-BestMSE ) <= 10^(-4)
        break;
    end
    if gen == MAXGEN
        break;
    end
    gen = gen + 1;
end

%%
figure;
hold on;
trace = round(trace*10000)/10000;
plot(trace(1:gen,1),'r*-','LineWidth',1);
plot(trace(1:gen,2),'b*-','LineWidth',1);
legend('Best Fitness','Average Fitness');
xlabel('Generation','FontSize',8);
ylabel('Fitness','FontSize',8);
grid on;
axis auto;

line1 = 'MSE for SVM';

line2 = ['Best c=',num2str(Bestc),' g=',num2str(Bestg), ...
    ' MSE=',num2str(BestMSE)];
title({line1;line2},'FontSize',6);
