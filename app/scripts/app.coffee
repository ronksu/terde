define [
  'map'
  'knockout'
  'appViewModelFactory'
  'weatherSymbols'
], (
  map
  ko
  appViewModel
  weatherSymbols
) ->

  init = ->
    ko.applyBindings appViewModel
    map.init
      mapData: appViewModel.mapData
      userLocation: appViewModel.userLocation
      selectedTerrace: appViewModel.selectedTerrace

    weatherSymbols.init
      logicalCloudiness: appViewModel.weather.logicalCloudiness

  {init}
