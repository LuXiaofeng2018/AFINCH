function varargout = AFWaterYieldGUI(varargin)
% AFWATERYIELDGUI MATLAB code for AFWaterYieldGUI.fig
%      AFWATERYIELDGUI, by itself, creates a new AFWATERYIELDGUI or raises the existing
%      singleton*.
%
%      H = AFWATERYIELDGUI returns the handle to a new AFWATERYIELDGUI or the handle to
%      the existing singleton*.
%
%      AFWATERYIELDGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFWATERYIELDGUI.M with the given input arguments.
%
%      AFWATERYIELDGUI('Property','Value',...) creates a new AFWATERYIELDGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFWaterYieldGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFWaterYieldGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFWaterYieldGUI

% Last Modified by GUIDE v2.5 16-Feb-2012 13:44:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFWaterYieldGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFWaterYieldGUI_OutputFcn, ...
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

% --- Executes just before AFWaterYieldGUI is made visible.
function AFWaterYieldGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFWaterYieldGUI (see VARARGIN)
% global WY1 WYn nYr HSR 
hAFinchGUI = getappdata(0,'hAFinchGUI');
WY1        = getappdata(hAFinchGUI,'WY1');
WYn        = getappdata(hAFinchGUI,'WYn');
AFstruct   = getappdata(hAFinchGUI,'AFstruct');
HSR        = getappdata(hAFinchGUI,'HSR');
Ny         = getappdata(hAFinchGUI,'Ny');
% Choose default command line output for AFWaterYieldGUI
handles.output = hObject;
% Create cell array of years
years = WY1:WYn;
for i = 1:Ny
    handles.WYseq(i) = {num2str(years(i))};
end
%
guidata(hObject,handles);
set(handles.WaterYearPM,'String',handles.WYseq); 
set(handles.WaterYearPM,'Value',1);
strYear = handles.WYseq(1);
set(handles.WaterYieldMeaTitleST,'String',...
    ['Incremental Water Yield Unadjusted for Water Use in ',strYear{:},' (inches)']);
set(handles.WaterYieldAdjTitleST,'String',...
    ['Incremental Water Yield Adjusted for Water Use in ',strYear{:},' (inches)']);
%
[Ny,nSta] = size(eval(['AFstruct.',HSR]));
clear YMeaIncWY yMeaIncWY staListWY
kSta = 0; % Counter for the numbers of streamgages with data
for iSta = 1:nSta
    % Find if the station was active for the selected year
    yMeaIncWY = eval(['AFstruct.',HSR,'(',num2str(1),',',num2str(iSta),').YTotIncWY']);
    yAdjIncWY = eval(['AFstruct.',HSR,'(',num2str(1),',',num2str(iSta),').YAdjIncWY']);
    if ~isempty(yMeaIncWY)
        if exist('YMeaIncWY','var')
            kSta = kSta + 1;
            YMeaIncWY = [YMeaIncWY;yMeaIncWY(1:12)];
            YAdjIncWY = [YAdjIncWY;yAdjIncWY(1:12)];
            staListWY(kSta) = eval(['AFstruct.',HSR,'(',num2str(1),',',num2str(iSta),').Station']);
        else
            % First station with data for the selected water year
            kSta = 1;
            YMeaIncWY = yMeaIncWY(1:12);
            YAdjIncWY = yAdjIncWY(1:12);
            staListWY(1) = eval(['AFstruct.',HSR,'(',num2str(1),',',num2str(iSta),').Station']);
        end
    end
