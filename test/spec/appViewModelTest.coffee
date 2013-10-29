# @TODO rename data-source to outdoor seating area or such
define ['lodash', '../scripts/AppViewModel'], (_, AppViewModel) ->
  describe "terde view model tests", ->
    beforeEach ->
      $.mockjax
        url: '/data/terassit_0101.json'
        contentType: "text/json"
        proxy: 'data/geo.json'

      $.mockjax
        url: 'http://api.openweathermap.org/data/2.5/*'
        contentType: "text/json"
        responseText: '{"coord":{"lon":24.93545,"lat":60.169521},"sys":{"country":"FI","sunrise":1383025029,"sunset":1383057043},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10n"}],"base":"gdps stations","main":{"temp":281.988,"temp_min":281.988,"temp_max":281.988,"pressure":998.73,"sea_level":1002.58,"grnd_level":998.73,"humidity":95},"wind":{"speed":7.15,"deg":249.5},"rain":{"3h":1},"clouds":{"all":92},"dt":1383065423,"id":658225,"name":"Helsinki","cod":200}'

    afterEach ->
      $.mockjaxClear()

    it "initialize model async", (done) ->
      appViewModel = new AppViewModel()

      subscribe = ->
        appViewModel.locationData.subscribe (data) ->
          done()
        appViewModel.init()

      setTimeout subscribe, 0

    describe "Loaded data is correctly parsed", ->
      it "validate raw data", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.locationData.subscribe (data) ->
          flatData = _.flatten(data)
          expect(flatData).to.be.a('Array').and.to.have.length(7)
          _.each flatData, (POI) ->
            expect(POI()).to.have.keys(['geometry', 'properties', 'type', 'id'])

          done()
        appViewModel.init()

      it "validate map data", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.mapData.subscribe (data) ->
          flatData = _.flatten(data)
          _.each flatData, (POI) ->
            expect(POI).to.have.keys(['coordinates', 'address', 'name', 'shine', 'id'])
          done()
        appViewModel.init()

      it "validate single point", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.mapData.subscribe (data) ->
          terde1 = _.first(_.flatten(data))
          expect(terde1.id).to.be.a('string').and.to.equal('22')
          expect(parseInt(terde1.id)).to.be.a('number').and.to.equal(22)
          expect(terde1.name).to.be.a('string').and.to.equal('terde1')
          expect(terde1.address).to.be.a('string').and.to.equal('Address of terde1')
          expect(terde1.shine).to.be.a('array').and.to.equalAsSets([2, 3, 1, 0, 0, 0])
          expect(terde1.coordinates).to.be.an('array').and.to.equalAsSets([102, 0.5])
          done()

        appViewModel.init
          clockFn: (clock) -> clock(15)

      it "validate single point without address", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.mapData.subscribe (data) ->
          terde1 = _.last(_.flatten(data))
          expect(terde1.name).to.be.a('string').and.to.equal('terde7')
          expect(terde1.address).to.be.a('string').and.to.equal('')
          done()

        appViewModel.init
          clockFn: (clock) -> clock(15)

    describe "shine level is updated according to time", ->
      it "hours 12 level 0", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.mapData.subscribe (data) ->
          testData = _.first(_.flatten(data))
          expect(testData.shine).to.be.a('array').and.to.equalAsSets([0, 1, 2, 2, 3, 1, 0])
          done()

        appViewModel.init
          clockFn: (clock) -> clock(12)

      it "hours 13 level 1", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.mapData.subscribe (data) ->
          testData = _.first(_.flatten(data))
          expect(_.first(testData.shine)).to.be.a('number').and.to.equal(1)
          done()

        appViewModel.init
          clockFn: (clock) -> clock(13)

      it "hours 14 level 2", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.mapData.subscribe (data) ->
          testData = _.first(_.flatten(data))
          expect(_.first(testData.shine)).to.be.a('number').and.to.equal(2)
          done()

        appViewModel.init
          clockFn: (clock) -> clock(14)

      it "level is 0 when current hour has no shine level", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.mapData.subscribe (data) ->
          testData = _.first(_.flatten(data))
          expect(_.first(testData.shine)).to.be.a('number').and.to.equal(0)
          done()

        appViewModel.init
          clockFn: (clock) -> clock(-1)

      it "levels get updated on hour change", (done) ->
        shineLevels = [1, 2]
        appViewModel = new AppViewModel()
        appViewModel.mapData.subscribe (data) ->
          testData = _.first(_.flatten(data))
          expect(_.first(testData.shine)).to.be.a('number').and.to.equal(shineLevels.shift())
          if(shineLevels.length is 0)
            done()

          # Async or otherwise event will not be triggered
          setTimeout ->
            appViewModel.clock(14)
          ,
            0

        appViewModel.init
          clockFn: (clock) -> clock(13)

    describe.skip "Gets nearest points", ->
      it "Loads nearest points on load", (done) ->
        appViewModel = new AppViewModel()
        appViewModel.nearestPoints.subscribe (data) ->
          expect(data).to.be.a('array').and.to.have.length(5)
          done()

        appViewModel.init
          clockFn: (clock) -> clock(12)

