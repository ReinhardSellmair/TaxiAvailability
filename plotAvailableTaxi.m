function plotAvailableTaxi( dataTable )
% plot locations of available taxis on google map
% dataTable was created by downloadTaxiAvailability()

plot(dataTable.longitude, dataTable.latitude, ...
    '.', ...
    'markersize', 20, ...
    'color', 'red' ...
)
axis off
plot_google_map


end

