define ['jquery', 'knockout', 'lodash', 'Uri'], ($, ko, _, Uri) ->
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
          address: item.properties.pisteen_os
          shine: parseInt(item.properties.shine[@clock()] ? 0)
          coordinates: item.geometry.coordinates.reverse()

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
        # @TODO extract elsewhere...
        uri = new Uri(window.location)
        hashClock = parseInt uri.setQuery(uri.anchor()).getQueryParamValues('clock')

        if _.isNumber hashClock
          @clock(hashClock)
        else
          initClock(@clock)

      mapDataRequest = $.ajax
        url: '/data/terassit_0101.json'
        dataType: 'json'

      mapDataRequest.done (data) =>
        ko.mapping.fromJS [data], @terdeDataMapping, @locationData

      mapDataRequest.fail (jqXHR, textStatus, errorThrown) ->
        # @TODO fail nicely
