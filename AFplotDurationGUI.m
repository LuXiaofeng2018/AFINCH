function varargout = AFplotDurationGUI(varargin)
% AFPLOTDURATIONGUI MATLAB code for AFplotDurationGUI.fig
%      AFPLOTDURATIONGUI, by itself, creates a new AFPLOTDURATIONGUI or raises the existing
%      singleton*.
%
%      H = AFPLOTDURATIONGUI returns the handle to a new AFPLOTDURATIONGUI or the handle to
%      the existing singleton*.
%
%      AFPLOTDURATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFPLOTDURATIONGUI.M with the given input arguments.
%
%      AFPLOTDURATIONGUI('Property','Value',...) creates a new AFPLOTDURATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFplotDurationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFplotDurationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFplotDurationGUI

% Last Modified by GUIDE v2.5 25-Apr-2012 17:04:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AFplotDurationGUI_OpeningFcn, ...
    'gui_OutputFcn',  @AFplotDurationGUI_OutputFcn, ...
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

% --- Executes just before AFplotDurationGUI is made visible.
function AFplotDurationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFplotDurationGUI (see VARARGIN)
% global WY1 WYn nYr HSR StaHist
% Choose default command line output for AFplotDurationGUI
handles.output = hObject;
%
hAFinchGUI           = getappdata(0,'hAFinchGUI');
handles.flowFLsumCon = getappdata(hAFinchGUI,'flowFLsumCon');
handles.Station      = getappdata(hAFinchGUI,'Station');
handles.ComIdGage    = getappdata(hAFinchGUI,'ComIdGage');
handles.StaHist      = getappdata(hAFinchGUI,'StaHist');
handles.HSR          = getappdata(hAFinchGUI,'HSR');
handles.WY1          = getappdata(hAFinchGUI,'WY1');
handles.WYn          = getappdata(hAFinchGUI,'WYn');
years                = handles.WY1:handles.WYn; 
nYr                  = handles.WYn - handles.WY1 + 1;
handles.ioDir        = getappdata(hAFinchGUI,'ioDir');
% handles.plotType     = 'estFlowRB';
% Create cell array of years
for i = 1:nYr
    handles.wySeq(i) = {num2str(years(i))};
