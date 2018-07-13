%% import downloaded taxi availability data
% all downloads of one day are combined in one table. Each table entry
% contains time of import, location data, and number of available taxis

% saved data as table with columns:
% time: datetime of import
% nAvailable: number of available taxis
% location: table with latitude and longitude of taxis

%% Parameter

% directory where downloaded data is saved
dirDownload = '..\data\download\';
% directory where combined data shall be saved
dirSave = '..\data\combined\';

% number of iterations until information is shown in Command Window
nIterationInfo = 100;

%% Calculation

% get all file names
dirInfo = dir(dirDownload(1:end-1));
dirInfoCell = struct2cell(dirInfo(3:end));
fileName = dirInfoCell(1, :)';
% number of files
nFile = length(fileName);

importDayNumber = 0;
% number of files in data set
nFileDataSet = 0;

% start of import
datetimeStart = datetime('now');

for iFile = 1:nFile
    % import file
    load([dirDownload, fileName{iFile}])
    % get day number of loaded data
    dayNumberLoad = floor(datenum(availabilityData.timeImport));
    % check if loaded data is from a different day as the previous data
    if importDayNumber ~= dayNumberLoad
        % data is of a new day - save current dataset and create a new data set
        if nFileDataSet > 0
            % remove empty cells
            dataSet = dataSet(1:nFileDataSet, :);
            % convert to table
            dataSetTable = ...
                cell2table(dataSet, 'VariableNames', {'time', 'nAvailable', 'location'});
            % generate file name
            fileNameSave = [datestr(importDayNumber, 'yyyymmdd'), 'TaxiAvailabilityTable'];
            % save data set
            save([dirSave, fileNameSave], 'dataSetTable');
        end
        
        % create new data set
        dataSet = cell(730, 3);
        nFileDataSet = 0;
        importDayNumber = dayNumberLoad;        
    end
    
    % update file number
    nFileDataSet = nFileDataSet + 1;
    
    % insert data
    dataSet{nFileDataSet, 1} = availabilityData.timeImport;
    dataSet{nFileDataSet, 2} = availabilityData.nAvailable;
    dataSet{nFileDataSet, 3} = availabilityData.location;
    
    if mod(iFile, nIterationInfo) == 0
        % show information in Command Window
        fprintf('%s File %d/%d\n', datestr(now), iFile, nFile)
        % calculate estimated end of import
        estimatedEnd = (datetime('now') - datetimeStart) / iFile * nFile + datetimeStart;
        fprintf('Estimated end of import: %s\n', datestr(estimatedEnd))
    end
end

% save last dataset
if nFileDataSet > 0
    % remove empty cells
    dataSet = dataSet(1:nFileDataSet, :);
    % convert to table
    dataSetTable = ...
        cell2table(dataSet, 'VariableNames', {'time', 'nAvailable', 'location'});
    % generate file name
    fileNameSave = [datestr(importDayNumber, 'yyyymmdd'), 'TaxiAvailabilityTable'];
    % save data set
    save([dirSave, fileNameSave], 'dataSetTable');
end

