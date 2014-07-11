"""
script to read in AFINCH design matrix, replace climate-based explanatory
variables as needed and generate unconstrained regression estimates of
incremental yields and flows
"""
__author__ = "H.W. Reeves, USGS Michigan Water Science Center"
__email__ = "hwreeves@usgs.gov"
__date__ = "July 3, 2014"

import os
import re
import numpy as np
import calendar

#set path to climate data
home = os.getcwd()
#set path to climate data
#climatedata = os.path.join("G:", os.sep,"AFinch", "HR04","PRISM")
climatedata = os.path.join(home,"Climate_change")


#list names of climate variables used in the regression as
#a dictionary pointing to path and base file name for new values
climatebasename = {'CurrentPrecip':'PrismPrecipWY',
               'CurrentTemper':'PrismTempAveWY'}
climatepath = {'CurrentPrecip':os.path.join(climatedata,'Precipitation'),
               'CurrentTemper':os.path.join(climatedata,'Temperature')}
#get list of design matrix files
flist = os.listdir(home)
desmatlist = []
bvaluelist = []
for fl in flist:
    if re.match('DesMat',fl):
        desmatlist.append(fl)
    if re.match('b_vec',fl):
        bvaluelist.append(fl)

#set range of desired water years for calculation
WY1 = 1971
WY2 = 2010

mlist = [10,11,12,1,2,3,4,5,6,7,8,9]
mname = {'Oct':10,
         'Nov':11,
         'Dec':12,
         'Jan':1,
         'Feb':2,
         'Mar':3,
         'Apr':4,
         'May':5,
         'June':6,
         'July':7,
         'Aug':8,
         'Sep':9}

#create headerstring for output file
headerstring = 'GridCode,AreaSqMi,'
fllist = []
ydlist = []
for mnlab in ['Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep']:
    fllist.append('flowCatchEst'+mnlab)
    ydlist.append('yieldCatchEst'+mnlab)
headerstring = headerstring + ",".join(fllist)+","+",".join(ydlist)
# read in design matrix, pull out grid codes, and store for each month
designmatrix = dict()
bvals = dict()

for fl in desmatlist:
    m = re.match('DesMat_(\w+)',fl)
    monlab = m.group(1)
    mn = mname[monlab]
    des = np.genfromtxt(fl,skip_header=1,delimiter=",")
    gridcode = np.array(des[:,0],dtype=int)
    designmatrix[mn] = des[:,1:]

del des
for fl in bvaluelist:
    m = re.match('b_vec_(\w+)',fl)
    monlab = m.group(1)
    mn = mname[monlab]
    BINPUT = open(fl,'r')
    nameline = BINPUT.readline().strip()
    inoutline = BINPUT.readline().strip()
    bvalueline = BINPUT.readline().strip()
    nms = re.split(',',nameline.strip(','))
    inouts = re.split(',',inoutline.strip(','))
    b = re.split(',',bvalueline.strip(','))
    nms.insert(0,'Intercept')
    inouts.insert(0,1)
    inmodel=map(int,inouts)
    bvec=map(float,b)
    bvals[mn]=[nms,inmodel,bvec]

for wy in range(WY1,WY2+1):
    print 'doing multiplication for WY = {0}\n'.format(wy)
    # get climate data for the specified water year,
    # pull out desired grid codes
    climate_wy=dict()
    # set up an empty np array for flowcatchestimates
    flowcatchest = np.zeros([len(gridcode),12],dtype=float)
    yieldcatchest = np.zeros([len(gridcode),12],dtype=float)
    for climvar in climatebasename.iterkeys():
        basepath = climatepath[climvar]
        targetfile = os.path.join(basepath,climatebasename[climvar]+str(wy)+'.dat')
        indat = np.genfromtxt(targetfile,skip_header=4)
        climgridcode = np.array(indat[:,0],dtype=int)
        if re.match('CurrentPrecip',climvar):
            areasqmi = np.array(indat[:,1],dtype=float)
            climate_wy[climvar] = indat[:,2:]
        else:
            climate_wy[climvar] = indat[:,1:]
    #find indices for gridcode entries that match values in designmatrix
    #and use these indices to reduce areasqmi and climate_wy matrices to
    #needed values

    matchlist = [i for i, x in enumerate(climgridcode) if x in gridcode]
    final_clim_wy=dict()
    for climvar in climate_wy.iterkeys():
        final_clim_wy[climvar] = climate_wy[climvar][matchlist,:]
        final_clim_gc = climgridcode[matchlist]
        final_area = areasqmi[matchlist]
    del climate_wy
    del climgridcode
    del areasqmi

    for wymnth in range(0,12):
        mn = mlist[wymnth]
        #get days in month accounting for leap years
        if mn > 9:
            yr = wy-1
        else:
            yr = wy
        daysinmonth = calendar.monthrange(yr,mn)[1]

        # put the climate data into the design matrix and
        # multiply by the B vector to get the unconstrained estimate
        # of the square root of yield
        dm = designmatrix[mn]
        explan = np.array(bvals[mn][0])
        inmods = np.array(bvals[mn][1], dtype=int)
        bcoef = np.array(bvals[mn][2], dtype=float)
        #eliminate unused (inmodel=0) column from b coef; already taken
        #out of design matrix, and replace climate variables in existing
        #design matrix with appropriate column from the final_clim_wy
        #dataset established above
        matchlist = [i for i, x in enumerate(inmods) if x ==1]
        finalb = bcoef[matchlist]
        finalexplan = explan[matchlist]
        for j in range(0,len(finalexplan)):
            explanvariable = finalexplan[j].strip()
            if explanvariable in final_clim_wy:
                dm[:,j] = final_clim_wy[explanvariable][:,wymnth]

        #do the multiplication
        sqrtyield = np.dot(dm,finalb)
        yieldcatchest[:,wymnth] = np.power(sqrtyield,2)
        flowcatchest[:,wymnth] = yieldcatchest[:,wymnth]*final_area*(5280**2)/(daysinmonth*24*3600*12)

    #write results for flow and yield in same form as used by AFINCH
    flname = 'Estimate_WY'+str(wy)+'.txt'
    OUTFL = open(flname,'w')
    OUTFL.write(headerstring+'\n')
    for i in range(0,len(gridcode)):
        outlist = [gridcode[i],final_area[i]]
        outlist.extend(flowcatchest[i,:])
        outlist.extend(yieldcatchest[i,:])
        OUTFL.write(",".join(map(str,outlist))+"\n")

    OUTFL.close()

