/*global define */
define(['map', 'knockout', 'knockoutAutoComplete', 'AppViewModel'], function (map, ko, knockoutAutoComplete ,AppViewModel) {

    var init = function() {
        // @TODO useless class constructions, refactor away
        aVM = new AppViewModel()
        aVM.init()

        ko.applyBindings(aVM)

        map.init(aVM.mapData)
    };

    return {init: init};
});