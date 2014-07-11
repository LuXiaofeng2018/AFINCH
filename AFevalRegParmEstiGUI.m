function varargout = AFevalRegParmEstiGUI(varargin)
% AFEVALREGPARMESTIGUI MATLAB code for AFevalRegParmEstiGUI.fig
%      AFEVALREGPARMESTIGUI, by itself, creates a new AFEVALREGPARMESTIGUI or raises the existing
%      singleton*.
%
%      H = AFEVALREGPARMESTIGUI returns the handle to a new AFEVALREGPARMESTIGUI or the handle to
%      the existing singleton*.
%
%      AFEVALREGPARMESTIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFEVALREGPARMESTIGUI.M with the given input arguments.
%
%      AFEVALREGPARMESTIGUI('Property','Value',...) creates a new AFEVALREGPARMESTIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFevalRegParmEstiGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFevalRegParmEstiGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFevalRegParmEstiGUI

% Last Modified by GUIDE v2.5 01-Mar-2012 13:50:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFevalRegParmEstiGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFevalRegParmEstiGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AFevalRegParmEstiGUI is made visible.
function AFevalRegParmEstiGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFevalRegParmEstiGUI (see VARARGIN)

% Choose default command line output for AFevalRegParmEstiGUI
handles.output = hObject;

% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
RegEqnWYr     = getappdata(hAFinchGUI,'RegEqnWYr');
xVarTableData = getappdata(hAFinchGUI,'xVarTableData'); 
WY1           = getappdata(hAFinchGUI,'WY1');
RegEqnPoA     = getappdata(hAFinchGUI,'RegEqnPoA');
wYearVec      = getappdata(hAFinchGUI,'wYearVec');
MonthName     = getappdata(hAFinchGUI,'MonthName');
%
handles.monNdx = 1;
set(handles.OctRB,'Value',handles.monNdx);
% ndxVarName = find(RegEqnWYr(3,1).inmodel); 
set(handles.ParameterPUMenu,'String',['Intercept',RegEqnWYr(3,handles.monNdx).RegVarNames]);
handles.legend_icon = imread('legendParamPlot.jpg','jpg');
set(handles.legendPB,'CData',handles.legend_icon);
guidata(hObject,handles);
% set(handles.SetupShapefileVarPB,'CData',handles.shpf_icon);

% Update handles structure
guidata(hObject, handles);
% Plot October scatter data on startup. 
colormap('Jet');
ndx = find(~isnan(RegEqnPoA(1,handles.monNdx).Yhat));
scatter(handles.scatterAxes,RegEqnPoA(1,handles.monNdx).Ymea(ndx),...
    RegEqnPoA(1,handles.monNdx).Yhat(ndx),3,wYearVec(ndx));
