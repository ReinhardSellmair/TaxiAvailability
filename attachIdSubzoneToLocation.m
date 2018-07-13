%% this script attaches the subzone id to each taxi availability location
% a subzone is an area described by a polygone
% (https://data.gov.sg/dataset/master-plan-2014-subzone-boundary-web)

% loaded data must have been combined for each day (run
% combineAvailabilityData)

% subzones_ex is a cell array with all subzones, the subzone id is
% equivalent with the number of the cell, each cell contains a table with
% the zone's polygon with latitude and longitude pairs

%% Parameter

% directory where files are saved
dirData = '..\data\combined\';

%% Calculation

% load subzones to be matched
load subzones_ex

% get file names of all data sets which shall be attached with the subzone id
dirInfo = dir(dirData(1:end-1));
dirInfoCell = struct2cell(dirInfo(3:end));
fileName = dirInfoCell(1, :)';
% number of files
nFile = length(fileName);

% start of calculation
datetimeStart = datetime('now');

% attach subzone id to each data set
for iFile = 1:nFile
    fprintf('%s File %d/%d\n', datestr(now), iFile, nFile)
    
    % load data
    load([dirData, fileName{iFile}])
    
    % attach subzone id
    dataSetTable.location = matchZonesNoInterpolation(dataSetTable.location, subzones_ex);
    
    % estimate end of calculation
    estimatedEnd = (datetime('now') - datetimeStart) / iFile * nFile + datetimeStart;
    fprintf('Estimated end of calculation: %s\n', datestr(estimatedEnd))    
    
    % save file
    save([dirData, fileName{iFile}])
end



