function varargout = AFDesignMatrixDAreasGUI(varargin)
% AFDESIGNMATRIXDAREASGUI MATLAB code for AFDesignMatrixDAreasGUI.fig
%      AFDESIGNMATRIXDAREASGUI, by itself, creates a new AFDESIGNMATRIXDAREASGUI or raises the existing
%      singleton*.
%
%      H = AFDESIGNMATRIXDAREASGUI returns the handle to a new AFDESIGNMATRIXDAREASGUI or the handle to
%      the existing singleton*.
%
%      AFDESIGNMATRIXDAREASGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFDESIGNMATRIXDAREASGUI.M with the given input arguments.
%
%      AFDESIGNMATRIXDAREASGUI('Property','Value',...) creates a new AFDESIGNMATRIXDAREASGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFDesignMatrixDAreasGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFDesignMatrixDAreasGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFDesignMatrixDAreasGUI

% Last Modified by GUIDE v2.5 07-Jun-2012 15:49:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFDesignMatrixDAreasGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFDesignMatrixDAreasGUI_OutputFcn, ...
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

% --- Executes just before AFDesignMatrixDAreasGUI is made visible.
function AFDesignMatrixDAreasGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFDesignMatrixDAreasGUI (see VARARGIN)
hAFinchGUI      = getappdata(0,'hAFinchGUI');
WY1             = getappdata(hAFinchGUI,'WY1');
WYn             = getappdata(hAFinchGUI,'WYn');
Ny              = getappdata(hAFinchGUI,'Ny');
handles.StaHist = getappdata(hAFinchGUI,'StaHist');
% HSR        = getappdata(hAFinchGUI,'HSR');
% AFstruct   = getappdata(hAFinchGUI,'AFstruct');

% Choose default command line output for AFDesignMatrixDAreasGUI
handles.output = hObject;
% Create cell array of years
years = WY1:WYn; 
for i = 1:Ny
    handles.wySeq(i) = {num2str(years(i))};
end
%
set(handles.WaterYearPM,'String',handles.wySeq); 
set(handles.WaterYearPM,'Value',1); 
handles.wySel = 1;
% Update handles structure
guidata(hObject, handles);
%
plotDesignMatrixDAreas(handles);

% UIWAIT makes AFDesignMatrixDAreasGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFDesignMatrixDAreasGUI_OutputFcn(hObject, eventdata, handles) 
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
%
guidata(hObject,handles);
plotDesignMatrixDAreas(handles);

    
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
%
% yloc = handles.stationNdx; 
set(handles.designMatrixAX,'YTick',handles.stationNdx);
set(handles.designMatrixAX,'YTickLabel',...
    handles.stationLst(handles.stationNdx));
% Cause area relation to identify selected points
axes(handles.dAreaNwisNhdAX);
% Plot active streamgages in selected water year
plot(sqrt(handles.StaHist(1,handles.wySel).NHDAreaIWY),...
    sqrt(handles.StaHist(1,handles.wySel).NWISAreaIWY),'r+');
hold on
% Plot line of agreement
plot([.1,sqrt(max(max([handles.StaHist(1,handles.wySel).NHDAreaIWY]),...
     max([handles.StaHist(1,handles.wySel).NWISAreaIWY])))],...
     [.1,sqrt(max(max([handles.StaHist(1,handles.wySel).NHDAreaIWY]),...
     max([handles.StaHist(1,handles.wySel).NWISAreaIWY])))],'k-');
% Plot area in square roots (consistent with flows, where 0 values may be fine.)
plot(sqrt(handles.StaHist(1,handles.wySel).NHDAreaIWY(handles.stationNdx)),...
    sqrt(handles.StaHist(1,handles.wySel).NWISAreaIWY(handles.stationNdx)),'bs');
% Label axes
set(get(gca,'YLabel'),'String','Square root of NWIS drainage area, in square miles');
set(get(gca,'XLabel'),'String','Square root of NHDPlus drainage area, in square miles');
hold off

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

