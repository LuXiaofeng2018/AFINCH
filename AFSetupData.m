function AFSetupData(iy)
%%
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Populate variables from memory
WY1        = getappdata(hAFinchGUI,'WY1');
HSR        = getappdata(hAFinchGUI,'HSR');
AFstruct   = getappdata(hAFinchGUI,'AFstruct')
%
disp('<a href="matlab: junk=0;">AFSetupData</a>');
% Run sequence of Matlab scripts to setup data structures 
% Update water year

WY = WY1 + iy -1;
%
fprintf(1,'--------------------------------------------------------------------\n');
fprintf(1,'  AFINCH: Analysis of Flow in Networks of Channels for Water Year\n');
fprintf(1,'    %s in Target Hydrologic Subregion (THS) \n',num2str(WY));
fprintf(1,'--------------------------------------------------------------------\n');
%
% DaysInMo is annual variable that handles leap years
% this vector was replaced by a function AFdaysInMonth-- HWR July 7, 2014
% copied below as necessary
%DaysInMo = [31 30 31 31 eomday(WY,2) 31 30 31 30 31 31 30 337+eomday(WY,2)];
%setappdata(hAFinchGUI,'DaysInMo',DaysInMo);
%
% Run scripts
%% AFReadPrismPrec
% Read in PRISM precipitation and temperature data
AFReadPrismPrec(iy)

%% AFGenStrucData
% Create data structure that contains ComIDs, GridCodes, 
% Stations, for all historical stations in the THS.  Uses a StationList.txt 
% file and csv files generated from ArcMap for each station.
AFGenStrucData(iy)        

%% AFReadInWUseWY
% Read in WY specific water use data.
AFReadInWUseWY(iy)

%% AFReadInFlowWY
% Read in WY specific flows at streamgages
% and non-WY specific water use data.
AFReadInFlowWY(iy)

%% AFStaBasinGridComIDWY
% Generate data files
AFStaBasinGridComIDWY(iy)

%% AFPlotAreaFlowsCompute
% Compute Incremental Areas and Measured and Adjusted Incremental Monthly Flows
% Use QTotWY and QAdjWY computed in AFReadInFlowWY
%
QAdjWY     = getappdata(hAFinchGUI,'QAdjWY');
QTotWY     = getappdata(hAFinchGUI,'QTotWY');
StaHist    = getappdata(hAFinchGUI,'StaHist');
AFstruct   = getappdata(hAFinchGUI,'AFstruct');
NetDesign  = getappdata(hAFinchGUI,'NetDesign');
%
% QAdjWY     = [QAdjWY mean(QAdjWY,2)];
% Compute the incremental flows at gages
QTotIncWY = NetDesign\QTotWY;
QAdjIncWY = NetDesign\QAdjWY;
Ns = getappdata(hAFinchGUI,'Ns');
%
negvalue='no';
negstation=' ';
%
for is=1:Ns,
    AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).QMeaTotInc = QTotIncWY(is,:);
    AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).QMeaAdjInc = QAdjIncWY(is,:);
    for im=1:12
        if AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).QMeaAdjInc(im) < 0
            negvalue='yes';
            negstation=AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).Station;
        end
    end
    AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).WaterYear  = WY;
end
%
if strcmp(negvalue,'yes')
   warndlg(['Incremental negative flow(s) at', negstation,' in water year ',num2str(WY),...
       'Check input data.'], 'Warning');
end
%
StaHist(iy).QTotWY    = QTotWY;
StaHist(iy).QAdjWY    = QAdjWY;
StaHist(iy).QTotIncWY = QTotIncWY;
StaHist(iy).QAdjIncWY = QAdjIncWY;
%
setappdata(hAFinchGUI,'StaHist',StaHist);
setappdata(hAFinchGUI,'AFstruct',AFstruct);
%
%% AFYieldImageCompute
% Compute Measured and Ajdusted Incremental Water Yields for Gaged Basins
% Compute exact yields in inches from monthly flows in cfs
NHDAreaIWY  = getappdata(hAFinchGUI,'NHDAreaIWY');
% make a daysinmonth vector corresponding to current WY
DaysInMo = [31 30 31 31 eomday(WY,2) 31 30 31 30 31 31 30 337+eomday(WY,2)];

%
YTotIncWY = QTotIncWY(:,1:12)./repmat(NHDAreaIWY,1,12) .*...
    repmat((DaysInMo(1:12)*24*3600*12/5280.^2),length(NHDAreaIWY),1);
YAdjIncWY = QAdjIncWY(:,1:12)./repmat(NHDAreaIWY,1,12) .*...
    repmat((DaysInMo(1:12)*24*3600*12/5280.^2),length(NHDAreaIWY),1);
% Store Yields
StaHist(iy).YTotIncWY = YTotIncWY;
StaHist(iy).YAdjIncWY = YAdjIncWY;
StaHist(iy).rYTotIncWY = real(sqrt(YTotIncWY));
StaHist(iy).rYAdjIncWY = real(sqrt(YAdjIncWY));
%
setappdata(hAFinchGUI,'StaHist',StaHist);
%
%% AFReadPrismTemp
% Read in PRISM Temperature and Precipitation data, compute weighted 
% average for active stations, store results in HSR file structure
AFReadPrismTemp(iy)

%% AFAreaWtXVar
% Area weight NLCD and PRISM data
AFAreaWtXVar(iy)

