# @TODO rename data-source to outdoor seating area or such
define ['lodash', '../scripts/AppViewModel'], (_, AppViewModel) ->
  describe "terde view model tests", ->
    beforeEach ->
      $.mockjax
        url: '/geoproxy'
        contentType: "text/json"
        proxy: 'data/geo.json'

    afterEach ->
      $.mockjaxClear()

    it "initialize model async", (done) ->
      appViewModel = new AppViewModel()

      subscribe = ->
        appViewModel.locationData.subscribe (data) ->
          done()
        appViewModel.init()

      setTimeout subscribe, 0

    it "validate raw data", (done) ->
      appViewModel = new AppViewModel()
      appViewModel.locationData.subscribe (data) ->
        flatData = _.flatten(data)
        expect(flatData).to.be.a('Array').and.to.have.length(4)
        _.each flatData, (POI) ->
          expect(POI()).to.have.keys(['geometry', 'properties', 'type'])

        done()
      appViewModel.init()

    it "validate map data", (done) ->
      appViewModel = new AppViewModel()
      appViewModel.mapData.subscribe (data) ->
        flatData = _.flatten(data)
        _.each flatData, (POI) ->
          expect(POI).to.have.keys(['coordinates', 'description', 'name', 'shine'])
        done()
      appViewModel.init()

    it "validate single point", (done) ->
      appViewModel = new AppViewModel()
      appViewModel.mapData.subscribe (data) ->
        terde1 = _.first(_.flatten(data))
        expect(terde1.name).to.be.a('string').and.to.equal('terde1')
        expect(terde1.description).to.be.a('string').and.to.equal('description of terde1')
        expect(terde1.shine).to.be.a('number').and.to.equal(2)
        expect(terde1.coordinates).to.be.an('array').and.to.equalAsSets([102, 0.5])
        done()

      appViewModel.init
        clockFn: (clock) -> clock(15)

    it "clock test 1", (done) ->
      appViewModel = new AppViewModel()
      appViewModel.mapData.subscribe (data) ->
        testData = _.first(_.flatten(data))
        expect(testData.shine).to.be.a('number').and.to.equal(0)
        done()

      appViewModel.init
        clockFn: (clock) -> clock(12)

    it "clock test 2", (done) ->
      appViewModel = new AppViewModel()
      appViewModel.mapData.subscribe (data) ->
        testData = _.first(_.flatten(data))
        expect(testData.shine).to.be.a('number').and.to.equal(1)
        done()

      appViewModel.init
        clockFn: (clock) -> clock(13)

    it "clock test 3", (done) ->
      appViewModel = new AppViewModel()
      appViewModel.mapData.subscribe (data) ->
        testData = _.first(_.flatten(data))
        expect(testData.shine).to.be.a('number').and.to.equal(2)
        done()

      appViewModel.init
        clockFn: (clock) -> clock(14)

    it "clock test 4(undefined index)", (done) ->
      appViewModel = new AppViewModel()
      appViewModel.mapData.subscribe (data) ->
        testData = _.first(_.flatten(data))
        expect(testData.shine).to.be.a('number').and.to.equal(0)
        done()

      appViewModel.init
        clockFn: (clock) -> clock(-1)