function varargout = AFStudyArea(varargin)
% AFSTUDYAREA MATLAB code for AFStudyArea.fig
%      AFSTUDYAREA, by itself, creates a new AFSTUDYAREA or raises the existing
%      singleton*.
%
%      H = AFSTUDYAREA returns the handle to a new AFSTUDYAREA or the handle to
%      the existing singleton*.
%
%      AFSTUDYAREA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFSTUDYAREA.M with the given input arguments.
%
%      AFSTUDYAREA('Property','Value',...) creates a new AFSTUDYAREA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFStudyArea_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFStudyArea_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFStudyArea

% Last Modified by GUIDE v2.5 06-Mar-2012 13:12:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AFStudyArea_OpeningFcn, ...
    'gui_OutputFcn',  @AFStudyArea_OutputFcn, ...
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
%
% End initialization code - DO NOT EDIT
% --- Executes just before AFStudyArea is made visible.
function AFStudyArea_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFStudyArea (see VARARGIN)

% Choose default command line output for AFStudyArea
handles.output = hObject;
hAFinchGUI = getappdata(0,'hAFinchGUI');
setappdata(hAFinchGUI,'in4digit',1);
setappdata(hAFinchGUI,'originalFmt',1);
% Update handles structure
guidata(hObject, handles);
%

% --- Outputs from this function are returned to the command line.
function varargout = AFStudyArea_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
varargout{1} = handles.output;
%

% --- Executes on selection change in HydrologicRegionLB.
function HydrologicRegionLB_Callback(hObject, ~, handles)
% hObject    handle to HydrologicRegionLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAFinchGUI     = getappdata(0,'hAFinchGUI');
AllRegions     = cellstr(get(hObject,'String'));
HydroRegionNdx = AllRegions{get(hObject,'Value')};
fprintf(1,'%s \n',HydroRegionNdx);
% Check to see whether a corresponding Region is defined on
% HSR is Hydrologic (Sub)Region
curDir                  = pwd;
ndxSlash                = max(strfind(curDir,'\'));
handles.HSR             = ['HR',HydroRegionNdx(2:3)];
setappdata(hAFinchGUI,'HSR',handles.HSR);
handles.dirHSR          = [curDir(1:ndxSlash),handles.HSR];
handles.shapefilefolder = [handles.dirHSR,'\GIS'];
handles.HSRname         = HydroRegionNdx(1:end);
setappdata(hAFinchGUI,'HSRname',handles.HSRname);
fprintf(1,'Dir %s expected for target hydrologic region %s.\n',...
    handles.HSR,handles.HSRname);
%
if exist(handles.dirHSR,'dir')
    fprintf(1,'%s folder was found. Continue. \n',handles.dirHSR);
    set(handles.HUCselectST,'String',handles.shapefilefolder);
    set(handles.HucListButtonGroup,'BackgroundColor',[0.91 0.91 0.91]);
    set(handles.HUCselectPanel,'BackgroundColor',[0.83 0.82 0.78]);
    set(handles.HUCselectST,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.selectHucPB,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.HucListButtonGroup,'BackgroundColor',[0.83 0.82 0.78]);
    set(handles.HucListButtonGroup,'BackgroundColor',[0.83 0.82 0.78]);
    set(handles.HucList4Digit,'BackgroundColor',[0.83 0.82 0.78]);
    set(handles.HucList8Digit,'BackgroundColor',[0.83 0.82 0.78]);
    set(handles.MapHucPB,'BackgroundColor',[1 1 1]);
    %
else
    % Run the directory selection tool.
    handles.selectHucPB
    set(handles.HucListButtonGroup,'BackgroundColor',[0.5 0.5 0.5]);
    errordlg({'Folder for selected region *not* found.';...
        'Select alternative folder or create folder ';...
        'outside of AFINCH with appropriate contents.'},...
        ['Folder ',handles.HSR,' not found.']);
end
guidata(hObject,handles);
%
% --- Executes during object creation, after setting all properties.
function HydrologicRegionLB_CreateFcn(hObject, ~, ~)
% hObject    handle to HydrologicRegionLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
% --- Executes on button press in MapHucPB.
function MapHucPB_Callback(~, ~, handles)
% hObject    handle to MapHucPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAFinchGUI  = getappdata(0,'hAFinchGUI');
in4digit    = getappdata(hAFinchGUI,'in4digit');
%Have user select 8 or 4 digit HUCS depending on button value
currentfolder=pwd;
% shapefilefolder=regexprep(currentfolder,'AWork','HUC');
% shapefilefolder = handles.dirHSR;
if in4digit==1
    %show map of 4-digit HUCS and ask user to select 1 or more HUCs
    tempshapefile='HUC4.shp';
    hucshapefile=fullfile(handles.shapefilefolder,tempshapefile);
    huclist=AFSelectHUC(hucshapefile);
else
    %show map of 8-digit HUCS and ask user to select 1 or more HUCs
    tempshapefile='HUC8.shp';
    hucshapefile=fullfile(handles.shapefilefolder,tempshapefile);
    huclist=AFSelectHUC(hucshapefile);
end
%
setappdata(hAFinchGUI,'huclist',huclist);
%
% --- Executes when selected object is changed in HucListButtonGroup.
function HucListButtonGroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in HucListButtonGroup
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
hAFinchGUI = getappdata(0,'hAFinchGUI');
HucSetTag = get(eventdata.NewValue,'Tag'); % Get Tag of selected object.
switch HucSetTag
    case 'HucList4Digit'
        setappdata(hAFinchGUI,'in4digit',1);
    case 'HucList8Digit'
        setappdata(hAFinchGUI,'in4digit',0);
end
%
% --- Executes on button press in HucToolExit.
function HucToolExit_Callback(~, ~, ~)
% hObject    handle to HucToolExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = gcf();
close(h);
return


% --- Executes on button press in selectHucPB.
function selectHucPB_Callback(hObject, eventdata, handles)
% hObject    handle to selectHucPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.shapefileDir = uigetdir('','Directory with HUC shapefile');
set(handles.HUCselectST,'String',handles.shapefileDir);
guidata(hObject,handles);
