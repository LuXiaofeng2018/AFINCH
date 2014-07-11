function AFGenLag1Prec
hAFinchGUI    = getappdata(0,'hAFinchGUI');
PrsmPrecTHS   = getappdata(hAFinchGUI,'PrsmPrecTHS');
PIn0          = getappdata(hAFinchGUI,'PIn0');
%
%   AFGenLag1Precp generates a version of PrsmPrecTHS (PrsmPremTHS) with 
%   lag1 (minus) monthly precipitation values.   
%%
[ii,jj,kk] = size(PrsmPrecTHS);
PrsmPremTHS = zeros(ii,jj,kk-1);
for i=1:ii,
    for j=1:jj,
        for k=1:12,
            if k==1 && i>1
                PrsmPremTHS(i,j,k) = PrsmPrecTHS(i-1,j,12);
            elseif k==1 && i==1
                PrsmPremTHS(i,j,k) = PIn0(j,12);
            else
                PrsmPremTHS(i,j,k) = PrsmPrecTHS(i,j,k-1);
            end
        end
    end
end
% Update hAFinchGUI variables
setappdata(hAFinchGUI,'PrsmPremTHS',PrsmPremTHS);
