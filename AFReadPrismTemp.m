function AFReadPrismTemp(iy)
hAFinchGUI        = getappdata(0,'hAFinchGUI');
huclist           = getappdata(hAFinchGUI,'huclist');
WY1               = getappdata(hAFinchGUI,'WY1');
Ny                = getappdata(hAFinchGUI,'Ny');
nGridCode_NLCDTHS = getappdata(hAFinchGUI,'nGridCode_NLCDTHS');
 GridCode_NLCDTHS = getappdata(hAFinchGUI, 'GridCode_NLCDTHS');
HSR               = getappdata(hAFinchGUI,'HSR');
%
WY = WY1 + iy -1;
% Read in Monthly Average PRISM Temperature
% stations, store results in HSR file structure
% TdC represents Temperature in degrees Celsius.

disp('<a href="matlab: junk=0;">AFReadPrismTemp</a>');
fprintf(1,'                 Reading Monthly PRISM Temperature Data.\n');
temp=char(huclist(1));
region=temp(1:2);

[GridCode_Temp TdC(:,1) TdC(:,2) TdC(:,3) TdC(:,4) TdC(:,5) TdC(:,6)...
    TdC(:,7) TdC(:,8) TdC(:,9) TdC(:,10) TdC(:,11) TdC(:,12)] = textread(...
    ['..\',HSR,'\PRISM\Temperature\PrismTempAveWY' num2str(WY) '.dat'],...
    '%u %f%f%f%f%f%f%f%f%f%f%f%f','headerlines',4);
%
nGridCode_Temp = length(GridCode_Temp);
% If undefined, allocate array to contain land use info
if ~exist('PrsmTempTHS','var');
    PrsmTempTHS = NaN(Ny,nGridCode_NLCDTHS,12);
end
%
%% Intersect GridCodes and ComIDs in target hydrologic subregion
% Note: ComID_NLCDTHS refers to COMIDs from the NLCD data set in THS.
[~,ndxa,ndxb]     = intersect(GridCode_Temp,GridCode_NLCDTHS);

GridCode_TempTHS = GridCode_Temp(ndxa);
TdC_THS          = TdC(ndxa,:);
%
% Identify discrepancies between NLCD and PRSM catchments.
% NLCD is considered the master data set because it is defined in NHDPlus.
%    PRSM catchments are matched to NLCD catchments.
%    If a PRSM catchment is not found to match an NLCD catchment, a PRMS
%    catchment is defined for it as the average precipitation.
%    If a PRSM catchment is defined for a catchment that is not an NLCD
%    catchment, the PRSM catchment is deleted.
%
[GridCode_Dif,ndxa,ndxb] = setxor(GridCode_NLCDTHS,GridCode_TempTHS);
if ~isempty(GridCode_Dif)
    if ~isempty(ndxa)
        fprintf(1,'Missing catchments detected in PRISM Temperature within %s.\n',region);
        fprintf(1,'Sequence  Index  GridCode  AreaSqMi \n');
        for i=1:length(ndxa)
            fprintf(1,'  %3u   %6u  %8u  %9.3f \n',...
                i,ndxa(i),GridCode_NLCDTHS(ndxa(i)),AreaSqMi_NLCDTHS(ndxa(i)));
        end
        AveTemp          = mean(TdC,1);
        GridCode_TempTHS = [GridCode_TempTHS; GridCode_NLCDTHS(ndxa)];
        %      AreaSqMi_TempTHS = [AreaSqMi_TempTHS; AreaSqMi_NLCDTHS(ndxa)];
        TdC_THS          = [TdC_THS; repmat(AveTemp(1:12),length(ndxa),1)];
        % Sort PRISM data after augmentation so that order is increasing
        [GridCode_TempTHS,ndx1] = sort(GridCode_TempTHS);
        TdC_THS                 =      TdC_THS(ndx1,:);
        clear ndx1 ndx2
        %
    elseif ~isempty(ndxb)
        fprintf(1,'\nExtra catchments detected in PRISM Temperature within %s.\n',region);
        fprintf(1,'Sequence  Index  GridCode   AreaSqMi  \n');
        for i=1:length(ndxb)
            fprintf(1,'  %3u   %6u  %8u  %9.3f \n',...
                i,ndxa(i),GridCode_NLCDTHS(ndxb(i)),AreaSqMi_NLCDTHS(ndxb(i)));
        end
        % Remove catchments, areas, and precipitation not included in NLCD dataset.
        GridCode_TempTHS = setdiff(GridCode_PrecTHS,GridCode_PrecTHS(ndxb));
        %         AreaSqMi_TempTHS = setdiff(AreaSqMi_PrecTHS,AreaSqMi_PrecTHS(ndxb));
        TdC_THS          = setdiff(TdC_THS,TdC_THS(ndxb,:),'rows');
    end
end
% Set gridcode length after dimensional augmentation or reduction
nGridCode_TempTHS = length(GridCode_TempTHS);
%
%% Populate PrsmTempTHS 3-D array with annual PRISM temperature
%
PrsmTempTHS     = getappdata(hAFinchGUI,'PrsmTempTHS');
if ~exist('PrsmTempTHS','var')
    PrsmTempTHS = zeros(Ny,nComID_NHDTHS,12);
end
%
PrsmTempTHS(iy,:,:) = TdC_THS;
%
% Refresh memory variables
setappdata(hAFinchGUI,'PrsmTempTHS',PrsmTempTHS);
setappdata(hAFinchGUI,'nGridCode_TempTHS',nGridCode_TempTHS);
setappdata(hAFinchGUI, 'GridCode_TempTHS' ,GridCode_TempTHS);
setappdata(hAFinchGUI, 'TdC_THS'          ,TdC_THS);