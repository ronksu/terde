define [
  'knockout'
  'lodash'
],(
  ko
  _
) ->

  kelvin2Celcius = (kelvins) ->
    kelvins - 273.15

  class OpenWeatherHelsinki
    hasWeatherCookie = ->
      temperature = $.cookie('temperature')
      cloudiness = $.cookie('cloudiness')

      _.isFinite(temperature) and _.isFinite(cloudiness)

    setWeatherFromCookie: ->
      temperatureC = $.cookie('temperature')
      cloudinessC = $.cookie('cloudiness')

      @temperature(temperatureC)
      @cloudinessInPercent(cloudinessC)

    setWeatherCookie = ({temperature, cloudiness}) ->
      expiryDate = new Date()
      expiryDate.setTime(expiryDate.getTime() + (30 * 60 * 1000)) # 30mins
      expires =
        expires: expiryDate

      $.cookie('temperature', temperature, expires)
      $.cookie('cloudiness', cloudiness, expires)

    constructor: ->
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

    init: ->
      if (hasWeatherCookie())
        setWeatherFromCookieTO = =>
          @setWeatherFromCookie()
        setTimeout(setWeatherFromCookieTO, 0)

      else
        weatherDataRequest = $.ajax
          type: 'GET'
          url: 'http://api.openweathermap.org/data/2.5/weather?id=658225&APPID=d7f3a7eeb97b8c3392a4cf98c42d441c&callback=?'
          contentType: "application/json"
          dataType: 'jsonp'

        weatherDataRequest.done (data) =>
          if _.isFinite(data?.clouds?.all) and _.isFinite(data?.main?.temp)
            @cloudinessInPercent(data.clouds.all)
            @temperature(data.main.temp)
            setWeatherCookie({temperature: data.main.temp, cloudiness: data.clouds.all})
