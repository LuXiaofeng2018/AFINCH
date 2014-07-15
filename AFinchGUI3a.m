function varargout = AFinchGUI3a(varargin)
% afinchgui3a MATLAB code for AFinchGUI3a.fig
%      AFINCHGUI3A, by itself, creates a new AFINCHGUI3A or raises the existing
%      singleton*.
%
%      H = AFINCHGUI3A returns the handle to a new AFINCHGUI3A or the handle to
%      the existing singleton*.
%
%      AFINCHGUI3A('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFINCHGUI3A.M with the given input arguments.
%
%      AFINCHGUI3A('Property','Value',...) creates a new AFINCHGUI3A or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFinchGUI3a_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFinchGUI3a_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFinchGUI3a

% Last Modified by GUIDE v2.5 05-Jun-2014 10:28:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFinchGUI3a_OpeningFcn, ...
                   'gui_OutputFcn',  @AFinchGUI3a_OutputFcn, ...
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

% --- Executes just before AFinchGUI3a is made visible.
function AFinchGUI3a_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFinchGUI3a (see VARARGIN)

% Choose default command line output for AFinchGUI3a
handles.output = hObject;
handles.RegSpan = 'poaRB';
handles.RegTech = 'olsRB';
AFVer = '3a';
set(handles.versionST,'String',['ver. ',AFVer]);
%
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFinchGUI3a wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Month name
MonthName = {'October','November','December','January','February',...
    'March','April','May','June','July','August','September'};
% Abbreviated month name
MoName = {'Oct.','Nov.','Dec.','Jan.','Feb.','Mar.','Apr.','May','June',...
    'July','Aug.','Sep.'};
% Calendar month sequency in water year
MoNumber = [10:12 1:9];
%
WU_notify = 'Yes';
% Setup hAFinchGUI link
setappdata(0, 'hAFinchGUI', gcf);
% Link hAFinchGUI workspace
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Store local variables to hFAinchGUI workspace
setappdata(hAFinchGUI,'MonthName',MonthName);
setappdata(hAFinchGUI,'MoName',MoName);
setappdata(hAFinchGUI,'MoNumber',MoNumber);
setappdata(hAFinchGUI,'WU_notify',WU_notify);
setappdata(hAFinchGUI,'AFVer',AFVer);
%
% --- Outputs from this function are returned to the command line.
function varargout = AFinchGUI3a_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in usgsLogoPB.
function usgsLogoPB_Callback(hObject, eventdata, handles)
% hObject    handle to usgsLogoPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function usgsLogoPB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to usgsLogoPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
USGSlogo = imread('USGS_B&WNM.bmp');
set(hObject,'CData',USGSlogo);


% --- Executes on button press in compilePB.
function compilePB_Callback(hObject, eventdata, handles)
% Step 1. Compile Data
% hObject    handle to compilePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Starting water year
handles.WY1 = str2double(get(handles.startWyET,'String'));
setappdata(hAFinchGUI,'WY1',handles.WY1);
% Ending water year
handles.WYn = str2double(get(handles.endWyET,'String'));
setappdata(hAFinchGUI,'WYn',handles.WYn);
% Number of years in the analysis
handles.Ny  = handles.WYn - handles.WY1 + 1;
setappdata(hAFinchGUI,'Ny',handles.Ny);
% HUC name
handles.HUCname = get(handles.HUCnameET,'String');
setappdata(hAFinchGUI,'HUCname',handles.HUCname);
% Analysis title
handles.analTitle = get(handles.titleET,'String');
setappdata(hAFinchGUI,'analTitle',handles.analTitle);
% Analyst name
handles.analyst = get(handles.analystET,'String');
setappdata(hAFinchGUI,'analyst',handles.analyst);
% Diary name
diary(get(handles.logFileET,'String')); diary on;
% Clear progress bar info
set(handles.progressBarST,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.progressBarST,'String','');
annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
    'Position',[428,20,215,25]);

drawnow;
%
HSR = getappdata(hAFinchGUI,'HSR');

