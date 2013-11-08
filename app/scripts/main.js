require.config({
    paths: {
        jquery: '../bower_components/jquery/jquery',
        knockout: '../bower_components/knockout.js/knockout',
        knockoutMapping: '../bower_components/knockout-mapping/knockout.mapping',
        lodash: '../bower_components/lodash/dist/lodash.min',
        Uri: '../bower_components/jsUri/Uri.min'
    },
    shim: {
        Uri: {
            exports: 'Uri'
        }
    },
    deps: ['knockout', 'knockoutMapping'],
    callback: function(ko, mapping) {
        ko.mapping = mapping;
    }
});

require(['app'], function (app) {
    app.init();
});
