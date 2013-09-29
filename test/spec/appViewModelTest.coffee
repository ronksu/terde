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

    it "validate data", (done) ->
      appViewModel = new AppViewModel()
      appViewModel.locationData.subscribe (data) ->
        flatData = _.flatten(data)
        expect(flatData).to.be.a('Array').and.to.have.length(4)
        _.each flatData, (POI) ->
          expect(POI()).to.have.keys(['geometry', 'properties', 'type'])

        done()
      appViewModel.init()