fprintf(1,'Hydrologic SubRegion is %s \n',HSR);
fid = fopen(['..\',HSR,'\Flowlines\NHDFlowlineVAAJoinShp.csv'],'rt');
C = textscan(fid,'%u %u %u %u %u %u %f %s','Delimiter',',','Headerlines',1);
fclose(fid);
ComID      = C{1,1}; FromNode  = C{1,2}; ToNode   = C{1,3}; HydroSeq  = C{1,4};
Divergence = C{1,5}; StartFlag = C{1,6}; LengthKM = C{1,7}; ReachCode = C{1,8};
clear C;
%
setappdata(hAFinchGUI,'ComID',ComID);
setappdata(hAFinchGUI,'FromNode',FromNode);
setappdata(hAFinchGUI,'ToNode',ToNode);
setappdata(hAFinchGUI,'HydroSeq',HydroSeq);
setappdata(hAFinchGUI,'Divergence',Divergence);
setappdata(hAFinchGUI,'StartFlag',StartFlag);
setappdata(hAFinchGUI,'LengthKM',LengthKM);
setappdata(hAFinchGUI,'ReachCode',ReachCode);
%
% Read in NLCD data
AFReadNLCD
setappdata(hAFinchGUI,'WY',handles.WY1-1);
% Read in precipitation for prior year
AFReadPrismPrec(0)
%
handles.WY1 = getappdata(hAFinchGUI,'WY1');
%
for iy=1:handles.Ny,
    annotation('rectangle','Units','pixels','FaceColor',[.5 .5 .5],...
        'Position',[428,20,215*iy/handles.Ny,25]);
    set(handles.progressBarST,'String',['Compiling data for ',...
        num2str(handles.WY1 + iy -1)]);  
    drawnow;
    %
    AFSetupData(iy)
end
AFGenLag1Prec
% Integrate flow and basin attribute information
AFAugAFstructQY
guidata(hObject,handles);
%
% Brighten button background colors to show that they are active.
set(handles.dataExplorePanel,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.networkDesignPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.flowAreaPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.waterYieldPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.specifyRegressionPanel,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.setupRegressionPB,'BackgroundColor',[0.83 0.82 0.78]);
% Reset annotation background color
annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
    'Position',[428,20,215,25]);
set(handles.progressBarST,'String','Done compiling data.');


% --- Executes on button press in networkDesignPB.
function networkDesignPB_Callback(hObject, eventdata, handles)
% hObject    handle to networkDesignPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFDesignMatrixDAreasGUI

% --- Executes on button press in flowAreaPB.
function flowAreaPB_Callback(hObject, eventdata, handles)
% hObject    handle to flowAreaPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFplotAreasFlowsGUI

% --- Executes on button press in waterYieldPB.
function waterYieldPB_Callback(hObject, eventdata, handles)
% hObject    handle to waterYieldPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFWaterYieldGUI


% --- Executes on button press in setupRegressionPB.
function setupRegressionPB_Callback(hObject, eventdata, handles)
% hObject    handle to setupRegressionPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = AFStepwiseSetup;
uiwait(h)
set(handles.annualParameterPB,'BackgroundColor',[0.83 0.82 0.78]);

function startWyET_Callback(hObject, eventdata, handles)
% hObject    handle to startWyET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.WY1 = get(hObject,'String');
fprintf(1,'wyStart = %s\n',handles.WY1);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function startWyET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startWyET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in selectHucPB.
function selectHucPB_Callback(hObject, eventdata, handles)
% hObject    handle to selectHucPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAFinchGUI = getappdata(0,'hAFinchGUI');
AFStudyArea;
uiwait
% outputDir = regexprep(workDir, 'AWork', HSR);
% handles.outputDir = [dirHSR,'\Output'];
% set(handles.outputDirST,'String',handles.outputDir);
% 
huclist     = getappdata(hAFinchGUI,'huclist');
% Determine whether 4- or 8-digit HUCs were entered
lenHUC = length(huclist{1});
% Length of huclist
nHUCs       = length(huclist);
% HUC 4s in list 
huc4s       = cell(nHUCs,1);
for i=1:nHUCs
    huc4s{i} = huclist{i}(1:4);
end
% Find unique 4-digit HUCs
uhuc4s = unique(huc4s);
% Count the number of 
% Allocate memory of the count of 4-digit HUCs
nuhuc4s = NaN(length(uhuc4s),1);
% Count the number of 4-digit HUCs
for i=1:length(uhuc4s);
    nuhuc4s(i) = sum(strncmp(uhuc4s(i),huclist,4));
end
% Determine whether 4- or 8-digit HUCs were entered.
if lenHUC==4
    % 4-digit HUCs entered
    if length(uhuc4s)>1
        hucString = [];
        for i=1:length(uhuc4s)-1
            hucString = [hucString sprintf('#{%s}=%d, ',uhuc4s{i},nuhuc4s(i))];
        end
        hucString = [hucString sprintf('#{%s}=%d',uhuc4s{end},nuhuc4s(end))];
    else
        hucString = sprintf('#{%s}=%d',uhuc4s{1},nuhuc4s(1));
    end
elseif lenHUC==8
    % 8-digit HUCs entered
    % Form a string to describe HUCs
    if length(uhuc4s)>1
        hucString = [];
        for i=1:length(uhuc4s)-1
            hucString = [hucString sprintf('#{%snnnn}=%d, ',uhuc4s{i},nuhuc4s(i))];
        end
        hucString = [hucString sprintf('#{%snnnn}=%d',uhuc4s{end},nuhuc4s(end))];
    else
        hucString = sprintf('#{%snnnn}=%d',uhuc4s{1},nuhuc4s(1));
    end
end
%
HSRname = getappdata(hAFinchGUI,'HSRname');
HUCname = [HSRname,': ',hucString];
set(handles.HUCnameET,'String',HUCname);
setappdata(hAFinchGUI,'HUCname',HUCname');
set(handles.hucPUMenu,'Value',1);
set(handles.hucPUMenu,'String',huclist);
set(handles.dataPrepPanel,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.compilePB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.progressBarST,'BackgroundColor',[0.83 0.82 0.78]);
guidata(hObject,handles);

% --- Executes on selection change in hucPUMenu.
function hucPUMenu_Callback(hObject, eventdata, handles)
% hObject    handle to hucPUMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hucPUMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hucPUMenu


% --- Executes during object creation, after setting all properties.
function hucPUMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hucPUMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function endWyET_Callback(hObject, eventdata, handles)
% hObject    handle to endWyET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.WYn = get(hObject,'String');
fprintf(1,'wyEnd= %s\n',handles.WYn);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function endWyET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endWyET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','2010'); 

function titleET_Callback(hObject, eventdata, handles)
% hObject    handle to titleET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of titleET as text
%        str2double(get(hObject,'String')) returns contents of titleET as a double

% --- Executes during object creation, after setting all properties.
function titleET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to titleET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function analystET_Callback(hObject, eventdata, handles)
% hObject    handle to analystET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of analystET as text
%        str2double(get(hObject,'String')) returns contents of analystET as a double


% --- Executes during object creation, after setting all properties.
function analystET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analystET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function logFileET_Callback(hObject, eventdata, handles)
% hObject    handle to logFileET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Logfile = get(hObject,'String');
% Hints: get(hObject,'String') returns contents of logFileET as text
%        str2double(get(hObject,'String')) returns contents of logFileET as a double
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function logFileET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to logFileET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.Logfile = ['AF',datestr(now(),'yyyymmddHHMM'),'.log'];
    set(hObject,'String',handles.Logfile);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles);


% --- Executes on button press in outputDirPB.
function outputDirPB_Callback(hObject, eventdata, handles)
% hObject    handle to outputDirPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.outputDir = uigetdir; % Choose Directory for AFinch output
fprintf(1,'outputDir = %s\n',handles.outputDir);
% assignin('base','outputDir',handles.outputDir);
set(handles.outputDirST,'String',handles.outputDir);
guidata(hObject,handles);


function HUCnameET_Callback(hObject, eventdata, handles)
% hObject    handle to HUCnameET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HUCnameET as text
%        str2double(get(hObject,'String')) returns contents of HUCnameET as a double


% --- Executes during object creation, after setting all properties.
function HUCnameET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HUCnameET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in annualParameterPB.
function annualParameterPB_Callback(hObject, eventdata, handles)
% hObject    handle to annualParameterPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define structure
RegEqnWYr = struct([]);
setappdata(hAFinchGUI,'RegEqnWYr',RegEqnWYr);
%
for iy=1:handles.Ny,
    AFRegressWYr(iy)
end
%
fprintf(1, 'Parameter estimates computed. \n');
set(handles.annualPoAParameterPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.applyRegEqnPanel,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.regressionSpanBG,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.poaRB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.annualRB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.olsRB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.robustRB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.pestTechBG,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.computeCatchYieldsFlowsPB,'BackgroundColor',[0.83 0.82 0.78]);
guidata(hObject,handles);

% --- Executes on button press in annualPoAParameterPB.
function annualPoAParameterPB_Callback(hObject, eventdata, handles)
% hObject    handle to annualPoAParameterPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFevalRegParmEstiGUI


% --- Executes on button press in computeCatchYieldsFlowsPB.
function computeCatchYieldsFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to computeCatchYieldsFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
Ny          = getappdata(hAFinchGUI,'Ny');
ExpVarNo    = getappdata(hAFinchGUI,'ExpVarNo');
xVar        = getappdata(hAFinchGUI,'xVar');
% DaysInMo    = getappdata(hAFinchGUI,'DaysInMo');
% StaHist     = getappdata(hAFinchGUI,'StaHist');
AFstruct    = getappdata(hAFinchGUI,'AFstruct');
RegEqnPoA   = getappdata(hAFinchGUI,'RegEqnPoA');
HSR         = getappdata(hAFinchGUI,'HSR');
RegEqnWYr     = getappdata(hAFinchGUI,'RegEqnWYr');
%%
% xVarTableData = getappdata(hAFinchGUI,'xVarTableData'); 
WY1           = getappdata(hAFinchGUI,'WY1');
% wYearVec      = getappdata(hAFinchGUI,'wYearVec');
% MonthName     = getappdata(hAFinchGUI,'MonthName');
MoName = getappdata(hAFinchGUI,'MoName');

% 
sxVar = struct([]); % NaN(size(xVar));
% Flip xVar if needed.
[r,c] = size(xVar);
if r > 1
    xVar = xVar';
end
%
for i=1:ExpVarNo
    sxVar(1,i).name   = xVar(1,i).name;
    sxVar(1,i).type   = xVar(1,i).type;
    if ismatrix(xVar(1,i).value)
        [sGridcode,ndxGridcode] = sort(xVar(1,i).gridcode,1);
        sxVar(1,i).value        = xVar(1,i).value(ndxGridcode);
        sxVar(1,i).gridcode     = sGridcode;
    elseif ndims(xVar(1,i).value) == 3
        [sGridcode,ndxGridcode] = sort(xVar(1,i).gridcode,1);
        sxVar(1,i).value        = xVar(1,i).value(:,ndxGridcode,1:12);
        sxVar(1,i).gridcode     = sGridcode;
    else
        errordlg('The ndims is not the expected value of 2 or 3','Stopping'); 
    end
end
%
% Use intersection to determine if the gridcodes are the same in each xVar
uniGridcode    = unique(sxVar(1,1).gridcode);
lenGridcode(1) = length(uniGridcode);
for i=2:ExpVarNo
    lenGridcode(i) = length(sxVar(1,i).gridcode);
    uniGridcode    = intersect(sxVar(1,i).gridcode,uniGridcode);
end
if length(uniGridcode) == max(lenGridcode)
    fprintf(1,'Gridcodes in all explanatory variables are the same.\n');
else
    fprintf(1,'There are %u common gridcodes in %u total gridcodes.\n',...
        length(uniGridcode),max(lenGridcode));
end
%
% Read in the shapefile for the region
% NHD = shaperead(['..\',HSR,'\GIS\Catchment.shp']);
AreaSqMi_PrecTHS = getappdata(hAFinchGUI,'AreaSqMi_PrecTHS');
GridCode_PrecTHS = getappdata(hAFinchGUI,'GridCode_PrecTHS');

% Intersect NHD gridcodes with uniGridcode
[~,~,ib] = intersect(uniGridcode,GridCode_PrecTHS);
% Convert square kilometers to square miles
AreaSqMi  = AreaSqMi_PrecTHS(ib);
%
% Compute estimated water yield using technique selected by user
% Develop yield estimates based on user-specifications
% 
% Allocate yieldCatchEst for regression stimates of monthly water yields from catchments
yieldCatchEst = NaN(Ny,length(uniGridcode),12);
 flowCatchEst = NaN(Ny,length(uniGridcode),12);
% 
% Select regression parameters for Period of Analysis and Ordinary Least Squares
%
if strcmp(handles.RegSpan,'poaRB') && strcmp(handles.RegTech,'olsRB')
    fprintf(1, 'RegSpan = PoA and RegTech = OLS \n');
    for im = 1:12,
        designMat      = NaN(length(uniGridcode),2+sum(RegEqnPoA(1,im).inmodel));
        designMat(:,2) = ones(length(uniGridcode),1);
        designMat(:,1) = uniGridcode;
        ndxvar   =  find(RegEqnPoA(1,im).inmodel);
        % build a designMat using the first water year for each month and
        % write it out, also write out the B values of the regression 
        % for each month
        labelvector = {'gridcode','intercept'};
        for ivar = 1:sum(RegEqnPoA(1,im).inmodel),
            if ndims(sxVar(1,ndxvar(ivar)).value)==3
                    % xVar varies monthly, annually, and spatially
                    designMat(:,ivar+2) = sxVar(1,ndxvar(ivar)).value(1,:,im)';
            else
                    % xVar only varies spatially
                    designMat(:,ivar+2) = sxVar(1,ndxvar(ivar)).value;
            end
            labelvector = [labelvector sxVar(1,ndxvar(ivar)).name];
        end
        % write design matrix to a file, also write b values
       
        abbrev = strrep(MoName(im),'.','');
        fname =strcat('DesMat_',abbrev,'.csv');
        fid = fopen(char(fname), 'wt');
        fprintf(fid,'%s, ',labelvector{:});
        fprintf(fid,'\n');
        dlmwrite(char(fname),designMat, '-append');
        fclose(fid);
        fname = strcat('b_vec_',abbrev,'.csv');
        fid = fopen(char(fname),'wt');
        fprintf(fid,'%s, ',sxVar(1,:).name);
        fprintf(fid,'\n');
        fprintf(fid,'%d, ',RegEqnPoA(1,im).inmodel);
        fprintf(fid,'\n');
        fprintf(fid,'%f, ',RegEqnPoA(1,im).OLS.b);
        fclose(fid);
        %reset design matrix
        clear designMat;
        designMat      = NaN(length(uniGridcode),1+sum(RegEqnPoA(1,im).inmodel));
        designMat(:,1) = ones(length(uniGridcode),1);
        for iy  = 1:Ny,
            for ivar = 1:sum(RegEqnPoA(1,im).inmodel)
                if ndims(sxVar(1,ndxvar(ivar)).value)==3
                    % xVar varies monthly, annually, and spatially
                    designMat(:,ivar+1) = sxVar(1,ndxvar(ivar)).value(iy,:,im)';
                else
                    % xVar only varies spatially
                    designMat(:,ivar+1) = sxVar(1,ndxvar(ivar)).value;
                end
            end
            WY = WY1 + iy -1;
            yieldCatchEst(iy,:,im) = designMat * ...
                RegEqnPoA(1,im).OLS.b([1,ndxvar+1]);
            % Compute flows corresponding to yieldCatchEst
             flowCatchEst(iy,:,im) = (yieldCatchEst(iy,:,im)').^2 ...
                 .* AreaSqMi * 5280^2 /(AFdaysInMonth(WY,im)*24*3600*12);
        end
    end
    % Period of Analysis and Robust regression estimates   
elseif strcmp(handles.RegSpan,'poaRB') && strcmp(handles.RegTech,'robustRB')
    fprintf(1, 'RegSpan = PoA and RegTech = Robust \n');
    for im = 1:12,
        designMat      = NaN(length(uniGridcode),1+sum(RegEqnPoA(1,im).inmodel));
        designMat(:,1) = ones(length(uniGridcode),1);
        ndxvar   =  find(RegEqnPoA(1,im).inmodel);
        for iy  = 1:Ny,
            for ivar = 1:sum(RegEqnPoA(1,im).inmodel)
                if ndims(sxVar(1,ndxvar(ivar)).value)==3
                    % xVar varies monthly, annually, and spatially
                    designMat(:,ivar+1) = sxVar(1,ndxvar(ivar)).value(iy,:,im)';
                else
                    % xVar only varies spatially
                    designMat(:,ivar+1) = sxVar(1,ndxvar(ivar)).value;
                end
            end
            WY = WY1 + iy -1;
            yieldCatchEst(iy,:,im) = designMat * RegEqnPoA(1,im).robust.b;
            % Compute flows corresponding to yieldCatchEst
             flowCatchEst(iy,:,im) = (yieldCatchEst(iy,:,im)').^2 ...
                 .* AreaSqMi * 5280^2 /(AFdaysInMonth(WY,im)*24*3600*12);
        end
    end
    % Analysis of Annual Regression Estimates computed using OLS  
elseif strcmp(handles.RegSpan,'annualRB') && strcmp(handles.RegTech,'olsRB')
    fprintf(1, 'RegSpan = Annual and RegTech = OLS \n');
    % Monthly values
    for im = 1:12,
        % Annual values
        for iy = 1:Ny,
            if ~isempty(RegEqnWYr(iy,im).OLS)
                designMat      = NaN(length(uniGridcode),1+sum(RegEqnWYr(iy,im).inmodel));
                designMat(:,1) = ones(length(uniGridcode),1);
                ndxvar   =  find(RegEqnWYr(iy,im).inmodel);
                for ivar = 1:sum(RegEqnWYr(iy,im).inmodel)
                    if ndims(sxVar(1,ndxvar(ivar)).value)==3
                        % xVar varies monthly, annually, and spatially
                        designMat(:,ivar+1) = sxVar(1,ndxvar(ivar)).value(iy,:,im)';
                    else
                        % xVar only varies spatially
                        designMat(:,ivar+1) = sxVar(1,ndxvar(ivar)).value;
                    end
                end
                WY = WY1 + iy -1;
                yieldCatchEst(iy,:,im) = designMat * ...
                    RegEqnWYr(iy,im).OLS.b;
                % Compute flows corresponding to yieldCatchEst
                flowCatchEst(iy,:,im)  = (yieldCatchEst(iy,:,im)').^2 ...
                    .* AreaSqMi * 5280^2 /(AFdaysInMonth(WY,im)*24*3600*12);
            end
        end
    end
    % Analysis of Annual Regression Estimates computed using robust
elseif strcmp(handles.RegSpan,'annualRB') && strcmp(handles.RegTech,'robustRB')
    fprintf(1, 'RegSpan = Annual and RegTech = Robust \n');
    % Monthly values
    for im = 1:12,
        % Annual values
        for iy = 1:Ny,
            if ~isempty(RegEqnWYr(iy,im).Robust)
                designMat      = NaN(length(uniGridcode),1+sum(RegEqnWYr(iy,im).inmodel));
                designMat(:,1) = ones(length(uniGridcode),1);
                ndxvar   =  find(RegEqnWYr(iy,im).inmodel);
                for ivar = 1:sum(RegEqnWYr(iy,im).inmodel)
                    if ndims(sxVar(1,ndxvar(ivar)).value)==3
                        % xVar varies monthly, annually, and spatially
                        designMat(:,ivar+1) = sxVar(1,ndxvar(ivar)).value(iy,:,im)';
                    else
                        % xVar only varies spatially
                        designMat(:,ivar+1) = sxVar(1,ndxvar(ivar)).value;
                    end
                end
                WY = WY1 + iy -1;
                yieldCatchEst(iy,:,im) = designMat * ...
                    RegEqnWYr(iy,im).Robust.b;
                % Compute flows corresponding to yieldCatchEst
                flowCatchEst(iy,:,im)  = (yieldCatchEst(iy,:,im)').^2 ...
                    .* AreaSqMi * 5280^2 /(AFdaysInMonth(WY,im)*24*3600*12);
            end
        end
    end
end
%
yieldCatchEst = yieldCatchEst.^2;
yieldCatchCon = yieldCatchEst;
flowCatchCon  = flowCatchEst;
% Modifies estimated yields and flows where streamgages are active 
[Ny,Ns] = size(eval(['AFstruct.',HSR]));
ConAdjust = NaN(Ny,Ns,12);
%
hAFinchGUI = getappdata(0, 'hAFinchGUI');
StaHist    = getappdata(hAFinchGUI,'StaHist');
AFstruct   = getappdata(hAFinchGUI,'AFstruct');
for iy=1:Ny,
    for is=1:length(StaHist(iy).StaNdx)
        % The target below is ib, the indices for the selected station
        [~,~,ib] = intersect(...
            [AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).SBGridCode],...
            GridCode_PrecTHS);
        %
        
        AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).flowBasinEstInc = ...
            reshape(sum(flowCatchEst(iy,ib,:),2),1,12);

        for im = 1:12,
            StaHist(iy).QEstIncWY(is,im) = sum(flowCatchEst(iy,ib,im));          
            ConAdjust(iy,is,im) = ...
                AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).QMeaAdjInc(im)/...
                AFstruct.(HSR)(iy,StaHist(iy).StaNdx(is)).flowBasinEstInc(im);
            flowCatchCon(iy,ib,im) =  ConAdjust(iy,is,im) .* ...
                flowCatchEst(iy,ib,im);
            WY = WY1 + iy -1;
            yieldCatchCon(iy,ib,im) = flowCatchCon(iy,ib,im)' ...
                ./ (AreaSqMi_PrecTHS(ib) * 5280^2) * (AFdaysInMonth(WY,im)*24*3600*12);
            StaHist(iy).QConIncWY(is,im) = sum(flowCatchCon(iy,ib,im));
        end
    end
end
%
setappdata(hAFinchGUI,'flowCatchEst',flowCatchEst);
setappdata(hAFinchGUI,'flowCatchCon',flowCatchCon);
setappdata(hAFinchGUI,'yieldCatchEst',yieldCatchEst);
setappdata(hAFinchGUI,'yieldCatchCon',yieldCatchCon);
setappdata(hAFinchGUI,'StaHist',StaHist);
%
set(handles.displayCatchYieldsPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.displayFlowsAtStreamgagesPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.accumFlowsPanel,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.accumCatchFlowsPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.outputCatchYieldsFlowsPB,'BackgroundColor',[0.83 0.82 0.78]);
% set(handles.wYrWriteST,'BackgroundColor',[0.83 0.82 0.78]);
%
handles.AreaSqMi      = AreaSqMi;
handles.gridcode      = uniGridcode;
handles.yieldCatchCon = yieldCatchCon;
handles.yieldCatchEst = yieldCatchEst;
handles.flowCatchCon  = flowCatchCon;
handles.flowCatchEst  = flowCatchEst;
%
fprintf(1, 'Catchment yields and flows computed. \n');
% 
guidata(hObject,handles);


% --- Executes when selected object is changed in pestTechBG.
function pestTechBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pestTechBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.RegTech = get(eventdata.NewValue,'Tag');
% guidata(hObject,handles);
fprintf(1,'RegTech = %s.\n',handles.RegTech);
% set(handles.computeCatchYieldsFlowsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.displayCatchYieldsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.displayFlowsAtStreamgagesPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.outputCatchYieldsFlowsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.accumCatchFlowsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.writeAccumFlowsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.plotFlowTimeSeriesPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.plotFlowDurationsPB,'BackgroundColor',[0.5 0.5 0.5]);
guidata(hObject,handles);


% --- Executes when selected object is changed in regressionSpanBG.
function regressionSpanBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in regressionSpanBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.RegSpan = get(eventdata.NewValue,'Tag');
% guidata(hObject,handles);
fprintf(1,'RegSpan = %s.\n',handles.RegSpan);
% set(handles.computeCatchYieldsFlowsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.displayCatchYieldsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.displayFlowsAtStreamgagesPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.outputCatchYieldsFlowsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.accumCatchFlowsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.writeAccumFlowsPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.plotFlowTimeSeriesPB,'BackgroundColor',[0.5 0.5 0.5]);
set(handles.plotFlowDurationsPB,'BackgroundColor',[0.5 0.5 0.5]);
guidata(hObject,handles);


% --- Executes on button press in displayCatchYieldsPB.
function displayCatchYieldsPB_Callback(hObject, eventdata, handles)
% hObject    handle to displayCatchYieldsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFdistWaterYieldGUI

% --- Executes on button press in accumCatchFlowsPB.
function accumCatchFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to accumCatchFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Accumulate Flow Using the Algorithm in the NHDPlus User Guide 
% Algorithm shown on p. 47 in the user guide.
% Setup hAFinchGUI link
hAFinchGUI   = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
HSR          = getappdata(hAFinchGUI,'HSR');
StaHist      = getappdata(hAFinchGUI,'StaHist');
MonthName    = getappdata(hAFinchGUI,'MonthName');
WY1          = getappdata(hAFinchGUI,'WY1');
ioDir        = getappdata(hAFinchGUI,'ioDir');
HSR          = getappdata(hAFinchGUI,'HSR');
fprintf(1,'Accumulating flows...');
% Reset annotation background color
annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
    'Position',[428,20,215,25]);
set(handles.progressBarST,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.progressBarST,'String','');
%
% Read in the HSR VAA table
%% Columns: 1-ComID 2-FromNode 3-ToNode 4-HydroSeq 5-Divergence 6-Startflag 7-Gridcode
%   note: AreaSqKm was the last column in the test file (not used).
%   note: The VAAComNodeSeq file will commonly be for an entire hydrolgic subregion
try 
   vaaComNodeSeqGrid = csvread([ioDir,'\GIS\NHDFlowlineVAA.csv'],1);
catch
    % The user is asked for file location if it's not where it's expected. 
    [file,path] = uigetfile('*.csv','NHDFlowlineVAA csv file');
    vaaComNodeSeqGrid = csvread([path,file],1);
end
% Sort vaaComNodeSeqGrid on gridcode so that data can be matched to ComIDs in VAA file
vaaComNodeSeqGrid    = sortrows(vaaComNodeSeqGrid,7);
vaaN                 = length(vaaComNodeSeqGrid);
handles.flowFLincEst = zeros(handles.Ny,length(vaaComNodeSeqGrid),12);
handles.flowFLincCon = zeros(handles.Ny,length(vaaComNodeSeqGrid),12);
% igc is ndx for gridcode
igc = 1;
for ivaa = 1:vaaN,
   if vaaComNodeSeqGrid(ivaa,7)==handles.gridcode(igc)
       handles.flowFLincEst(1:handles.Ny,ivaa,1:12) = ...
           handles.flowCatchEst(1:handles.Ny,igc,1:12);
       handles.flowFLincCon(1:handles.Ny,ivaa,1:12) = ...
           handles.flowCatchCon(1:handles.Ny,igc,1:12);
       igc = igc + 1;
   end
end
% Sort vaaComNodeSeq by decreasing hydroseq, the 4th colun
[vaaComNodeSeqGrid,ndxHydroSeq] = sortrows(vaaComNodeSeqGrid,-4);
% Create vectors for analysis
hseqComID      = vaaComNodeSeqGrid(:,1);
hseqFromNode   = vaaComNodeSeqGrid(:,2);
hseqToNode     = vaaComNodeSeqGrid(:,3);
hseqHydroSeq   = vaaComNodeSeqGrid(:,4);
hseqDivergence = vaaComNodeSeqGrid(:,5);
hseqStartFlag  = vaaComNodeSeqGrid(:,6);
% hseqGridcode   = vaaComNodeSeqGrid(:,7); 
%
% Reorder the flowFLinc data in decreasing hydroseq order
handles.flowFLincEst  = handles.flowFLincEst(:,ndxHydroSeq,1:12);
handles.flowFLincCon  = handles.flowFLincCon(:,ndxHydroSeq,1:12);
%
% Allocate arrays to contain accumulated flows
%% Initialize arrays with zeros instead of NaN
%   because some flowlines are short and have not been assigned a catchment
%%
% handles.flowFLsumEst = NaN(size(handles.flowFLincEst));
% handles.flowFLsumCon = NaN(size(handles.flowFLincCon));
handles.flowFLsumEst = zeros(size(handles.flowFLincEst));
handles.flowFLsumCon = zeros(size(handles.flowFLincCon));
%
% Start accumulating flow
for iy = 1:handles.Ny,
    annotation('rectangle','Units','pixels','FaceColor',[.5 .5 .5],...
        'Position',[428,20,215*iy/handles.Ny,25]);
    set(handles.progressBarST,'String',['Accumulating catchment flows ',...
        num2str(handles.WY1 + iy -1)]);
    drawnow
    im = 1:12;
        for fl = 1:vaaN
            if hseqHydroSeq(fl)>0
                if hseqStartFlag(fl)==1 || hseqDivergence(fl)==2
                    handles.flowFLsumCon(iy,fl,im) = ...
                        handles.flowFLincCon(iy,fl,im);
                else
                    Ndx = find(hseqToNode==hseqFromNode(fl));
                    handles.flowFLsumCon(iy,fl,im) = ...
                        sum(handles.flowFLsumCon(iy,Ndx,im),2) + ...
                        handles.flowFLincCon(iy,fl,im);
                end
            end
        end 
    %
    %% Read in monthly wateruse at flowlines indicated by ComID
    fprintf(1,'\n AFConFlowAccum: Checking for routed water use for Water Year %4u.\n',WY1+iy-1);
    % Read in the flow data at active stations for a specific water year
    FileIn = fullfile(ioDir,['WaterUse\ComIDWUseMonthly',num2str(WY1+iy-1),'.dat']);
    %
    fid = fopen(FileIn,'rt');
    if fid>-1
        C = textscan(fid,['%u ',repmat('%f ',1,12)],'HeaderLines',1,...
            'Delimiter','\t');
        ComID_WU = C{1,1};
        WUseWY   = [C{2:13}];
        fclose(fid);
    else
        fprintf(1,'CAUTION: Water use data was not found for WY %u. Analyis continuing...\n',WY1+iy-1);
        ComID_WU = [];
        WUseWY   = [];
    end
%    %
    % Find the ComIDs where WU occurred and add it back in to the flowFLsumCon data
%% Check whether water data found for WY    
    if fid>-1
        [~,ia,ib] = intersect(ComID_WU,hseqComID);
        handles.flowFLsumCon(iy,ib,1:12) = squeeze(handles.flowFLsumCon(iy,ib,1:12)) + WUseWY(ia,1:12);
    end
%    
end
% End year
%
% Reset annotation background color
annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
    'Position',[428,20,215,25]);
set(handles.progressBarST,'String','Done accumulating catchment flows');
%%
% Read in Station and ComID pairs
fid = fopen(['..\',HSR,'\Flowlines\StationComID.csv'],'rt');
if fid>0
    C = textscan(fid,'%s%u','HeaderLines',1,'Delimiter',',');
else
    % The user is asked for file location if it's not where it's expected.
    [file,path] = uigetfile('*.csv','StationComID csv file');
    fid = fopen([path,file],'rt');
    C = textscan(fid,'%s%u','HeaderLines',1,'Delimiter',',');
end
HRStation = C{:,1}; HRComID = C{:,2};
fclose(fid);
% Store variables in GUI
hAFinchGUI = getappdata(0,'hAFinchGUI');
setappdata(hAFinchGUI,'HRStation',HRStation);
setappdata(hAFinchGUI,'HRComID'  ,HRComID);
AFstruct = getappdata(hAFinchGUI,'AFstruct');
%
% Get size of AFstruct
[Ny,Ns] = size(AFstruct.(HSR));
% Populate AFstruct with ComIdGage
Station = cell(Ns,1);  ComIdGage = zeros(Ns,1,'uint32');
for ns = 1:Ns,
    numTargetGage  = AFstruct.(HSR)(1,ns).Station;
    ndxTargetComID = strcmp(numTargetGage,HRStation)==1;
    for iy = 1:Ny,
          AFstruct.(HSR)(iy,ns).ComIdGage = HRComID(ndxTargetComID);
          ComIdGage(ns)                   = HRComID(ndxTargetComID);
          Station(ns)                     = AFstruct.(HSR)(iy,ns).Station;
    end
end
setappdata(hAFinchGUI,'AFstruct',AFstruct);
setappdata(hAFinchGUI,'ComIdGage',ComIdGage);
setappdata(hAFinchGUI,'Station',Station);
%
% 
HRStaNum = zeros(length(HRStation),1);
for ig = 1:length(HRStation),
    HRStaNum(ig) = str2double(HRStation{ig});
end
%
for iy=1:handles.Ny
%% read in water use again here for output to screen 
    FileIn = fullfile(ioDir,['WaterUse\ComIDWUseMonthly',num2str(WY1+iy-1),'.dat']);
    %
    fid = fopen(FileIn,'rt');
    if fid>-1
        C = textscan(fid,['%u ',repmat('%f ',1,12)],'HeaderLines',1,...
            'Delimiter','\t');
        ComID_WU = C{1,1};
        WUseWY   = [C{2:13}];
        fclose(fid);
    else
        fprintf(1,'CAUTION: Water use data was not found for WY %u. Analyis continuing...\n',WY1+iy-1);
        ComID_WU = [];
        WUseWY   = [];
    end
%
    for im = 1:12
        % List monthly flow estimates at active streamgages
        fprintf(1,['\n',repmat('-',1,67),'\n']);
        fprintf(1,'Seq. Water       Station                    AFinch  Water Measured \n');
        fprintf(1,'Num. year  Month  number  Index    ComID     Flow    Use    flow   \n');
        fprintf(1,[repmat('-',1,67),'\n']);
        %
        AccStaFlow = zeros(length(StaHist(iy).StaList),1);
        for is=1:length(StaHist(iy).StaList)
            % is increments the active station count for a particular wyear
            Ndx = find(str2double(StaHist(iy).StaList{is})==HRStaNum);
            if ~isempty(Ndx)
                ComIDTarget = HRComID(Ndx);
                % Find the Ndx of the ComIDTarget in the dataset
                ComIDNdx        = find(ComIDTarget==hseqComID);
                AccStaFlow(is)  = handles.flowFLsumCon(iy,ComIDNdx,im);
            else
                warndlg(['Streamgage ',num2str(StaHist(iy).StaList{is}),' not found for ',...
                    'water year ',num2str(WY1+iy-1)]);
            end
            %
            NdxWU1 = find(hseqComID(ComIDNdx)==ComID_WU);
            if ~isempty(NdxWU1)
                WUse1 = WUseWY(NdxWU1, im);
            else    
                WUse1 = 0;
            end
%%            
            %
            % Find the measured monthly flows in StaHist(ii).StaList(i)
            fprintf(1,'%4u  %4u %4s  %s %4u  %10u %7.1f %6.1f %7.1f\n',is,...
                WY1+iy-1-1*(im<4),MonthName{im}(1:3),StaHist(iy).StaList{is},...
                Ndx,ComIDTarget,AccStaFlow(is),WUse1,StaHist(iy).QTotWY(is,im));
        end
        % QTotAdj = StaHist(iy).QTotWY;
        %
        % Accumulate over months
    end
    % Accumulate over years
end
%
fprintf(1, 'Catchment flows accumulated. \n');
set(handles.writeAccumFlowsPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.plotFlowTimeSeriesPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.plotFlowDurationsPB,'BackgroundColor',[0.83 0.82 0.78]);

hAFinchGUI = getappdata(0, 'hAFinchGUI');
setappdata(hAFinchGUI,'flowFLsumCon',handles.flowFLsumCon);
setappdata(hAFinchGUI,'hseqComID',hseqComID');
setappdata(hAFinchGUI,'AFstruct',AFstruct);
guidata(hObject, handles);
% 
% --- Executes on button press in plotFlowTimeSeriesPB.
function plotFlowTimeSeriesPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotFlowTimeSeriesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFplotFlowSeriesGUI;
%
%
% --- Executes on button press in plotNetworkFlows.
function plotNetworkFlows_Callback(hObject, eventdata, handles)
% hObject    handle to plotNetworkFlows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plotFlowDurationsPB.
function plotFlowDurationsPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotFlowDurationsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFplotDurationGUI

% --- Executes on button press in displayFlowsAtStreamgagesPB.
function displayFlowsAtStreamgagesPB_Callback(hObject, eventdata, handles)
% hObject    handle to displayFlowsAtStreamgagesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
AFplotMeaEstFlowsGUI

% --- Executes on button press in ExitPB.
function ExitPB_Callback(hObject, eventdata, handles)
% hObject    handle to ExitPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)


% --- Executes on button press in outputCatchYieldsFlowsPB.
function outputCatchYieldsFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to outputCatchYieldsFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Setup hAFinchGUI link
hAFinchGUI  = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
stepResults   = getappdata(hAFinchGUI,'stepResults');
MoName        = getappdata(hAFinchGUI,'MoName');
pEnter        = getappdata(hAFinchGUI,'pEnter');
pRemove       = getappdata(hAFinchGUI,'pRemove');
ioDir         = getappdata(hAFinchGUI,'ioDir');
% outPath     = get(handles.outputDirST,'String');
% Clear progress bar info
annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
    'Position',[428,20,215,25]);
set(handles.progressBarST,'String','');

if exist([ioDir,'\Output\Catchments'],'dir')~=7
    action = questdlg({['Directory ',ioDir,'\Output\Catchments\'];...
        ['does not exist.  Create the specified directory for output?']},'Create directory?',...
        'Yes','No','Yes');
    switch action
        case 'Yes'
            mkdir([ioDir,'\Output\Catchments']);
            outDir = 1;
        case 'No'
            msgbox({'No output directory was created.  Respecify output',...
                'directory in edit box above to write out data.'},...
                'Respecify output directory.','warn');
            outDir = 0;
            return
    end
    
else
    outDir = 1;
end
%
fOverwrite =  0; % Default is do not overwrite existing files.
if outDir==1
    for iy = 1:handles.Ny
        WY = handles.WY1 + iy -1;
        annotation('rectangle','Units','pixels','FaceColor',[.5 .5 .5],...
            'Position',[428,20,215*iy/handles.Ny,25]);
        set(handles.progressBarST,'String',['Writing yields and flows for ',...
            num2str(handles.WY1 + iy -1)]);
        drawnow
        % Write expanded header info to catchment output file
        fExist = exist([ioDir,'\Output\Catchments\CatchYieldsFlowsWY',...
            int2str(WY),'.csv'],'file');
        if fExist == 0
            oWrite = 'Overwrite All';
        end
        if fExist == 2 && fOverwrite == 0
            oWrite = questdlg([[ioDir,'\Output\Catchments\CatchYieldsFlowsWY',int2str(WY),...
            '.csv'],' exists. OVERWRITE THIS FILE SERIES FOR ALL WATER YEARS?'],...
            'Output file exists',...
            'Overwrite All','Do Not Overwrite','Overwrite All');
        end
        %
        switch oWrite 
            case 'Overwrite All'
            fOverwrite = 1;            
        fid = fopen([ioDir,'\Output\Catchments\CatchYieldsFlowsWY',...
            int2str(WY),'.csv'],'wt');
        fprintf(1,'Writing %s\\catchYieldsFlowsWY%4.0f.csv\n',ioDir,WY);
        % Write header information to the file.
        fprintf(fid,'TITLE: %s  Year Start: %d, End: %d. \n',...
            handles.analTitle,handles.WY1,handles.WYn);
        % Regression method
        if get(handles.olsRB,'Value')
            RegMeth = 'OLS';
        else
            RegMeth = 'Robust';
        end
        % Regression span
        if strcmp(handles.RegSpan,'poaRB')
            RegSpan = 'Period of Analysis';
        else
            RegSpan = 'Annual';
        end
        fprintf(fid,'Regression Span: %s, Method: %s.  Alpha: pEnter: %6.4f, pRemove: %5.4f.\n',...
            RegSpan,RegMeth,pEnter,pRemove);
        [Nr,~] = size(xVarTableData);
        fprintf(fid,['X Variable Names: ',...
            repmat(' %s',1,Nr),'. \n'],...
            xVarTableData{:,1});
        fprintf(fid,'Month [Indicator for xVar] N  RMSE F-Stat p-value  r2\n');
        for im = 1:12,
            fprintf(fid,[' %s [',repmat('%2u',1,Nr),' ] %4u %6.4f %5.1f %10.4g %6.4f\n'],...
            MoName{im},stepResults{im,:});
        end
        fprintf(fid,'logFile: %s, HUC-Output Dir: %s.\n',...
            get(handles.logFileET,'String'),get(handles.HUCnameET,'String'));
        fprintf(fid,'SELECTED HUCs: ');
        huclist = get(handles.hucPUMenu,'String');
        for ip=1:length(huclist), fprintf(fid,'%s ',huclist{ip}); end;
        fprintf(fid,'\n');
        % Analyst = get(handles.analystET,'String');
        fprintf(fid,'Analyst: %s. Rundate: %s. \n',...
            get(handles.analystET,'String'),datestr(now()));
        %
        % Write column identifiers in second line:
        fprintf(fid,'GridCode,AreaSqMi,');
        fprintf(fid,'flowCatchEstOct,flowCatchEstNov,flowCatchEstDec,flowCatchEstJan,');
        fprintf(fid,'flowCatchEstFeb,flowCatchEstMar,flowCatchEstApr,flowCatchEstMay,');
        fprintf(fid,'flowCatchEstJun,flowCatchEstJul,flowCatchEstAug,flowCatchEstSep,');
        fprintf(fid,'yieldCatchEstOct,yieldCatchEstNov,yieldCatchEstDec,yieldCatchEstJan,');
        fprintf(fid,'yieldCatchEstFeb,yieldCatchEstMar,yieldCatchEstApr,yieldCatchEstMay,');
        fprintf(fid,'yieldCatchEstJun,yieldCatchEstJul,yieldCatchEstAug,yieldCatchEstSep,');
        fprintf(fid,'flowCatchConOct,flowCatchConNov,flowCatchConDec,flowCatchConJan,');
        fprintf(fid,'flowCatchConFeb,flowCatchConMar,flowCatchConApr,flowCatchConMay,');
        fprintf(fid,'flowCatchConJun,flowCatchConJul,flowCatchConAug,flowCatchConSep,');
        fprintf(fid,'yieldCatchConOct,yieldCatchConNov,yieldCatchConDec,yieldCatchConJan,');
        fprintf(fid,'yieldCatchConFeb,yieldCatchConMar,yieldCatchConApr,yieldCatchConMay,');
        fprintf(fid,'yieldCatchConJun,yieldCatchConJul,yieldCatchConAug,yieldCatchConSep\n');
        for iCatch=1:length(handles.gridcode),
            fprintf(fid,['%u,%6.3f,',repmat('%f,',1,48),'\n'],...
                handles.gridcode(iCatch),handles.AreaSqMi(iCatch),...
                handles.flowCatchEst(iy,iCatch,1:12),...
                handles.yieldCatchEst(iy,iCatch,1:12),...
                handles.flowCatchCon(iy,iCatch,1:12),...
                handles.yieldCatchCon(iy,iCatch,1:12));
        end
        fclose(fid);
        case 'Do Not Overwrite'
           warndlg('Existing output files were not overwritten.','No Output Written');
           annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
             'Position',[428,20,215*(iy)/handles.Ny,25]);
           set(handles.progressBarST,'String','Did not write catchment yields and flows.');
           fprintf(1, 'Did not write catchment yields and flows.\n');
           return
        end        
    end
end
fprintf(1,'Completed writing of data to output files.\n');
annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
    'Position',[428,20,215,25]);
set(handles.progressBarST,'String','Done writing yields and flows');


% --- Executes on button press in writeAccumFlowsPB.
function writeAccumFlowsPB_Callback(hObject, eventdata, handles)
% hObject    handle to writeAccumFlowsPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Setup hAFinchGUI link
hAFinchGUI  = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
xVarTableData = getappdata(hAFinchGUI,'xVarTableData');
stepResults   = getappdata(hAFinchGUI,'stepResults');
MoName        = getappdata(hAFinchGUI,'MoName');
pEnter        = getappdata(hAFinchGUI,'pEnter');
pRemove       = getappdata(hAFinchGUI,'pRemove');
ioDir         = getappdata(hAFinchGUI,'ioDir');
flowFLsumCon  = getappdata(hAFinchGUI,'flowFLsumCon');
hseqComID     = getappdata(hAFinchGUI,'hseqComID');
%
annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
    'Position',[428,20,215,25]);
set(handles.progressBarST,'String','');
%
% Find out if output director exists.  Create if needed.
if exist([ioDir,'\Output\Flowlines'],'dir')~=7
    action = questdlg({['Directory ',ioDir,'\Output\Flowlines\'];...
        ['does not exist.  Create the specified directory for output?']},'Create directory?',...
        'Yes','No','Yes');
    switch action
        case 'Yes'
            mkdir([ioDir,'\Output\Flowlines']);
            outDir = 1;
        case 'No'
            msgbox({'No output directory was created.  Reselect input/output',...
                'directory in edit box above to write out data.'},...
                'Reselect input/output directory.','warn');
            outDir = 0;
            return
    end
%   
else
    outDir = 1;
end

%
fOverwrite =  0; % Default is do not overwrite existing files.
if outDir  == 1
    for iy = 1:handles.Ny
        WY = handles.WY1 + iy -1;
        % Get water-use data for the indexed water year
        ComID_WU      = getappdata(hAFinchGUI,['ComID_WU',num2str(WY)]);
        WUseWY        = getappdata(hAFinchGUI,['WUseWY',  num2str(WY)]);
%% For years with no water use
        if isempty(WUseWY)
            WUseWY=zeros(1,12);
        end
%
        annotation('rectangle','Units','pixels','FaceColor',[.5 .5 .5],...
            'Position',[428,20,215*iy/handles.Ny,25]);
        set(handles.progressBarST,'String',['Writing accumulated flows for ',...
            num2str(handles.WY1 + iy -1)]);
        drawnow
        % Write expanded header info to flowline output file.
        fExist = exist([ioDir,'\Output\Flowlines\AccumFlowsWY',...
            int2str(WY),'.csv'],'file');
        if fExist == 0
            oWrite = 'Overwrite All';
        end
        if fExist == 2 && fOverwrite == 0
            oWrite = questdlg([[ioDir,'\Output\Flowlines\AccumFlowsWY',int2str(WY),...
            '.csv'],' exists. OVERWRITE THIS FILE SERIES FOR ALL WATER YEARS?'],...
            'Output file exists',...
            'Overwrite All','Do Not Overwrite','Overwrite All');
        end
        %
        switch oWrite 
            case 'Overwrite All'
            fOverwrite = 1;     
        fid = fopen([ioDir,'\Output\Flowlines\AccumFlowsWY',...
            int2str(WY),'.csv'],'wt');
        % Write header information to the file.
        fprintf(fid,'TITLE: %s  Year Start: %d, End: %d. \n',...
            handles.analTitle,handles.WY1,handles.WYn);
        % Regression method
        if get(handles.olsRB,'Value')
            RegMeth = 'OLS';
        else
            RegMeth = 'Robust';
        end
        % Regression span
        if strcmp(handles.RegSpan,'poaRB')
            RegSpan = 'Period of Analysis';
        else
            RegSpan = 'Annual';
        end
        fprintf(fid,'Regression Span: %s, Method: %s.  Alpha: pEnter: %6.4f, pRemove: %5.4f.\n',...
            RegSpan,RegMeth,pEnter,pRemove);
        [Nr,~] = size(xVarTableData);
        fprintf(fid,['X Variable Names: ',...
            repmat(' %s',1,Nr),'. \n'],...
            xVarTableData{:,1});
        fprintf(fid,'Month [Indicator for xVar] N  RMSE F-Stat p-value  r2\n');
        for im = 1:12,
            fprintf(fid,[' %s [',repmat('%2u',1,Nr),' ] %4u %6.4f %5.1f %10.4g %6.4f\n'],...
                MoName{im},stepResults{im,:});
        end
        fprintf(fid,'logFile: %s, HUC-Output Dir: %s.\n',...
            get(handles.logFileET,'String'),get(handles.HUCnameET,'String'));
        fprintf(fid,'SELECTED HUCs: ');
        huclist = get(handles.hucPUMenu,'String');
        for ip=1:length(huclist), fprintf(fid,'%s ',huclist{ip}); end;
        fprintf(fid,'\n');
        % Analyst = get(handles.analystET,'String');
        fprintf(fid,'Analyst: %s. Rundate: %s. \n',...
            get(handles.analystET,'String'),datestr(now()));
        %
        % flowFLsumWua is the Water use adjusted flow
        flowFLsumWua          = squeeze(flowFLsumCon(iy,:,1:12));

        [~,ia,ib]             = intersect(hseqComID,ComID_WU);
        flowFLsumWua(ia,1:12) = squeeze(flowFLsumCon(iy,ia,1:12)) - WUseWY(ib,1:12);  
        % Write column identifiers in second line:
        fprintf(fid,'ComID,QAccConOct,QAccConNov,QAccConDec,QAccConJan,QAccConFeb,');
        fprintf(fid,['QAccConMar,QAccConApr,QAccConMay,QAccConJun,QAccConJul,',...
            'QAccConAug,QAccConSep,QAccWuaOct,QAccWuaNov,QAccWuaDec,QAccWuaJan,',...
            'QAccWuaFeb,QAccWuaMar,QAccWuaApr,QAccWuaMay,QAccWuaJun,QAccWuaJul,',...
            'QAccWuaAug,QAccWuaSep\n']);
        %
        fprintf(1,'Writing accumulated flows for water year %u.\n',WY);
        Nx = length(hseqComID);
        for ix=1:Nx,
            for iv=1:12
                if flowFLsumCon(iy,ix,iv)<0
                    fprintf(1, 'negative value at %u \n', flowFLsumCon(iy,ix,iv));
                end
            end
            fprintf(fid,['%u',repmat(',%f',1,24),'\n'],...
                hseqComID(ix),squeeze(flowFLsumCon(iy,ix,1:12)),...
                flowFLsumWua(ix,1:12));
        end
        fclose(fid);
        case 'Do Not Overwrite'
           warndlg('Existing output files were not overwritten.','No Output Written');
           annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
             'Position',[428,20,215*(iy)/handles.Ny,25]);
           set(handles.progressBarST,'String','Did not write accumulated flows.');
           fprintf(1, 'Did not write accumulated flows.\n');
           return
        end
    end
end
fprintf(1,'Done writing accumulated flows.\n');
annotation('rectangle','Units','pixels','FaceColor',[.831 .816 .784],...
    'Position',[428,20,215,25]);
set(handles.progressBarST,'String','Done writing accumulated flows.');

% --- Executes on button press in inOutDirPB.
function inOutDirPB_Callback(hObject, eventdata, handles)
% hObject    handle to inOutDirPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAFinchGUI    = getappdata(0, 'hAFinchGUI');
handles.ioDir = uigetdir('..','AFINCH study area directory');
set(handles.ioDirST,'String',handles.ioDir);
setappdata(hAFinchGUI,'ioDir',handles.ioDir);
setappdata(hAFinchGUI,'THS',handles.ioDir(max(strfind(handles.ioDir,'\'))+1:end));
set(handles.frameworkPanel,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.selectHucPB,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.locationPanel,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.periodPanel,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.hucPUMenu,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.startWyST,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.startWyET,'BackgroundColor',[1 1 1 ]);
set(handles.endWyST,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.endWyET,'BackgroundColor',[1 1 1 ]);
set(handles.HUCnameST,'BackgroundColor',[0.83 0.82 0.78]);
set(handles.HUCnameET,'BackgroundColor',[1 1 1 ]);
guidata(hObject,handles);
%
% --- Executes during object creation, after setting all properties.
function ioDirST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ioDirST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
