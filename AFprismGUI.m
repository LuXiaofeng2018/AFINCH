function varargout = AFprismGUI(varargin)
% AFPRISMGUI MATLAB code for AFprismGUI.fig
%      AFPRISMGUI, by itself, creates a new AFPRISMGUI or raises the existing
%      singleton*.
%
%      H = AFPRISMGUI returns the handle to a new AFPRISMGUI or the handle to
%      the existing singleton*.
%
%      AFPRISMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFPRISMGUI.M with the given input arguments.
%
%      AFPRISMGUI('Property','Value',...) creates a new AFPRISMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFprismGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFprismGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFprismGUI

% Last Modified by GUIDE v2.5 23-Jan-2012 11:47:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFprismGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFprismGUI_OutputFcn, ...
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


% --- Executes just before AFprismGUI is made visible.
function AFprismGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFprismGUI (see VARARGIN)
% 
hAFinchGUI     = getappdata(0,'hAFinchGUI');
%
ExpVarNo = varargin{:};
setappdata(hAFinchGUI,'ExpVarNo',ExpVarNo);
RegVarNameList = getappdata(hAFinchGUI,'RegVarNameList');
%
if isempty(RegVarNameList)
    RegVarNameList = cell(1);
    setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
end
%
set(handles.ExpVarST,'String',['Specifying Explanatory Variable ',...
    num2str(ExpVarNo)]);

% Choose default command line output for AFprismGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFprismGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFprismGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

handles.datatype = 'ConPrecip';
guidata(hObject,handles);
%
function RegVarNameET_Callback(hObject, eventdata, handles)
% hObject    handle to RegVarNameET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RegVarNameET as text
%        str2double(get(hObject,'String')) returns contents of RegVarNameET as a double


