define [
  'jquery'
  'knockout'
  'lodash'
],(
  $
  ko
  _
) ->

  kelvin2Celcius = (kelvins) ->
    kelvins - 273.15

  class openWeatherHelsinki
    constructor: () ->
      @temperature = ko.observable()
      @temperatureFormatted = ko.computed =>
        if _.isFinite(@temperature())
          "#{Math.round(kelvin2Celcius(@temperature()))} °C"
        else
          ""

      @cloudinessInPercent = ko.observable()
      @logicalCloudiness = ko.computed =>
        switch
          when @cloudinessInPercent() < 30
            'clear'
          when @cloudinessInPercent() < 70
            'partlyCloudy'
          else
            'cloudy'

    init: () ->
      # @TODO check cookie first
      weatherDataRequest = $.ajax
        type: 'GET'
        url: 'http://api.openweathermap.org/data/2.5/weather?id=658225'
        contentType: "application/json"
        dataType: 'jsonp'

      weatherDataRequest.done (data) =>
        if _.isFinite(data?.clouds?.all)
          @cloudinessInPercent(data.clouds.all)

        if _.isFinite(data?.main?.temp)
          @temperature(data.main.temp)
