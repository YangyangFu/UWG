CL_EPW_PATH = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data\AbuDhabi\';
CL_EPW = 'MasdarWeather2015_EPW.epw';

CL_RE_PATH = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\output\';
CL_RE = 'MasdarWeather2015_EPW_UWG.epw';

CL_XML_PATH = 'C:\Users\maoj\Dropbox\UWG_Matlab-master\data';
% CL_XML = {
%     'BackBayStation_27.xml'
%      };
% CL_XML = {
%     'initialize.m'
%      };
CL_XML = {
    'RunUWG_AD.xlsm'
     };
 
for i = 1:length(CL_XML)
    [new_climate_file] = UWG(CL_EPW_PATH,CL_EPW,CL_XML_PATH,CL_XML{i},CL_RE_PATH,CL_RE);
end