function [gof,cons] = ObjectiveFunction(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Input and output path
currentPath=pwd;
inputPath = strcat(currentPath,'\SensitivityAnalysis\Inputs.xlsx');
interfacePath = strcat(currentPath,'\data\RunUWG_AD_GA.xlsm');
bld2Path = strcat(currentPath,'\data\DOERefBuildings\BLD2.xlsx');
bld3Path = strcat(currentPath,'\data\DOERefBuildings\BLD3.xlsx');
bld4Path = strcat(currentPath,'\data\DOERefBuildings\BLD4.xlsx');
bld6Path = strcat(currentPath,'\data\DOERefBuildings\BLD6.xlsx');
bld10Path = strcat(currentPath,'\data\DOERefBuildings\BLD10.xlsx');
bld14Path = strcat(currentPath,'\data\DOERefBuildings\BLD14.xlsx');
resultPath = strcat(currentPath,'\output\UWGoutput.xlsx');
outputPath = strcat(currentPath,'\SensitivityAnalysis\2016data\OutputsDec.xlsx');

%% Update model inputs
t1_start=tic;
% Update meteorological factor
% xlswrite(interfacePath,num(i,1),1,'D4');    % A1
xlswrite(interfacePath,x(1),1,'D5');    % A2
xlswrite(interfacePath,x(2),1,'D6');    % A3
% xlswrite(interfacePath,num(i,4),1,'D9');    % A4
xlswrite(interfacePath,x(3),1,'D10');   % A5
% xlswrite(interfacePath,num(i,6),1,'D11');   % A6
% xlswrite(interfacePath,num(i,7),1,'D12');   % A7

% Update urban characteristics
% xlswrite(interfacePath,num(i,8),1,'D15');   % B1
xlswrite(interfacePath,x(4),1,'D16');   % B2
xlswrite(interfacePath,x(5),1,'D17');  % B3
% xlswrite(interfacePath,num(i,11),1,'D18');  % B4
xlswrite(interfacePath,x(6),1,'D19');  % B5
% xlswrite(interfacePath,num(i,13),1,'D21');  % B6
% xlswrite(interfacePath,num(i,14),1,'D23');  % B7

% Update vegetation varible
% xlswrite(interfacePath,num(i,15),1,'D25');  % C1
% xlswrite(interfacePath,num(i,16),1,'D26');  % C2
% xlswrite(interfacePath,num(i,17),1,'D29');  % C3
% xlswrite(interfacePath,num(i,18),1,'D30');  % C4
% xlswrite(interfacePath,num(i,19),1,'D31');  % C5
% xlswrite(interfacePath,num(i,20),1,'D32');  % C6

% Update building system BLD2
% xlswrite(bld2Path,num(i,21),1,'D5');    % D1
% xlswrite(bld2Path,num(i,22),3,'E38');   % D2
% xlswrite(bld2Path,num(i,23),3,'E8');    % D3
% xlswrite(bld2Path,num(i,24),3,'E9');    % D4
% xlswrite(bld2Path,num(i,25),2,'U3');    % D5
% xlswrite(bld2Path,num(i,26),3,'E12');   % D6
xlswrite(bld2Path,x(7),4,'G11');   % D7
xlswrite(bld2Path,x(8),2,'N3');    % D8
% xlswrite(bld2Path,num(i,29),2,'M3');    % D9
% xlswrite(bld2Path,num(i,30),2,'L6');    % D10

% Update building system BLD3
% xlswrite(bld3Path,num(i,21),1,'D5');    % D1
% xlswrite(bld3Path,num(i,22),3,'E38');   % D2
% xlswrite(bld3Path,num(i,23),3,'E8');    % D3
% xlswrite(bld3Path,num(i,24),3,'E9');    % D4
% xlswrite(bld3Path,num(i,25),2,'U3');    % D5
% xlswrite(bld3Path,num(i,26),3,'E12');   % D6
xlswrite(bld3Path,x(7),4,'G11');   % D7
xlswrite(bld3Path,x(8),2,'N3');    % D8
% xlswrite(bld3Path,num(i,29),2,'M3');    % D9
% xlswrite(bld3Path,num(i,30),2,'L6');    % D10

% Update building system BLD4
% xlswrite(bld4Path,num(i,21),1,'D5');    % D1
% xlswrite(bld4Path,num(i,22),3,'E38');   % D2
% xlswrite(bld4Path,num(i,23),3,'E8');    % D3
% xlswrite(bld4Path,num(i,24),3,'E9');    % D4
% xlswrite(bld4Path,num(i,25),2,'U3');    % D5
% xlswrite(bld4Path,num(i,26),3,'E12');   % D6
xlswrite(bld4Path,x(7),4,'G11');   % D7
xlswrite(bld4Path,x(8),2,'N3');    % D8
% xlswrite(bld4Path,num(i,29),2,'M3');    % D9
% xlswrite(bld4Path,num(i,30),2,'L6');    % D10

% Update building system BLD6
% xlswrite(bld6Path,num(i,21),1,'D5');    % D1
% xlswrite(bld6Path,num(i,22),3,'E38');   % D2
% xlswrite(bld6Path,num(i,23),3,'E8');    % D3
% xlswrite(bld6Path,num(i,24),3,'E9');    % D4
% xlswrite(bld6Path,num(i,25),2,'U3');    % D5
% xlswrite(bld6Path,num(i,26),3,'E12');   % D6
xlswrite(bld6Path,x(7),4,'G11');   % D7
xlswrite(bld6Path,x(8),2,'N3');    % D8
% xlswrite(bld6Path,num(i,29),2,'M3');    % D9
% xlswrite(bld6Path,num(i,30),2,'L6');    % D10

% Update building system BLD10
% xlswrite(bld10Path,num(i,21),1,'D5');    % D1
% xlswrite(bld10Path,num(i,22),3,'E38');   % D2
% xlswrite(bld10Path,num(i,23),3,'E8');    % D3
% xlswrite(bld10Path,num(i,24),3,'E9');    % D4
% xlswrite(bld10Path,num(i,25),2,'U3');    % D5
% xlswrite(bld10Path,num(i,26),3,'E12');   % D6
xlswrite(bld10Path,x(7),4,'G11');   % D7
xlswrite(bld10Path,x(8),2,'N3');    % D8
% xlswrite(bld10Path,num(i,29),2,'M3');    % D9
% xlswrite(bld10Path,num(i,30),2,'L6');    % D10

% Update building system BLD14
% xlswrite(bld14Path,num(i,21),1,'D5');    % D1
% xlswrite(bld14Path,num(i,22),3,'E38');   % D2
% xlswrite(bld14Path,num(i,23),3,'E8');    % D3
% xlswrite(bld14Path,num(i,24),3,'E9');    % D4
% xlswrite(bld14Path,num(i,25),2,'U3');    % D5
% xlswrite(bld14Path,num(i,26),3,'E12');   % D6
xlswrite(bld14Path,x(7),4,'G11');   % D7
xlswrite(bld14Path,x(8),2,'N3');    % D8
% xlswrite(bld14Path,num(i,29),2,'M3');    % D9
% xlswrite(bld14Path,num(i,30),2,'L6');    % D10

t1=toc(t1_start);
sprintf('updating model input costs %d seconds',t1)
%% Run simulation
t2_start=tic;
[~,TPred]=UWGGA;
t2=toc(t2_start);
sprintf('simulation costs %d seconds',t2)

m=load('Dec1to7');
%% Calculate and output the objective and constrants
w_nmbe=0.75;
gof=GOF(TPred,m.measure,w_nmbe);

% constraints if any
cons=[];

%% unlock function in memory
munlock UWGGA;

end