% --- Executes during object creation, after setting all properties.
function RegVarNameET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegVarNameET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in SelectClimaticData.
function SelectClimaticData_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in SelectClimaticData 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.datatype = get(eventdata.NewValue,'Tag'); % Get Tag of selected object.
% Setup hAFinchGUI link
hAFinchGUI      = getappdata(0,'hAFinchGUI');
ExpVarNo        = getappdata(hAFinchGUI,'ExpVarNo');
xVar            = getappdata(hAFinchGUI,'xVar');
%
switch handles.datatype
    case 'ConPrecip'
        set(handles.RegVarNameET,'String','CurrentPrecip');
        fprintf(1,'case ConPrecip being evaluated.\n');

    case 'PrePrecip'
        set(handles.RegVarNameET,'String','PrecedPrecip');

    case 'ConTemper'
        set(handles.RegVarNameET,'String','CurrentTemper');

    otherwise
        fprintf(1,'No match for Tag %s.\',datatype);
end

guidata(hObject,handles);

% --- Executes on button press in prismReturnPB.
function prismReturnPB_Callback(hObject, eventdata, handles)
% hObject    handle to prismReturnPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAFinchGUI       = getappdata(0,'hAFinchGUI');
AFstruct         = getappdata(hAFinchGUI,'AFstruct');
HSR              = getappdata(hAFinchGUI,'HSR');
ExpVarNo         = getappdata(hAFinchGUI,'ExpVarNo');
RegVarNameList{ExpVarNo} = get(handles.RegVarNameET,'String');
setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
WY1              = getappdata(hAFinchGUI,'WY1');
xVar             = getappdata(hAFinchGUI,'xVar');
GridCode_PrecTHS = getappdata(hAFinchGUI,'GridCode_PrecTHS');
GridCode_TempTHS = getappdata(hAFinchGUI,'GridCode_TempTHS');
%
fprintf(1,'At Return pushbutton in AFprismGUI.\n');
handles.RegVarName  = get(handles.RegVarNameET,'String');
fprintf(1,'RegVarName = %s.\n',handles.RegVarName);
fprintf(1,'ExpVarNo = %u.\n',ExpVarNo);
% fprintf(1,'Length RegVarNameList= %u.\n',length(RegVarNameList));
RegVarName                = handles.RegVarName;
RegVarNameList{ExpVarNo}  = RegVarName;
%
% Update hAFinchGUI variables
setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
setappdata(hAFinchGUI,'ExpVarNo',ExpVarNo);
%
% Update handles
guidata(hObject,handles);
%
for i=1:ExpVarNo
    fprintf(1,'Regression variable %u name is: %s.\n',...
     i,RegVarNameList{i});
end
% Create explanatory variables for HUC application
fprintf(1,'datatype = %s.\n',handles.datatype);
switch handles.datatype
    case 'ConPrecip'
        fprintf(1,'case ConPrecip being evaluated.\n');
        PrsmPrecTHS     = getappdata(hAFinchGUI,'PrsmPrecTHS');
        set(handles.RegVarNameET,'String','CurrentPrecip');
        xVar(ExpVarNo).name     = 'CurrentPrecip';
        xVar(ExpVarNo).type     = 'prism';
        xVar(ExpVarNo).value    = PrsmPrecTHS;
        xVar(ExpVarNo).gridcode = GridCode_PrecTHS;
        setappdata(hAFinchGUI,'xVar',xVar);
        %
    case 'PrePrecip'
        PrsmPremTHS       = getappdata(hAFinchGUI,'PrsmPremTHS');
        set(handles.RegVarNameET,'String','PrecedPrecip');
        xVar(ExpVarNo).name     = 'PrecedPrecip';
        xVar(ExpVarNo).type     = 'prism';
        xVar(ExpVarNo).value    = PrsmPremTHS;
        xVar(ExpVarNo).gridcode = GridCode_PrecTHS;
        setappdata(hAFinchGUI,'xVar',xVar);
    case 'ConTemper'
        PrsmTempTHS       = getappdata(hAFinchGUI,'PrsmTempTHS');
        set(handles.RegVarNameET,'String','CurrentTemper');
        xVar(ExpVarNo).name     = 'CurrentTemper';
        xVar(ExpVarNo).type     = 'prism';
        xVar(ExpVarNo).value    = PrsmTempTHS;
        xVar(ExpVarNo).gridcode = GridCode_TempTHS;
        setappdata(hAFinchGUI,'xVar',xVar);
    otherwise
        fprintf(1,'No match for Tag %s.\',datatype);
end
%
fprintf(1,'RegVarNameList{%u}= %s \n',...
    ExpVarNo,RegVarNameList{ExpVarNo});
% Generate the monthly water yield matrix first
[ny,ns] = size(eval(['AFstruct.',HSR]));
% xmat holds the prism data by year, streamgage 
xmat = NaN(ny*ns,12);
%
k = 0;
for i = 1:ny
    for j = 1:ns
        AFstr = ['AFstruct.',HSR,'(',num2str(i),',',num2str(j),').'];
        % Check to see if flow data are available
        if ~isempty(eval([AFstr,'QMeaAdjInc']))
            k = k + 1;
            % StaYr identifies the streamgage and year
            StaYr = strcat('SY',eval([AFstr,'Station']),num2str(WY1+i-1));
            % Precip data used as an example
            switch handles.datatype
                case 'ConPrecip'
                    xmat(k,1:12) = eval([AFstr,'Precip']);
                    fprintf(1,[' %s ',repmat('%9.5f',1,12),'\n'],...
                        StaYr{:},xmat(k,1:12));
                case 'PrePrecip'
                    xmat(k,1:12) = eval([AFstr,'Precip1']);
                    fprintf(1,[' %s ',repmat('%9.5f',1,12),'\n'],...
                        StaYr{:},xmat(k,1:12));
                case 'ConTemper'
                    xmat(k,1:12) = eval([AFstr,'Temp']);
                    fprintf(1,[' %s ',repmat('%9.4f',1,12),'\n'],...
                        StaYr{:},xmat(k,1:12));
            end
        end
    end
end
% This eliminates the NaN values in the second column rather than the first
xmat = xmat(~isnan(xmat(:,2)),:);
fprintf(1,'xmat is %u by %u.\n',size(xmat));
Xarr = getappdata(hAFinchGUI,'Xarr');
if ~isempty(Xarr)
    Xarr(:,ExpVarNo,1:12) = reshape(xmat,length(xmat),1,12);
else
    Xarr(:,1,1:12) = reshape(xmat,length(xmat),1,12);
end

% Update hAFinchGUI variables
setappdata(hAFinchGUI,'Xarr',Xarr);
setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
setappdata(hAFinchGUI,'ExpVarNo',ExpVarNo);
close(gcf);
%
