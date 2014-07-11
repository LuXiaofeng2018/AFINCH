function varargout = AFStepwiseSetup(varargin)
% AFSTEPWISESETUP MATLAB code for AFStepwiseSetup.fig
%      AFSTEPWISESETUP, by itself, creates a new AFSTEPWISESETUP or raises the existing
%      singleton*.
%
%      H = AFSTEPWISESETUP returns the handle to a new AFSTEPWISESETUP or the handle to
%      the existing singleton*.
%
%      AFSTEPWISESETUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFSTEPWISESETUP.M with the given input arguments.
%
%      AFSTEPWISESETUP('Property','Value',...) creates a new AFSTEPWISESETUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFStepwiseSetup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFStepwiseSetup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFStepwiseSetup

% Last Modified by GUIDE v2.5 16-Mar-2012 09:29:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFStepwiseSetup_OpeningFcn, ...
                   'gui_OutputFcn',  @AFStepwiseSetup_OutputFcn, ...
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

% --- Executes just before AFStepwiseSetup is made visible.
function AFStepwiseSetup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFStepwiseSetup (see VARARGIN)
handles.prism_icon = imread('prismPB.jpg','jpg');
handles.nlcd_icon  = imread('nlcd2006PB.jpg','jpg');
handles.shpf_icon  = imread('shapefile.jpg','jpg');
guidata(hObject,handles);
set(handles.SetupShapefileVarPB,'CData',handles.shpf_icon);
set(handles.prismPB,'CData',handles.prism_icon);
set(handles.nlcdPB,'CData',handles.nlcd_icon);
% Choose default command line output for AFStepwiseSetup
handles.output   = hObject;
% ExpVarNo = 0;
%   Read CBVector if it exists in the workspace
try
    handles.CBVector = load('CBVector');
    % fprintf(1,'Reading in CBVector.\n');
    % Read in CBMatrix if it exists in the workspace
    % If CBVector is not defined, then
catch
    fprintf(1,'Did *not* read in CBVector or CBMatrix.\n');
    fprintf(1,'The first explanatory variable has not been defined.\n');
end
%
% Initialize variable structure
ExpVarNo       = 1; 
xVarTableData  = cell(1,2);
RegVarNameList = cell(1);
Xarr = []; Yarr = []; xVar = [];
% Update handles structureset(handles.XMatrixPanel,'Title','Specify Explanatory Variables');
set(handles.xVarTable,'Data',xVarTableData);
set(handles.XVarNoET,'String',num2str(ExpVarNo));

guidata(hObject, handles);

% UIWAIT makes AFStepwiseSetup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AFStepwiseSetup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);
% Get default command line output from handles structure
varargout{1} = handles.output;
% varargout{2} = ExpVarNo;
warning off
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Input hAFinchGUI variables
xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
%
prism_icon = imread('prismPB.jpg','jpg');
nlcd_icon  = imread('nlcd2006PB.jpg','jpg');
shpf_icon  = imread('shapefile.jpg','jpg');
handles.MonNum  = 1;
handles.MonName = 'Oct';
pEnter  = 0.01;
pRemove = 0.01;
% The set statements below provide defaults for the radiobutton sets
set(handles.EnterAlpha01,'Value',1);
set(handles.RemoveAlpha01,'Value',1);
if ~isempty(xVarTableData)
    set(handles.xVarTable,'Data',xVarTableData);
else
    xVarTableData = cell(1,2);
end
% Update hAFinchGUI variables
setappdata(hAFinchGUI,'xVarTableData',xVarTableData);
setappdata(hAFinchGUI,'pEnter',pEnter);
setappdata(hAFinchGUI,'pRemove',pRemove);
setappdata(hAFinchGUI,'prism_icon',prism_icon);
setappdata(hAFinchGUI,'nlcd_icon',nlcd_icon);
setappdata(hAFinchGUI,'shpf_icon',shpf_icon);
%
guidata(hObject,handles);
%
% --- Executes on button press in nlcdPB.
function nlcdPB_Callback(hObject, eventdata, handles)
% hObject    handle to nlcdPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Get hAFinchGUI variables 
% Xarr           = getappdata(hAFinchGUI,'Xarr');
% RegVarNameList = getappdata(hAFinchGUI,'RegVarNameList');
% xVarTableData  = getappdata(hAFinchGUI,'xVarTableData');
%
ExpVarNo = str2num(get(handles.XVarNoET,'String'));
fprintf(1,'ExpVarNo = %u.\n',ExpVarNo);
AFnlcdGUI(ExpVarNo);
uiwait(gcf);  % This wait stop AFstepwiseSetup from proceeding w/o info from AFnlcdGUI
% After returning from AFnlcdGUI, extra info from hAFinchGUI
RegVarNameList = getappdata(hAFinchGUI,'RegVarNameList');
ExpVarNo       = getappdata(hAFinchGUI,'ExpVarNo'      );
xVarTableData  = getappdata(hAFinchGUI,'xVarTableData' );
Xarr           = getappdata(hAFinchGUI,'Xarr');
% xVar           = getappdata(hAFinchGUI,'xVar');
%
% set(hObject,'UserData',handles.Xarr) %%%TS%%%
if exist('RegVarNameList','var')
    % load RegVarNameList
    % guidata(hObject,handles);
