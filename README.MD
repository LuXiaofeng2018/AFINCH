AFINCH (Analysis of Flow in Networks of Channels)
========================================================

* AFINCH is a computer application designed to generate time series of monthly flows at stream segments (flowlines) and corresponding water yields at catchments defined in the National Hydrography Dataset (NHDPlus, v. 2).  
* AFINCH provides a basis for integrating monthly flow data from streamgages, water-use data, monthly climatic data, land-cover characteristics defined in NHDPlus, and catchment attributes described in user-defined shapefiles to estimate natural monthly water yields from catchments.
* AFINCH provides an interactive process for the user to develop sets of multiple-regression equations for estimating monthly water yields.  
 * Images of monthly water yields for active streamgages are generated in AFINCH and provide a basis for detecting anomalies in water yields, which may be associated with undocumented flow diversions or augmentations.  
* Water yields are multiplied by the drainage areas of the corresponding catchments to estimate monthly flows.  
* Flows from catchments are accumulated downstream through the streamflow network described by the stream segments.  
 * For stream segments where streamgages are active, ratios of measured to accumulated flows are computed.  
 * These ratios are applied to upstream water yields to proportionally constrain estimated flows to match measured flows.  
* A time series of monthly flows can be generated for stream segments that average about 1-mile long, or monthly water yields from catchments that average about 1 square mile.  
 * Chloropleth maps of monthly water yield and flow can be generated and analyzed.  
 * Estimated monthly flows can be displayed within AFINCH, examined for nonstationarity, and tested for monotonic trends.  
 * Monthly flows also can be used to estimate flow-duration characteristics at stream segments within AFINCH.  
* AFINCH generates output files of monthly flows and water yields that are that can be used for specialized analyses.  
* AFINCH conserves through the NHDPlus network.  
* Matlab code used in the AFINCH application is included in the repository starting with version 3a. 

Changes to AFINCH

## version: AFinchGUI3b.m 
* summary: write out design matrix and regression coefficients to text files so that climate change scenarios can be run efficiently by replacing the climate variables in the design matrix with desired values and multiplying the design matrix and the vector of regression coefficients.  This multiplication yields the unconstrained incremental square root catchment yields which
         are used to estimate the unconstrained incremental flows for each catchment.  One file with a design matrix and one file with regression coefficients are written for each month.  nly period-of-analysis, ordinary least-squares, values are written. 
         
* changes: AFinchGUI3b.m, added code from lines 593 - 627 to fill a design matrix
         including a gridcode column and write it to files by month. The
         files are DesMat_mon.csv, where mon is an abbreviated month name. Also write
         the regression coefficient information to b_vec_mon.csv where mon 
         is the abbreviated month name. Code was added to get the current water
         year given the iy counter for the calculation (WY = WY1 + iy - 1) and
         to use this information in the AFdaysInMonth script.  The vector
         DaysInMo in version GUI3a was not updating with water year and 
         was replaced.
         
*          AFdaysInMonth.m, this script was added to get return the number of
         days in each month considering leapyear given the computation month
         and water year.  Used in AFinchGUI3b.m in the estimate of incremental
         flow from a catchment. 
         
*         AFSetupData.m, the vector DaysInMo was moved later in the code and kept
         internal to this script.  It had been written to application memory to 
         be used in AFinchGUI, but this vector was removed.  AFdaysInMonth.m
         replaces this vector.
     
