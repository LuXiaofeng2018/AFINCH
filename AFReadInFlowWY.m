function AFReadInFlowWY(iy)
hAFinchGUI = getappdata(0,'hAFinchGUI');
THS        = getappdata(hAFinchGUI,'THS');
WY1         = getappdata(hAFinchGUI,'WY1');
ioDir      = getappdata(hAFinchGUI,'ioDir');
StaTHS     = getappdata(hAFinchGUI,'StaTHS');
ComID_WU   = getappdata(hAFinchGUI,'ComID_WU');
WUseWY     = getappdata(hAFinchGUI,'WUseWY');
%
WY = WY1 + iy -1;
%% Read in monthly flows at all active streamgages in the region for a specific WY
fprintf(1,'\n AFReadInFlowWY: Reading in flows at active streamgages.\n');
% Read in the flow data at active stations for a specific water year 
% FileIn = strcat(['..\HSR',THS(1:2),'00\Streamflow\ComIDStationDAMoAnQ'],num2str(WY));
FileIn = fullfile(ioDir,['Streamflow\ComIDStationDAMoAnQ',num2str(WY),'.dat']);
% 
[ComIDSta StaWY NWISArea Q(:,01) Q(:,02) Q(:,03) Q(:,04) Q(:,05)...
     Q(:,06) Q(:,07) Q(:,08) Q(:,09) Q(:,10) Q(:,11) Q(:,12) Q(:,13)] =...
     textread(FileIn,...
     ['%u %s ',repmat('%f ',1,14)],'headerlines',1);
% 
% Select streamgages in the target hydrologic region for the specific water year
[StaTHSWY, ia, ib] = intersect(StaWY, StaTHS);
Ns = length(ComIDSta);
%
% Flag active gages in network
POA(ib,iy) = 1;
%
%% Adjust flows at streamgages for water use
% ComID_WU are the set of all comids affected by water use
% WUseWY are the corresponding affected flows
QTotWY      = Q(ia,1:12);
QAdjWY      = QTotWY;    % Allocates array before adjustment for Water Use
ComIDStaTHS = ComIDSta(ia);
[ComID_QmWU,NdxQm,NdxWU] = intersect(ComIDStaTHS,ComID_WU);
% QAdj is measured flow for water use
% The statement below initializes the matrix
if ~isempty(ComID_QmWU)
    nComID_QmWU = length(ComID_QmWU);
    fprintf(1,'There are %u streamgages where flows are affected by water use.\n',...
        nComID_QmWU);
    % Adjust measured flows to account for water use.  
    % Withdrawal is negative, augmentation is positive.
    QAdjWY(NdxQm,1:12) = QTotWY(NdxQm,1:12) - WUseWY(NdxWU,1:12);
end
%% Print out flow info
fprintf(1,['\n   Flows at Streamgages in Hydrologic Subregion %s ',...
    'for Water Year %u\n'],THS,WY);
fprintf(1,['   ',repmat('-',1,82),'\n']);
fprintf(1,'   Index  Gaging   Drainage    \n');     
fprintf(1,['   Loop   Station  Area (mi2)     Oct       Nov       Dec',...
    '       Jan       Feb       Mar\n']);
fprintf(1,['    THS                           Apr       May       Jun',...
    '       Jul       Aug       Sep\n']);
fprintf(1,['   ',repmat('-',1,82),'\n']);
for is=1:length(ComIDStaTHS),
    fprintf(1,['    %3u   %s  %7.1f ',repmat('%9.1f ',1,6),'\n'],...
        is,StaWY{ia(is)},NWISArea(ia(is)),QTotWY(is,1:6));
    fprintf(1,['    %3u                     ',repmat('%9.1f ',1,6),'\n'],...
        is,QTotWY(is,07:12)); 
    % Print adjusted flows if different than
    if QTotWY(is,:)~=QAdjWY(is,:)
        fprintf(1,'      * * * Station flows adjusted for water use. * * * \n');
        fprintf(1,['    %3u   %s  %7.1f ',repmat('%9.1f ',1,6),'\n'],...
        is,StaWY{ia(is)},NWISArea(ia(is)),QAdjWY(is,1:6));
    fprintf(1,['    %3u                     ',repmat('%9.1f ',1,6),'\n'],...
        is,QAdjWY(is,07:12)); 
        fprintf(1,'      * * *\n');
    end
    if is>1 && isequal(Q(ia(is),:),Q(ia(is-1),:))
        warndlg(['Check for duplicates at station number ',StaWY{ia(is)}],...
            'Duplicate station numbers?');
        return
    end
end
%
%% Refresh memory variables
setappdata(hAFinchGUI,'ComIDStaTHS',ComIDStaTHS);
setappdata(hAFinchGUI,'StaWY',StaWY);
setappdata(hAFinchGUI,'Q',Q);
setappdata(hAFinchGUI,'ComIDSta',ComIDSta);
setappdata(hAFinchGUI,'NWISArea',NWISArea);
setappdata(hAFinchGUI,'QTotWY',QTotWY);
setappdata(hAFinchGUI,'QAdjWY',QAdjWY);
setappdata(hAFinchGUI,'Ns',Ns);
%
