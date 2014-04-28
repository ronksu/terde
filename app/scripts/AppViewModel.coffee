define [
  'knockout'
  'lodash'
  './clockTick'
  './terraceData'
  './OpenWeatherHelsinki'
  './nearestPoints'
  './TerraceSearch'
  './TerracePager'
  './Tabs'
],(
    ko
    _
    clockTick
    terraceData
    OpenWeatherHelsinki
    nearestPoints
    TerraceSearch
    TerracePager
    Tabs
) ->
  class TerdeViewModel
    constructor: () ->
      @clock = ko.observable((new Date()).getHours())
      @weather = new OpenWeatherHelsinki()

      @mapData = terraceData(@clock)
      @userLocation = ko.observable()
      @nearestPoints = nearestPoints({@userLocation, @mapData})

      @tabs = new Tabs()
      @search = new TerraceSearch({@mapData, @nearestPoints})
      @pager = new TerracePager({results: @search.results})
      @selectedTerrace = ko.observable()

      @focusOnClick = (terrace) =>
        @selectedTerrace(terrace)

    init: ({clockFn} = {}) ->
      clockTick({clock: @clock, clockFn})
      @weather.init()

      @