end
% Load and plot the explanation
%
guidata(hObject,handles);
%
handles.wySel  = 1;
handles.stationNdx = [];
handles.fullpath   = [handles.ioDir,'\Output\Duration\'];
if exist(handles.fullpath,'dir')~=7
    mkdir(handles.fullpath);
end
set(handles.OutputPathST,'String',handles.fullpath);

handles.outFilename = get(handles.ComIdET,'String');
set(handles.OutputFileET,'String',['C',handles.outFilename,'Duration.dat']);

titlePlot(handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFplotDurationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = AFplotDurationGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in stationPickLB.
function stationPickLB_Callback(hObject, eventdata, handles)
% hObject    handle to stationPickLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stationPickLB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stationPickLB
handles.stationNdx = get(hObject,'Value');
handles.stationLst = cellstr(get(hObject,'String'));
%
hAFinchGUI = getappdata(0,'hAFinchGUI');
ComIdGage   = getappdata(hAFinchGUI,'ComIdGage');
ndx = get(hObject,'Value');
set(handles.ComIdET,'String',num2str(ComIdGage(ndx),'%u'));
set(handles.OutputFileET,'String',['C',num2str(ComIdGage(ndx)),'Duration.dat']);
titlePlot(handles)
guidata(hObject,handles);
%
% --- Executes during object creation, after setting all properties.
function stationPickLB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stationPickLB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%
hAFinchGUI   = getappdata(0,'hAFinchGUI');
Station      = getappdata(hAFinchGUI,'Station');
set(hObject,'String',Station);
guidata(hObject,handles);

%
function titlePlot(handles)
%% Title and plot drainage areas and flows
set(handles.octTitleST,'String','October ');
set(handles.novTitleST,'String','November ');
set(handles.decTitleST,'String','December ');
set(handles.janTitleST,'String','January ');
set(handles.febTitleST,'String','February ');
set(handles.marTitleST,'String','March ');
set(handles.aprTitleST,'String','April ');
set(handles.mayTitleST,'String','May ');
set(handles.junTitleST,'String','June ');
set(handles.julTitleST,'String','July ');
set(handles.augTitleST,'String','August ');
set(handles.sepTitleST,'String','September ');
% 

function ComIdET_Callback(hObject, eventdata, handles)
% hObject    handle to ComIdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ComIdET as text
%        str2double(get(hObject,'String')) returns contents of ComIdET as a double
comId = get(hObject,'String');
set(handles.OutputFileET,'String',['C',comId,'Duration.dat']);


% --- Executes during object creation, after setting all properties.
function ComIdET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComIdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% 
hAFinchGUI   = getappdata(0,'hAFinchGUI');
ComIdGage    = getappdata(hAFinchGUI,'ComIdGage');
Station      = getappdata(hAFinchGUI,'Station');
set(hObject,'String',num2str(ComIdGage(1),'%u'));
%
guidata(hObject,handles);

% --- Executes on button press in plotTimeSeriesPB.
function plotTimeSeriesPB_Callback(hObject, eventdata, handles)
% hObject    handle to plotTimeSeriesPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hAFinchGUI   = getappdata(0,'hAFinchGUI');
flowFLsumCon = getappdata(hAFinchGUI,'flowFLsumCon');
AFstruct     = getappdata(hAFinchGUI,'AFstruct');
hseqComID    = getappdata(hAFinchGUI,'hseqComID');
WY1          = getappdata(hAFinchGUI,'WY1');
AFstruct     = getappdata(hAFinchGUI,'AFstruct');
HSR            = getappdata(hAFinchGUI,'HSR');
ComIdPlot    = str2double(get(handles.ComIdET,'String'));
ComIdNdx     = find(hseqComID==ComIdPlot);
[nYr,~]      = size(AFstruct.(HSR));
ranks        = NaN(nYr,12);
probs        = NaN(nYr,12);
nrminv       = NaN(nYr,12);
qmMat        = NaN(nYr,12); 
%            
if ~isempty(ComIdNdx)
    for im = 1:12
        h = eval(sprintf('handles.PlotAx%02u',im));
        axes(h);
        %
        ranks(:,im) = nYr + 1 - tiedrank(flowFLsumCon(:,ComIdNdx,im));
        % Cunnane (1978) plotting position (p)
        % Helsel, D.R., and Hirsch, R.M., 2002, Statistical Methods in
        % Water Resources (Chapter A3), Book 4, Hydrologic Analysis and
        % Interpretation: Techniques of Water-Resources Investigations of
        % the United States Geological Survey, p. 23, i is the rank and
        % Ny is the number of observations.
        % p = (i - 0.4) / (Ny + 0.2)
        % Estimate probability from ranks
        probs(:,im)  = (ranks(:,im) - 0.4) ./ (         nYr  + 0.2);
        nrminv(:,im) = norminv(probs(:,im),0,1);
        %
        % Plot estimated values in red
        plot(nrminv(:,im),sqrt(flowFLsumCon(:,ComIdNdx,im)),...
            'r+','MarkerSize',4);
        set(gca,...
            'XTick',[-2.326,-1.6449,-1.282,-0.674,0,...
            0.674,1.282,1.6449,2.326],...
            'XTickLabel',{'1','5','10','25','50','75','90','95','99'},...
            'FontSize',8,'XLim',[-2.5 2.5],...
            'YLim',[floor(sqrt(min(flowFLsumCon(:,ComIdNdx,im)))) ,...
            ceil(sqrt(max(flowFLsumCon(:,ComIdNdx,im))))]);
        % Label x-axis for bottom row of plot
        if ismember(im,[9 10 11 12])
            xlabel({'Percentage of time indicated',...
                'flow was equalled or exceeded'});
        end
        % Label y-axis for left side plots
        if ismember(im,[1,5,9])
            ylabel({'Square root of flow,';'in cubic feet per second'});
        end
        %
        %% Overplot cumulative flows at streamgages if they exist
        ndx = find([AFstruct.(HSR)(1,:).ComIdGage]==ComIdPlot);
        % If following is true, streamgage existed on ComId at some time 
        % (maybe not POA).
        if ~isempty(ndx)
            hold on
            % This sets up the matrix but if there are missing I don't know which
            % t = NaN(Ny,1); 
            k = 0;
            for iy=1:nYr,
                k    = k + 1;
                try
                    qmMat(k,im) = AFstruct.(HSR)(iy,ndx).QTotWY(im);

                catch
                    qmMat(k,im) = NaN();
                end
            end
            % qmMat = reshape([AFstruct.HR04(:,ndx).QTotWY],12,[])';
            plot(nrminv(:,im),sqrt(qmMat(:,im)),'bo','MarkerSize',5);
        end
        hold off
%
    end
else
    errordlg('A match for the specified ComID was not found in the study area.',...
        'No match for ComID');
end
%
handles.probs    = probs;
handles.ComInNdx = ComIdNdx;
guidata(hObject,handles);

function OutputFileET_Callback(hObject, eventdata, handles)
% hObject    handle to OutputFileET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputFileET as text
%        str2double(get(hObject,'String')) returns contents of OutputFileET as a double


% --- Executes during object creation, after setting all properties.
function OutputFileET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputFileET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OutputSavePB.
function OutputSavePB_Callback(hObject, eventdata, handles)
% hObject    handle to OutputSavePB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hAFinchGUI   = getappdata(0,'hAFinchGUI');
flowFLsumCon = getappdata(hAFinchGUI,'flowFLsumCon');
path         = get(handles.OutputPathST,'String');
file         = get(handles.OutputFileET,'String');
pathfile     = fullfile(path,file);
fid          = fopen(pathfile,'wt');
nYr          = handles.WYn - handles.WY1 + 1;
wYear        = handles.WY1:handles.WYn;
probs        = handles.probs;
ComIdNdx     = handles.ComInNdx;
%
fprintf(1  ,'wYear\t pOct\tqOct\t pNov\tqNov\t pDec\t qDec\t pJan\tqJan\t pFeb\tqFeb\t pMar\tqMar\t ');
fprintf(1  ,'pApr\tqApr\t pMay\tqMay\t pJun\t qJun\t pJul\tqJul\t pAug\tqAug\t pSep\tqSep\n' );
fprintf(fid,'wYear\t pOct\tqOct\t pNov\tqNov\t pDec\t qDec\t pJan\tqJan\t pFeb\tqFeb\t pMar\tqMar\t ');
fprintf(fid,'pApr\tqApr\t pMay\tqMay\t pJun\t qJun\t pJul\tqJul\t pAug\tqAug\t pSep\tqSep\n' );
%
for i=1:nYr,
    intleave =  reshape([probs(i,:);squeeze(flowFLsumCon(i,ComIdNdx,1:12))'],[],1);
    fprintf(1  ,['%4u \t',repmat('%7.5f\t %8.2f\t',1,12 ),'\n'],wYear(i),intleave);
    fprintf(fid,['%4u \t',repmat('%7.5f\t %8.2f\t',1,12 ),'\n'],wYear(i),intleave);
end
fclose(fid);
