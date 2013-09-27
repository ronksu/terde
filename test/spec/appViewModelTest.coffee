# @TODO rename data-source to outdoor seating area or such
define ['../scripts/AppViewModel'], (AppViewModel) ->
  describe "terde view model tests", ->
    beforeEach ->
      $.mockjax
        url: '/geoproxy'
        contentType: "text/json"
        proxy: 'data/geo.json'

    afterEach ->
      $.mockjaxClear()

    it "initialize model", (done) ->
      appViewModel = new AppViewModel()

      subscribe = ()->
        appViewModel.locationData.subscribe (data) ->
          done()
        appViewModel.init()

      setTimeout subscribe, 0
