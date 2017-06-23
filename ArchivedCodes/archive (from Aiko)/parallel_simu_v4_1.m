CL_EPW_PATH = 'C:\Users\Jason\Desktop\Test2\Boston_commercial';
CL_EPW = 'boston.epw';
CL_XML_PATH = 'C:\Users\Jason\Desktop\Test2\Boston_commercial';
CL_XML = {'Commercial-ruralRoadVHC_High.xml','Commercial-ruralRoadVHC_Low.xml',...
    'Commercial-ruralVegFraction_High.xml','Commercial-ruralVegFraction_Low.xml'...
    'Commercial-sensibleAnthroHeat_High.xml','Commercial-sensibleAnthroHeat_Low.xml'...
    'Commercial-treeCoverage_High.xml','Commercial-treeCoverage_Low.xml',...
    'Commercial-urbanRoadAlbedo_High.xml','Commercial-urbanRoadAlbedo_Low.xml',...
    'Commercial-urbanRoadK_High.xml','Commercial-urbanRoadK_Low.xml',...
    'Commercial-urbanRoadVegFraction_High.xml','Commercial-urbanRoadVegFraction_Low.xml',...
    'Commercial-urbanRoadVHC_High.xml','Commercial-urbanRoadVHC_Low.xml',...
    'Commercial-vHRatios_High.xml','Commercial-vHRatios_Low.xml',...
    'Commercial-wallVegCoverage_High.xml','Commercial-wallVegCoverage_Low.xml',...    
    };

for i = 1:length(CL_XML)
    currcity = 'Boston_';
    run = strcat(currcity, CL_XML{i});
    disp(run); 
    [new_climate_file] = generateEPW_10_xml_AN10_importdata(CL_EPW_PATH,CL_EPW,CL_XML_PATH,run);
end

