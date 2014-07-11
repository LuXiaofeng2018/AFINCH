function varargout = AFdistWaterYieldGUI(varargin)
% AFDISTWATERYIELDGUI MATLAB code for AFdistWaterYieldGUI.fig
%      AFDISTWATERYIELDGUI, by itself, creates a new AFDISTWATERYIELDGUI or raises the existing
%      singleton*.
%
%      H = AFDISTWATERYIELDGUI returns the handle to a new AFDISTWATERYIELDGUI or the handle to
%      the existing singleton*.
%
%      AFDISTWATERYIELDGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFDISTWATERYIELDGUI.M with the given input arguments.
%
%      AFDISTWATERYIELDGUI('Property','Value',...) creates a new AFDISTWATERYIELDGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFdistWaterYieldGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFdistWaterYieldGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFdistWaterYieldGUI

% Last Modified by GUIDE v2.5 09-Mar-2012 13:06:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFdistWaterYieldGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFdistWaterYieldGUI_OutputFcn, ...
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


% --- Executes just before AFdistWaterYieldGUI is made visible.
function AFdistWaterYieldGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFdistWaterYieldGUI (see VARARGIN)
%
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
WY1 = getappdata(hAFinchGUI,'WY1');
WYn = getappdata(hAFinchGUI,'WYn');
%
handles.estimator = 'Regression';
% Choose default command line output for AFdistWaterYieldGUI
handles.output = hObject;
set(handles.waterYearPU,'String',num2str([WY1:WYn]'));
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFdistWaterYieldGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFdistWaterYieldGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in waterYearPU.
function waterYearPU_Callback(hObject, eventdata, handles)
% hObject    handle to waterYearPU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns waterYearPU contents as cell array
%        contents{get(hObject,'Value')} returns selected item from waterYearPU


% --- Executes during object creation, after setting all properties.
function waterYearPU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waterYearPU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in monthPU.
function monthPU_Callback(hObject, eventdata, handles)
% hObject    handle to monthPU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns monthPU contents as cell array
%        contents{get(hObject,'Value')} returns selected item from monthPU


% --- Executes during object creation, after setting all properties.
function monthPU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monthPU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createHistPB.
function createHistPB_Callback(hObject, eventdata, handles)
% hObject    handle to createHistPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI
WY1       = getappdata(hAFinchGUI,'WY1');
MonthName = getappdata(hAFinchGUI,'MonthName');


lcatchSF  = length(handles.catchSF);
iy        = get(handles.waterYearPU,'Value');
im        = get(handles.monthPU,'Value');
% Recompute yield estimator target given the selected estimator
% computeTarget(hObject, eventdata, handles)
% handles.iy        = get(handles.waterYearPU,'Value');
% handles.im        = get(handles.monthPU,'Value');
%
if strcmpi(handles.estimator,'Regression')
    % Case for regression estimator
    for i=1:lcatchSF
        handles.catchSF(i,1).Target = ...
            handles.catchSF(i,1).YieldCatchEst(iy,im);
    end
    handles.subtitle = 'Regression Estimate ';
    fprintf(1,'Target is regression estimate.\n');
else
    % Case for constrained estimator 
    for i=1:lcatchSF
        handles.catchSF(i,1).Target = ...
            handles.catchSF(i,1).YieldCatchCon(iy,im);
    end
    handles.subtitle = 'Constrained Estimate ';
    fprintf(1,'Target is constrained estimate.\n');
end

%
% h = axes(handles.histPlot);
TargetHi = prctile([handles.catchSF.Target],99.5);

[n,xout] = hist([handles.catchSF.Target],0:.1:TargetHi);
n = n/sum(n);
bar(handles.histPlot,xout,n);
set(handles.histPlot,'XLim',[0,ceil(TargetHi)]);
ytick = get(handles.histPlot,'YTick');
set(handles.histPlot,'YTickLabel',sprintf('%4.2f|',ytick));
set(get(handles.histPlot,'XLabel'),'String','Water yield, in inches');
set(get(handles.histPlot,'YLabel'),'String','Relative frequency');
set(get(handles.histPlot,'Title'),'String',[handles.subtitle,...
    'for ',MonthName{im},' ',num2str(WY1+iy-1,'%u')]);
drawnow
guidata(hObject,handles);

% --- Executes when selected object is changed in yieldEstimatorBG.
function yieldEstimatorBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in yieldEstimatorBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

handles.estimator = get(eventdata.NewValue,'String');
% handles.iy        = get(handles.waterYearPU,'Value');
% handles.im        = get(handles.monthPU,'Value');
guidata(hObject,handles);
computeTarget(hObject, eventdata, handles)

%
function computeTarget(hObject, ~, handles)
%
% handles.estimator = get(eventdata.NewValue,'String');
handles.iy        = get(handles.waterYearPU,'Value');
handles.im        = get(handles.monthPU,'Value');
%
if strcmpi(handles.estimator,'Regression')
    % Case for regression estimator
    for i=1:handles.lcatchSF
        handles.catchSF(i,1).Target = ...
            handles.catchSF(i,1).YieldCatchEst(handles.iy,handles.im);
    end
    handles.subtitle = 'Regression Estimate ';
    fprintf(1,'Target is regression estimate.\n');
else
    % Case for constrained estimator 
    for i=1:handles.lcatchSF
        handles.catchSF(i,1).Target = ...
            handles.catchSF(i,1).YieldCatchCon(handles.iy,handles.im);
    end
    handles.subtitle = 'Constrained Estimate ';
    fprintf(1,'Target is constrained estimate.\n');
end
%
guidata(hObject,handles);

% --- Executes on button press in chloroPlotPB.
function chloroPlotPB_Callback(hObject, eventdata, handles)
% hObject    handle to chloroPlotPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
MonthName  = getappdata(hAFinchGUI,'MonthName');
HSRname    = getappdata(hAFinchGUI,'HSRname');
WY1        = getappdata(hAFinchGUI,'WY1');
%
iy         = get(handles.waterYearPU,'Value');
im         = get(handles.monthPU,'Value');
set(handles.statusPanel,'BackgroundColor',[0.93, 0.84, 0.84]);
set(handles.statusST,'String','Really busy...','FontWeight','bold',...
    'BackgroundColor',[0.93, 0.84, 0.84]);
drawnow
%
yieldColors = makesymbolspec('Polygon', {'Target', ...
   [0 ceil(prctile([handles.catchSF.Target],99.5))], 'FaceColor', flipud(jet)});
% figure(11); clf(11);
mapshow(handles.catchSF,'SymbolSpec',yieldColors,'EdgeColor',[.2 .2 .2],...
    'LineWidth',.2);
caxis([0 ceil(prctile([handles.catchSF.Target],99.5))])
title([handles.subtitle,' of Water Yield (in inches) in ',HSRname,' for ',...
    MonthName{im},' ',num2str(WY1+iy-1)]);
% Longitude label
xlabel('Degrees longitude');
xtick = get(handles.chloroplethPlot,'XTick');
set(handles.chloroplethPlot,'XTickLabel',sprintf('%4.1f|',xtick));
% Latitude label
ylabel('Degrees latitude');
ytick = get(handles.chloroplethPlot,'YTick');
set(handles.chloroplethPlot,'YTickLabel',sprintf('%4.1f|',ytick));
% Colorbar characteristics
colormap(flipud(jet));
hcb = colorbar;
%
set(handles.statusPanel,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.statusST,'String','Ready','FontWeight','normal',...
    'BackgroundColor',[0.83, 0.82, 0.78]);

guidata(hObject,handles);


% --- Executes on button press in readShapefilePB.
function readShapefilePB_Callback(hObject, eventdata, handles)
% hObject    handle to readShapefilePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Setup hAFinchGUI link
hAFinchGUI  = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
ioDir            = getappdata(hAFinchGUI,'ioDir');
yieldCatchEst    = getappdata(hAFinchGUI,'yieldCatchEst');
yieldCatchCon    = getappdata(hAFinchGUI,'yieldCatchCon');
 flowCatchEst    = getappdata(hAFinchGUI,'flowCatchEst');
 flowCatchCon    = getappdata(hAFinchGUI,'flowCatchCon');
gridcodeData     = getappdata(hAFinchGUI,'GridCode_PrecTHS');

% Get catchment shapfile
[fileName,pathName] = uigetfile('*.shp','Select the Catchment Shapefile',...
    [ioDir,'\GIS\']);
%
set(handles.statusPanel,'BackgroundColor',[0.93, 0.84, 0.84]);
set(handles.statusST,'String','Busy...','FontWeight','bold',...
    'BackgroundColor',[0.93, 0.84, 0.84]);
drawnow
% Start reading the shapefile and populating the datt structure
handles.catchSF  = shaperead([pathName,fileName]);
handles.lcatchSF = length(handles.catchSF);
%
gridcodeCatch = [handles.catchSF.GRIDCODE];
% Intersect to match data with catchments
[~,ia,ib]=intersect(gridcodeCatch,gridcodeData);
%
if isempty(ib)
    error('shapefile grid codes do not match yield output file grid codes');
else
    fprintf('The are %u common gridcodes in Data and Catchments.\n',...
        length(ib));
end
for i=1:length(ia)
    handles.catchSF(ia(i),1).YieldCatchEst = squeeze([yieldCatchEst(:,ib(i),:)]);
    handles.catchSF(ia(i),1).YieldCatchCon = squeeze([yieldCatchCon(:,ib(i),:)]);
    handles.catchSF(ia(i),1).FlowCatchEst  = squeeze( [flowCatchEst(:,ib(i),:)]);
    handles.catchSF(ia(i),1).FlowCatchCon  = squeeze( [flowCatchCon(:,ib(i),:)]);
end
%
% Initialize the Target with the regression estimate of water yield
iy        = get(handles.waterYearPU,'Value');
im        = get(handles.monthPU,'Value');
%
for i=1:handles.lcatchSF
    handles.catchSF(i,1).Target = handles.catchSF(i,1).YieldCatchEst(iy,im);
end
handles.subtitle = 'Regression Estimate ';
fprintf(1,'Target is regression estimate.\n');
%
set(handles.statusPanel,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.statusST,'String','Ready','FontWeight','normal',...
    'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.plotPanel,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.chloroPlotPB,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.RegressionRB,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.ConstrainedRB,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.yieldEstimatorBG,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.waterYearPU,'BackgroundColor',[1 1 1]);
set(handles.monthPU,'BackgroundColor',[1 1 1]);
set(handles.waterYearMonthPanel,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.createHistPB,'BackgroundColor',[0.83, 0.82, 0.78]);
set(handles.plotPanel,'BackgroundColor',[0.83, 0.82, 0.78]);
guidata(hObject,handles);
