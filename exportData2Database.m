%% export availability data to database

% This script uses the Matlab database toolbox to export the combined taxi
% availability data to a database. 

% The availability data was downloaded with the script logTaxiAvailability,
% logs were combined per day with combineAvailabilityData, and SubZone IDs
% were added with attachIdSubzoneToLocation. 
% After thses steps the data can be exported to a database. The database
% consists of following tables:
% Time - time of download, columns: idTime, datetime (yyyy-mm-dd HH:MM:SS)
% DataPoint - locations of taxis, columns:
%   idTime: id of Time table when data was downloaded
%   idSubZone: id of subzone where taxi was when data got recorded
%   latitude: latitude of recorded taxi
%   longitude: longitude of recorded taxi
% The function availabilityDataDatabase_rs creates the connection to the
% database.

%% parameter

% directory where data is saved
dirData = '..\data\combined\';
% only files with this keyword shall be loaded
keyword = 'TaxiAvailabilityTable';

%% export

% connection to database
conn = availabilityDataDatabase_rs();
% autocommit shall be off so that no data is exported to database if the
% script crashes
set(conn, 'AutoCommit', 'off')
% get connection handle
connHandle = conn.Handle;

% get filenames with data to be exported
dirInfo = dir(dirData(1:end-1));
dirInfoCell = struct2cell(dirInfo(3:end));
fileName = dirInfoCell(1, :)';

% names of files which shall be imported (filename must contain keyword)
fileNameLoad = fileName(~cellfun(@isempty, strfind(fileName, keyword)));
% number of files
nFile = length(fileNameLoad);

% start time of export
timeStart = datetime('now');

% export each file one at a time
try
    for iFile = 1:nFile
        fprintf('%s File %d/%d\n', datestr(now), iFile, nFile)
        
        % load data
        load([dirData, fileNameLoad{iFile}])
        % number of tables
        nTable = height(dataSetTable);
        % get columns of table
        time = dataSetTable.time;
        location = dataSetTable.location;        
        
        % export each table one at a time
        for iTable = 1:nTable            
            %% export data to Time table
            % convert time to string
            timeString = datestr(time(iTable), '''yyyy-mm-dd HH:MM:SS''');
            % create export statement
            stmt = connHandle.createStatement;
            statement = sprintf('INSERT INTO Time VALUES(%s)', timeString);
            % add statement to batch
            stmt.addBatch(statement);
            % execute batch
            stmt.executeBatch;
            % get id of exported value
            idTime = get_identity(conn, 'Time');            
            
            %% export data to DataPoint table
            % get location table of datapoints
            locationDataPoint = location{iTable};
            % get values of datapoints to be imported
            valueExport = location{iTable};
            % number of datapoints
            nDataPoint = height(valueExport);

            % create cell array with export data
            exportData = cell(nDataPoint, 4);
            % idTime
            exportData(:, 1) = cellstr(repmat(num2str(idTime), nDataPoint, 1));
            % idSubZone
            exportData(:, 2) = cellstr(num2str(locationDataPoint.idSubZone));
            % replace NaN values by NULL
            exportData(isnan(locationDataPoint.idSubZone), 2) = {'NULL'};            
            % latitude
            exportData(:, 3) = cellstr(num2str(locationDataPoint.latitude));
            % longitude
            exportData(:, 4) = cellstr(num2str(locationDataPoint.longitude));
            
            % create statement
            stmt = connHandle.createStatement;
            for iDataPoint = 1:nDataPoint
                statement = ...
                    sprintf( ...
                        'INSERT INTO DataPoint VALUES(%s)', ...
                        strjoin(exportData(iDataPoint, :), ' , ') ...
                    );
                % add statement to batch
                stmt.addBatch(statement);                
            end            
            % execute batch
            stmt.executeBatch;
        end
        
        % estimate end of export
        estimatedEnd = (datetime('now') - timeStart) / iFile * nFile + timeStart;
        fprintf('Estimated end of export: %s\n', datestr(estimatedEnd))
    end
catch exception
    % if script crashes no data shall be exported to database
    rollback(conn)
    getReport(exception)
end

% commit data export
commit(conn)