end
%
set(handles.stationWyLB,'String',staListWY);
%
%% Create two Lo and Hi variables so that Mea. and Adj. plots have same limits
CLimLo1 = floor(min(min([YMeaIncWY(:,1:12)]))*10)/10;
CLimHi1 =  ceil(max(max([YMeaIncWY(:,1:12)]))*10)/10;
CLimLo2 = floor(min(min([YAdjIncWY(:,1:12)]))*10)/10;
CLimHi2 =  ceil(max(max([YAdjIncWY(:,1:12)]))*10)/10;
CLimLo = min(CLimLo1, CLimLo2);
CLimHi = max(CLimHi1, CLimHi2);
%
red = ones(64,1); grn = ones(64,1); blu = ones(64,1);
if CLimLo<0,
    CLimDt          = (CLimHi - CLimLo)/64;
    NStep           = abs(round(CLimLo/CLimDt));
    % Interpolate from red to white
    red(1:NStep)    = ones(NStep,1);
    grn(1:NStep)    = interp1([CLimLo,0],[0,1],linspace(CLimLo,0,NStep));
    blu(1:NStep)    = interp1([CLimLo,0],[0,1],linspace(CLimLo,0,NStep));
    % Interpolate from white to blue
    red(NStep+1:64) = interp1([1,CLimHi],[1,0],linspace(1,CLimHi,64-NStep));
    grn(NStep+1:64) = interp1([1,CLimHi],[1,0],linspace(1,CLimHi,64-NStep));
    blu(NStep+1:64) = ones(64-NStep,1);
else
    % Interpolate from white to blue
    red(1:64)       = linspace(1,0,64);
    grn(1:64)       = linspace(1,0,64);
    blu(1:64)       = ones(64,1);