%     for i=1:ExpVarNo
%         fprintf(1,'NLCD Var(%u) \n',i);
%     end
    % set(handles.XVarNameLB,'String',RegVarNameList);
    xVarTableData{ExpVarNo,1} = RegVarNameList{ExpVarNo};
    xVarTableData{ExpVarNo,2} = false;
    guidata(hObject,handles);
    set(handles.xVarTable,'Data',xVarTableData);
    setappdata(hAFinchGUI,'xVarTableData',xVarTableData);
    %
end
set(handles.XVarNoET,'String',num2str(ExpVarNo+1));
handles.XarrSize = size(Xarr);
fprintf(1,'Rows= %u, Cols= %u, Months= %u. \n',handles.XarrSize);
guidata(hObject,handles);
set(handles.XMatrixPanel,'Title',...
    ['Selected Explanatory Variables are ',num2str(handles.XarrSize(1)),...
    ' by ',num2str(handles.XarrSize(2)),' by ',num2str(handles.XarrSize(3))]);
%
% --- Executes on button press in UserShapefilePB.
function UserShapefilePB_Callback(hObject, eventdata, handles)
% hObject    handle to UserShapefilePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
function XVarNoET_Callback(hObject, eventdata, handles)
% hObject    handle to XVarNoET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of XVarNoET as text
%        str2double(get(hObject,'String')) returns contents of XVarNoET as a double
%
% --- Executes during object creation, after setting all properties.
function XVarNoET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XVarNoET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in StepwisePB.
function StepwisePB_Callback(hObject, eventdata, handles)
% hObject    handle to StepwisePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% fprintf(1,'gcf = %f\n.',gcf());
% Setup hAFinchGUI link
hAFinchGUI   = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI
AFstruct     = getappdata(hAFinchGUI,'AFstruct');
HSR          = getappdata(hAFinchGUI,'HSR');
WY1          = getappdata(hAFinchGUI,'WY1');
% Generate the monthly water yield matrix first
[ny,ns] = size(eval(['AFstruct.',HSR]));
% xmat holds the prism data by year, streamgage 
ymat     = NaN(ny*ns,12);
wYearVec = NaN(ny*ns);
%
k = 0;
for i = 1:ny
    for j = 1:ns
        AFstr = ['AFstruct.',HSR,'(',num2str(i),',',num2str(j),').'];
        % Check to see if flow data are available
        if ~isempty(eval([AFstr,'YAdjIncWY']))
            k = k + 1;
            % StaYr identifies the streamgage and year
            StaYr = strcat('SY',eval([AFstr,'Station']),num2str(WY1+i-1));
            % Precip data used as an example
            ymat(k,:)  = eval([AFstr,'YAdjIncWY']);
            wYearVec(k)= WY1+i-1; 
            fprintf(1,[' %s ',repmat('%9.5f',1,12),'\n'],...
                StaYr{:},ymat(k,1:12));
        end
    end
end
% This eliminates the NaN values in the second column rather than the first
ymat = ymat(~isnan(ymat(:,2)),:);
wYearVec = wYearVec(~isnan(wYearVec));
 Yarr    =           ymat;
