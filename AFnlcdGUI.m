function varargout = AFnlcdGUI(varargin)
% AFNLCDGUI MATLAB code for AFnlcdGUI.fig
%      AFNLCDGUI, by itself, creates a new AFNLCDGUI or raises the existing
%      singleton*.
%
%      H = AFNLCDGUI returns the handle to a new AFNLCDGUI or the handle to
%      the existing singleton*.
%
%      AFNLCDGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFNLCDGUI.M with the given input arguments.
%
%      AFNLCDGUI('Property','Value',...) creates a new AFNLCDGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFnlcdGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFnlcdGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFnlcdGUI

% Last Modified by GUIDE v2.5 29-Nov-2012 14:28:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFnlcdGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFnlcdGUI_OutputFcn, ...
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
%
% --- Executes just before AFnlcdGUI is made visible.
function AFnlcdGUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFnlcdGUI (see VARARGIN)
fprintf(1, 'AFnlcdGUI \n');
fprintf(1,'Argument passed as input is %u\n',varargin{:});
% Choose default command line output for AFnlcdGUI
handles.output   = hObject;
% 
% Link AFinchGUI workspace
hAFinchGUI     = getappdata(0,'hAFinchGUI');
ExpVarNo = varargin{:};
% Updatate AFinchGUI workspace
setappdata(hAFinchGUI,'ExpVarNo',ExpVarNo);
% Update local variables
RegVarNameList = getappdata(hAFinchGUI,'RegVarNameList');
%
if isempty(RegVarNameList)
    RegVarNameList = cell(1);
    setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
end
%
set(handles.ExpVarST,'String',['Specifying Explantory Variable ',...
    num2str(ExpVarNo)]);
% Update handles structure
handles.VarName  = [];
handles.CBVector = zeros(16,1);
guidata(hObject, handles);
% uiwait(handles.Return_Callback,ButtonDownFcn,1);

%
% --- Outputs from this function are returned to the command line.
function AFnlcdGUI_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Initialize variables
% handles.fig = gcf(); Also works like close(handles.figure1);
guidata(hObject,handles);
warning off
%

% Variable initial
% --- Executes on button press in CB31.
function CB31_Callback(hObject, ~, handles)
% hObject    handle to CB31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.CBVector(7,1) == 1
    handles.CBVector(7,1) = 0;
    handles.VarName = strrep(handles.VarName,'BarrenRock',[]);
else
    handles.CBVector(7,1) = 1;
    handles.VarName = [handles.VarName 'BarrenRock'];
