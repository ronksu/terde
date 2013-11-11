define ['lodash', '../scripts/OpenWeatherHelsinki'], (_, OpenWeatherHelsinki) ->
  mockWeatherRequest = (temperature, clouds) ->
    $.mockjaxClear()
    $.mockjax
      url: 'http://api.openweathermap.org/data/2.5/*'
      contentType: "text/json"
      responseText: """{"coord":{"lon":24.93545,"lat":60.169521},"sys":{"country":"FI","sunrise":1383025029,"sunset":1383057043},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10n"}],"base":"gdps stations","main":{"temp":#{temperature},"temp_min":281.988,"temp_max":281.988,"pressure":998.73,"sea_level":1002.58,"grnd_level":998.73,"humidity":95},"wind":{"speed":7.15,"deg":249.5},"rain":{"3h":1},"clouds":{"all":#{clouds}},"dt":1383065423,"id":658225,"name":"Helsinki","cod":200}"""
      responseTime:  0

  describe "Open weather component", ->
    beforeEach ->
      $.cookie('temperature', false)
      $.cookie('cloudiness', false)
      mockWeatherRequest(100, 50)

    it "loads data correctly", (done) ->
      temperatureAsserted = $.Deferred()
      cloudinessAsserted = $.Deferred()

      weather = new OpenWeatherHelsinki()

      weather.temperature.subscribe (temperature) ->
        expect(temperature).to.equal(100)
        temperatureAsserted.resolve()

      weather.cloudinessInPercent.subscribe (cloudiness) ->
        expect(cloudiness).to.equal(50)
        cloudinessAsserted.resolve()

      weather.init()

      $.when(temperatureAsserted, cloudinessAsserted).done done

    it "returns correctly formatted temperature", (done) ->
      weather = new OpenWeatherHelsinki()

      weather.temperatureFormatted.subscribe (temperature) ->
        expect(temperature).to.equal('-173 °C')
        done()

      weather.init()

    describe "returns 3 different cloudiness levels", ->
      it "below 30 is clear", (done) ->
        mockWeatherRequest(100, 10)

        weather = new OpenWeatherHelsinki()

        weather.logicalCloudiness.subscribe (cloudiness) ->
          expect(cloudiness).to.equal('clear')
          done()

        weather.init()

      it "below 50 is partly cloudy", (done) ->
        mockWeatherRequest(100, 50)

        weather = new OpenWeatherHelsinki()

        weather.logicalCloudiness.subscribe (cloudiness) ->
          expect(cloudiness).to.equal('partlyCloudy')
          done()

        weather.init()

      it "below 80 is cloudy", (done) ->
        mockWeatherRequest(100, 80)

        weather = new OpenWeatherHelsinki()

        weather.logicalCloudiness.subscribe (cloudiness) ->
          expect(cloudiness).to.equal('cloudy')
          done()

        weather.init()



    describe "Caching", ->
      it "weather is put to cookie on load", (done) ->
        mockWeatherRequest(100, 50)

        weather = new OpenWeatherHelsinki()

        weather.temperatureFormatted.subscribe (data) ->
          setTimeout ->
            expect($.cookie('temperature')).to.equal('100')
            expect($.cookie('cloudiness')).to.equal('50')
            done()
          ,
            10

        weather.init()

      it "weather is updated only once every 30 mins", (done) ->
        calledOnce = false
        mockWeatherRequest(100, 50)
        weather = new OpenWeatherHelsinki()

        weather.temperature.subscribe (data) ->
          expect(calledOnce).to.equal(false)
          calledOnce = true

          setTimeout ->
            mockWeatherRequest(150, 80)
            weather.init()
            done()
          ,
            10

        weather.init()
