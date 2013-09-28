/*global define:false, jQuery:false*/
define('jquery', [], function() { return jQuery; });

require.config({
    paths: {
        // @TODO mock
        mapBox: 'http://api.tiles.mapbox.com/mapbox.js/v1.0.2/mapbox',
        knockout: '/bower_components/knockout/knockout-2.3.0.debug',
        knockoutMapping: '/bower_components/knockout-mapping/build/output/knockout.mapping-latest.debug',
        lodash: '/bower_components/lodash/dist/lodash'
    },
    shim: {
        mapBox: {
            exports: 'L'
        }
    },
    deps: ['knockout', 'knockoutMapping'],
    callback: function(ko, mapping) {
        ko.mapping = mapping;
    }
});
