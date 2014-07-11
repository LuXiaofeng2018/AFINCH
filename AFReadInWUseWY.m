function AFReadInWUseWY(iy)
%
hAFinchGUI   = getappdata(0,'hAFinchGUI');
PIn          = getappdata(hAFinchGUI,'PIn');
THS          = getappdata(hAFinchGUI,'THS');
WY1          = getappdata(hAFinchGUI,'WY1');
ioDir        = getappdata(hAFinchGUI,'ioDir');
ComID_NHDTHS = getappdata(hAFinchGUI,'ComID_NHDTHS');
WU_notify    = getappdata(hAFinchGUI,'WU_notify');
%
WY = WY1 + iy -1;
% Read in water use data at flowlines
fprintf(1,['  Initializing zero water use in all %u reaches and all ',...
    'months within the THS.\n'],length(PIn));
ReachWU = zeros(length(PIn),12);
% The FileIn needs to modified to utilize water use data for a specific
% water year. 
%% Read in monthly flows at flowlines
fprintf(1,'\n AFReadInWUseWY: Reading in routed water use from data defined at selected flowlines.\n');
% Read in the flow data at active stations for a specific water year 
% FileIn = strcat(['..\','HSR',THS,'\WaterUse\ComIDWUseMonthly'],num2str(WY),'.dat');
FileIn = fullfile(ioDir,['WaterUse\ComIDWUseMonthly',num2str(WY),'.dat']);
% 
fid = fopen(FileIn,'rt');
if fid>0
    C = textscan(fid,['%u ',repmat('%f ',1,12)],'HeaderLines',1,...
        'Delimiter','\t');
    ComID_WU = C{1,1};
    WUseWY   = [C{2:13}];
    %
    % Water use data
    [~,ai,bi]=intersect(ComID_WU,ComID_NHDTHS);
    %
    fprintf(1,['\n   Water Use in CFS within THS %s (negative indicates ',...
        'withdrawal from reach).\n'],THS);
    fprintf(1,['   ',repmat('-',1,94),'\n']);
    fprintf(1,['     ComID     Oct    Nov    Dec    Jan    Feb    Mar    Apr  ',...
        '  May    Jun    Jul    Aug    Sep\n']);
    fprintf(1,['   ',repmat('-',1,94),'\n']);
    for i=1:length(ai),
        fprintf(1,['   %8u ',repmat('%7.1f',1,12),'\n'],...
            ComID_WU(ai(i)),WUseWY(ai(i),1:12));
    end
    fprintf(1,['   ',repmat('-',1,94),'\n']);
    % Store WU in ReachWU
    ReachWU(bi,1:12) = WUseWY(ai,1:12);
else
    ComID_WU = [];  
    WUseWY = [];
    if strcmp(WU_notify,'Yes')
        WU_notify = questdlg(['No water-use data found for water year ',num2str(WY),'. ';...
            'Do you wish to receive further notifications?'],...
            'Missing Water Use Data');
    end
    fprintf(1,'WARNING: No water-use data found for Water Year %u.\n',WY);
end
% 
% Refresh memory variables
setappdata(hAFinchGUI,['ComID_WU',num2str(WY)],ComID_WU);
setappdata(hAFinchGUI,['WUseWY',  num2str(WY)],WUseWY);
setappdata(hAFinchGUI,'ComID_WU',ComID_WU);
setappdata(hAFinchGUI,'WUseWY',WUseWY);
setappdata(hAFinchGUI,'WU_notify',WU_notify);
%
