define ['jquery', 'knockout', 'lodash', 'Uri', 'getNearestPoints'], ($, ko, _, Uri, getNearestPoints) ->
  class terdeViewModel

    # @TODO move somewhere else...
    initClock = (clock) ->
      clockTick = () ->
        clock((new Date()).getHours())

      setInterval(clockTick, 1000*60)

    getShiningLevels = ({levels, currentHour}) ->
      getShineLevel = (accu, hourAdd) ->
        accu.push(parseInt(levels[(currentHour + hourAdd) % 23] ? 0))
        accu

      _.reduce [0..5], getShineLevel, []

    constructor: () ->
      @clock = ko.observable((new Date()).getHours())
      @locationData = ko.observable()
      @mapData = ko.computed =>
        extractedLocationData = _.flatten(@locationData())
        _.map extractedLocationData, (observable) =>
          item = observable()

          name: item.properties.nimi
          address: item.properties.pisteen_os
          shine: getShiningLevels({levels:item.properties.shine, currentHour: @clock()})
          coordinates: item.geometry.coordinates.reverse()

      @userLocation = ko.observable()
      @nearestPoints = ko.computed =>
        if (@userLocation() instanceof L.LatLng) and @mapData().length > 0
          getNearestPoints @userLocation(), @mapData()
        else
          []

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

        if _.isFinite hashClock
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
