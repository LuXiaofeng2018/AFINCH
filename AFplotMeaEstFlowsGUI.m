function varargout = AFplotMeaEstFlowsGUI(varargin)
% AFPLOTMEAESTFLOWSGUI MATLAB code for AFplotMeaEstFlowsGUI.fig
%      AFPLOTMEAESTFLOWSGUI, by itself, creates a new AFPLOTMEAESTFLOWSGUI or raises the existing
%      singleton*.
%
%      H = AFPLOTMEAESTFLOWSGUI returns the handle to a new AFPLOTMEAESTFLOWSGUI or the handle to
%      the existing singleton*.
%
%      AFPLOTMEAESTFLOWSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFPLOTMEAESTFLOWSGUI.M with the given input arguments.
%
%      AFPLOTMEAESTFLOWSGUI('Property','Value',...) creates a new AFPLOTMEAESTFLOWSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFplotMeaEstFlowsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFplotMeaEstFlowsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFplotMeaEstFlowsGUI

% Last Modified by GUIDE v2.5 26-Apr-2012 14:31:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AFplotMeaEstFlowsGUI_OpeningFcn, ...
    'gui_OutputFcn',  @AFplotMeaEstFlowsGUI_OutputFcn, ...
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

% --- Executes just before AFplotMeaEstFlowsGUI is made visible.
function AFplotMeaEstFlowsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFplotMeaEstFlowsGUI (see VARARGIN)
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
WY1        = getappdata(hAFinchGUI,'WY1');
WYn        = getappdata(hAFinchGUI,'WYn');
% Choose default command line output for AFplotMeaEstFlowsGUI
handles.output = hObject;
handles.plotType = 'estFlowRB';
% Create cell array of years
years = WY1:WYn; nYr = WYn - WY1 + 1;
for i = 1:nYr
    handles.wySeq(i) = {num2str(years(i))};
