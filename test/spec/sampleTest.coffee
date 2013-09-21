define [], () ->
  describe "Test set template", ->
    it "test assert", ->
      expect(0).to.equal(0)

  describe "Ajax mock test", ->
    beforeEach ->
      $.mockjax
        url: '/foo',
        contentType: "text/json"
        responseText: { bar: 42 }

      $.mockjax
        url: '/geoproxy',
        contentType: "text/json"
        proxy: 'data/geo.json'

    afterEach ->
      $.mockjaxClear()

    it "test assert", (done) ->
      request = $.ajax
        url: '/foo'
        dataType: 'json'

      request.done (data) ->
        expect(data).to.be.an('object').and.to.deep.equal({bar: 42})
        done()

    it "proxy test", (done) ->
      request = $.ajax
        url: '/geoproxy'
        dataType: 'json'

      request.done (data) ->
        done()


