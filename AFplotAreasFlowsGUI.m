function varargout = AFplotAreasFlowsGUI(varargin)
% AFPLOTAREASFLOWSGUI MATLAB code for AFplotAreasFlowsGUI.fig
%      AFPLOTAREASFLOWSGUI, by itself, creates a new AFPLOTAREASFLOWSGUI or raises the existing
%      singleton*.
%
%      H = AFPLOTAREASFLOWSGUI returns the handle to a new AFPLOTAREASFLOWSGUI or the handle to
%      the existing singleton*.
%
%      AFPLOTAREASFLOWSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFPLOTAREASFLOWSGUI.M with the given input arguments.
%
%      AFPLOTAREASFLOWSGUI('Property','Value',...) creates a new AFPLOTAREASFLOWSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFplotAreasFlowsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFplotAreasFlowsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFplotAreasFlowsGUI

% Last Modified by GUIDE v2.5 26-Apr-2012 14:59:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFplotAreasFlowsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFplotAreasFlowsGUI_OutputFcn, ...
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

% --- Executes just before AFplotAreasFlowsGUI is made visible.
function AFplotAreasFlowsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFplotAreasFlowsGUI (see VARARGIN)
hAFinchGUI = getappdata(0,'hAFinchGUI');
WY1        = getappdata(hAFinchGUI,'WY1');
WYn        = getappdata(hAFinchGUI,'WYn');
%
% Choose default command line output for AFplotAreasFlowsGUI
handles.output = hObject;
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

% UIWAIT makes AFplotAreasFlowsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFplotAreasFlowsGUI_OutputFcn(hObject, eventdata, handles) 
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
handles.stationNdx = [];
guidata(hObject,handles);
% Plot results for selection
titlePlot(handles)
% Update guidata
    
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
% Plot incremental drainage areas with incremental monthly flows
hAFinchGUI = getappdata(0,'hAFinchGUI');
StaHist    = getappdata(hAFinchGUI,'StaHist');
%
iy = get(handles.WaterYearPM,'Value');
% djh commented the following line out to avoid resetting the station LB
% set(handles.stationWyLB,'Value',1);
set(handles.stationWyLB,'String',StaHist(1,iy).StaList);
%
% Plot monthly flow-area relations
for im = 1:12,
    h  = eval(sprintf('handles.PlotAx%02u',im));
    axes(h);
    plot(sqrt(StaHist(1,handles.wySel).NHDAreaIWY),...
        sqrt(StaHist(1,handles.wySel).QTotIncWY(:,im)),'r+');
    hold on
    plot(sqrt(StaHist(1,handles.wySel).NHDAreaIWY),...
        sqrt(StaHist(1,handles.wySel).QAdjIncWY(:,im)),'kx','MarkerSize',8);
    if ~isempty(handles.stationNdx)
        plot(sqrt(StaHist(1,handles.wySel).NHDAreaIWY(handles.stationNdx)),...
            sqrt(StaHist(1,handles.wySel).QAdjIncWY(handles.stationNdx,im)),'bs');
    end
    hold off
    % Label x-axis for bottom row of plot
    if ismember(im,[9 10 11 12])
        xlabel({'Square root of incremental';'drainage area, in square miles'});
    end
    % Label y-axis for left side plots
    if ismember(im,[1,5,9])
        ylabel({'Square root of incremental';'flow, in cubic feet per second'});
    end
%    set(get(gca,'YLabel'),'String',{'Square root of incremental';'flow, in cubic feet per second'});
end

% --- Executes on button press in explainPB.
function explainPB_Callback(hObject, eventdata, handles)
% hObject    handle to explainPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function explainPB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to explainPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
explainIcon = imread('dAreaFlowExplain.jpg','jpg');
set(hObject,'CData',explainIcon);
