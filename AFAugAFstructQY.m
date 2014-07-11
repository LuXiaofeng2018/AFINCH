%% Populate AFstruct with flow and yields from StaHist
hAFinchGUI = getappdata(0,'hAFinchGUI');
StaHist    = getappdata(hAFinchGUI,'StaHist');
AFstruct   = getappdata(hAFinchGUI,'AFstruct');
HSR        = getappdata(hAFinchGUI,'HSR');
%
%  StaHist is a structured variable with 1 row and nYear columns.
%   Each column of data has monthly and annual fields in nSta field: 
%     QTotWY, QAdjWY, QTotIncWY, QAdjIncWY, YTotIncWY, YAdjIncWY
%
nYear = length(StaHist); 
for n=1:nYear,
    [jSta,~] = size(StaHist(1,n).QTotWY);
    for j=1:jSta
        kNdx = StaHist(1,n).StaNdx;      
        AFstruct.(HSR)(n,kNdx(j)).QTotWY    = StaHist(1,n).QTotWY(j,1:12); 
        AFstruct.(HSR)(n,kNdx(j)).QAdjWY    = StaHist(1,n).QAdjWY(j,1:12);
        AFstruct.(HSR)(n,kNdx(j)).QTotIncWY = StaHist(1,n).QTotIncWY(j,1:12);
        AFstruct.(HSR)(n,kNdx(j)).QAdjIncWY = StaHist(1,n).QAdjIncWY(j,1:12);
        AFstruct.(HSR)(n,kNdx(j)).YTotIncWY = StaHist(1,n).YTotIncWY(j,1:12);
        AFstruct.(HSR)(n,kNdx(j)).YAdjIncWY = StaHist(1,n).YAdjIncWY(j,1:12);
    end
end
% Refresh GUI memory
setappdata(hAFinchGUI,'AFstruct',AFstruct);
