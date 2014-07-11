function AFStaBasinGridComIDWY(iy)
%%
hAFinchGUI = getappdata(0,'hAFinchGUI');
HSR        = getappdata(hAFinchGUI,'HSR');
AFstruct   = getappdata(hAFinchGUI,'AFstruct');
StaWY      = getappdata(hAFinchGUI,'StaWY');
Q          = getappdata(hAFinchGUI,'Q');
StaHist    = getappdata(hAFinchGUI,'StaHist');
ComIDSta   = getappdata(hAFinchGUI,'ComIDSta');
ComID_WU   = getappdata(hAFinchGUI,'ComID_WU');
WUseWY     = getappdata(hAFinchGUI,'WUseWY');
NWISArea   = getappdata(hAFinchGUI,'NWISArea');
WY1        = getappdata(hAFinchGUI,'WY1');
%
WY = WY1 + iy -1;
%
disp('<a href="matlab: junk=0;">AFStaBasinGridComIDWY</a>');
fprintf(1,'AFStaBasinGridComIDWY: Creating/populating StaHist structure,\n');
fprintf(1,'                       Determining the annual Network Design Matrix.\n');
% This script generates the network design matrix specific to a given year.
% Station is a list of the historical streamgages in the current region
% StationQ is a list of all the active streamgages in a particular year
% StationList is the station numbers active in a given year
% StationNdx is the index within SHR0405.
%
% The intersection below integrates information about gages operated 
% historically and gages operated in a specific water year. 
%%
%
% $$ [StaList, ia, ib ] = StationAll \cap StationWY $$
%
% StaList = StationAll(ia);  StaList = StationWY(ib);
%
[StaList,StaNdx,FloNdx]=intersect([AFstruct.(HSR)(iy,:).Station],StaWY);
% Ns is the number of active stations in a given year
Ns = length(StaList);
%
%% Create station history structure variable
if ~exist('StaHist','var')
    StaHist = struct('StaList',-9999,'StaNdx',-9999,'NStaAct',-9999,...
        'QTotWY',-9999.,'QAdjWY',-9999.,...
        'QTotIncWY',-9999.,'QAdjIncWY',-9999.);
end
%% Populate station history
StaHist(iy).StaList = StaList';
StaHist(iy).StaNdx  = StaNdx';
StaHist(iy).NStaAct = Ns;
%
% QTotWY is the total flow at the streamgages
QTotWY = Q(FloNdx,:);
% Also, compute the flow adjusted for water use
%
% For each active station in SHR0405, get all the GRIDCODEs
% GridCodes = SHR0405(StationNdx(1)).GridCode;
% For these GridCodes
% NStaAct is the number of active stations in a specific Water Year
for is=1:Ns,
    fprintf(1,'%5u %5u %s \n',is,StaNdx(is),...
        [AFstruct.(HSR)(iy,StaNdx(is)).Station{:}]);
    AFstruct.(HSR)(iy,StaNdx(is)).SBGridCode  = ...
        AFstruct.(HSR)(iy,StaNdx(is)).GridCode;
    AFstruct.(HSR)(iy,StaNdx(is)).SBComID     = ...
        AFstruct.(HSR)(iy,StaNdx(is)).ComID;
    AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm  = ...
        AFstruct.(HSR)(iy,StaNdx(is)).AreaSqKm;
    AFstruct.(HSR)(iy,StaNdx(is)).SBReachCode = ...
        AFstruct.(HSR)(iy,StaNdx(is)).ReachCode;
    % Find the index for the station in the total station list
    ndxStaComID = find(strcmp(AFstruct.(HSR)(iy,StaNdx(is)).Station,StaWY)==1);
    % Find the ComID of the station
    StaComID   = ComIDSta(ndxStaComID);
    % Find that ComID in the water use matrix
    ndxComID = find(StaComID==ComID_WU);
%     [ComIDwu,ia,ib] = intersect(AFstruct.(HSR)(iy,StaNdx(is)).ComID,...
%         ComID_WU);
    if ~isempty(ndxComID)
%         fprintf(1,'     Number of reaches with specified WU %u \n',...
%             length(ComID));
        % [junk,Ndxa,Ndxb] = intersect(ComIDwu,ComID_NHDTHS);
        fprintf(1,'Station = %s, ComID_WU= %u\n',...
            AFstruct.(HSR)(iy,StaNdx(is)).Station{:},ComID_WU(ndxComID));
        AFstruct.(HSR)(iy,StaNdx(is)).WaterUse    =  WUseWY(ndxComID,:);
    end
