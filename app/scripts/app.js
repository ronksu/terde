/*global define */
define(['map', "AppViewModel"], function (map, AppViewModel) {

    var init = function() {
        // @TODO useless class constructions, refactor away
        aVM = new AppViewModel()
        aVM.init()

        map.init(aVM.mapData);
    };

    return {init: init};
});