"""
script to compare catchment yields and incremental flows
from original AFINCH run and multiplication of design matrix * B values
done by python script
"""
__author__ = "H.W. Reeves, USGS Michigan Water Science Center"
__email__ = "hwreeves@usgs.gov"
__date__ = "July 3, 2014"

import os
import numpy as np
import re

home = os.getcwd()
AFpath = os.path.join("G:", os.sep,"AFinch", "HR04","HR0405_test","Output","Catchments")

headerstring = 'GridCode,diffarea,'
fllist = []
ydlist = []
for mnlab in ['Oct','Nov','Dec','Jan','Feb','Mar','Apr','May','June','July','Aug','Sep']:
    fllist.append('diffflow'+mnlab)
    ydlist.append('diffyield'+mnlab)
headerstring = headerstring + ",".join(fllist)+","+",".join(ydlist)


flist = os.listdir(home)
estimateslist = []
for fl in flist:
    if re.match('Estimate_',fl):
        estimateslist.append(fl)

#loop over estimated files, read in values, read in AF values and compare
format='%d'
for i in range(0,25):
    format = format + ', %f'
for fl in estimateslist:
     est = np.genfromtxt(fl,skip_header=1,delimiter=",")
     gridcode = np.array(est[:,0],dtype=int)
     #get WY
     mtch = re.match('Estimate_WY(\w+)',fl)
     wy = mtch.group(1)
     #get AF output
     afname = "CatchYieldsFlowsWY"+wy+'.csv'
     af_file = os.path.join(AFpath,afname)
     cols = range(0,26)
     af = np.genfromtxt(af_file,usecols=cols,skip_header=20,delimiter=",")
     #ignore differences in areas
     af[:,1]=est[:,1]
     #get differnces and percent differences
     diff = af-est
     pct = (diff/af)*100.
     print "maximum/minimum difference in WY = {0} is {1}/{2}\n".format(wy,np.amax(diff),np.amin(diff))
     print "maximum/minimum percent diff in WY = {0} is {1}/{2}\n".format(wy,np.amax(pct),np.amin(pct))
     outfl = "differenceWY"+wy+".txt"
     diff[:,0]=gridcode
     np.savetxt(outfl,diff,delimiter=',',newline='\n',header=headerstring,fmt=format, comments='')
     outfl = "percentWY"+wy+".txt"
     pct[:,0]=gridcode
     np.savetxt(outfl,pct,delimiter=',',newline='\n',header=headerstring,fmt=format, comments='')
