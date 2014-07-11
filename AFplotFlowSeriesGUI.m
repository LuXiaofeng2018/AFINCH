function varargout = AFplotFlowSeriesGUI(varargin)
% AFPLOTFLOWSERIESGUI MATLAB code for AFplotFlowSeriesGUI.fig
%      AFPLOTFLOWSERIESGUI, by itself, creates a new AFPLOTFLOWSERIESGUI or raises the existing
%      singleton*.
%
%      H = AFPLOTFLOWSERIESGUI returns the handle to a new AFPLOTFLOWSERIESGUI or the handle to
%      the existing singleton*.
%
%      AFPLOTFLOWSERIESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFPLOTFLOWSERIESGUI.M with the given input arguments.
%
%      AFPLOTFLOWSERIESGUI('Property','Value',...) creates a new AFPLOTFLOWSERIESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AFplotFlowSeriesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AFplotFlowSeriesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AFplotFlowSeriesGUI

% Last Modified by GUIDE v2.5 25-Apr-2012 14:27:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AFplotFlowSeriesGUI_OpeningFcn, ...
    'gui_OutputFcn',  @AFplotFlowSeriesGUI_OutputFcn, ...
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
% global WY1 WYn nYr HSR AFstruct StaHist


% --- Executes just before AFplotFlowSeriesGUI is made visible.
function AFplotFlowSeriesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AFplotFlowSeriesGUI (see VARARGIN)
% global WY1 WYn nYr HSR StaHist
% Choose default command line output for AFplotFlowSeriesGUI
handles.output = hObject;

hAFinchGUI           = getappdata(0,'hAFinchGUI');
handles.flowFLsumCon = getappdata(hAFinchGUI,'flowFLsumCon');
handles.Station      = getappdata(hAFinchGUI,'Station');
handles.ComIdGage    = getappdata(hAFinchGUI,'ComIdGage');
handles.tagTrend     = 'noTrendRB';
handles.thresP       = 0.01; 
handles.WY1          = getappdata(hAFinchGUI,'WY1');
handles.WYn          = getappdata(hAFinchGUI,'WYn');
years                = handles.WY1:handles.WYn; 
nYr                  = handles.WYn - handles.WY1 + 1;
handles.ioDir        = getappdata(hAFinchGUI,'ioDir');
handles.Station      = getappdata(hAFinchGUI,'Station');
handles.ComIdGage    = getappdata(hAFinchGUI,'ComIdGage');
% handles.plotType     = 'estFlowRB';
% Create cell array of years
for i = 1:nYr
    handles.wySeq(i) = {num2str(years(i))};
