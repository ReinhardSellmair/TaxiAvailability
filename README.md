# TaxiAvailability

This repository contains Matlab code to download locations of currently available taxis from mytransport.sg. Furthermore, scripts are included to export the downloaded data to a database and visualise the location of taxis. Analyses on the data is summaries in a presentation. 

## Registration

Access of mytransport.sg API must be requested at https://www.mytransport.sg/content/mytransport/home/dataMall/request-for-api.html. Users will get an account key and a unique user ID. These, must be inserted in the function downloadTaxiAvailability() to access the data.

## Code

downloadTaxiAvailability.m: Download locations of currently available taxis. 
logTaxiAvailability.m: Script to repaetedly download and save available taxi locations, contains infinite loop and must be stoped manually.
combineAvailabilityData.m: Combine downloaded files to one file per day.
attachIdSubxoneToLocation.m: Attach an area ID to each recorded taxi position.
exportData2Database.m: Export combined files with area IDs to database.
plotAvailableTaxi.m: Plot locations of available taxis on Google map.

## Presentation

Presentation.pdf: contains anlyses on number of available taxis with respect to time and density of available taxis.

## Requirements

Toolboxes:
Matlab Database Toolbox: https://www.mathworks.com/products/database.html

Functions:
inpoly.m: https://www.mathworks.com/matlabcentral/fileexchange/10391-fast-points-in-polygon-test
parse_json.m: https://www.mathworks.com/matlabcentral/fileexchange/20565-json-parser
plot_google_map.m: https://www.mathworks.com/matlabcentral/fileexchange/27627-zoharby-plot_google_map
urlread2.m: https://www.mathworks.com/matlabcentral/fileexchange/35693-urlread2?s_tid=mwa_osa_a