end
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
function CB21_Callback(hObject, ~, handles)
% hObject    handle to CB21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
initCheckBoxStat = [num2str(handles.CBVector(3,1)),...
    num2str(handles.CBVector(4,1)),num2str(handles.CBVector(5,1)),...
    num2str(handles.CBVector(6,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
%
switch initCheckBoxStat
    case '0000'
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.CBVector(3,1) = 1;
    case '0001'
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.CBVector(3,1) = 1;
    case '0010'
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.CBVector(3,1) = 1;
    case '0100'
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.CBVector(3,1) = 1;
    case '1000'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.CBVector(3,1) = 0;
    case '0011'
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = [handles.VarName,'DevelopedMH'];
        handles.CBVector(3,1) = 1;
    case '0101'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLH'];   
        handles.CBVector(3,1) = 1;
    case '0110'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLM'];             
        handles.CBVector(3,1) = 1;
    case '1001'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);          
        handles.CBVector(3,1) = 0;
    case '1010'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);   
        handles.CBVector(3,1) = 0;
    case '1100'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.CBVector(3,1) = 0;
    case '0111'
        handles.VarName = strrep(handles.VarName,'DevelopedLMH',[]);
        handles.VarName = [handles.VarName,'Developed'];
        handles.CBVector(3,1) = 1;    
    case '1011'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedMH',[]);
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(3,1) = 0;           
    case '1101'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedLH',[]);
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(3,1) = 0;             
    case '1110'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedLM',[]);
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.CBVector(3,1) = 0;                     
    case '1111'
        handles.VarName = strrep(handles.VarName,'Developed',[]);
        handles.VarName = [handles.VarName,'DevelopedLMH'];
        handles.CBVector(3,1) = 0; 
end
%
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB22.
function CB22_Callback(hObject, ~, handles)
% hObject    handle to CB22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
initCheckBoxStat = [num2str(handles.CBVector(3,1)),...
    num2str(handles.CBVector(4,1)),num2str(handles.CBVector(5,1)),...
    num2str(handles.CBVector(6,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
%
switch initCheckBoxStat
    case '0000'
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.CBVector(4,1) = 1;
    case '0001'
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.CBVector(4,1) = 1;
    case '0010'
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.CBVector(4,1) = 1;
    case '0100'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.CBVector(4,1) = 0;
    case '1000'
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.CBVector(4,1) = 1;
    case '0011'
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLMH'];
        handles.CBVector(4,1) = 1;
    case '0101'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.CBVector(4,1) = 0;
    case '0110'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.CBVector(4,1) = 0;
    case '1001'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLH'];                
        handles.CBVector(4,1) = 1;
    case '1010'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLM'];        
        handles.CBVector(4,1) = 1;
    case '1100'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.CBVector(4,1) = 0;
    case '0111'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedLMH',[]);
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(4,1) = 0;    
    case '1011'
        handles.VarName = strrep(handles.VarName,'DevelopedMH',[]);
        handles.VarName = [handles.VarName,'Developed'];
        handles.CBVector(4,1) = 1;            
    case '1101'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedLH',[]);
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(4,1) = 0;             
    case '1110'
        handles.VarName = strrep(handles.VarName,'DevelopedLM',[]);
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.CBVector(4,1) = 0;                     
    case '1111'
        handles.VarName = strrep(handles.VarName,'Developed',[]);
        handles.VarName = [handles.VarName,'DevelopedMH'];
        handles.CBVector(4,1) = 0; 
end
%
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB23.
function CB23_Callback(hObject, ~, handles)
% hObject    handle to CB23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
initCheckBoxStat = [num2str(handles.CBVector(3,1)),...
    num2str(handles.CBVector(4,1)),num2str(handles.CBVector(5,1)),...
    num2str(handles.CBVector(6,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
%
switch initCheckBoxStat
    case '0000'
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.CBVector(5,1) = 1;
    case '0001'
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.CBVector(5,1) = 1;
    case '0010'
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.CBVector(5,1) = 0;
    case '0100'
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.CBVector(5,1) = 1;
    case '1000'
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.CBVector(5,1) = 1;
    case '0011'
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.CBVector(5,1) = 0;
    case '0101'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLMH'];   
        handles.CBVector(5,1) = 1;
    case '0110'
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.CBVector(5,1) = 0;
    case '1001'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = [handles.VarName,'DevelopedMH'];                
        handles.CBVector(5,1) = 1;
    case '1010'
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.CBVector(5,1) = 0;
    case '1100'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLM'];        
        handles.CBVector(5,1) = 1;
    case '0111'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedLMH',[]);
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(5,1) = 0;    
    case '1011'
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedMH',[]);
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(5,1) = 0;            
    case '1101'
        handles.VarName = strrep(handles.VarName,'DevelopedLH',[]);
        handles.VarName = [handles.VarName,'Developed'];
        handles.CBVector(5,1) = 1;             
    case '1110'
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedLM',[]);
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.CBVector(5,1) = 0;                     
    case '1111'
        handles.VarName = strrep(handles.VarName,'Developed',[]);
        handles.VarName = [handles.VarName,'DevelopedLH'];
        handles.CBVector(5,1) = 0; 
end
%
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB24.
function CB24_Callback(hObject, eventdata, handles)
% hObject    handle to CB24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
initCheckBoxStat = [num2str(handles.CBVector(3,1)),...
    num2str(handles.CBVector(4,1)),num2str(handles.CBVector(5,1)),...
    num2str(handles.CBVector(6,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
%
switch initCheckBoxStat
    case '0000'
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(6,1) = 1;
    case '0001'
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.CBVector(6,1) = 0;
    case '0010'
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(6,1) = 1;
    case '0100'
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(6,1) = 1;
    case '1000'
        handles.VarName = [handles.VarName,'ResidHiInt'];
        handles.CBVector(6,1) = 1;
    case '0011'
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.CBVector(6,1) = 0;
    case '0101'
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.CBVector(6,1) = 0;
    case '0110'
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLMH'];             
        handles.CBVector(6,1) = 1;
    case '1001'
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.CBVector(6,1) = 0;
    case '1010'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'ResidMedInt',[]);
        handles.VarName = [handles.VarName,'DevelopedMH'];        
        handles.CBVector(6,1) = 1;
    case '1100'
        handles.VarName = strrep(handles.VarName,'ResidOpen',[]);
        handles.VarName = strrep(handles.VarName,'ResidLoInt',[]);
        handles.VarName = [handles.VarName,'DevelopedLH'];        
        handles.CBVector(6,1) = 1;
    case '0111'
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedLMH',[]);
        handles.VarName = [handles.VarName,'ResidLoInt'];
        handles.VarName = [handles.VarName,'ResidMedInt'];
        handles.CBVector(6,1) = 0;    
    case '1011'
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedMH',[]);
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.VarName = [handles.VarName,'ResidMedInt'];       
        handles.CBVector(6,1) = 0;            
    case '1101'
        handles.VarName = strrep(handles.VarName,'ResidHiInt',[]);
        handles.VarName = strrep(handles.VarName,'DevelopedLH',[]);
        handles.VarName = [handles.VarName,'ResidOpen'];
        handles.VarName = [handles.VarName,'ResidLoInt'];    
        handles.CBVector(6,1) = 0;             
    case '1110'
        handles.VarName = strrep(handles.VarName,'DevelopedLM',[]);
        handles.VarName = [handles.VarName,'Developed'];
        handles.CBVector(6,1) = 1;                     
    case '1111'
        handles.VarName = strrep(handles.VarName,'Developed',[]);
        handles.VarName = [handles.VarName,'DevelopedLM'];
        handles.CBVector(6,1) = 0; 
end
%
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB11.
function CB11_Callback(hObject, ~, handles)
% hObject    handle to CB11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initCheckBoxStat = [num2str(handles.CBVector(1,1)),num2str(handles.CBVector(2,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
switch initCheckBoxStat
    case '00'
        handles.VarName = [handles.VarName,'WaterOpen'];
        handles.CBVector(1,1) = 1;
    case '01'
        handles.VarName = strrep(handles.VarName,'PerenIceSnow',[]);
        handles.VarName = [handles.VarName,'Water'];
        handles.CBVector(1,1) = 1;
    case '10'        
        handles.VarName = strrep(handles.VarName,'WaterOpen',[]);
        handles.CBVector(1,1) = 0;
    case '11'
        handles.VarName = strrep(handles.VarName,'Water',[]);
        handles.VarName = [handles.VarName,'PerenIceSnow'];
        handles.CBVector(1,1) = 0;
end

set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB12.
function CB12_Callback(hObject, ~, handles)
% hObject    handle to CB12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initCheckBoxStat = [num2str(handles.CBVector(1,1)),num2str(handles.CBVector(2,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
%
switch initCheckBoxStat
    case '00'
        handles.VarName = [handles.VarName,'PerenIceSnow'];
        handles.CBVector(2,1) = 1;
    case '01'
        handles.VarName = strrep(handles.VarName,'PerenIceSnow',[]);
        handles.CBVector(2,1) = 0;
    case '10'
        handles.VarName = strrep(handles.VarName,'WaterOpen',[]);
        handles.VarName = [handles.VarName,'Water'];
        handles.CBVector(2,1) = 1;
    case '11'
        handles.VarName = strrep(handles.VarName,'Water',[]);
        handles.VarName = [handles.VarName,'WaterOpen'];
        handles.CBVector(2,1) = 0;
end

set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
function CB52_Callback(hObject, ~, handles)
% hObject    handle to CB52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.CBVector(11,1) == 1
    handles.CBVector(11,1) = 0;
    handles.VarName = strrep(handles.VarName,'Shrubland',[]);
else
    handles.CBVector(11,1) = 1;
    handles.VarName = [handles.VarName 'Shrubland'];
end
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB41.
function CB41_Callback(hObject, ~, handles)
% hObject    handle to CB41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initCheckBoxStat = [num2str(handles.CBVector(8,1)),...
    num2str(handles.CBVector(9,1)),num2str(handles.CBVector(10,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
%
switch initCheckBoxStat
    case '000'
        handles.VarName = [handles.VarName,'ForestDecid'];
        handles.CBVector(8,1) = 1;
    case '001'
        handles.VarName = [handles.VarName,'ForestDecid'];
        handles.CBVector(8,1) = 1;
    case '010'
        handles.VarName = [handles.VarName,'ForestDecid'];
        handles.CBVector(8,1) = 1;
    case '011'
        handles.VarName = strrep(handles.VarName,'ForestEGreen',[]);
        handles.VarName = strrep(handles.VarName,'ForestMixed',[]);
        handles.VarName = [handles.VarName,'Forest'];
        handles.CBVector(8,1) = 1;
    case '100'
        handles.VarName = strrep(handles.VarName,'ForestDecid',[]);
        handles.CBVector(8,1) = 0;
    case '101'
        handles.VarName = strrep(handles.VarName,'ForestDecid',[]);
        handles.CBVector(8,1) = 0;
    case '110'
        handles.VarName = strrep(handles.VarName,'ForestDecid',[]);
        handles.CBVector(8,1) = 0;
    case '111'
        handles.VarName = strrep(handles.VarName,'Forest',[]);
        handles.VarName = [handles.VarName,'ForestEGreen'];
        handles.VarName = [handles.VarName,'ForestMixed'];
        handles.CBVector(8,1) = 0;     
end

set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB42.
function CB42_Callback(hObject, ~, handles)
% hObject    handle to CB42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initCheckBoxStat = [num2str(handles.CBVector(8,1)),...
    num2str(handles.CBVector(9,1)),num2str(handles.CBVector(10,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
%
switch initCheckBoxStat
    case '000'
        handles.VarName = [handles.VarName,'ForestEGreen'];
        handles.CBVector(9,1) = 1;
    case '001'
        handles.VarName = [handles.VarName,'ForestEGreen'];
        handles.CBVector(9,1) = 1;
    case '010'
        handles.VarName = strrep(handles.VarName,'ForestEGreen',[]);
        handles.CBVector(9,1) = 0;
    case '011'
        handles.VarName = strrep(handles.VarName,'ForestEGreen',[]);
        handles.CBVector(9,1) = 0;
    case '100'
        handles.VarName = [handles.VarName,'ForestEGreen'];
        handles.CBVector(9,1) = 1;
    case '101'
        handles.VarName = strrep(handles.VarName,'ForestDecid',[]);
        handles.VarName = strrep(handles.VarName,'ForestMixed',[]);
        handles.VarName = [handles.VarName,'Forest'];
        handles.CBVector(9,1) = 1;
    case '110'
        handles.VarName = strrep(handles.VarName,'ForestEGreen',[]);
        handles.CBVector(9,1) = 0;
    case '111'
        handles.VarName = strrep(handles.VarName,'Forest',[]);
        handles.VarName = [handles.VarName,'ForestDecid'];
        handles.VarName = [handles.VarName,'ForestMixed'];
        handles.CBVector(9,1) = 0;     
end

set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB43.
function CB43_Callback(hObject, ~, handles)
% hObject    handle to CB43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initCheckBoxStat = [num2str(handles.CBVector(8,1)),...
    num2str(handles.CBVector(9,1)),num2str(handles.CBVector(10,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
%
switch initCheckBoxStat
    case '000'
        handles.VarName = [handles.VarName,'ForestMixed'];
        handles.CBVector(10,1) = 1;
    case '001'
        handles.VarName = strrep(handles.VarName,'ForestMixed',[]);
        handles.CBVector(10,1) = 0;
    case '010'
        handles.VarName = [handles.VarName,'ForestMixed'];
        handles.CBVector(10,1) = 1;
    case '011'
        handles.VarName = strrep(handles.VarName,'ForestMixed',[]);
        handles.CBVector(10,1) = 0;
    case '100'
        handles.VarName = [handles.VarName,'ForestMixed'];
        handles.CBVector(10,1) = 1;
    case '101'
        handles.VarName = strrep(handles.VarName,'ForestMixed',[]);
        handles.CBVector(10,1) = 0;
    case '110'
        handles.VarName = strrep(handles.VarName,'ForestDecid',[]);
        handles.VarName = strrep(handles.VarName,'ForestEGreen',[]);
        handles.VarName = [handles.VarName,'Forest'];
        handles.CBVector(10,1) = 1;
    case '111'
        handles.VarName = strrep(handles.VarName,'Forest',[]);
        handles.VarName = [handles.VarName,'ForestDecid'];
        handles.VarName = [handles.VarName,'ForestEGreen'];
        handles.CBVector(10,1) = 0;     
end

set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB81.
function CB81_Callback(hObject, ~, handles)
% hObject    handle to CB81 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.CBVector(13,1) == 1
    handles.CBVector(13,1) = 0;
    handles.VarName = strrep(handles.VarName,'PastureHay',[]);
else
    handles.CBVector(13,1) = 1;
    handles.VarName = [handles.VarName 'PastureHay'];
end
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB82.
function CB82_Callback(hObject, ~, handles)
% hObject    handle to CB82 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.CBVector(14,1) == 1
    handles.CBVector(14,1) = 0;
    handles.VarName = strrep(handles.VarName,'RowCrops',[]);
else
    handles.CBVector(14,1) = 1;
    handles.VarName = [handles.VarName 'RowCrops'];
end
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
function CB71_Callback(hObject, ~, handles)
% hObject    handle to CB71 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.CBVector(12,1) == 1
    handles.CBVector(12,1) = 0;
    handles.VarName = strrep(handles.VarName,'GrassHerbaceous',[]);
else
    handles.CBVector(12,1) = 1;
    handles.VarName = [handles.VarName 'GrassHerbaceous'];
end
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB90.
function CB90_Callback(hObject, ~, handles)
% hObject    handle to CB90 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initCheckBoxStat = [num2str(handles.CBVector(15,1)),num2str(handles.CBVector(16,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);
switch initCheckBoxStat
    case '00'
        handles.VarName = [handles.VarName,'WetlandWoody'];
        handles.CBVector(15,1) = 1;
    case '01'
        handles.VarName = strrep(handles.VarName,'WetlandHerbaceous',[]);
        handles.VarName = [handles.VarName,'Wetland'];
        handles.CBVector(15,1) = 1;
    case '10'        
        handles.VarName = strrep(handles.VarName,'WetlandWoody',[]);
        handles.CBVector(15,1) = 0;
    case '11'
        handles.VarName = strrep(handles.VarName,'Wetland',[]);
        handles.VarName = [handles.VarName,'WetlandHerbaceous'];
        handles.CBVector(15,1) = 0;
end

set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in CB95.
function CB95_Callback(hObject, ~, handles)
% hObject    handle to CB95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initCheckBoxStat = [num2str(handles.CBVector(15,1)),num2str(handles.CBVector(16,1))];
fprintf(1,'Initial checkbox stat is %s.\n',initCheckBoxStat);

switch initCheckBoxStat
    case '00'
        handles.VarName = [handles.VarName,'WetlandHerbaceous'];
        handles.CBVector(16,1) = 1;
    case '01'
        handles.VarName = strrep(handles.VarName,'WetlandHerbaceous',[]);
        handles.CBVector(16,1) = 0;
    case '10'
        handles.VarName = strrep(handles.VarName,'WetlandWoody',[]);
        handles.VarName = [handles.VarName,'Wetland'];
        handles.CBVector(16,1) = 1;
    case '11'
        handles.VarName = strrep(handles.VarName,'Wetland',[]);
        handles.VarName = [handles.VarName,'WetlandWoody'];
        handles.CBVector(16,1) = 0;
end
%
set(handles.RegVarNameET,'String',handles.VarName);
guidata(hObject,handles);
%
% --- Executes on button press in ReturnPB.
function ReturnPB_Callback(hObject, ~, handles)
% hObject    handle to ReturnPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Recall hAFinchGUI variables
RegVarNameList      = getappdata(hAFinchGUI,'RegVarNameList');
ExpVarNo            = getappdata(hAFinchGUI,'ExpVarNo');
AFstruct            = getappdata(hAFinchGUI,'AFstruct');
Xarr                = getappdata(hAFinchGUI,'Xarr');
xVar                = getappdata(hAFinchGUI,'xVar');
NLCD_THS            = getappdata(hAFinchGUI,'NLCD_THS');
GridCode_NLCDTHS    = getappdata(hAFinchGUI,'GridCode_NLCDTHS');
HSR                 = getappdata(hAFinchGUI,'HSR');
WY1                 = getappdata(hAFinchGUI,'WY1');
%
handles.RegVarName    = get(handles.RegVarNameET,'String');
fprintf(1,'RegVarName = %s.\n',handles.RegVarName);
fprintf(1,'ExpVarNo = %u.\n',ExpVarNo);
%
% Form vector of explanatory variables for HUC application
xVar(ExpVarNo).name      = handles.RegVarName;
xVar(ExpVarNo).type      = 'nlcd';
xVar(ExpVarNo).value     = sum(NLCD_THS(:,logical(handles.CBVector(1:16))),2);
xVar(ExpVarNo).gridcode  = GridCode_NLCDTHS;
RegVarName               = handles.RegVarName;
RegVarNameList{ExpVarNo} = handles.RegVarName;
%
%% Check whether most catchments have zero values for the selected NLCD variable
NoValue = 0;
len_NLCD_THS = length(NLCD_THS);
for i = 1:len_NLCD_THS
    if xVar(ExpVarNo).value <0.00001
        NoValue = NoValue + 1;
    end
end
%
VarChk = NoValue / len_NLCD_THS;
if VarChk > 0.75
    warndlg(['More than 75% of the catchments have zero values for ',...
        handles.RegVarName]);
    return
end
%%
guidata(hObject,handles);
%
for i=1:ExpVarNo
    fprintf(1,'Regression variable %u name is: %s.\n',...
     i,RegVarNameList{i});
end
%
fprintf(1,'RegVarNameList{%u}= %s \n',...
    ExpVarNo,RegVarNameList{ExpVarNo});
fprintf(1,'CBVector = %u.\n',handles.CBVector);
% handles.varargout{3} = RegVarNameList;
% save('CBVector','CBVector');
% 
%% AFGenXVar functionality below
% Generate the monthly water yield matrix first
[ny,ns] = size(eval(['AFstruct.',HSR]));
% Allocate as if all the stations were active for all years
xvar = NaN(ny*ns,1);
NdxX = find(handles.CBVector)';
%
maxNdxX = max(NdxX);
minNdxX = min(NdxX);
if maxNdxX>16 && minNdxX<17
%if maxNdxX>21 && minNdxX<22
    errordlg('NLCD and PRISM variables have different units and cannot be added together.',...
        'Mixed NLCD and PRISM Variables in Selection');
end
k = 0;
for i = 1:ny
    for j = 1:ns
        AFstr = ['AFstruct.',HSR,'(',num2str(i),',',num2str(j),').'];
        if ~isempty(eval([AFstr,'QMeaAdjInc']))
            k = k + 1;
            StaYr = strcat('SY',eval([AFstr,'Station']),num2str(WY1+j-1));
            if maxNdxX < 17    
                % NLCD data selected (note: data is in percent)
                xvar(k) = sum(eval([AFstr,'NLCD([',num2str(NdxX),'])']));
                fprintf(1,[' %s ',repmat('%9.5f',1,length(NdxX)+1),'\n'],...
                    StaYr{:},eval([AFstr,'NLCD([',num2str(NdxX),'])']),...
                    sum(eval([AFstr,'NLCD([',num2str(NdxX),'])'])));
            elseif maxNdxX == 17
                % Precip data selected
                xvar(k) = eval([AFstr,'Precip(22)']);
            elseif maxNdxX == 18
                % Lag1 Precip data selected
            elseif maxNdxX == 19    
                % Temp data selected
            else
                % Don't know what was selected
            end
        end
    end
end
xvar = xvar(~isnan(xvar(:,1)));
% Generate duplicate 
xmat = repmat(xvar,1,12);
if exist('Xarr','var')
    Xarr(:,ExpVarNo,1:12) = repmat(xvar,1,12);
else
    Xarr(:,1,1:12) = repmat(xvar,1,12);
end
% 
try 
    close(gcf);
catch
    set(0,'showhiddenhandles','on');
    fH = max(get(0,'children'));
    set(fH,'closereq',' delete(get(0,''currentfigure''))');
    close(gcf);
end
%
% Refresh AFinchGUI variables
setappdata(hAFinchGUI,'AFstruct',AFstruct);
setappdata(hAFinchGUI,'Xarr',Xarr);
setappdata(hAFinchGUI,'RegVarName',RegVarName);
setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
setappdata(hAFinchGUI,'ExpVarNo',ExpVarNo);
setappdata(hAFinchGUI,'xVar',xVar');
%
function RegVarNameET_Callback(hObject, ~, handles)
% hObject    handle to RegVarNameET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function RegVarNameET_CreateFcn(hObject, ~, handles)
% hObject    handle to RegVarNameET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
% --- Executes during object creation, after setting all properties.
function ExpVarST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExpVarST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Setup hAFinchGUI link
% hAFinchGUI = getappdata(0,'hAFinchGUI');
% Refresh hAFinchGUI workspace
% setappdata(hAFinchGUI,'CBVector',CBVector);
%
% xVar(ExpVarNo).name = handles.VarName;
% xVar(ExpVarNo).vec  = handles.CBVector;
% Hint: delete(hObject) closes the figure
close(gcf)
