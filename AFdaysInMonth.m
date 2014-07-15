function numberofdays=AFdaysInMonth(wy,mn)
%  function to give days in month to allow for leap years
%  replaces DaysInMo vector in AFINCH to vary by year
%  input water year and month of evaluation, converts to real
%  year and real month, returns days in the month
monthvector = [10,11,12,1,2,3,4,5,6,7,8,9];
realmonth= monthvector(mn);
if mn < 3
    realyear = wy-1;
else
    realyear = wy;
end
numberofdays = eomday(realyear,realmonth);
