function AFAreaWtXVar(iy)
hAFinchGUI       = getappdata(0,'hAFinchGUI');
AFstruct         = getappdata(hAFinchGUI,'AFstruct');
Ns               = getappdata(hAFinchGUI,'Ns');
GridCode_NLCDTHS = getappdata(hAFinchGUI,'GridCode_NLCDTHS');
GridCode_PrecTHS = getappdata(hAFinchGUI,'GridCode_PrecTHS');
GridCode_TempTHS = getappdata(hAFinchGUI,'GridCode_TempTHS');
NLCD_THS         = getappdata(hAFinchGUI,'NLCD_THS');
HSR              = getappdata(hAFinchGUI,'HSR');
StaNdx           = getappdata(hAFinchGUI,'StaNdx');
PIn_THS          = getappdata(hAFinchGUI,'PIn_THS');
PIn0             = getappdata(hAFinchGUI,'PIn0');
PrsmPrecTHS      = getappdata(hAFinchGUI,'PrsmPrecTHS');
TdC_THS          = getappdata(hAFinchGUI,'TdC_THS');
WY1              = getappdata(hAFinchGUI,'WY1');
WYn              = getappdata(hAFinchGUI,'WYn');
%
% Compute Area-Weighted NLCD Properties for Incremental Streamgages
NLCD11_THS = NLCD_THS(:, 1); NLCD12_THS = NLCD_THS(:, 2); NLCD21_THS = NLCD_THS(:, 3);
NLCD22_THS = NLCD_THS(:, 4); NLCD23_THS = NLCD_THS(:, 5); NLCD24_THS = NLCD_THS(:, 6);
NLCD31_THS = NLCD_THS(:, 7); NLCD41_THS = NLCD_THS(:, 8); NLCD42_THS = NLCD_THS(:, 9);
NLCD43_THS = NLCD_THS(:,10); NLCD52_THS = NLCD_THS(:,11); NLCD71_THS = NLCD_THS(:,12);
NLCD81_THS = NLCD_THS(:,13); NLCD82_THS = NLCD_THS(:,14); NLCD90_THS = NLCD_THS(:,15); 
NLCD95_THS = NLCD_THS(:,16);
%
WY = WY1 + iy -1;
for is=1:Ns,
    % Find indices of basin
    % The land uses for basins are recomputed annual because of possible
    % changes in the network of active stations.  
    % The NLCD, themselves, are invariant with year. 
    [~,ia,ib] = intersect(AFstruct.(HSR)(iy,StaNdx(is)).SBGridCode,GridCode_NLCDTHS);
    WtLU = repmat(AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm(ia),1,16) .*...
        [NLCD11_THS(ib) NLCD12_THS(ib) NLCD21_THS(ib) NLCD22_THS(ib)...
         NLCD23_THS(ib) NLCD24_THS(ib) NLCD31_THS(ib) NLCD41_THS(ib)...
         NLCD42_THS(ib) NLCD43_THS(ib) NLCD52_THS(ib) NLCD71_THS(ib)...
         NLCD81_THS(ib) NLCD82_THS(ib) NLCD90_THS(ib) NLCD95_THS(ib)];
     %% Compute Area-Weighted PRISM Precipitation and Temperature
    [~,ia,ib] = intersect(AFstruct.(HSR)(iy,StaNdx(is)).SBGridCode,GridCode_PrecTHS);
    WtPIn = repmat(AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm(ia),1,12) .* PIn_THS(ib,1:12);
   %
    [~,ia,ib] = intersect(AFstruct.(HSR)(iy,StaNdx(is)).SBGridCode,GridCode_TempTHS);
    % Compute weighted temperature values in degC
    WtTcD = repmat(AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm(ia),1,12) .* TdC_THS(ib,1:12);
    
   % Avoid dimension reduction for single catchment basins.
    if length(ib) > 1
        SumSBAreaPRSM = sum(repmat(AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm(ia),1,12));
        SumSBAreaLUse = sum(repmat(AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm(ia),1,16));
        SumWtPIn  = sum(WtPIn);
        SumWtLU   = sum(WtLU);
    else
        SumSBAreaPRSM = repmat(AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm(ia),1,12);
        SumSBAreaLUse = repmat(AFstruct.(HSR)(iy,StaNdx(is)).SBAreaSqKm(ia),1,16);        
        SumWtPIn  =     WtPIn;
        SumWtLU   =     WtLU;
    end
    % Compute land use precentage weighted by catchment area.
    AFstruct.(HSR)(iy,StaNdx(is)).NLCD   = SumWtLU  ./ SumSBAreaLUse;
    %
    % Compute weighted average precip
    AFstruct.(HSR)(iy,StaNdx(is)).Precip = SumWtPIn ./ SumSBAreaPRSM;
    % The following for loop computes the lag1 precip
    for mo = 1:12
        if mo==1 
            if iy==1
%                AFstruct.(HSR)(iy,StaNdx(is)).Precip1(1) = NaN;
                AFstruct.(HSR)(iy,StaNdx(is)).Precip1(1) = mean(PIn0(ib,12));
            elseif ~isempty(AFstruct.(HSR)(iy-1,StaNdx(is)).Precip)
                AFstruct.(HSR)(iy,StaNdx(is)).Precip1(1) = ...
                    AFstruct.(HSR)(iy-1,StaNdx(is)).Precip(12);
            else
%                AFstruct.(HSR)(iy,StaNdx(is)).Precip1(1) = NaN;
                AFstruct.(HSR)(iy,StaNdx(is)).Precip1(1) = mean(PrsmPrecTHS(iy-1,ib,12));
            end
        else
            AFstruct.(HSR)(iy,StaNdx(is)).Precip1(mo) = ...
                AFstruct.(HSR)(iy,StaNdx(is)).Precip(mo-1); 
        end
    end
    %
    % Store weighted average temperature
        % Avoid dimension reduction for single catchment basins.
    if length(ib) > 1
        SumWtTcD  = sum(WtTcD);
        
    else
        SumWtTcD  =     WtTcD;
    end

    AFstruct.(HSR)(iy,StaNdx(is)).Temp   = SumWtTcD ./ SumSBAreaPRSM;
end
%
if (WY == WYn),
    save(['AFstruct.(HSR)_' int2str(WY)],'AFstruct');
end
%
setappdata(hAFinchGUI,'AFstruct',AFstruct);
%