% set(handles.scatterAxes,'YLabel','linear');
hold on
minX = min(RegEqnPoA(1,handles.monNdx).Ymea);
maxX = max(RegEqnPoA(1,handles.monNdx).Ymea);
plot(handles.scatterAxes,[minX,maxX],[minX,maxX],'k:');
[r,p] = corrcoef([RegEqnPoA(1,handles.monNdx).Ymea(ndx)';RegEqnPoA(1,handles.monNdx).Yhat(ndx)']');
r2pval= ['r^2 = ',num2str(r(1,2)^2,4),' p = ',num2str(p(1,2),'%8.4g')];
fprintf(1,'r2 = %s, p-value = %s \n',num2str(r(1,2)^2,5),num2str(p(1,2),'%8.4g'));
set(handles.statsST,'String',r2pval);
hold off
textstr = ['Estimated and Measured Water Yield for ',MonthName{handles.monNdx}];
set(handles.monthST,'String',textstr);
PlotParameterPB_Callback(hObject, eventdata, handles);
guidata(hObject,handles);


% UIWAIT makes AFevalRegParmEstiGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFevalRegParmEstiGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ParameterPUMenu.
function ParameterPUMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ParameterPUMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotParameterPB_Callback(hObject, eventdata, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns ParameterPUMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ParameterPUMenu


% --- Executes during object creation, after setting all properties.
function ParameterPUMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ParameterPUMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in MonthBG.
function MonthBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in MonthBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
%
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
RegEqnWYr     = getappdata(hAFinchGUI,'RegEqnWYr');
% xVarTableData = getappdata(hAFinchGUI,'xVarTableData'); 
% WY1           = getappdata(hAFinchGUI,'WY1');
RegEqnPoA     = getappdata(hAFinchGUI,'RegEqnPoA');
wYearVec      = getappdata(hAFinchGUI,'wYearVec');
MonthName     = getappdata(hAFinchGUI,'MonthName');

switch get(eventdata.NewValue,'Tag') % Get the tag of the selected RB
    case 'OctRB'
        handles.monNdx = 1;
    case 'NovRB'
        handles.monNdx = 2;
    case 'DecRB'
        handles.monNdx = 3;
    case 'JanRB'
        handles.monNdx = 4;
    case 'FebRB'
        handles.monNdx = 5;
    case 'MarRB'
        handles.monNdx = 6;
    case 'AprRB'
        handles.monNdx = 7;
    case 'MayRB'
        handles.monNdx = 8;
    case 'JunRB'
        handles.monNdx = 9;
    case 'JulRB'
        handles.monNdx = 10;
    case 'AugRB'
        handles.monNdx = 11;
    case 'SepRB'
        handles.monNdx = 12;
end
set(handles.ParameterPUMenu,'String','');
set(handles.ParameterPUMenu,'Value',1);
set(handles.ParameterPUMenu,'String',['Intercept',RegEqnWYr(3,handles.monNdx).RegVarNames]);
set(handles.scatterPlotBG,'SelectedObject',handles.yieldsRB);
set(handles.scatterXlabel,'String','Measured Water Yield, in area inches');
set(handles.scatterYlabel,'String',['E';'s';'t';'i';'m';'a';'t';'e';'d']);
%
colormap('Jet');
ndx = find(~isnan(RegEqnPoA(1,handles.monNdx).Yhat));
scatter(handles.scatterAxes,RegEqnPoA(1,handles.monNdx).Ymea(ndx),...
    RegEqnPoA(1,handles.monNdx).Yhat(ndx),3,wYearVec(ndx));
hold(handles.scatterAxes,'on');
minX = min(RegEqnPoA(1,handles.monNdx).Ymea);
maxX = max(RegEqnPoA(1,handles.monNdx).Ymea);
plot(handles.scatterAxes,[minX,maxX],[minX,maxX],'k:');
[r,p] = corrcoef([RegEqnPoA(1,handles.monNdx).Ymea(ndx)';RegEqnPoA(1,handles.monNdx).Yhat(ndx)']');
r2pval= ['r^2 = ',num2str(r(1,2)^2,4),', p = ',num2str(p(1,2),'%8.4g')];
fprintf(1,'r2 = %s, p-value = %s \n',num2str(r(1,2)^2,5),num2str(p(1,2),'%8.4g'));
set(handles.statsST,'String',r2pval);
hold(handles.scatterAxes,'off');
textstr = ['Estimated and Measured Water Yield for ',MonthName{handles.monNdx}];
set(handles.monthST,'String',textstr);
PlotParameterPB_Callback(hObject, eventdata, handles);
guidata(hObject,handles);
%
% --- Executes on button press in PlotParameterPB.
function PlotParameterPB_Callback(hObject, eventdata, handles)
% hObject    handle to PlotParameterPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
RegEqnWYr     = getappdata(hAFinchGUI,'RegEqnWYr');
RegEqnPoA     = getappdata(hAFinchGUI,'RegEqnPoA');
% xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
WY1           = getappdata(hAFinchGUI,'WY1');
% wYearVec      = getappdata(hAFinchGUI,'wYearVec');
MonthName     = getappdata(hAFinchGUI,'MonthName');
%
paramNdx  = get(handles.ParameterPUMenu,'Value');
olsParm   = [1 find(RegEqnPoA(1,handles.monNdx).inmodel) + 1];
paramName = get(handles.ParameterPUMenu,'String');
fprintf(1,'Analyzing parameter %u (%s).\n',paramNdx,paramName{paramNdx});
[nyrs,~]  = size(RegEqnWYr);
timeVec   = (1:nyrs) + WY1 - 1;
T         = length(timeVec);
betaOLShat   = NaN(T,1);
betaOLSL95   = NaN(T,1);
betaOLSU95   = NaN(T,1);
betaRobhat   = NaN(T,1);
betaRobL95   = NaN(T,1);
betaRobU95   = NaN(T,1);
for t = 1:nyrs
    if ~isempty(RegEqnWYr(t,handles.monNdx).OLS);
        betaOLShat(t) = RegEqnWYr(t,handles.monNdx).OLS.b(paramNdx);
        betaOLSL95(t) = RegEqnWYr(t,handles.monNdx).OLS.bInterval(paramNdx,1);
        betaOLSU95(t) = RegEqnWYr(t,handles.monNdx).OLS.bInterval(paramNdx,2);
        betaRobhat(t) = RegEqnWYr(t,handles.monNdx).Robust.b(paramNdx);
        halfInt95     = RegEqnWYr(t,handles.monNdx).Robust.stats.se(paramNdx)*...
                          tinv(0.975,RegEqnWYr(t,handles.monNdx).Robust.stats.dfe);
        betaRobL95(t) = betaRobhat(t) - halfInt95;
        betaRobU95(t) = betaRobhat(t) + halfInt95;
    end
end
ndx = find(~isnan(betaOLShat));
%
guidata(hObject,handles);
% OLS estimates
plot(handles.ParameterAxes,timeVec(ndx)-5/nyrs,betaOLShat(ndx),'bs',...
    'MarkerSize',3,'MarkerFaceColor','b');
hold(handles.ParameterAxes,'on');
plot(handles.ParameterAxes,timeVec(ndx)-5/nyrs,betaOLSL95(ndx),'b^',...
    'MarkerSize',3,'MarkerFaceColor','b');
plot(handles.ParameterAxes,timeVec(ndx)-5/nyrs,betaOLSU95(ndx),'bV',...
    'MarkerSize',3,'MarkerFaceColor','b');
% Robust estimates
plot(handles.ParameterAxes,timeVec(ndx)+5/nyrs,betaRobhat(ndx),'r*',...
    'MarkerSize',4,'MarkerFaceColor','r');
plot(handles.ParameterAxes,timeVec(ndx)+5/nyrs,betaRobL95(ndx),'r^',...
    'MarkerSize',3,'MarkerFaceColor','r');
plot(handles.ParameterAxes,timeVec(ndx)+5/nyrs,betaRobU95(ndx),'rV',...
    'MarkerSize',3,'MarkerFaceColor','r');
for t = 1:length(ndx)
    plot(handles.ParameterAxes,[timeVec(ndx(t)),timeVec(ndx(t))]-.1,...
        [betaOLShat(ndx(t)),betaOLSU95(ndx(t))],'b:');
    plot(handles.ParameterAxes,[timeVec(ndx(t)),timeVec(ndx(t))]-.1,...
        [betaOLShat(ndx(t)),betaOLSL95(ndx(t))],'b:');
    plot(handles.ParameterAxes,[timeVec(ndx(t)),timeVec(ndx(t))]+0.1,...
        [betaRobhat(ndx(t)),betaRobU95(ndx(t))],'r:');
    plot(handles.ParameterAxes,[timeVec(ndx(t)),timeVec(ndx(t))]+0.1,...
        [betaRobhat(ndx(t)),betaRobL95(ndx(t))],'r:');
end
%
%% Compute and plot the period of analysis OLS betas and their 95% CI
plot(handles.ParameterAxes,[timeVec(1)-0.2,timeVec(end)+0.2],...
    [RegEqnPoA(1,handles.monNdx).OLS.b(olsParm(paramNdx)),...
     RegEqnPoA(1,handles.monNdx).OLS.b(olsParm(paramNdx))],'k-',...
     'LineWidth',1.0);
if paramNdx>1
     halfInt95  = RegEqnPoA(1,handles.monNdx).OLS.seb(olsParm(paramNdx)-1)*...
                  tinv(0.975,RegEqnPoA(1,handles.monNdx).OLS.stats.dfe);
     plot(handles.ParameterAxes,[timeVec(1)-0.2,timeVec(end)+0.2],...
    [RegEqnPoA(1,handles.monNdx).OLS.b(olsParm(paramNdx))+halfInt95,...
     RegEqnPoA(1,handles.monNdx).OLS.b(olsParm(paramNdx))+halfInt95],'k:',...
     'LineWidth',0.5);
     plot(handles.ParameterAxes,[timeVec(1)-0.2,timeVec(end)+0.2],...
    [RegEqnPoA(1,handles.monNdx).OLS.b(olsParm(paramNdx))-halfInt95,...
     RegEqnPoA(1,handles.monNdx).OLS.b(olsParm(paramNdx))-halfInt95],'k:',...
     'LineWidth',0.5);
end        
%
hold(handles.ParameterAxes,'off');
set(handles.ParameterAxes,'XLim',[min(timeVec(ndx))-1 max(timeVec(ndx))+1]);
set(handles.ParameterAxes,'YLim',[min([betaOLSL95',betaRobL95']),...
    max([betaOLSU95',betaRobU95'])]);
set(handles.xLabelST,'String','Water Year');
 % nBlanks = length('Parameter Estimates of Explanatory Variable ')-length(eval('paramName'));
 % paramNameAug = [paramName,blanks(nBlanks)];
figTitle = ['Time Series of Parameter Estimates for Explanatory Variable ',...
    paramName{paramNdx},' in ',MonthName{handles.monNdx}];
set(handles.figTitleST,'String',figTitle);
%
guidata(hObject,handles);

% --- Executes on button press in legendPB.
function legendPB_Callback(hObject, eventdata, handles)
% hObject    handle to legendPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in scatterPlotBG.
function scatterPlotBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in scatterPlotBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
% RegEqnWYr     = getappdata(hAFinchGUI,'RegEqnWYr');
% xVarTableData = getappdata(hAFinchGUI,'xVarTableData'); 
% WY1           = getappdata(hAFinchGUI,'WY1');
RegEqnPoA     = getappdata(hAFinchGUI,'RegEqnPoA');
wYearVec      = getappdata(hAFinchGUI,'wYearVec');
% MonthName     = getappdata(hAFinchGUI,'MonthName');

plotType = get(eventdata.NewValue,'Tag');
fprintf(1,'handles.scatterAxes = %f.\n',handles.scatterAxes);
ndx = find(~isnan(RegEqnPoA(1,handles.monNdx).Yhat));
minTime = min(wYearVec(ndx)); maxTime = max(wYearVec(ndx));
seqTime = linspace(minTime,maxTime,length(wYearVec(ndx)));
if strcmp(plotType,'yieldsRB')
    fprintf(1,'plotType = %s.\n',plotType);
    scatter(handles.scatterAxes,RegEqnPoA(1,handles.monNdx).Ymea(ndx),...
        RegEqnPoA(1,handles.monNdx).Yhat(ndx),3,wYearVec(ndx));
    hold(gca,'on')
    minX = min(RegEqnPoA(1,handles.monNdx).Ymea);
    maxX = max(RegEqnPoA(1,handles.monNdx).Ymea);
    plot(handles.scatterAxes,[minX,maxX],[minX,maxX],'k:');
    hold(gca,'off')
    set(handles.scatterXlabel,'String','Measured Water Yield, in area inches');
    set(handles.scatterYlabel,'String',['E';'s';'t';'i';'m';'a';'t';'e';'d']);
    [r,p] = corrcoef([RegEqnPoA(1,handles.monNdx).Ymea(ndx)';...
        RegEqnPoA(1,handles.monNdx).Yhat(ndx)']');
    r2pval= ['r^2 = ',num2str(r(1,2)^2,4),' p = ',num2str(p(1,2),'%8.4g')];
    fprintf(1,'r2 = %s, p-value = %s \n',num2str(r(1,2)^2,5),num2str(p(1,2),'%8.4g'));
    set(handles.statsST,'String',r2pval);
    %
elseif strcmp(plotType,'residsRB')
    fprintf(1,'plotType = %s.\n',plotType);
    ndx = find(~isnan(RegEqnPoA(1,handles.monNdx).Yhat));
    scatter(handles.scatterAxes,seqTime,...
        RegEqnPoA(1,handles.monNdx).Yhat(ndx)-...
        RegEqnPoA(1,handles.monNdx).Ymea(ndx),3,wYearVec(ndx));
    hold(gca,'on')
    plot(gca,[seqTime(1),seqTime(end)],[0,0],'k:');
    hold off
    set(handles.scatterXlabel,'String','Water Year');
    set(handles.scatterYlabel,'String',['R';'e';'s';'i';'d';'u';'a';'l']);
    set(handles.statsST,'String',[]);
%
else
    fprintf(1,'Plot type not recognized.\n');
end
