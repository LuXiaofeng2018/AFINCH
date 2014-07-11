function varargout = AFxVarShapeGUI(varargin)
% AFXVARSHAPEGUI MATLAB code for AFxVarShapeGUI.fig
%      AFXVARSHAPEGUI, by itself, creates a new AFXVARSHAPEGUI or raises the existing
%      singleton*.
%
%      H = AFXVARSHAPEGUI returns the handle to a new AFXVARSHAPEGUI or the handle to
%      the existing singleton*.
%
%      AFXVARSHAPEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFXVARSHAPEGUI.M with the given input arguments.
%
%      AFXVARSHAPEGUI('Property','Value',...) creates a new AFXVARSHAPEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFxVarShapeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFxVarShapeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFxVarShapeGUI

% Last Modified by GUIDE v2.5 03-Feb-2012 10:30:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AFxVarShapeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AFxVarShapeGUI_OutputFcn, ...
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


% --- Executes just before AFxVarShapeGUI is made visible.
function AFxVarShapeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFxVarShapeGUI (see VARARGIN)

% Choose default command line output for AFxVarShapeGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFxVarShapeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = AFxVarShapeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
handles.xVarNum  = 0;
guidata(hObject,handles);
%
% --- Executes on button press in BrowseShapefilePB.
function BrowseShapefilePB_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseShapefilePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
ioDir = getappdata(hAFinchGUI,'ioDir');
%
set(handles.readStatusST,'String','Reading shapefile...');
[shapein,pathname]=uigetfile('*.shp','SELECT SHAPEFILE',...
    [ioDir,'\GIS\']);
% Display filename in ST field so that it seems something is going on.
set(handles.UserShapefileST,'String',[pathname,shapein]);
% refreshdata(handles.readStatusST);
% Read in the shapefile
handles.IND=shaperead([pathname,shapein]);
set(handles.readStatusST,'String','Shapefile read.');
%
handles.attrList=fieldnames(handles.IND);
set(handles.ShapefileRecordCntST,'String',num2str(length(handles.IND)));
set(handles.ShapefileFieldCntST,'String',num2str(length(handles.attrList)));
set(handles.ShapefileFieldLB,'String',handles.attrList);
gridcodeNdx  = find(strcmpi('GRIDCODE',handles.attrList));
if ~isempty(gridcodeNdx)
    gridcodeName = handles.attrList{gridcodeNdx};
    set(handles.ShapefileFieldLB,'Value',gridcodeNdx);
    set(handles.GridcodeFieldST,'String',gridcodeName);
    set(handles.CreateExplanatoryVariablePanel,...
        'BackgroundColor',[0.83 0.82 0.78]);
    set(handles.AddVariablePB,'BackgroundColor',[0.831 0.816 0.784]);
end
guidata(hObject,handles);

% --- Executes on selection change in ShapefileFieldLB.
function ShapefileFieldLB_Callback(hObject, eventdata, handles)
% hObject    handle to ShapefileFieldLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.GridcodeValue = get(hObject,'Value');
set(handles.GridcodeFieldST,'String',handles.attrList(handles.GridcodeValue));
% Hints: contents = cellstr(get(hObject,'String')) returns ShapefileFieldLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ShapefileFieldLB


% --- Executes during object creation, after setting all properties.
function ShapefileFieldLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShapefileFieldLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddVariablePB.
function AddVariablePB_Callback(hObject, eventdata, handles)
% Setup hAFinchGUI link
hAFinchGUI = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
HSR            = getappdata(hAFinchGUI,'HSR');
AFstruct       = getappdata(hAFinchGUI,'AFstruct');
xShapeMatrix   = getappdata(hAFinchGUI,'xShapeMatrix');
RegVarNameList = getappdata(hAFinchGUI,'RegVarNameList');
xVarTableData  = getappdata(hAFinchGUI,'xVarTableData');
Xarr           = getappdata(hAFinchGUI,'Xarr');
xVar           = getappdata(hAFinchGUI,'xVar');
ExpVarNo       = getappdata(hAFinchGUI,'ExpVarNo');
%
% Get the field name assigned by the user (guessed by the program)
gridcodeName = get(handles.GridcodeFieldST,'String');
[gridcodeSphCell{1:length(handles.IND),1}] = eval(['handles.IND.',gridcodeName]);
 gridcodeShp         = cell2mat(gridcodeSphCell);
 
 % hObject    handle to AddVariablePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xVarNum = handles.xVarNum + 1;
% Create a cell array xVarAttrData if one does not exist
if handles.xVarNum == 1
    handles.xVarAttrData = cell(1,4);
end
guidata(hObject,handles);
% Select attributes for explanatory variable
promptstring={'Multiple attributes will be added for xVar.'};
[selectList,ok]=listdlg('ListString',handles.attrList,...
    'ListSize',[200 300],...
    'SelectionMode','multiple',...
    'Name','Select Variables',...
    'PromptString',promptstring);
if ok
    ExpVarNo = ExpVarNo + 1;
    fprintf(1,'ExpVarNo = %u.\n',ExpVarNo);
    % Indices of selected attributes
    attrNdx  = selectList;
    % Number of selected attributes used to form a variable
    attrNum  = length(attrNdx);
    % Default name of variables
    handles.xVarName = [handles.attrList(attrNdx)];
    % Allocate memory for variables
    xMat = NaN(length(handles.IND),attrNum);
    % Check that the variables are numeric

    for ivar = 1:attrNum
        [xVecCell{1:length(handles.IND),1}] = ...
            eval(['handles.IND.',handles.xVarName{ivar}]);
        if strcmp(class([xVecCell{1:end}]),'double')
            fprintf(1,'Variable %u (%s) is numeric.\n',...
                ivar,handles.attrList{attrNdx(ivar)}');
            % Add column to explanatory matrix
            xMat(:,ivar) = [xVecCell{1:length(handles.IND),1}]';
        else
            fprintf(1,'xVec is not numeric.  Stopping.\n');
            return
        end
    end
    % Concatenate variable names to one. 
    xVarName = [handles.attrList{attrNdx}];
    fprintf(1,'Explanatory variable is named %s.\n',xVarName);
    % Sum selected attributes across columns
    xVec = sum(xMat,2);
    xVar(ExpVarNo).name     = xVarName;
    xVar(ExpVarNo).type     = 'shapefile';
    xVar(ExpVarNo).value    = xVec;
    xVar(ExpVarNo).gridcode = gridcodeShp;
    xVar(ExpVarNo).vec      = [];
    setappdata(hAFinchGUI,'xVar',xVar);
    drawnow
    % 
else
    fprintf(1,'No attributes selected.  Returning.\n');
    return
end
%
[yrs,sta] = size(eval(['AFstruct.',HSR]));
% Allocate matrix to contain variable
eval([xVarName,' = NaN(',num2str(yrs),',',num2str(sta),');']);
for iyrs=1:yrs
    for jsta=1:sta
        if ~isempty(eval(['AFstruct.',HSR,'(iyrs,jsta).SBGridCode']));
            gridcodeStaYr = eval(['AFstruct.',HSR,'(iyrs,jsta).SBGridCode']);
            sbAreaSqKm    = eval(['AFstruct.',HSR,'(iyrs,jsta).SBAreaSqKm']);
            [~,gridcodeShpNdx,gridcodeStaYrNdx] = ...
                intersect(gridcodeShp,gridcodeStaYr);
            % This is where the area-weighted value is computed for each station-year
            wtxVec = sum(xVec(gridcodeShpNdx).*sbAreaSqKm(gridcodeStaYrNdx))./...
                sum(sbAreaSqKm(gridcodeStaYrNdx));
            % Now store the result in the appropriate matrix
            eval([xVarName,'(',num2str(iyrs),',',num2str(jsta),') = wtxVec;']);
%             fprintf(1,' %4u  %4u  %8.5f \n',iyrs,jsta,...
%                 eval([xVarName,'(',num2str(iyrs),',',num2str(jsta),')']));
            eval(['AFstruct.',HSR,'(iyrs,jsta).',xVarName,' = ',xVarName,'(iyrs,jsta);']);
        else
            eval(['AFstruct.',HSR,'(iyrs,jsta).',xVarName,' = [];']);
        end
        
    end
end
% fprintf(1,'Stopping.\n');
% Update Data in xVarAttrTable
handles.xVarAttrData(handles.xVarNum,1) = cellstr(xVarName);
RegVarNameList{ExpVarNo}  = xVarName;
xVarTableData{ExpVarNo,1} = xVarName;
xVarTableData{ExpVarNo,2} = false;
%
% Compute summary statistics
k = 0; xvec = NaN(yrs*sta,1);
for iyrs=1:yrs
    for jsta=1:sta
        xvar = eval(['AFstruct.',HSR,'(',num2str(iyrs),',',num2str(jsta),').',xVarName]);
        if ~isempty(xvar);
            k = k + 1;
            xvec(k) = xvar;
        end
    end
end
xvec = xvec(~isnan(xvec));
Xarr(:,ExpVarNo,1:12)   = repmat(xvec,1,12);
handles.xVarAttrData(handles.xVarNum,2) = num2cell(min(xvec));    % Min
handles.xVarAttrData(handles.xVarNum,3) = num2cell(mean(xvec));   % Mean
handles.xVarAttrData(handles.xVarNum,4) = num2cell(max(xvec));    % Max
handles.xVarAttrData(handles.xVarNum,5) = num2cell(length(xvec)); % Length
%
% Update table data
set(handles.xVarAttrTable,'Data',handles.xVarAttrData);
% Append vector to xVarMatrix
if handles.xVarNum == 1
    handles.xVarMatrix = xvec;
else
    handles.xVarMatrix = [handles.xVarMatrix,xvec];
end
%
% Increment the number of explanatory variables
% Update hAFinchGUI workspace
setappdata(hAFinchGUI,'RegVarNameList',RegVarNameList);
setappdata(hAFinchGUI,'ExpVarNo',ExpVarNo');
% setappdata(hAFinchGUI,'xVarName',xVarName');
setappdata(hAFinchGUI,'xVarAttrData',handles.xVarAttrData);
setappdata(hAFinchGUI,'AFstruct',AFstruct);
setappdata(hAFinchGUI,'xVarMatrix',handles.xVarMatrix);
setappdata(hAFinchGUI,'xVarTableData',xVarTableData);
setappdata(hAFinchGUI,'Xarr',Xarr);
guidata(hObject,handles);

% --- Executes when entered data in editable cell(s) in xVarAttrTable.
function xVarAttrTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to xVarAttrTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ReturnPB.
function ReturnPB_Callback(hObject, eventdata, handles)
% hObject    handle to ReturnPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Setup hAFinchGUI link
hAFinchGUI     = getappdata(0,'hAFinchGUI');
% Define local variables from hAFinchGUI workspace
% RegVarNameList = getappdata(hAFinchGUI,'RegVarNameList');
ExpVarNo       = getappdata(hAFinchGUI,'ExpVarNo');
xVarTableData  = getappdata(hAFinchGUI,'xVarTableData');
% 
fprintf(1,'At Return pushbutton in AFxVarShapeGUI.\n');
xVarAttrData = get(handles.xVarAttrTable,'Data');
% Number of new variables from Shapefile
[RowShapeVar,~] = size(xVarAttrData);
% Indices of new shape variables
 NewShapeVarNdx = (ExpVarNo-RowShapeVar+1):ExpVarNo;
% Update local variable with new xVar names
 xVarTableData(NewShapeVarNdx,1) = xVarAttrData(:,1);
% Update hAFinchGUI workspace with niew xVarTableData
setappdata(hAFinchGUI,'xVarTableData',xVarTableData);
%
guidata(hObject,handles);
delete(gcf);