end
RGB1 = [red grn blu];
% Plot the Measured Water Yield Image
axes(handles.WaterYieldMeasuredAX);
set(gcf,'Colormap',RGB1);
imagesc(YMeaIncWY(:,1:12),[CLimLo,CLimHi]); % ,'Colormap',RGB1);
colorbar();
% Plot the Adjusted Water Yield Image (Adjusted is Measured minus Water Use
axes(handles.WaterYieldAdjustedAX);
imagesc(YAdjIncWY(:,1:12),[CLimLo,CLimHi]); 
colorbar();
% 
% handles.stationNdx = get(hObject,'Value');
% handles.stationLst = cellstr(get(hObject,'String'));
yloc = 1:length(staListWY);
set(handles.WaterYieldMeasuredAX,'YTick',yloc);
set(handles.WaterYieldMeasuredAX,'YTickLabel',staListWY);
% set Month names
set(handles.WaterYieldMeasuredAX,'XTick',1:12);
set(handles.WaterYieldMeasuredAX','XTickLabel',...
    {'Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep'});
set(handles.WaterYieldAdjustedAX,'XTick',1:12);
set(handles.WaterYieldAdjustedAX','XTickLabel',...
    {'Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep'});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFWaterYieldGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFWaterYieldGUI_OutputFcn(hObject, eventdata, handles) 
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
hAFinchGUI = getappdata(0,'hAFinchGUI');
AFstruct   = getappdata(hAFinchGUI,'AFstruct');
HSR        = getappdata(hAFinchGUI,'HSR');
%
yrSeq  = cellstr(get(hObject,'String'));
selYr  =         get(hObject,'Value');
%
set(handles.WaterYieldMeaTitleST,'String',...
    ['Incremental Water Yield Unadjusted for Water Use in ',yrSeq{selYr},' (inches)']);
set(handles.WaterYieldAdjTitleST,'String',...
    ['Incremental Water Yield Adjusted for Water Use in ',yrSeq{selYr},' (inches)']);
%
[Ny,nSta] = size(eval(['AFstruct.',HSR]));
clear YMeaIncWY yMeaIncWY staListWY
kSta = 0; % Counter for the numbers of streamgages with data
for iSta = 1:nSta
    % Find if the station was active for the selected year
    yMeaIncWY = eval(['AFstruct.',HSR,'(',num2str(selYr),',',num2str(iSta),').YTotIncWY']);
    yAdjIncWY = eval(['AFstruct.',HSR,'(',num2str(selYr),',',num2str(iSta),').YAdjIncWY']);
    if ~isempty(yMeaIncWY)
        if exist('YMeaIncWY','var')
            kSta = kSta + 1;
            YMeaIncWY = [YMeaIncWY;yMeaIncWY(1:12)];
            YAdjIncWY = [YAdjIncWY;yAdjIncWY(1:12)];
            staListWY(kSta) = eval(['AFstruct.',HSR,'(',num2str(selYr),',',num2str(iSta),').Station']);
        else
            % First station with data for the selected water year
            kSta = 1;
            YMeaIncWY = yMeaIncWY(1:12);
            YAdjIncWY = yAdjIncWY(1:12);
            staListWY(1) = eval(['AFstruct.',HSR,'(',num2str(selYr),',',num2str(iSta),').Station']);
        end
    end
end
%
% Update the y-axis with station number
set(handles.stationWyLB,'String',staListWY);
%
%% Create two Lo and Hi variables so that Mea. and Adj. plots have same limits
CLimLo1 = floor(min(min([YMeaIncWY(:,1:12)]))*10)/10;
CLimHi1 =  ceil(max(max([YMeaIncWY(:,1:12)]))*10)/10;
CLimLo2 = floor(min(min([YAdjIncWY(:,1:12)]))*10)/10;
CLimHi2 =  ceil(max(max([YAdjIncWY(:,1:12)]))*10)/10;
CLimLo = min(CLimLo1, CLimLo2);
CLimHi = max(CLimHi1, CLimHi2);
%
red = ones(64,1); grn = ones(64,1); blu = ones(64,1);
if CLimLo<0,
    CLimDt          = (CLimHi - CLimLo)/64;
    NStep           = abs(round(CLimLo/CLimDt));
    % Interpolate from red to white
    red(1:NStep)    = ones(NStep,1);
    grn(1:NStep)    = interp1([CLimLo,0],[0,1],linspace(CLimLo,0,NStep));
    blu(1:NStep)    = interp1([CLimLo,0],[0,1],linspace(CLimLo,0,NStep));
    % Interpolate from white to blue
    red(NStep+1:64) = interp1([1,CLimHi],[1,0],linspace(1,CLimHi,64-NStep));
    grn(NStep+1:64) = interp1([1,CLimHi],[1,0],linspace(1,CLimHi,64-NStep));
    blu(NStep+1:64) = ones(64-NStep,1);
else
    % Interpolate from white to blue
    red(1:64)       = linspace(1,0,64);
    grn(1:64)       = linspace(1,0,64);
    blu(1:64)       = ones(64,1);
end
RGB1 = [red grn blu];
% Plot the Measured Water Yield Image

axes(handles.WaterYieldMeasuredAX);
set(gcf,'Colormap',RGB1);
imagesc(YMeaIncWY,[CLimLo,CLimHi]);
% imagesc(YMeaIncWY);
colorbar();

% Plot the Adjusted Water Yield Image (Adjusted is Measured minus Water Use
axes(handles.WaterYieldAdjustedAX);
%
set(gcf,'Colormap',RGB1);
imagesc(YAdjIncWY,[CLimLo,CLimHi]);
% imagesc(YAdjIncWY); 
colorbar();
% 
yloc = 1:length(staListWY);
set(handles.WaterYieldMeasuredAX,'YTick',yloc);
set(handles.WaterYieldMeasuredAX,'YTickLabel',staListWY);
% set Month names
set(handles.WaterYieldMeasuredAX,'XTick',1:12);
set(handles.WaterYieldMeasuredAX','XTickLabel',...
    {'Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep'});
set(handles.WaterYieldAdjustedAX,'XTick',1:12);
set(handles.WaterYieldAdjustedAX','XTickLabel',...
    {'Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep'});

% Update guidata
guidata(hObject,handles);
    


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
yloc = handles.stationNdx; % - 1/(2*length(handles.stationLst));
set(handles.WaterYieldMeasuredAX,'YTick',yloc);
set(handles.WaterYieldMeasuredAX,'YTickLabel',...
    handles.stationLst(handles.stationNdx));
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
