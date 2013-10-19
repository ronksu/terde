/*global define */
define(['map', 'knockout',"appViewModelFactory"], function (map, ko, appViewModel) {

    var init = function() {
        ko.applyBindings(appViewModel)
        map.init({mapData: appViewModel.mapData, userLocation: appViewModel.userLocation, selectedTerraceCoordinates: appViewModel.selectedTerraceCoordinates})
    };

    return {init: init};
});