end
%
% guidata(hObject,handles);
%
handles.wySel      = 1;
handles.stationNdx = [];
handles.fullpath   = [handles.ioDir,'\Output\FlowSeries\'];
if exist(handles.fullpath,'dir')~=7
    mkdir(handles.fullpath);
end
set(handles.OutputPathST,'String',handles.fullpath);

handles.outFilename = get(handles.ComIdET,'String');
set(handles.OutputFileET,'String',['C',handles.outFilename,'Series.dat']);
titlePlot(handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AFplotFlowSeriesGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = AFplotFlowSeriesGUI_OutputFcn(hObject, eventdata, handles)
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
hAFinchGUI  = getappdata(0,'hAFinchGUI');
ComIdGage   = getappdata(hAFinchGUI,'ComIdGage');
ndx = get(hObject,'Value');
set(handles.ComIdET,'String',num2str(ComIdGage(ndx),'%u'));
set(handles.OutputFileET,'String',['C',num2str(ComIdGage(ndx)),'Series.dat']);
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
% --- Executes on button press in explainPB.
function explainPB_Callback(hObject, eventdata, handles)
% hObject    handle to explainPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function explainPB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to explainPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
explainIcon = imread('dAreaFlowExplain.jpg','jpg');
set(hObject,'CData',explainIcon);
%

function ComIdET_Callback(hObject, eventdata, handles)
% hObject    handle to ComIdET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ComIdET as text
%        str2double(get(hObject,'String')) returns contents of ComIdET as a double
comId = get(hObject,'String');
set(handles.OutputFileET,'String',['C',comId,'Series.dat']);

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
hseqComID    = getappdata(hAFinchGUI,'hseqComID');
WY1          = getappdata(hAFinchGUI,'WY1');
WYn          = getappdata(hAFinchGUI,'WYn');
StaHist      = getappdata(hAFinchGUI,'StaHist');
AFstruct     = getappdata(hAFinchGUI,'AFstruct');
HRStation    = getappdata(hAFinchGUI,'HRStation');
HRComID      = getappdata(hAFinchGUI,'HRComID');
HSR          = getappdata(hAFinchGUI,'HSR');
ComIdPlot    = str2num(get(handles.ComIdET,'String'));
plotNdx      = find(hseqComID==ComIdPlot);
[Ny,~]       = size(AFstruct.(HSR));
%
%% Plot times series of computed flows
if ~isempty(plotNdx)
    for im = 1:12,
        h = eval(sprintf('handles.PlotAx%02u',im));
        axes(h);
        plot(WY1+(1:Ny)-1,sqrt(flowFLsumCon(1:Ny,plotNdx,im)),'r+','MarkerSize',5);
        hold on
        % Overplot cumulative flows at streamgages if they exist
        ndx = find([AFstruct.(HSR)(1,:).ComIdGage]==ComIdPlot);
        if ~isempty(ndx)
            % This sets up the matrix but if there are missing I don't know which
            t = NaN(Ny,1); qmMat = NaN(Ny,12); k = 0;
            for iy=1:Ny,
                if ~isempty(AFstruct.(HSR)(iy,ndx).QTotWY)
                    k    = k + 1;
                    t(k) = iy;
                    qmMat(k,1:12) = [AFstruct.(HSR)(iy,ndx).QTotWY];
                end
            end
            % qmMat = reshape([AFstruct.HR04(:,ndx).QTotWY],12,[])';
            plot(WY1+t-1,sqrt(qmMat(:,im)),'bo','MarkerSize',5);
        end
        % Plot trend line if requested
        switch handles.tagTrend
            case 'noTrendRB'
                hold off
            case 'linearTrendRB'
                [tau, pval, intcpt, med_slope, med_data, med_time time yhat] = ...
                    AFKenSen([WY1+(1:Ny)-1]',[sqrt(flowFLsumCon(1:Ny,plotNdx,im))]);
                if pval > handles.thresP
                    plot([WY1,WYn],[med_data, med_data],'Color',[0.5 0.5 0.5],...
                        'LineStyle',':');
                else
                    % Plot the linear trend throught the square roots of flow
                    plot([WY1,WYn],[intcpt+WY1*med_slope, intcpt+WYn*med_slope],'r-');
                end
        end
        % Label y-axis as needed
        if ismember(im,[1 5 9])
            set(get(gca,'YLabel'),'String',...
                {'Square root of total flow,';'in cubic feet per second'});
        end
        % Label x-axis as needed
        if ismember(im,[9 10 11 12])
            set(get(gca,'XLabel'),'String','Water Year');
        end
        % End month loop
        hold off
    end
    %
else
    errordlg('A match for the specified ComID was not found in the study area.',...
        'No match for ComID');
end
set(get(gca,'XLabel'),'String','Water Year');
handles.flowFLsumCon = flowFLsumCon;
handles.plotNdx      = plotNdx; 
guidata(hObject,handles);
%
% --- Executes when selected object is changed in trendTypeBG.
function trendTypeBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in trendTypeBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.tagTrend = get(eventdata.NewValue,'Tag');
fprintf(1,'Tag of selected trend is %s\n',handles.tagTrend);
guidata(hObject,handles);

        


% --- Executes when selected object is changed in significanceBG.
function significanceBG_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in significanceBG 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
stringP = get(eventdata.NewValue,'String');
k = strfind(stringP,'%');
handles.thresP = str2double(stringP(1:k-1))/100;
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

% --- Executes during object creation, after setting all properties.
function OutputPathST_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputPathST (see GCBO)
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
path     = get(handles.OutputPathST,'String');
file     = get(handles.OutputFileET,'String');
pathfile = fullfile(path,file);
fid      = fopen(pathfile,'wt');
years    = handles.WY1:handles.WYn; 
nYr      = handles.WYn - handles.WY1 + 1;
fprintf(1  ,'Year\tOct\tNov\tDec\tJan\tFeb\tMar\tApr\tMay\tJune\tJuly\tAug\tSep\n');
fprintf(fid,'Year\tOct\tNov\tDec\tJan\tFeb\tMar\tApr\tMay\tJune\tJuly\tAug\tSep\n');
%
for i=1:nYr,
    fprintf(1  ,['%4u\t ',repmat('%9.2f\t',1,12),'\n'],...
        years(i),handles.flowFLsumCon(i,handles.plotNdx,1:12));
    fprintf(fid,['%4u\t ',repmat('%9.2f\t',1,12),'\n'],...
        years(i),handles.flowFLsumCon(i,handles.plotNdx,1:12));
end
fclose(fid);