function plotDesignMatrixDAreas(handles)
%
hAFinchGUI = getappdata(0,'hAFinchGUI');
HSR        = getappdata(hAFinchGUI,'HSR');
AFstruct   = getappdata(hAFinchGUI,'AFstruct');
StaHist    = getappdata(hAFinchGUI,'StaHist');
%
set(handles.WaterYieldMeaTitleST,'String',...
    ['Lower triangular elements show nested subbasin structure in ',...
    handles.wySeq{handles.wySel}]);
set(handles.WaterYieldAdjTitleST,'String',...
    ['Relation between NHDPlus and NWIS drainage areas in ',...
    handles.wySeq{handles.wySel}]);
%
%%
% The intersection below integrates information about gages operated 
% historically and gages operated in a specific water year. 
[StaList,StaNdx,FloNdx]=intersect([AFstruct.(HSR)(handles.wySel,:).Station],...
    StaHist(handles.wySel).StaList);
% Ns is the number of active stations in a given year
Ns = length(StaList);
NetDesign = eye(Ns);
%
for is=1:(Ns-1),
    % "js" is a local index tracking the station index "is".
    for js=is+1:Ns,
        % Find any common catchments within the two streamgages
        [~,Ndx] = intersect(AFstruct.(HSR)(handles.wySel,StaNdx(is)).GridCode,...
            AFstruct.(HSR)(handles.wySel,StaNdx(js)).GridCode);
        % If the basins are nested, remove the common catchments from the
        % lower gaged area
        if ~isempty(Ndx)
            NetDesign(js,is) = 1;
        end
    end
end
%
%% Plot the Network Design Matrix
% Gather data from base workspace
% Select axes of target plot
axes(handles.designMatrixAX);
% Display image of network design
imagesc(NetDesign,[0,1]); 
set(get(gca,'XLabel'),'String','Sequence number of downstream-ordered streamgage');
% set(get(gca,'YTickLabel'),'String',[handles.StaHist(1,handles.wySel).StaList]);
set(handles.designMatrixAX,'YTick',1:length(handles.StaHist(1,handles.wySel).StaList));
set(handles.designMatrixAX,'YTickLabel',handles.StaHist(1,handles.wySel).StaList);
set(handles.stationWyLB,'Value',1);
set(handles.stationWyLB,'String',handles.StaHist(1,handles.wySel).StaList);
colormap([1 1 1;.5 .5 .5]);
%
%% Plot the NHDPlus and NWIS drainage areas
axes(handles.dAreaNwisNhdAX);
% Plot area in square roots (consistent with flows, where 0 values may be fine.)
plot(sqrt(handles.StaHist(1,handles.wySel).NHDAreaIWY),...
    sqrt(handles.StaHist(1,handles.wySel).NWISAreaIWY),'r+');
hold on
% Plot line of agreement
plot([.1,sqrt(max(max([handles.StaHist(1,handles.wySel).NHDAreaIWY]),...
     max([handles.StaHist(1,handles.wySel).NWISAreaIWY])))],...
     [.1,sqrt(max(max([handles.StaHist(1,handles.wySel).NHDAreaIWY]),...
     max([handles.StaHist(1,handles.wySel).NWISAreaIWY])))],'k-');
% Label axes
set(get(gca,'YLabel'),'String','Square root of NWIS drainage area, in square miles');
set(get(gca,'XLabel'),'String','Square root of NHDPlus drainage area, in square miles');
hold off
%
% Refresh memory variables
setappdata(hAFinchGUI,'StaHist',handles.StaHist);
setappdata(hAFinchGUI,'Ns',Ns);


% --- Executes on button press in explainPB.
function explainPB_Callback(hObject, eventdata, handles)
% hObject    handle to explainPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% axes(handles.explainPB);



% --- Executes during object creation, after setting all properties.
function explainPB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to explainPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
explainIcon = imread('designMatrixDAreaExplain.jpg','jpg');
set(hObject,'CData',explainIcon);
