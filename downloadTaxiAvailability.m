function [dataTable, nValue] = downloadTaxiAvailability()
% download locations of currently available taxis from mytransport.sg


%% Parameter
url = 'http://datamall2.mytransport.sg/ltaodataservice/TaxiAvailability';

header(1).name = 'AccountKey';
header(1).value = 'XXX';
header(2).name = 'UniqueUserId';
header(2).value = 'XXX';
header(3).name = 'accept';
header(3).value = 'application/json';

% number of values per request
nValueRequest = 500;

%% import data from internet

% number of imported cells
nCell = nValueRequest;
% number of request
nRequest = 0;

data.latitude = NaN(30000, 1);
data.longitude = NaN(30000, 1);

strImport = cell(60, 1);

while nCell == nValueRequest
    
    % number of values to be skipped
    nSkip = nRequest * nValueRequest;
    nRequest = nRequest + 1;
    
    % add number of lines to be skipped to url
    if nSkip > 0
        urlRequest = [url, '?$skip=', num2str(nSkip)];
    else
        urlRequest = url;
    end

    % import data from internet
    strImport{nRequest} = urlread2(urlRequest, 'GET', [], header);  
    
    % check if values were found
    if ~isempty(strfind(strImport{nRequest}, '"value":[]'))
        nRequest = nRequest - 1;
        break
    end
end

% total number of values
nValue = 0;

% transform import data strings to Matlab format
for iRequest = 1:nRequest
    
    % transform data to matlab format
    % string to be searched for
    strSearchStart = '"value":';
    strSearchEnd = ']}';
    indexStart = strfind(strImport{iRequest}, strSearchStart) + length(strSearchStart);
    indexEnd = strfind(strImport{iRequest}, strSearchEnd);
    dataCell = parse_json(strImport{iRequest}(indexStart:indexEnd));
    dataCell = dataCell{1};

    % convert cell to array
    % number of cells
    nCell = length(dataCell);

    dataImport.latitude = NaN(nCell, 1);
    dataImport.longitude = NaN(nCell, 1);
    for iCell = 1:nCell
        dataImport.latitude(iCell) = dataCell{iCell}.Latitude;
        dataImport.longitude(iCell) = dataCell{iCell}.Longitude;
    end
    
    data.latitude(nValue + 1:nValue + nCell) = dataImport.latitude;
    data.longitude(nValue + 1:nValue + nCell) = dataImport.longitude;
    
    nValue = nValue + nCell;
end

dataTable = struct2table(data);
dataTable = dataTable(1:nValue, :);

disp([datestr(now), ' Number of available taxis: ', num2str(nValue)])

end











