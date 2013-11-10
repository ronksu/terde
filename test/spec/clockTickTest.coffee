define ['lodash', 'knockout','../scripts/clockTick'], (_, ko, clockTick) ->
  describe "Clock tick", ->
    it "returns current clock", (done) ->
      clock = ko.observable()

      clockTick({clock, interval: 0})

      clock.subscribe (hour) ->
        expect(hour).to.be.a('number').and.to.equal((new Date()).getHours())
        done()

    it "gets clock from URL", (done) ->
      clock = ko.observable()

      clockTick({clock, customUrl: 'http://locahost/daa#clock=15'})

      clock.subscribe (hour) ->
        expect(hour).to.be.a('number').and.to.equal(15)
        done()

    it "gets clock from URL #2", (done) ->
      clock = ko.observable()

      clockTick({clock, interval: 0,customUrl: 'http://locahost/daa#clock=asdasdsa'})

      clock.subscribe (hour) ->
        expect(hour).to.be.a('number').and.to.equal((new Date()).getHours())
        done()

    it "gets clock from given clock function", (done) ->
      clock = ko.observable()
      clockFn = (clock) -> clock(12)

      clockTick({clockFn, clock})

      clock.subscribe (hour) ->
        expect(hour).to.be.a('number').and.to.equal(12)
        done()