rYarr    = real(sqrt(ymat));
setappdata(hAFinchGUI, 'Yarr', Yarr);
setappdata(hAFinchGUI,'rYarr',rYarr);
setappdata(hAFinchGUI,'wYearVec',wYearVec);
% close(gcf);
figure();
AFStepwiseRun
return
%
% --- Executes when selected object is changed in pEnterBG.
function pEnterBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pEnterBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
pEnter     = str2num(get(eventdata.NewValue,'String'));
hAFinchGUI = getappdata(0,'hAFinchGUI');
setappdata(hAFinchGUI,'pEnter',pEnter);
fprintf(1,'p-Enter = %f.\n',pEnter);
%
% --- Executes when selected object is changed in pRemoveBG.
function pRemoveBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pRemoveBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
pRemove    = str2num(get(eventdata.NewValue,'String'));
hAFinchGUI = getappdata(0,'hAFinchGUI');
setappdata(hAFinchGUI,'pRemove',pRemove);
fprintf(1,'p-Remove = %f.\n',pRemove);
%
% --- Executes during object creation, after setting all properties.
function pEnterBG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pEnterBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(handles.pEnterBG,'SelectedObject',handles.EnterAlpha05);
% --- Executes on button press in BoxplotPB.

function BoxplotPB_Callback(hObject, eventdata, handles)
% hObject    handle to BoxplotPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
Xarr          = getappdata(hAFinchGUI,'Xarr');
rYarr         = real(sqrt(getappdata(hAFinchGUI,'Yarr')));
xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
if ~isempty(rYarr)
    figure('Name','Boxplot of Regression Variables','NumberTitle','off');
    % handles.Xarr = get(hObject,'UserData'); %%%TS%%%
    subplot(1,5,1),
    boxplot(rYarr(:,handles.MonNum),'labelorientation','horizontal',...
        'labels',handles.MonName(handles.MonNum,:));
    title('Response');
    ylabel('Square root of water yields, in area inches');
    subplot(1,5,2:5),
    boxplot(Xarr(:,:,handles.MonNum),{xVarTableData{:,1}},'labelorientation','inline');
    title(['Distribution of Explanatory Variables for ',handles.MonName(handles.MonNum,:)]);
else
    figure('Name','Boxplot of Explanatory Regression Variables','NumberTitle','off');
    boxplot(Xarr(:,:,handles.MonNum),{xVarTableData{:,1}},'labelorientation','inline');
    title(['Distribution of Explanatory Variables for ',handles.MonName(handles.MonNum,:)]);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    delete(hObject);
end

% --- Executes during object creation, after setting all properties.
function nlcdPB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nlcdPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hAFinchGUI = getappdata(0,'hAFinchGUI');
nlcd_icon  = getappdata(hAFinchGUI,'nlcd_icon');
set(hObject,'CData',nlcd_icon);

% --- Executes on button press in prismPB.
function prismPB_Callback(hObject, eventdata, handles)
% Setup hAFinchGUI variables
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Recall hAFinchGUI variables
Xarr           = getappdata(hAFinchGUI,'Xarr');
RegVarNameList = getappdata(hAFinchGUI,'RegVarNameList');
% ExpVarNo       = getappdata(hAFinchGUI,'ExpVarNo');
xVarTableData  = getappdata(hAFinchGUI,'xVarTableData');
% hObject    handle to prismPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ExpVarNo = str2double(get(handles.XVarNoET,'String'));
fprintf(1,'ExpVarNo = %u.\n',ExpVarNo);
AFprismGUI(ExpVarNo);
uiwait(gcf);  % This stops AFstepwiseSetup from proceeding w/o info from AFNlcdPrism
%
% After returning from AFprismGUI, extra info from hAFinchGUI
RegVarNameList = getappdata(hAFinchGUI,'RegVarNameList');
ExpVarNo       = getappdata(hAFinchGUI,'ExpVarNo'      );
xVarTableData  = getappdata(hAFinchGUI,'xVarTableData' );
Xarr           = getappdata(hAFinchGUI,'Xarr');
%
% set(hObject,'UserData',handles.Xarr) %%%TS%%%
if exist('RegVarNameList','var')
    xVarTableData{ExpVarNo,1} = RegVarNameList{ExpVarNo};
    xVarTableData{ExpVarNo,2} = false;
    guidata(hObject,handles);
    set(handles.xVarTable,'Data',xVarTableData);
    setappdata(hAFinchGUI,'xVarTableData',xVarTableData);
end
set(handles.XVarNoET,'String',num2str(ExpVarNo+1));
%
handles.XarrSize = size(Xarr);
fprintf(1,'Rows= %u, Cols= %u, Months= %u. \n',handles.XarrSize);
guidata(hObject,handles);
set(handles.XMatrixPanel,'Title',...
    ['Selected Explanatory Variables are ',num2str(handles.XarrSize(1)),...
    ' by ',num2str(handles.XarrSize(2)),' by ',num2str(handles.XarrSize(3))]);
