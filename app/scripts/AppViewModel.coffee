define [
  'knockout'
  'lodash'
  './clockTick'
  './terraceData'
  './OpenWeatherHelsinki'
  './nearestPoints'
  './TerraceSearch'
  './TerracePager'
],(
    ko
    _
    clockTick
    terraceData
    OpenWeatherHelsinki
    nearestPoints
    TerraceSearch
    TerracePager
) ->
  class TerdeViewModel
    constructor: () ->
      @clock = ko.observable((new Date()).getHours())
      @weather = new OpenWeatherHelsinki()

      @mapData = terraceData(@clock)
      @userLocation = ko.observable()
      @nearestPoints = nearestPoints({@userLocation, @mapData})

      @search = new TerraceSearch({@mapData, @nearestPoints})
      @pager = new TerracePager({results: @search.results})
      @selectedTerrace = ko.observable()

      @focusOnClick = (terrace) =>
        @selectedTerrace(terrace)

    init: ({clockFn} = {}) ->
      clockTick({clock: @clock, clockFn})
      @weather.init()

      @