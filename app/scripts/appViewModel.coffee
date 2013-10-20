define [
  'jquery'
  'knockout'
  'lodash'
  './clockTick'
  './openWeatherHelsinki'
  './getNearestPoints'
],(
    $
    ko
    _
    clockTick
    openWeatherHelsinki
    getNearestPoints
) ->
  class terdeViewModel

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
          coordinates: item.geometry.coordinates

      @userLocation = ko.observable()
      @nearestPoints = ko.computed =>
        if (@userLocation() instanceof L.LatLng) and @mapData().length > 0
          getNearestPoints @userLocation(), @mapData()
        else
          []

      @searchCriteria = ko.observable()
      @searchResults = ko.computed =>
        if _.isString(@searchCriteria()) and @searchCriteria().length > 3
          _.filter @mapData(), (point) =>
            point.name?.toLowerCase().indexOf(@searchCriteria().toLowerCase()) >= 0 or
            point.address?.toLowerCase().indexOf(@searchCriteria().toLowerCase()) >= 0
        else
          @nearestPoints()

      @terdeDataMapping =
        key: (item) ->
          item
        create: (data) ->
          _.map data.data.features, (feature) ->
            # @TODO fix here wrong coordinate order in data for now..
            feature.geometry.coordinates.reverse()
            ko.observable feature

      @selectedTerraceCoordinates = ko.observable()

      @focusOnClick = (terrace) =>
        @selectedTerraceCoordinates(terrace.coordinates)

      @weather = new openWeatherHelsinki()

    init: ({clockFn} = {}) ->
      clockTick({clock: @clock, clockFn})

      @weather.init()

      mapDataRequest = $.ajax
        url: '/data/terassit_0101.json'
        dataType: 'json'

      mapDataRequest.done (data) =>
        ko.mapping.fromJS [data], @terdeDataMapping, @locationData

      mapDataRequest.fail (jqXHR, textStatus, errorThrown) ->
        # @TODO fail nicely

      @