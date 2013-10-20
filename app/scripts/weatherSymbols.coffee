define [
  'jquery'
],(
  $
) ->

  init: ({logicalCloudiness}) ->
    skyCons = new Skycons();
    logicalCloudiness.subscribe (cloudiness) ->
      # @TODO separate day and night.
      skyconsName = switch
        when cloudiness is "partlyCloudy" then Skycons.PARTLY_CLOUDY_DAY
        when cloudiness is "cloudy" then Skycons.CLOUDY
        else Skycons.CLEAR_DAY
      skyCons.set("cloud-icon", skyconsName);

      skyCons.play()
