function data = matchZonesNoInterpolation(data, zones)
% Matches data points to zones without interpolating between datapoints.
% All datapoints that could not be matched to a zone get the value NaN.
% data is a cell array where each cell contains a table. 


for i = 1:length(data)
    dataSet = data{i};
    dataSet.idSubZone = NaN(height(dataSet), 1);
    point = [dataSet.longitude, dataSet.latitude];
    for k = 1:length(zones)
        in = inpoly(point, [zones{k}.Longitude, zones{k}.Latitude]);
        dataSet.idSubZone(in) = k;
    end  
    data{i} = dataSet;
end

end