% Update hAFinchGUI variables
setappdata(hAFinchGUI,'xVarTableData',xVarTableData);
setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
setappdata(hAFinchGUI,'ExpVarNo',ExpVarNo);
setappdata(hAFinchGUI,'Xarr',Xarr);

% --- Executes during object creation, after setting all properties.
function prismPB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prismPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hAFinchGUI = getappdata(0,'hAFinchGUI');
prism_icon = getappdata(hAFinchGUI,'prism_icon');
set(hObject,'CData',prism_icon);

% --- Executes on button press in SetupShapefileVarPB.
function SetupShapefileVarPB_Callback(hObject, eventdata, handles)
%
% hObject    handle to SetupShapefileVarPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% Run the AFxVarShapeGUI 
AFxVarShapeGUI
% Wait for return of data from AFxVarShapeGUI
uiwait(gcf); 
%
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI
xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
ExpVarNo      = getappdata(hAFinchGUI,'ExpVarNo');
Xarr          = getappdata(hAFinchGUI,'Xarr');
%
set(handles.xVarTable,'Data',xVarTableData);
set(handles.XVarNoET,'String',num2str(ExpVarNo));
%   Read CBVector if it exists in the workspace
% handles.CBVector = load('CBVector');
%
handles.XarrSize = size(Xarr);
fprintf(1,'Rows= %u, Cols= %u, Months= %u. \n',handles.XarrSize);
guidata(hObject,handles);
set(handles.XMatrixPanel,'Title',...
    ['Selected Explanatory Variables are ',num2str(handles.XarrSize(1)),...
    ' by ',num2str(handles.XarrSize(2)),' by ',num2str(handles.XarrSize(3))]);
%
function SelectMonLB_Callback(hObject, eventdata, handles)
% hObject    handle to SelectMonLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.MonNum  = get(hObject,'Value');
handles.MonName = get(hObject,'String');
guidata(hObject,handles);
fprintf(1,'Month number = %u, Month name = %s.\n',handles.MonNum,...
    handles.MonName{handles.MonNum});
% Hints: contents = cellstr(get(hObject,'String')) returns SelectMonLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectMonLB

% --- Executes during object creation, after setting all properties.
function SelectMonLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectMonLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
% --- Executes when entered data in editable cell(s) in xVarTable.
function xVarTable_CellEditCallback(hObject, eventdata, handles)
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
% hObject    handle to xVarTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
handles.tableNdx = eventdata.Indices;
handles.tableDat = eventdata.NewData;
if eventdata.NewData
    xVarTableData{eventdata.Indices(1),2} = true;
    fprintf(1,'Variable %s will be in the final model.\n',...
        xVarTableData{eventdata.Indices(1),1});
else
    xVarTableData{eventdata.Indices(1),2} = false;
    fprintf(1,'Variable %s presence in the final model will be determined by p-value.\n',...
        xVarTableData{eventdata.Indices(1),1});    
end
setappdata(hAFinchGUI,'xVarTableData',xVarTableData);


% --- Executes on button press in ClearVariablesPB.
function ClearVariablesPB_Callback(hObject, eventdata, handles)
% hObject    handle to ClearVariablesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% return
% 
ExpVarNo       = 1; 
xVarTableData  = cell(1,2);
RegVarNameList = [];
Xarr = []; Yarr = []; xVar = [];
set(handles.XMatrixPanel,'Title','Specify Explanatory Variables');
set(handles.xVarTable,'Data',xVarTableData);
set(handles.XVarNoET,'String',num2str(ExpVarNo));
% close(gcf);
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Refresh hAFinchGUI data
setappdata(hAFinchGUI,'ExpVarNo',ExpVarNo);
setappdata(hAFinchGUI,'xVarTableData',xVarTableData);
setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
setappdata(hAFinchGUI,'Xarr',Xarr);
setappdata(hAFinchGUI,'Yarr',Yarr);
setappdata(hAFinchGUI,'xVar',xVar);
return
 
% --- Executes on button press in ExitSetupPB.
function ExitSetupPB_Callback(hObject, eventdata, handles)
% hObject    handle to ExitSetupPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(gcf);
return

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in ShpVarNameLB.
function ShpVarNameLB_Callback(hObject, eventdata, handles)
% hObject    handle to ShpVarNameLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ShpVarNameLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ShpVarNameLB
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ShpVarNameLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShpVarNameLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function SetupShapefileVarPB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SetupShapefileVarPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
hAFinchGUI = getappdata(0,'hAFinchGUI');
shpf_icon = getappdata(hAFinchGUI,'shpf_icon');
set(hObject,'CData',shpf_icon);
