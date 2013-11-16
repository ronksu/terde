require.config
  paths:
    jquery: '../bower_components/jquery/jquery'
    knockout: '../bower_components/knockout.js/knockout'
    knockoutMapping: '../bower_components/knockout-mapping/knockout.mapping'
    lodash: '../bower_components/lodash/dist/lodash.min'
    Uri: '../bower_components/jsUri/Uri.min'
    fastclick: '../bower_components/fastclick/lib/fastclick'
  shim:
    Uri:
      exports: 'Uri'
  deps: ['knockout', 'knockoutMapping']
  callback: (ko, mapping) ->
    ko.mapping = mapping

require ['fastclick', 'app'], (fastclick, app) ->
  fastclick.attach(document.body)
  app.init()