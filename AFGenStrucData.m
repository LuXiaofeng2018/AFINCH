function AFGenStrucData(iy)
hAFinchGUI = getappdata(0,'hAFinchGUI');
%
% Generate structured data file from dbf (csv) file integrating ComIDs and
% gridcode.  The StaTHS info describes streamgages that have been
% historically operated in the Target Hydrologic Subregion.
% Fields in the csv files are:
% ID, GRIDCODE, OID_, NDX, SUMNO, COMID, AREASQKM, GRIDCODE_1, FID_1,
% FID_12, REACHCODE, COMID_1, FROMMEAS, TOMEAS
% 
% Explanation for selected fields:
% GRIDCODE:   Unique id for each catchment   
% COMID:      Unique id for each reach   
% AREASQKM:   Catchment area in square kilometers
% REACHCODE:  14-digit string identifying HUC.      
%% Setup Structure Variable for Streamgage Data
disp('<a href="matlab: junk=0;">AFGenStrucData</a>');
fprintf(1,'\n                 Creating data structures for all streamgages.\n');
fprintf(1,'  Contains GridCode, ComID, AreaSqKm, and ReachCode sets for\n');
fprintf(1,'  historically gaged basins.\n');
%
% Create structure for SubHydrologic Region if doesn't already exist 
WY1      = getappdata(hAFinchGUI,'WY1');
Ny       = getappdata(hAFinchGUI,'Ny');
huclist  = getappdata(hAFinchGUI,'huclist');
HSR      = getappdata(hAFinchGUI,'HSR');
in4digit = getappdata(hAFinchGUI,'in4digit');
ioDir    = getappdata(hAFinchGUI,'ioDir');
AFstruct = getappdata(hAFinchGUI,'AFstruct');
%
WY = WY1 + iy -1;
THSYear = strcat('THS',num2str(WY));
%
% The StationList.txt files contains one field of streamgage numbers
% and as many rows as stations ever gaged in the hydrologic subregion.
seenHUC=containers.Map;
StaFileRead = 0;
for i=1:length(huclist)
    tempname=char(huclist);
    THS=tempname(i,1:4);
    if isKey(seenHUC,THS)
        %skip reading stations more than once- organized by 4-digit HUC
        seenHUC(THS)=seenHUC(THS)+1;
    else
        if StaFileRead == 0
            % Folder   = ['\',HSR,'\GagedCatchments\'];
            templist   = textread([ioDir,'\GagedCatchments\','StationList.txt'],'%s',...
                'commentstyle','c');
            % sort stationlist file and save sorted list to StaThs
            %
            templistS  = sort(templist);
            if i==1
                StaTHS=templistS;
            else
                StaTHS=vertcat(StaTHS,templistS);
            end
            StaFileRead = 1;
        end
        seenHUC(THS)=1;
    end
end
%
NStaTHS  = length(StaTHS);  % NStaTHS is the number of streamgages 
%                                   in the Target Hydrologic Subregion
%
% If not existing, initialize matrix to identify which stations...
%   were operating each year during the Period of Analysis (POA)
if ~exist('POA','var');
    POA = zeros(NStaTHS,Ny,'int8');
end
%% Read in Gridcodes and Flowlines Associated Streamgages for WY
% A separate file is created for each station historically gaged.
% The file is constructed in ArcMap by use of the Flowtable or VAA
% navigator.  Once the ComID at the gage station is identified, all
% upstream ComIDs and corresponding catchments (if any) are associated
% their GridCodes
% identify all ComIDs and GridCodes upstream of a streamgage.  
for is=1:NStaTHS,
    [GridCodeWY,ComIDWY,AreaSqKmWY,ReachCodeWY] = textread(...
        fullfile(ioDir,'GagedCatchments',[StaTHS{is},'.dat']),...
        '%u %u %f %s','delimiter',',','headerlines',1);
    AFstruct.(HSR)(iy,is).Station     = StaTHS(is);
    AFstruct.(HSR)(iy,is).GridCode    = GridCodeWY;
    AFstruct.(HSR)(iy,is).ComID       = ComIDWY;
    AFstruct.(HSR)(iy,is).AreaSqKm    = AreaSqKmWY;
    AFstruct.(HSR)(iy,is).TotAreaSqMi = sum(AFstruct.(HSR)(iy,is).AreaSqKm)*...
        0.386102159;
    AFstruct.(HSR)(iy,is).ReachCode   = reshape([ReachCodeWY{:}]',14,[])';
    % The statement below initializes water use but is not populated here.
    AFstruct.(HSR)(iy,is).WaterUse    = zeros(1,12);
    %
end
% Refresh hAFinchGUI memory variables
setappdata(hAFinchGUI,'AFstruct',AFstruct');
setappdata(hAFinchGUI,'StaTHS',StaTHS);
setappdata(hAFinchGUI,'NStaTHS',NStaTHS);
    

