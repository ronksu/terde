/*global define */
define(['map', 'knockout',"AppViewModel"], function (map, ko ,AppViewModel) {

    var init = function() {
        // @TODO useless class constructions, refactor away
        aVM = new AppViewModel()
        aVM.init()

        ko.applyBindings(aVM)

        map.init(aVM.mapData, aVM.userLocation)
    };

    return {init: init};
});