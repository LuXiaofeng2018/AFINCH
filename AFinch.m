%% AFinch: Analysis of Flows in Networks of Channels
% AFinch is a product of the USGS National Water Availability 
% and Use Program: Great Lakes Pilot.
%
% The following pragma references scripts used in AFinch for the compiler
%
% AFinch integrates monthly streamflow data at streamgages, monthly water 
%   use data, monthly precipitation and climatic data, and land cover
%   characteristics to estimate monthly flows at NHDPlus flowlines and
%   water yields in catchments within four-digit hydrologic units.
%   David J. Holtschlag, USGS Michigan Water Science Center
%% Startup AFinch Application
clear; clear global; clc
%
% Determine if AFinch is initiated in the appropriate directory.
dir = eval('pwd');
StrtCol = strfind(upper(dir),upper('AFinch\AWork'));
if isempty(StrtCol)
   % If the directory is not appropriate, notify user and end AFinch.   
%    errordlg('AFinch was not initiated in the ...\AFinch\AWork subdirectory.',...
%        'AFinch Code Not Found.');
   % If the directory is not AFinch\AWork, prompt user for the directory.
   dir = uigetdir(dir,'Select AFinch\AWork Directory to Initiate AFinch Analysis');
   cd(dir);
   fprintf('Changed current directory to %s \n',dir);
   % return
end
%
clearvars dir StrtCol
%% Run the AFinch GUI
AFinchGUI3a;
fprintf(1,'AFinch\n');

