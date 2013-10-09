define ['jquery', 'knockout', 'lodash'], ($, ko, _) ->
  class terdeViewModel

    # @TODO move somewhere else...
    initClock = (clock) ->
      clockTick = () ->
        clock((new Date()).getHours())

      setInterval(clockTick, 1000*60)

    constructor: () ->
      @locationData = ko.observable()
      @clock = ko.observable((new Date()).getHours())
      @mapData = ko.computed =>
        extractedLocationData = _.flatten(@locationData())
        _.map extractedLocationData, (observable) =>
          item = observable()

          name: item.properties.nimi
          description: item.properties.description
          shine: parseInt(item.properties.shine[@clock()] ? 0)
          coordinates: item.geometry.coordinates

      @terdeDataMapping =
        key: (item) ->
          item
        create: (data) ->
          _.map data.data.features, (feature) ->
            ko.observable feature

    init: ({clockFn} = {}) ->
      # @TODO separate to own component
      if _.isFunction(clockFn)
        clockFn(@clock)
      else
        initClock(@clock)

      mapDataRequest = $.ajax
        url: '/data/terassit_0101.json'
        dataType: 'json'

      mapDataRequest.done (data) =>
        ko.mapping.fromJS [data], @terdeDataMapping, @locationData

      mapDataRequest.fail (jqXHR, textStatus, errorThrown) ->
        # @TODO fail nicely
