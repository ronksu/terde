define [],() ->

  init: ({logicalCloudiness}) ->
    skyCons = new Skycons({"resizeClear": true});
    logicalCloudinessSubscription = logicalCloudiness.subscribe (cloudiness) ->
      logicalCloudinessSubscription.dispose()
      # @TODO separate day and night.
      skyconsName = switch
        when cloudiness is "partlyCloudy" then "PARTLY_CLOUDY_DAY"
        when cloudiness is "cloudy" then "CLOUDY"
        else "CLEAR_DAY"

      skyCons.set("cloud-icon", skyconsName);

      skyCons.play()
