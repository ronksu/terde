require.config({
    paths: {
        jquery: '../bower_components/jquery/jquery',
        // @TODO mock
        mapBox: 'http://api.tiles.mapbox.com/mapbox.js/v1.0.2/mapbox',
        knockout: '../bower_components/knockout/knockout-2.3.0.debug',
        knockoutMapping: '../bower_components/knockout-mapping/knockout.mapping'
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
