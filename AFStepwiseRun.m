%% AFStepwiseReg does an OLS stepwise variable selection analysis from the 
function AFStepwiseRun
% set of variables specified by they user for each month using data for the
% entire period period of analysis.  This set is used in both Period of
% Analysis and Water Year (Annual) equations estimated by use of OLS or
% robust methods.  In the process, the RegEqnPoA.OLS equations are estimated. 
%
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
Xarr          = getappdata(hAFinchGUI,'Xarr');
 Yarr         = getappdata(hAFinchGUI,'Yarr');
rYarr         = getappdata(hAFinchGUI,'rYarr');
pEnter        = getappdata(hAFinchGUI,'pEnter');
pRemove       = getappdata(hAFinchGUI,'pRemove');

fprintf(1,['InModel = [ %u %u %u %u ]\n'],xVarTableData{:,2});
% 
for im=1:12,
    [betacoef,RegEqnPoA(im).OLS.seb,RegEqnPoA(im).OLS.pvalb,...
        RegEqnPoA(im).inmodel,RegEqnPoA(im).OLS.stats ] = ...
        stepwisefit(Xarr(:,:,im),rYarr(:,im),...
        'penter',pEnter,'premove',pRemove,...
        'keep',logical([xVarTableData{:,2}]),...
        'inmodel',logical([xVarTableData{:,2}])); 
    RegEqnPoA(im).RegVarNames = {xVarTableData{RegEqnPoA(im).inmodel,1}};
    RegEqnPoA(im).OLS.b = [RegEqnPoA(im).OLS.stats.intercept; betacoef];
    RegEqnPoA(im).rYhat = [ones(length(Xarr),1),Xarr(:,[find(RegEqnPoA(1,im).inmodel)],im)] * ...
        RegEqnPoA(1,im).OLS.b(find([1,RegEqnPoA(1,im).inmodel]));
    RegEqnPoA(im).Yhat = (RegEqnPoA(im).rYhat).^2;
    
 %   RegEqnPoA(im).Qhat = RegEqnPoA(im).Yhat 
 
 RegEqnPoA(im).Ymea  =  Yarr(:,im);
 RegEqnPoA(im).rYmea = rYarr(:,im);
    % Computes robust parameter estimates for the PoA.
    [RegEqnPoA(im).robust.b,RegEqnPoA(im).robust.stats] = ...
        robustfit(Xarr(:,[find(RegEqnPoA(1,im).inmodel)],im),...
        rYarr(:,im),'bisquare',4.685);
