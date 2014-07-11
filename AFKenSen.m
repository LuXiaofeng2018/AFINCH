%% AFKenSen
% A Matlab function that computes Kendall's tau corcoeff and associated 
%    p-value between two variables and Sen's slope estimator.
% Syntax: 
% [tau, pval, intcpt, med_slope, med_data, med_time yhat] =
%  AFKenSen(time,data,MisInd,tail)
% fprintf(1,'Specify criteria for one- or two-sided test.\n'); 
% tail = input('Enter "ne", "gt", or "lt" with single quotes: ','s');
%
function [tau, pval, intcpt, med_slope, med_data, med_time time yhat] = ...
    AFKenSen(time,data,MisInd,tail)
if nargin == 4
    Ndx = find(data~=MisInd);
    data= data(Ndx);
    time= time(Ndx);
    n   = length(Ndx);
else
    n = length(data);
    Ndx = 1:n;
end
slopes = zeros(n*(n-1)/2,1);
k = 0;
for i=1:n-1,
    for j=i+1:n,
        if time(i)~=time(j)
        k = k+1;
        slopes(k) = (data(i)-data(j))/(time(i)-time(j));
        end
    end
end
%
med_slope = median(slopes(1:k));
%
med_data  = median(real(data));
med_time  = median(time);
intcpt    = med_slope * -med_time + med_data;
yhat      = intcpt + med_slope*time;
[tau,pval]= corr(real(data),time,'type','Kendall');
%
