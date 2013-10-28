define [
  'jquery'
  'knockout'
  'lodash'
  './clockTick'
  './terraceDataRequest'
  './OpenWeatherHelsinki'
  './getNearestPoints'
],(
    $
    ko
    _
    clockTick
    terraceDataRequest
    OpenWeatherHelsinki
    getNearestPoints
) ->
  class TerdeViewModel

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

          id: item.id
          name: item.properties.nimi
          address: item.properties.pisteen_os ? ""
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
        if _.isString(@searchCriteria()) and @searchCriteria().length > 0
          _.filter @mapData(), (point) =>
            point.name?.toLowerCase().indexOf(@searchCriteria().toLowerCase()) >= 0 or
            point.address?.toLowerCase().indexOf(@searchCriteria().toLowerCase()) >= 0
        else
          @nearestPoints()

      @terdeDataMapping =
        create: (data) ->
          _.map data.data.features, (feature) ->
            # @TODO fix here wrong coordinate order in data for now..
            feature.geometry.coordinates.reverse()
            feature.id = _.uniqueId()
            ko.observable feature

      @selectedTerrace = ko.observable()

      @focusOnClick = (terrace) =>
        @selectedTerrace(terrace)

      @weather = new OpenWeatherHelsinki()

    init: ({clockFn} = {}) ->
      clockTick({clock: @clock, clockFn})

      @weather.init()

      mapDataRequest = terraceDataRequest.init()
      mapDataRequest.done (data) =>
        ko.mapping.fromJS [data], @terdeDataMapping, @locationData

      @