end
setappdata(hAFinchGUI,'RegEqnPoA',RegEqnPoA);
%
% Define R2B as a matrix where negative values are red, 0 values are white,
% and positive values are blue.
R2B = [[ones(32,1);linspace(1,0,32)'],...
       [linspace(0,1,32)'; linspace(1,0,32)'],...
       [linspace(0,1,32)'; ones(32,1)]];
%
%% Plot Image of Monthly Regression Variable Significance
% Create figure color coding the significant variables by month.  
% Red areas show significant negative coefficients, blue areas show
% significant positive coefficients, and white areas show no significant
% coefficients.
% figure('NextPlot','new'); 
imagesc([RegEqnPoA(01).inmodel'.* RegEqnPoA(01).OLS.b(2:end) ./ RegEqnPoA(01).OLS.seb,...
         RegEqnPoA(02).inmodel'.* RegEqnPoA(02).OLS.b(2:end) ./ RegEqnPoA(02).OLS.seb,...
         RegEqnPoA(03).inmodel'.* RegEqnPoA(03).OLS.b(2:end) ./ RegEqnPoA(03).OLS.seb,...
         RegEqnPoA(04).inmodel'.* RegEqnPoA(04).OLS.b(2:end) ./ RegEqnPoA(04).OLS.seb,...
         RegEqnPoA(05).inmodel'.* RegEqnPoA(05).OLS.b(2:end) ./ RegEqnPoA(05).OLS.seb,...
         RegEqnPoA(06).inmodel'.* RegEqnPoA(06).OLS.b(2:end) ./ RegEqnPoA(06).OLS.seb,...
         RegEqnPoA(07).inmodel'.* RegEqnPoA(07).OLS.b(2:end) ./ RegEqnPoA(07).OLS.seb,...
         RegEqnPoA(08).inmodel'.* RegEqnPoA(08).OLS.b(2:end) ./ RegEqnPoA(08).OLS.seb,...
         RegEqnPoA(09).inmodel'.* RegEqnPoA(09).OLS.b(2:end) ./ RegEqnPoA(09).OLS.seb,...
         RegEqnPoA(10).inmodel'.* RegEqnPoA(10).OLS.b(2:end) ./ RegEqnPoA(10).OLS.seb,...
         RegEqnPoA(11).inmodel'.* RegEqnPoA(11).OLS.b(2:end) ./ RegEqnPoA(11).OLS.seb,...
         RegEqnPoA(12).inmodel'.* RegEqnPoA(12).OLS.b(2:end) ./ RegEqnPoA(12).OLS.seb],[-10,10]);
%     
colormap(R2B)
colorbar('location','SouthOutside');
MoName = {'Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep'};
set(gca,'YTick',1:length(xVarTableData(:,1)),...
    'YTickLabel',xVarTableData(:,1),'XTick',1:12,...
    'XTickLabel',MoName);
set(gcf,'NumberTitle','Off','Name',...
['Monthly t-values for Significant (p<=',...
num2str(max(pEnter,pRemove),4),') Parameters across all Years']);
title(['Monthly t-values for Significant (p<=',...
    num2str(max(pEnter,pRemove),4),') Parameters for the period of analysis.']);
%
% Print out model statistics for each month
ndash = 63;
fprintf(1,'Monthly Regression Results for Period of Analysis \n');
fprintf(1,['',repmat('-',1,ndash),'\n']);
fprintf(1,'       Number of   Degrees                          \n');
fprintf(1,'      explanatory    of                                \n');
fprintf(1,'Month  variables   Freedom   RMSE    F-stat    p-value    r2  \n');
fprintf(1,['',repmat('-',1,ndash),'\n']);
for im=1:12,
    fprintf(1,'%5s      %u        %u %9.4f %8.2f %10.5f   %6.4f\n',...
    MoName{im},...
    RegEqnPoA(1,im).OLS.stats.df0,...
    RegEqnPoA(1,im).OLS.stats.dfe,...
    RegEqnPoA(1,im).OLS.stats.rmse,...
    RegEqnPoA(1,im).OLS.stats.fstat,...
    RegEqnPoA(1,im).OLS.stats.pval,...
    1-RegEqnPoA(1,im).OLS.stats.SSresid/RegEqnPoA(1,im).OLS.stats.SStotal);
end
fprintf(1,['',repmat('-',1,ndash),'\n']);
%
%% Print ANOVA to a figure
%
[nChkBox,~]= size(xVarTableData); % Number of explanatory variables
switch nChkBox
    case 1
        cnames = {'x1','DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 30 60 60 80 80 };
        cformat= {'logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 2
        cnames = {'x1','x2','DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 30 60 60 80 80 };
        cformat= {'logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 3
        cnames = {'x1','x2','x3','DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 20 30 60 60 80 80 };
        cformat= {'logical','logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 4
        cnames = {'x1','x2','x3','x4','DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 20 20 30 60 60 80 80 };
        cformat= {'logical','logical','logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 5
        cnames = {'x1','x2','x3','x4','x5',...
            'DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 20 20 20 30 60 60 80 80 };
        cformat= {'logical','logical','logical','logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 6
        cnames = {'x1','x2','x3','x4','x5','x6',...
            'DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 20 20 20 20 30 60 60 80 80 };
        cformat= {'logical','logical','logical','logical',...
            'logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 7
        cnames = {'x1','x2','x3','x4','x5','x6','x7',...
            'DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 20 20 20 20 20 30 60 60 80 80 };
        cformat= {'logical','logical','logical','logical',...
            'logical','logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 8
        cnames = {'x1','x2','x3','x4','x5','x6','x7','x8',...
            'DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 20 20 20 20 20 20 30 60 60 80 80 };
        cformat= {'logical','logical','logical','logical',...
            'logical','logical','logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 9
        cnames = {'x1','x2','x3','x4','x5','x6','x7','x8','x9',...
            'DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 20 20 20 20 20 20 20 30 60 60 80 80 };
        cformat= {'logical','logical','logical','logical',...
            'logical','logical','logical','logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    case 10
        cnames = {'x1','x2','x3','x4','x5','x6','x7','x8','x9','x10',...
            'DF','RMSE','F-stat','p-value','r-squared'};
        cwidth = { 20 20 20 20 20 20 20 20 20 20 30 60 60 80 80 };
        cformat= {'logical','logical','logical','logical',...
            'logical','logical','logical','logical','logical','logical',...
            'numeric','numeric','numeric','numeric','short','numeric'};
        skipTable = false;
    otherwise
        fprintf(1,'The number of explanatory variables is limited to 10.\n');
        msgbox({'See console output for stepwise results.  Graphical table';...
            'not generated for more than 10 explanatory variables.'},...
            'Stepwise results displayed in console.','help');
        skipTable = true;
end
%
if skipTable == false
    stepResults = cell(12,nChkBox+4);
    for im=1:12
        stepResults(im,1) = MoName(im);
        for iv = 1:nChkBox
            stepResults{im,iv} = RegEqnPoA(im).inmodel(iv);
        end
        stepResults{im,1+nChkBox}   =  RegEqnPoA(1,im).OLS.stats.dfe;
        stepResults{im,2+nChkBox}   =  RegEqnPoA(1,im).OLS.stats.rmse;
        stepResults{im,3+nChkBox}   =  RegEqnPoA(1,im).OLS.stats.fstat;
        stepResults{im,4+nChkBox}   =  RegEqnPoA(1,im).OLS.stats.pval;
        stepResults{im,5+nChkBox}   =  1-RegEqnPoA(1,im).OLS.stats.SSresid/...
            RegEqnPoA(1,im).OLS.stats.SStotal;
    end
    %
    f = figure('Position',[200,200,sum([cwidth{:}])+120,320+nChkBox*13],...
        'NumberTitle','off','Name','Stepwise Regression Analysis of Variance Table');
    title(['Stepwise Summary with p-Enter ',num2str(pEnter,4),...
        ', p-Remove ',num2str(pRemove,4),' and InModel [',...
        num2str([xVarTableData{:,2}]),']']);
    axis off
    t = uitable('Parent',f,'Data',stepResults,'ColumnName',cnames,...
        'RowName',MoName,'Position',[20,49+nChkBox*13,sum([cwidth{:}])+120,237],...
        'ColumnFormat',cformat,'ColumnWidth',cwidth,...
        'BackgroundColor',[.86 .86 .86;.94 .94 .94]);
    % text(0,-0.1,'x1 is regression variable 1');
    for iv = 1:nChkBox
        text(-.1,-iv*.05+nChkBox*.04,['x',num2str(iv),': ',xVarTableData{iv,1}]);
    end
else
    stepResults = cell(12,nChkBox+4);
    for im=1:12
        stepResults(im,1) = MoName(im);
        for iv = 1:nChkBox
            stepResults{im,iv} = RegEqnPoA(im).inmodel(iv);
        end
        stepResults{im,1+nChkBox}   =  RegEqnPoA(1,im).OLS.stats.dfe;
        stepResults{im,2+nChkBox}   =  RegEqnPoA(1,im).OLS.stats.rmse;
        stepResults{im,3+nChkBox}   =  RegEqnPoA(1,im).OLS.stats.fstat;
        stepResults{im,4+nChkBox}   =  RegEqnPoA(1,im).OLS.stats.pval;
        stepResults{im,5+nChkBox}   =  1-RegEqnPoA(1,im).OLS.stats.SSresid/...
            RegEqnPoA(1,im).OLS.stats.SStotal;
    end   
end
%
% Update hAFinchGUI workspace
setappdata(hAFinchGUI,'stepResults',stepResults);

