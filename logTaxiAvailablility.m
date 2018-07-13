%% log taxi availability in regular time steps

% save data as structure with:
% timeImport: datetime of import
% location: table with latitude and longitude of each taxi
% nAvailable: number of available taxis

%% Parameter

% time steps per data log (hour, min, sec)
logTime = duration(0, 2, 8);

% directory where data shall be saved
dirSave = '..\data\download\';

%% import data

timeStart = datetime('now');

i = 0;

while true      
    % get current time
    time = datetime('now');
    
    % calculate waiting time for next import
    durationWait = max(timeStart + i * logTime - time, 0);
    % stop until wait duration is reached
    pause(seconds(durationWait));
    
    % number of iteration
    i = i + 1;
    
    % time of data import
    timeImport = datetime('now');

    % import data from internet
    try
        [location, nValue] = downloadTaxiAvailability();
    catch
        disp([datestr(timeImport), ' Import failed'])
        continue
    end
    
    % combine imported data in structure
    availabilityData.timeImport = timeImport;
    availabilityData.location = location;
    availabilityData.nAvailable = nValue;
    
    % save data
    fileName = [datestr(timeImport, 'yyyymmddHHMM'), 'AvailabilityData.mat'];
    save([dirSave, fileName], 'availabilityData')
end
    
    
    
    
    
    
    