end
%% Define the Network Design Matrix
% Initalize the Network Design Matrix as an identity matrix 
NetDesign = eye(Ns);
%
for is=1:(Ns-1),
    % "js" is a local index tracking the station index "is".
    for js=is+1:Ns,
        % Find any common catchments within the two streamgages
        [GC,Ndx] = intersect(AFstruct.(HSR)(iy,StaNdx(is)).SBGridCode,...
            AFstruct.(HSR)(iy,StaNdx(js)).SBGridCode);
        % If the basins are nested, remove the common catchments from the
        % lower gaged area
        if ~isempty(Ndx)
            NetDesign(js,is) = 1;
            [GC,Ndx] = setdiff(AFstruct.(HSR)(iy,StaNdx(js)).SBGridCode,...
                AFstruct.(HSR)(iy,StaNdx(is)).SBGridCode);
            AFstruct.(HSR)(iy,StaNdx(js)).SBGridCode  = ...
                AFstruct.(HSR)(iy,StaNdx(js)).SBGridCode(Ndx);
            AFstruct.(HSR)(iy,StaNdx(js)).SBComID     = ...
                AFstruct.(HSR)(iy,StaNdx(js)).SBComID(Ndx);
            AFstruct.(HSR)(iy,StaNdx(js)).SBAreaSqKm  = ...
                AFstruct.(HSR)(iy,StaNdx(js)).SBAreaSqKm(Ndx);
            AFstruct.(HSR)(iy,StaNdx(js)).SBReachCode = ...
                AFstruct.(HSR)(iy,StaNdx(js)).SBReachCode(Ndx);
        end
    end
end
%
%% Check that the Network Design Matrix is valid
for js = 1:Ns,
    netElem = NetDesign(js,1);
    for is = 1:js,
        % Check for ones in the diagonal
        if is == js && NetDesign(js,is)~=1
            errordlg(['Diagonal component ',num2str(js),...
                ' in the network design matrix for water year ',num2str(WY),' is not equal to one.'],...
                'Error in the diagonal of the Network Design Matrix.');
        end
        % Check for graded rows
        if NetDesign(js,is) < netElem
            errordlg(['The network design matrix for water year ',num2str(WY),' is not graded along its rows. '...
                'Problem found in row ',num2str(js),' and column ',num2str(is),'.'],...
                'Error in the grading of network design matrix.');
        end
        netElem = NetDesign(js,is);
        % Check that upper triangular components are zero
        allZeros = triu(NetDesign,1);
        ndxBad = find(allZeros~=0, 1);
        if ~isempty(ndxBad)
            errordlg(['Not all upper triangular components in the network design matrix '...
                'for water year ',num2str(WY),' are equal to zero.'],...
                'Nonzero component in the triu(NetDesign) matrix');
        end
    end
end
%        
%% Plot the Network Design Matrix
% The plot function has been moved to AFDesignMatrixDAreasGUI
% Use NetDesign matrix to compute incremental areas at gaged stations
NWISAreaIWY   = NetDesign\NWISArea(FloNdx);
NHDAreaIWY   = NetDesign\[AFstruct.(HSR)(iy,StaNdx).TotAreaSqMi]';
StaHist(iy).NWISAreaIWY = NWISAreaIWY;
StaHist(iy).NHDAreaIWY  =  NHDAreaIWY;
%
%% Printout GridCodes and ComIDs for each subbasin in WY
fid = fopen(['StaBasinGridComIDWY' num2str(WY) '.dat'],'wt');
% fprintf(1,'  WY  StaSeq Station SubBasin GridCode  ComID  SBAreaSqMi\n');
for is=1:Ns,
    % find out how many records are in ith station
    Nr = length(AFstruct.(HSR)(iy,StaNdx(is)).SBGridCode);
    for r=1:Nr,
        %         % Print to file
        fprintf(fid,'%4.0f %3u %s %4u %8u %9u %7.3f \n',...
            WY, is, StaList{is}, r, ...
            AFstruct.(HSR)(iy,StaNdx(is)).SBGridCode(r),...
            AFstruct.(HSR)(iy,StaNdx(is)).SBComID(r),0.3861*...
            AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm(r));
    end
end
fclose(fid);
% Refresh memory variables
setappdata(hAFinchGUI,'StaHist' ,StaHist);
setappdata(hAFinchGUI,'StaList' ,StaList);
setappdata(hAFinchGUI,'StaNdx'  ,StaNdx);
setappdata(hAFinchGUI,'AFstruct',AFstruct);
setappdata(hAFinchGUI,'NWISAreaIWY',NWISAreaIWY);
setappdata(hAFinchGUI,'NHDAreaIWY',NHDAreaIWY);
setappdata(hAFinchGUI,'NetDesign',NetDesign);
setappdata(hAFinchGUI,'Ns',Ns);
setappdata(hAFinchGUI,'FloNdx',FloNdx);
%
