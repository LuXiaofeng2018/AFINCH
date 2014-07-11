%% AFReadNLCD.m
function AFReadNLCD
hAFinchGUI = getappdata(0,'hAFinchGUI');
huclist    = getappdata(hAFinchGUI,'huclist');
HSR        = getappdata(hAFinchGUI,'HSR');
% Read in region data sets
%
disp('<a href="matlab: junk=0;">AFReadNLCD</a>');
temp=char(huclist(1));
region=temp(1:2);
%
fprintf('\n AFReadNLCD: Reading NLCD data for hydrologic region %s.\n',HSR);
% Note: The "catchmentattributesnlcd.txt" file read below can be 
% created by adding the "NHDPlus##\catchmentattributesnlcd.dbf" 
% data file to an ArcMap session, where '##' is (generally) a two-
% digit code identifying Hydrologic Region number of interest. 
% Once the table is in ArcMap, it can be exported as a comma
% delimited text (txt) file. Leading commas in column 1 and the
% decimal and tailing zeros in the first two fields (ComID and 
% GridCode) must be eliminated before reading the data with
% format string below because these fields are read as integers (%u). 
[ComID_NLCD,GridCode_NLCD,NLCD11,NLCD12,NLCD21,NLCD22,...
    NLCD23,NLCD24,NLCD31,NLCD41,NLCD42,NLCD43,NLCD52,...
    NLCD71,NLCD81,NLCD82,NLCD90,NLCD95,AreaSqKm_NLCD]=...
    textread(['..\',HSR,'\NLCD\CatchmentNLCDArea.csv'],...
    ['%u%u',repmat('%f',1,17)],...
    'delimiter',',','headerlines',1); 
AreaSqMi_NLCD = AreaSqKm_NLCD / 2.59;   % Unit conversion
%
%% Determine the number of records in the NLCD dataset
nComID_NLCD = length(ComID_NLCD); nGridCode_NLCD = length(GridCode_NLCD);
fprintf(1,['There are %u unique catchments defined in the 1992 NLCD ',...
    'for hydrologic region %s.\n'],nGridCode_NLCD,region);
% Read the nhdflowline data for the region.
fprintf('\n Reading the nhdflowline data for the region.\n');
originalFmt = getappdata(hAFinchGUI,'originalFmt');
if originalFmt==1
    % Note: The "nhdflowline.txt" file read below can be 
    % created by adding the "NHDPlus##\Hydrography\nhdflowline.shp 
    % shape file to an ArcMap session.  Once the attribute table associated 
    % with the shape file is opened in ArcMap, fields other than "COMID", 
    % "LENGTHKM", AND "REACHCODE" can be turned off to prevent their 
    % display and export. The selected fields can then be exported 
    % by selecting the appropriate options for exporting a text file
    % within the table view of ArcMap. The double quotes around the 
    % REACHCODE should be deleted before reading the file into MATLAB
    % with the command below. 
    %
    % Read in ComID,LengthKm,ReachCode for Hydrologic Region
    [ComID_NHD, LengthKm, ReachCode] = textread(...
        ['..\',HSR,'\Flowlines\nhdflowline.csv'],...
        '%u %f %s','delimiter',',','headerlines',1);
    %
    % Determine the number of NHD flowlines in the hydrologic region
    nComID_NHD = length(ComID_NHD);
    fprintf(1,['There are %u unique flowlines defined in the nhdflowline file ',...
        'for hydrologic region %s.\n'],nComID_NHD,region);
else
    % read in flowlines from NHDflowline shapefile
    %prompt user for name of shapefile with desired data
    [shapein,pathname]=uigetfile('*.shp','Select NHDflowline shapefile');
    ffile=fullfile(pathname,shapein);
    NHD=shaperead(ffile);
    vtemp=[NHD.COMID];
    [~,idx]=sort(vtemp);
    ComID_NHD=[NHD(idx).COMID];
    LengthKm=[NHD(idx).LENGTHKM];
    ReachCode={NHD(idx).REACHCODE};
    nComID_NHD=length(ComID_NHD);
    fprintf(1,['There are %u unique flowlines defined in the nhdflowline file ',...
        '\n'],nComID_NHD);
    clear NHD;
end
%
%% Extract the specified subregional data and join data 
% 
% ind is a 0/1 indicator vector of the subregion in the ReachCode 
% Compare the first four characters of the reach code with the THS
% [ComID_NHD, LengthKm, ReachCode] were read from the same file.  
% ReachCode has the same length and index set as ComID_NHD
in4digit = getappdata(hAFinchGUI,'in4digit');
if in4digit==1
    chars=4;
else
    chars=8;
end
 sumind=zeros([length(ReachCode) 1]);
for i=1:length(huclist)
    ind = strncmp(ReachCode,char(huclist(i)),chars);
    sumind=sumind+ind;
end
% ndx is the subset of indices for the subregion in the regional data
ndx = sumind>=1;
% ComID and ReachCodes for the specified subregion
 ComID_NHDTHS =        ComID_NHD(ndx);
nComID_NHDTHS = length(ComID_NHDTHS);
% ReachCodeTHS  = ReachCode(ndx);
%
%% Intersect the nhdflowline and NLCD data sets
[~,ndxa,ndxb] = intersect(ComID_NHDTHS,ComID_NLCD);
% Sort both vectors by increasing ComID and get length.
 ComID_NHDTHS    =           ComID_NHDTHS(ndxa);
nComID_NHDTHS    =    length(ComID_NHDTHS);
 ComID_NLCDTHS   =           ComID_NLCD(ndxb);
nComID_NLCDTHS   =    length(ComID_NLCDTHS);

checkfile=fopen('check.txt','w');
fprintf(checkfile,'COMID\n');
for i=1:length(ComID_NHDTHS)
    fprintf(checkfile,'%d\n',ComID_NHDTHS(i));
end
fclose(checkfile);

%
 GridCode_NLCDTHS =        GridCode_NLCD(ndxb); 
nGridCode_NLCDTHS = length(GridCode_NLCDTHS);
NLCD11_THS = NLCD11(ndxb); NLCD12_THS = NLCD12(ndxb); NLCD21_THS = NLCD21(ndxb);
NLCD22_THS = NLCD22(ndxb); NLCD23_THS = NLCD23(ndxb); NLCD24_THS = NLCD24(ndxb); 
NLCD31_THS = NLCD31(ndxb); NLCD41_THS = NLCD41(ndxb); NLCD42_THS = NLCD42(ndxb); 
NLCD43_THS = NLCD43(ndxb); NLCD52_THS = NLCD52(ndxb); NLCD71_THS = NLCD71(ndxb); 
NLCD81_THS = NLCD81(ndxb); NLCD82_THS = NLCD82(ndxb); NLCD90_THS = NLCD90(ndxb); 
NLCD95_THS = NLCD95(ndxb);AreaSqMi_NLCDTHS = AreaSqMi_NLCD(ndxb);
%
NLCD_THS = [NLCD11_THS NLCD12_THS NLCD21_THS NLCD22_THS NLCD23_THS NLCD24_THS ...
            NLCD31_THS NLCD41_THS NLCD42_THS NLCD43_THS NLCD52_THS NLCD71_THS ...
            NLCD81_THS NLCD82_THS NLCD90_THS NLCD95_THS];
% Store results to GUI 
setappdata(hAFinchGUI,'NLCD_THS',NLCD_THS);
setappdata(hAFinchGUI,'GridCode_NLCDTHS',GridCode_NLCDTHS);
setappdata(hAFinchGUI,'nGridCode_NLCDTHS',nGridCode_NLCDTHS);
setappdata(hAFinchGUI,'AreaSqMi_NLCDTHS',AreaSqMi_NLCDTHS);
setappdata(hAFinchGUI,'ComID_NHDTHS',ComID_NHDTHS);
setappdata(hAFinchGUI,'nComID_NHDTHS',nComID_NHDTHS);
setappdata(hAFinchGUI,'NLCD_THS',NLCD_THS);
%
fprintf(1,'  Selected %u NLCD records from HSR%s.\n',...
    nComID_NLCDTHS,region);
