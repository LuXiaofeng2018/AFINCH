%% AFRegressWYr
function AFRegressWYr(iy)
% Develop monthly models by water year
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
Xarr          = getappdata(hAFinchGUI,'Xarr');
Yarr          = getappdata(hAFinchGUI,'Yarr');
rYarr         = getappdata(hAFinchGUI,'rYarr');
RegEqnWYr     = getappdata(hAFinchGUI,'RegEqnWYr');
RegEqnPoA     = getappdata(hAFinchGUI,'RegEqnPoA');
WY1           = getappdata(hAFinchGUI,'WY1');
WYn           = getappdata(hAFinchGUI,'WYn');
xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
StaHist       = getappdata(hAFinchGUI,'StaHist');
wYearVec      = getappdata(hAFinchGUI,'wYearVec');
WY            = WY1 + iy -1;
% 
%% Compute Ordinary Least-Squares and Robust Estimates of Parameters
% NdxWY = find(RegMat(:,1)==WY);
NdxWY = find(WY == wYearVec);
for im=1:12,
    % NdxMo  = find(RegMat(:,3)==im);
    NdxXvar   = find(RegEqnPoA(im).inmodel);
    RegDesign = Xarr(NdxWY,NdxXvar,im);
    %
    % Test if RegDesign has a column (or lot) of NaNs
    % If the number of NaNs in any one column is less than N(WY)-2*N(Xvar)
    if max(sum(isnan(RegDesign),1))<length(RegDesign)-2*length(NdxXvar)
        % Compute Robust Regression Coefficients
        [RegEqnWYr(iy,im).Robust.b,RegEqnWYr(iy,im).Robust.stats] = ...
            robustfit(RegDesign,rYarr(NdxWY,im),'fair');
        % Add column of ones for OLS regression
        RegDesignAug = [ones(length(RegDesign),1) RegDesign];
        RegEqnWYr(iy,im).Robust.rPredRUAdj = (RegDesignAug * [RegEqnWYr(iy,im).Robust.b]);
        RegEqnWYr(iy,im).Robust.PredRUAdj  = (RegEqnWYr(iy,im).Robust.rPredRUAdj).^2;
        % Compute OLS Regression Coefficients
        [RegEqnWYr(iy,im).OLS.b,RegEqnWYr(iy,im).OLS.bInterval,RegEqnWYr(iy,im).OLS.r,...
            RegEqnWYr(iy,im).OLS.rInterval,RegEqnWYr(iy,im).OLS.stats] = ...
            regress(rYarr(NdxWY,im),RegDesignAug);
        RegEqnWYr(iy,im).OLS.PredRUAdj  = (RegDesignAug * RegEqnWYr(iy,im).OLS.b);
        RegEqnWYr(iy,im).PoA.olsBeta    = RegEqnPoA(1,im).OLS.b;
        RegEqnWYr(iy,im).RegVarNames    = {xVarTableData{NdxXvar,1}};
        RegEqnWYr(iy,im).inmodel        = RegEqnPoA(im).inmodel;
        RegEqnWYr(iy,im).PoA.rYhatAdjOls = (RegDesignAug * ...
            RegEqnWYr(iy,im).PoA.olsBeta(logical([1,RegEqnWYr(iy,im).inmodel])));
        RegEqnWYr(iy,im).PoA.YhatAdjOls = (RegEqnWYr(iy,im).PoA.rYhatAdjOls).^2;
        RegEqnWYr(iy,im).PoA.QhatAdjOls = RegEqnWYr(iy,im).PoA.YhatAdjOls .* ...
            StaHist(1,iy).NWISAreaIWY;
        %
        %if ismember(iy+WY0,ShowWY)
    else
        warndlg({'Too many NaNs in one or more explanatory variables to compute ',...
            ['regression for water year ',num2str(WY),'.  Returning for next water year.']},...
            'Insufficient number of valid observations.');
        uiwait(gcf);
        return
    end
end
setappdata(hAFinchGUI,'RegEqnWYr',RegEqnWYr);
