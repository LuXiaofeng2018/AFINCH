% GenPrismPrecip is a script file for generating water year precipitation
% for NHDPlus v. 2 catchments from two calendar-year data files.  Units are
% converted to English for consistency with AFINCH conventions.
fprintf(1,'Note: Raw precipitation files have been edited by: \n'); 
fprintf(1,'  (1) Deleting "NHDFlowline," field, \n');
fprintf(1,'  (2) Replacing the overflow area field code (*) with zero,\n');
fprintf(1,'  (3) Deleting rows at end of file containing the word "Sink".\n');
fprintf(1,'\nA read error will occur if this is not done prior execution.\n');
fprintf(1,'Raw data file are expected to have the root name: "nhd4_prism3_"\n');
%
% clear workspace variables
clear
froot = 'nhd4_prism3_';
WY    = inputdlg('Water Year of Data','Generate PRISM Precip');
% Convert input cell array to number
WY    = str2num(WY{1});
% Check if data files are present
fid0 = fopen([froot num2str(WY-1,'%u') '.csv'],'rt');
fid1 = fopen([froot num2str(WY  ,'%u') '.csv'],'rt');
if fid0 >0 && fid1 >0
    fprintf(1,'Raw data files found.  Continuing... \n');
    fclose(fid0); fclose(fid1);
else
    return
end
%
% Read in first data set
fprintf(1,'Reading in first data file ...\n');
[GridcodeP0,Count0,ComID0,AreaM20,p0Jan,p0Feb,p0Mar,p0Apr,p0May,p0Jun,...
    p0Jul,p0Aug,p0Sep,p0Oct,p0Nov,p0Dec,p0Ann] =...
    textread([froot num2str(WY-1,'%u') '.csv'],...
    ['%u %u %d %f ',repmat(' %f',1,13)],'delimiter',',');
% Read in second data set
fprintf(1,'Reading in second data file ...\n');
[GridcodeP1,Count1,ComID1,AreaM21,p1Jan,p1Feb,p1Mar,p1Apr,p1May,p1Jun,...
    p1Jul,p1Aug,p1Sep,p1Oct,p1Nov,p1Dec,p1Ann] =...
    textread([froot num2str(WY,'%u') '.csv'],...
    ['%u %u %d %f ',repmat(' %f',1,13)],'delimiter',',');
%
% If the following statement is true there is no need to match Gridcodes
tf = isequal(GridcodeP0,GridcodeP1);
%
if tf==1;
    CountKm2 = Count1*900/1e6; % Count is the number of 30 meter square pixels
    AreaKm2  = AreaM21   /1e6; % AreaM2 is area in square meters
    %
    NdxZero = find(AreaM21==0);
    AreaKm2(NdxZero) = CountKm2(NdxZero);
    mm_in     = 25.4;
    km2_mi2   = 0.386102;
    %
    GCAreaSqMi= AreaKm2 * km2_mi2 ;
    N         = length(GCAreaSqMi);
    PIn       = NaN(N,13);
    %
    PIn(:,01) = p0Oct / mm_in /100;
    PIn(:,02) = p0Nov / mm_in /100;
    PIn(:,03) = p0Dec / mm_in /100;
    PIn(:,04) = p1Jan / mm_in /100;
    PIn(:,05) = p1Feb / mm_in /100;
    PIn(:,06) = p1Mar / mm_in /100;
    PIn(:,07) = p1Apr / mm_in /100;
    PIn(:,08) = p1May / mm_in /100;
    PIn(:,09) = p1Jun / mm_in /100;
    PIn(:,10) = p1Jul / mm_in /100;
    PIn(:,11) = p1Aug / mm_in /100;
    PIn(:,12) = p1Sep / mm_in /100;
    
    %
    % Print out abbreviated results to command window.
    fprintf(1,'Average precipitation in inches by GridCode for WY %u.\n',WY);
    fprintf(1,[repmat('-',1,125),'\n']);
    fprintf(1,'GridCode   GCAreaSqMi    Oct     Nov     Dec     Jan     Feb     Mar     Apr     May     Jun     Jul     Aug     Sep     Ann \n');
    fprintf(1,[repmat('-',1,125),'\n']);
%    
    for i=1:10,
        fprintf(1,['%10u %9.4f ',repmat('%8.2f',1,13),'\n'],...
            GridcodeP1(i),GCAreaSqMi(i),PIn(i,1:12),sum(PIn(i,1:12)));
    end
    %
    % Print out full results to named file
    fid = fopen(['PrismPrecipWY',num2str(WY),'.dat'],'wt');
    fprintf(fid,'Average precipitation in inches by GridCode for WY %u.\n',WY);
    fprintf(fid,[repmat('-',1,125),'\n']);
    fprintf(fid,'GridCode   GCAreaSqMi    Oct     Nov     Dec     Jan     Feb     Mar     Apr     May     Jun     Jul     Aug     Sep     Ann \n');
    fprintf(fid,[repmat('-',1,125),'\n']);
%    
    for i=1:N,
        fprintf(fid,['%10u %9.4f ',repmat('%8.2f',1,13),'\n'],...
            GridcodeP1(i),GCAreaSqMi(i),PIn(i,1:12),sum(PIn(i,1:12)));
    end
%
    fclose(fid); % Close file containing output data.
    fprintf(1,'%s \n',...
        ['Precip file: PrismPrecipWY',num2str(WY),'.dat generated.']);
    % End if Gridcode match    
else
    fprintf(1,'Gridcodes did *NOT* match.  Precip file not generated.\n');
    beep();
end