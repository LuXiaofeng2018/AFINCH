function AFReadPrismPrec(iy)
hAFinchGUI = getappdata(0,'hAFinchGUI');
%
% AFReadPrismPrec reads in ASCII files of precipitation data.
% Creation of these data files requires extensive GIS processing.
% In this analysis, monthly precipitation data was obtained from PRISM data
% sets.  PRISM (Parameter-elevation Regressions on Independent Slopes Model)
% data sets are available as gridded data with a cell size of 2.5-arcmin
% or about 4 km on a side.
%
%% Read in PRISM Precipitation Data for the Water Year
WY1           = getappdata(hAFinchGUI,'WY1');
Ny            = getappdata(hAFinchGUI,'Ny');
nComID_NHDTHS = getappdata(hAFinchGUI,'nComID_NHDTHS');
huclist       = getappdata(hAFinchGUI,'huclist');
HSR           = getappdata(hAFinchGUI,'HSR');
%
WY = WY1 + iy -1;
fprintf(1,'   AFReadPrismPrec for WY %u .\n',WY);
%
temp=char(huclist(1));
region=temp(1:2);
% Read in precipitation data
[GridCode_Prec,AreaSqMi_Prec,PIn(:,01),PIn(:,02),PIn(:,03),PIn(:,04),PIn(:,05),PIn(:,06),...
    PIn(:,07),PIn(:,08),PIn(:,09),PIn(:,10),PIn(:,11),PIn(:,12),PIn(:,13)] = ...
    textread(['..\',HSR,'\PRISM\Precipitation\PrismPrecipWY',...
    num2str(WY),'.dat'],repmat(' %f',1,15),'headerlines',4,'delimiter',' ');
%
%% Intersect GridCodes and ComIDs in target hydrologic subregion
% Note: ComID_NLCDTHS refers to COMIDs from the NLCD data set in THS.
GridCode_NLCDTHS           = getappdata(hAFinchGUI,'GridCode_NLCDTHS');
AreaSqMi_NLCDTHS           = getappdata(hAFinchGUI,'AreaSqMi_NLCDTHS');
[GridCode_Same,ndxa,ndxb]  = intersect(GridCode_Prec,GridCode_NLCDTHS);

GridCode_PrecTHS = GridCode_Prec(ndxa);
AreaSqMi_PrecTHS = AreaSqMi_Prec(ndxa);
PIn_THS          = PIn(ndxa,:);
%
% Identify discrepancies between NLCD and PRSM catchments.
% NLCD is considered the master data set because it is defined in NHDPlus.
%    PRSM catchments are matched to NLCD catchments.
%    If a PRSM catchment is not found to match an NLCD catchment, a PRMS
%    catchment is defined for it as the average precipitation.
%    If a PRSM catchment is defined for a catchment that is not an NLCD
%    catchment, the PRSM catchment is deleted.
%
[GridCode_Dif,ndxa,ndxb] = setxor(GridCode_NLCDTHS,GridCode_PrecTHS);
if ~isempty(GridCode_Dif)
    if ~isempty(ndxa)
        fprintf(1,'Missing catchments detected in PRISM Precipitation within %s.\n',region);
        fprintf(1,'Sequence  Index  GridCode  AreaSqMi \n');
        for i=1:length(ndxa)
            fprintf(1,'  %3u   %6u  %8u  %9.3f \n',...
                i,ndxa,GridCode_NLCDTHS(ndxa),AreaSqMi_NLCDTHS(ndxa));
        end
        AvePrec          = mean(PIn,1);
        GridCode_PrecTHS = [GridCode_PrecTHS; GridCode_NLCDTHS(ndxa)];
        AreaSqMi_PrecTHS = [AreaSqMi_PrecTHS; AreaSqMi_NLCDTHS(ndxa)];
        PIn_THS          = [PIn_THS; repmat(AvePrec(1:13),length(ndxa),1)];
        % Sort PRISM data after augmentation so that order is increasing
        %[GridCode_Dif,ndx1,ndx2] = intersect(GridCode_NLCDTHS,GridCode_PrecTHS);
        [GridCode_PrecTHS,ndx1] = sort(GridCode_PrecTHS);
        AreaSqMi_PrecTHS        =      AreaSqMi_PrecTHS(ndx1);
        PIn_THS                 =      PIn_THS(ndx1,:);
        clear ndx1 ndx2
        %
    elseif ~isempty(ndxb)
        fprintf(1,'\nExtra catchments detected in PRISM Prcipitation within %s.\n',HSR);
        fprintf(1,'Sequence  Index  GridCode   AreaSqMi  \n');
        for i=1:length(ndxb)
            fprintf(1,'  %3u   %6u  %8u  %9.3f \n',...
                i,ndxa(i),GridCode_NLCDTHS(ndxb(i)),AreaSqMi_NLCDTHS(ndxb(i)));
        end
        % Remove catchments, areas, and precipitation not included in NLCD dataset.
        GridCode_PrecTHS = setdiff(GridCode_PrecTHS,GridCode_PrecTHS(ndxb));
        AreaSqMi_PrecTHS = setdiff(AreaSqMi_PrecTHS,AreaSqMi_PrecTHS(ndxb));
        PIn_THS          = setdiff(PIn_THS,PIn_THS(ndxb,:),'rows');
    end
end
% Set gridcode length after dimensional augmentation or reduction
nGridCode_PrecTHS = length(GridCode_PrecTHS);
%
%% Populate PrsmPrecTHS 3-D array with annual PRISM precipitation
%
PrsmPrecTHS = getappdata(hAFinchGUI,'PrsmPrecTHS');
if ~exist('PrsmPrecTHS','var')
    PrsmPrecTHS = zeros(Ny,nComID_NHDTHS,13);
end
% Store monthly precipitation for time=0 to PIn0
if WY<WY1
    setappdata(hAFinchGUI,'PIn0',PIn_THS);
else
    PrsmPrecTHS(iy,:,:) = PIn_THS;
    setappdata(hAFinchGUI,'PrsmPrecTHS',PrsmPrecTHS);
end
%
% Update GUI memory
setappdata(hAFinchGUI,'PIn_THS',PIn_THS);
setappdata(hAFinchGUI,'AreaSqMi_PrecTHS',AreaSqMi_PrecTHS);
setappdata(hAFinchGUI,'GridCode_PrecTHS',GridCode_PrecTHS);


