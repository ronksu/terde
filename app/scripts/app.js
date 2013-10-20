/*global define */
define(['map', 'knockout',"appViewModelFactory", "weatherSymbols"], function (map, ko, appViewModel, weatherSymbols) {

    var init = function() {
        ko.applyBindings(appViewModel)
        map.init({mapData: appViewModel.mapData, userLocation: appViewModel.userLocation, selectedTerraceCoordinates: appViewModel.selectedTerraceCoordinates})
        weatherSymbols.init({logicalCloudiness: appViewModel.weather.logicalCloudiness})
    };

    return {init: init};
});