end
% Load and plot the explanation
%
guidata(hObject,handles);
set(handles.WaterYearPM,'String',handles.wySeq);
set(handles.WaterYearPM,'Value',1);
%
handles.wySel  = 1;
handles.stationNdx = [];
titlePlot(handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFplotMeaEstFlowsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFplotMeaEstFlowsGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in WaterYearPM.
function WaterYearPM_Callback(hObject, eventdata, handles)
% hObject    handle to WaterYearPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns WaterYearPM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WaterYearPM
%
handles.wySeq  = cellstr(get(hObject,'String'));
handles.wySel  =         get(hObject,'Value');
set(handles.stationWyLB,'Value',1);
handles.stationNdx = [];
guidata(hObject,handles);
% Plot results for selection
titlePlot(handles)
% Update guidata
%
% --- Executes during object creation, after setting all properties.
function WaterYearPM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WaterYearPM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stationWyLB.
function stationWyLB_Callback(hObject, eventdata, handles)
% hObject    handle to stationWyLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stationWyLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stationWyLB
handles.stationNdx = get(hObject,'Value');
handles.stationLst = cellstr(get(hObject,'String'));
% Plot results for selection
titlePlot(handles)
%
% --- Executes during object creation, after setting all properties.
function stationWyLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stationWyLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
function titlePlot(handles)
%% Title and plot drainage areas and flows
set(handles.octTitleST,'String',['October ', ...
    num2str(str2num(handles.wySeq{handles.wySel})-1)]);
set(handles.novTitleST,'String',['November ',...
    num2str(str2num(handles.wySeq{handles.wySel})-1)]);
set(handles.decTitleST,'String',['December ',...
    num2str(str2num(handles.wySeq{handles.wySel})-1)]);
set(handles.janTitleST,'String',['January ',handles.wySeq{handles.wySel}]);
set(handles.febTitleST,'String',['February ',handles.wySeq{handles.wySel}]);
set(handles.marTitleST,'String',['March ',handles.wySeq{handles.wySel}]);
set(handles.aprTitleST,'String',['April ',handles.wySeq{handles.wySel}]);
set(handles.mayTitleST,'String',['May ',handles.wySeq{handles.wySel}]);
set(handles.junTitleST,'String',['June ',handles.wySeq{handles.wySel}]);
set(handles.julTitleST,'String',['July ',handles.wySeq{handles.wySel}]);
set(handles.augTitleST,'String',['August ',handles.wySeq{handles.wySel}]);
set(handles.sepTitleST,'String',['September ',handles.wySeq{handles.wySel}]);
%
% Plot incremental adjusted measured flow and estimated/constrained flows
% Setup hAFinchGUI link
hAFinchGUI  = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
StaHist     = getappdata(hAFinchGUI','StaHist');
%
iy = get(handles.WaterYearPM,'Value');
% set(handles.stationWyLB,'Value',1);
set(handles.stationWyLB,'String',StaHist(1,iy).StaList);
% Plot monthly flow data
for im = 1:12,
    h = eval(sprintf('handles.PlotAx%02u',im));
    axes(h);
    if strcmp(handles.plotType,'estFlowRB')
        plot(sqrt(StaHist(1,handles.wySel).QAdjIncWY(:,im)),...
            sqrt(StaHist(1,handles.wySel).QEstIncWY(:,im)),'r+','MarkerSize',5);
        % Plot squares on selected station
        hold on
        if ~isempty(handles.stationNdx)
            plot(sqrt(StaHist(1,handles.wySel).QAdjIncWY(handles.stationNdx,im)),...
                sqrt(StaHist(1,handles.wySel).QEstIncWY(handles.stationNdx,im)),...
                'bs','MarkerSize',6);
        end
        %
        maxQ = max([StaHist(1,handles.wySel).QAdjIncWY(:,im)',...
            StaHist(1,handles.wySel).QEstIncWY(:,im)']);
        rho = corr([StaHist(1,handles.wySel).QAdjIncWY(:,im)],...
            [StaHist(1,handles.wySel).QEstIncWY(:,im)],'type','Spearman');
        text(0.7*sqrt(max(StaHist(1,handles.wySel).QAdjIncWY(:,im))),...
            0.15*sqrt(max(StaHist(1,handles.wySel).QAdjIncWY(:,im))),...
            ['r^2 = ',num2str(rho^2,'%4.2f')]);
        %
    else
        % plotType is conFlowRB
        plot(sqrt(StaHist(1,handles.wySel).QAdjIncWY(:,im)),...
            sqrt(StaHist(1,handles.wySel).QConIncWY(:,im)),'ro','MarkerSize',5);
        % Plot squares on selected station
        hold on
        if ~isempty(handles.stationNdx)
            plot(sqrt(StaHist(1,handles.wySel).QAdjIncWY(handles.stationNdx,im)),...
                sqrt(StaHist(1,handles.wySel).QConIncWY(handles.stationNdx,im)),...
                'bs','MarkerSize',6);
        end
        maxQ = max([StaHist(1,handles.wySel).QAdjIncWY(:,im)',...
            StaHist(1,handles.wySel).QConIncWY(:,im)']);
    end
    plot([0,sqrt(maxQ)],[0,sqrt(maxQ)],'k:');
    hold off
    % Label y-axis as needed
    if ismember(im,[1 5 9])
        set(get(gca,'YLabel'),'String',...
            {'Square root of incremental';'adjusted estimated flow,';...
            'in cubic feet per second'});
    end
    % Label x-axis as needed
    if ismember(im,[9 10 11 12])
        set(get(gca,'XLabel'),'String',...
            {'Square root of incremental';'adjusted measured flow,';...
            'in cubic feet per second'});
    end
    % End month loop
end
%

% --- Executes when selected object is changed in plotTypeBG.
function plotTypeBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in plotTypeBG
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.plotType = get(eventdata.NewValue,'Tag');
titlePlot(handles)
fprintf(1,'plotType = %s.\n',handles.plotType);
guidata(hObject,handles);
