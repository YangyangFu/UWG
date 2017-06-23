function [ UWGCalibrate ] = Calibrate( inputPath, interfacePath, bld2Path, bld3Path, bld4Path, bld6Path, bld10Path, bld14Path, resultPath, outputPath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Input and output path
inputPath = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\SensitivityAnalysis\Inputs.xlsx';
interfacePath = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data\RunUWG_AD_GA.xlsm';
bld2Path = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data\DOERefBuildings\BLD2.xlsx';
bld3Path = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data\DOERefBuildings\BLD3.xlsx';
bld4Path = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data\DOERefBuildings\BLD4.xlsx';
bld6Path = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data\DOERefBuildings\BLD6.xlsx';
bld10Path = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data\DOERefBuildings\BLD10.xlsx';
bld14Path = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data\DOERefBuildings\BLD14.xlsx';
resultPath = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\output\UWGoutput.xlsx';
outputPath = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\SensitivityAnalysis\2016data\OutputsDec.xlsx';

%% Update model inputs
    % Update meteorological factor
    % xlswrite(interfacePath,num(i,1),1,'D4');    % A1
    xlswrite(interfacePath,num(i,2),1,'D5');    % A2
    xlswrite(interfacePath,num(i,3),1,'D6');    % A3
    % xlswrite(interfacePath,num(i,4),1,'D9');    % A4
    xlswrite(interfacePath,num(i,5),1,'D10');   % A5
    % xlswrite(interfacePath,num(i,6),1,'D11');   % A6
    % xlswrite(interfacePath,num(i,7),1,'D12');   % A7
    
    % Update urban characteristics
    % xlswrite(interfacePath,num(i,8),1,'D15');   % B1
    xlswrite(interfacePath,num(i,9),1,'D16');   % B2
    xlswrite(interfacePath,num(i,10),1,'D17');  % B3
    % xlswrite(interfacePath,num(i,11),1,'D18');  % B4
    xlswrite(interfacePath,num(i,12),1,'D19');  % B5
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
    xlswrite(bld2Path,num(i,27),4,'G11');   % D7
    xlswrite(bld2Path,num(i,28),2,'N3');    % D8
    % xlswrite(bld2Path,num(i,29),2,'M3');    % D9
    % xlswrite(bld2Path,num(i,30),2,'L6');    % D10
    
    % Update building system BLD3
    % xlswrite(bld3Path,num(i,21),1,'D5');    % D1
    % xlswrite(bld3Path,num(i,22),3,'E38');   % D2
    % xlswrite(bld3Path,num(i,23),3,'E8');    % D3
    % xlswrite(bld3Path,num(i,24),3,'E9');    % D4
    % xlswrite(bld3Path,num(i,25),2,'U3');    % D5
    % xlswrite(bld3Path,num(i,26),3,'E12');   % D6
    xlswrite(bld3Path,num(i,27),4,'G11');   % D7
    xlswrite(bld3Path,num(i,28),2,'N3');    % D8
    % xlswrite(bld3Path,num(i,29),2,'M3');    % D9
    % xlswrite(bld3Path,num(i,30),2,'L6');    % D10
    
    % Update building system BLD4
    % xlswrite(bld4Path,num(i,21),1,'D5');    % D1
    % xlswrite(bld4Path,num(i,22),3,'E38');   % D2
    % xlswrite(bld4Path,num(i,23),3,'E8');    % D3
    % xlswrite(bld4Path,num(i,24),3,'E9');    % D4
    % xlswrite(bld4Path,num(i,25),2,'U3');    % D5
    % xlswrite(bld4Path,num(i,26),3,'E12');   % D6
    xlswrite(bld4Path,num(i,27),4,'G11');   % D7
    xlswrite(bld4Path,num(i,28),2,'N3');    % D8
    % xlswrite(bld4Path,num(i,29),2,'M3');    % D9
    % xlswrite(bld4Path,num(i,30),2,'L6');    % D10
    
    % Update building system BLD6
    % xlswrite(bld6Path,num(i,21),1,'D5');    % D1
    % xlswrite(bld6Path,num(i,22),3,'E38');   % D2
    % xlswrite(bld6Path,num(i,23),3,'E8');    % D3
    % xlswrite(bld6Path,num(i,24),3,'E9');    % D4
    % xlswrite(bld6Path,num(i,25),2,'U3');    % D5
    % xlswrite(bld6Path,num(i,26),3,'E12');   % D6
    xlswrite(bld6Path,num(i,27),4,'G11');   % D7
    xlswrite(bld6Path,num(i,28),2,'N3');    % D8
    % xlswrite(bld6Path,num(i,29),2,'M3');    % D9
    % xlswrite(bld6Path,num(i,30),2,'L6');    % D10
    
    % Update building system BLD10
    % xlswrite(bld10Path,num(i,21),1,'D5');    % D1
    % xlswrite(bld10Path,num(i,22),3,'E38');   % D2
    % xlswrite(bld10Path,num(i,23),3,'E8');    % D3
    % xlswrite(bld10Path,num(i,24),3,'E9');    % D4
    % xlswrite(bld10Path,num(i,25),2,'U3');    % D5
    % xlswrite(bld10Path,num(i,26),3,'E12');   % D6
    xlswrite(bld10Path,num(i,27),4,'G11');   % D7
    xlswrite(bld10Path,num(i,28),2,'N3');    % D8
    % xlswrite(bld10Path,num(i,29),2,'M3');    % D9
    % xlswrite(bld10Path,num(i,30),2,'L6');    % D10
    
    % Update building system BLD14
    % xlswrite(bld14Path,num(i,21),1,'D5');    % D1
    % xlswrite(bld14Path,num(i,22),3,'E38');   % D2
    % xlswrite(bld14Path,num(i,23),3,'E8');    % D3
    % xlswrite(bld14Path,num(i,24),3,'E9');    % D4
    % xlswrite(bld14Path,num(i,25),2,'U3');    % D5
    % xlswrite(bld14Path,num(i,26),3,'E12');   % D6
    xlswrite(bld14Path,num(i,27),4,'G11');   % D7
    xlswrite(bld14Path,num(i,28),2,'N3');    % D8
    % xlswrite(bld14Path,num(i,29),2,'M3');    % D9
    % xlswrite(bld14Path,num(i,30),2,'L6');    % D10
    
%% Run simulation
    UWGGA;
    
%% Calculate the objective function


%% GA search


%% Output final solutions


end