define ['lodash', 'knockout','../scripts/TerraceSearch'], (_, ko, TerraceSearch) ->
  mapData = false
  nearestPoints =  false

  generatePointFunctor = (prefix) ->
    (accu, value, key) ->
      accu.push
        name: "#{prefix}#{key}"
        address: "#{prefix}#{key}address"
      accu

  beforeEach ->
    mapData = ko.observable(_.reduce [1..20], generatePointFunctor('data'), [])
    nearestPoints = ko.observable(_.reduce [1..5], generatePointFunctor('nearest'), [])

  expectDefaultSearchResults = (data) ->
    expect(data).to.be.a('Array').and.to.have.length(5)
    for i in [0..4]
      do (i) ->
        expect(data[i].name).to.be.a('String').and.to.equal("nearest#{i}")
        expect(data[i].address).to.be.a('String').and.to.equal("nearest#{i}address")

  describe "Terrace search", ->
    it "returns nearest points on init", (done) ->
      search = new TerraceSearch({mapData, nearestPoints})
      search.results.subscribe (data) ->
        expectDefaultSearchResults(data)
        done()

      search.results.notifySubscribers(search.results())

    it "does not return new set on mapData change", ->
      search = new TerraceSearch({mapData, nearestPoints})
      search.results.subscribe (data) ->
        fail('results changed')
      mapData([])
      expectDefaultSearchResults(nearestPoints())

    it "returns matching search results on search string change", (done) ->
      search = new TerraceSearch({mapData, nearestPoints})
      search.results.subscribe (data) ->
        expect(data).to.be.a('Array').and.to.have.length(1)
        expect(data[0].name).to.be.a('String').and.to.equal("data0")
        expect(data[0].address).to.be.a('String').and.to.equal("data0address")
        done()

      search.criteria("data0")

    it "returns nearest when search string cleared", (done) ->
      search = new TerraceSearch({mapData, nearestPoints})
      search.criteria("data0")

      search.results.subscribe (data) ->
        expectDefaultSearchResults(nearestPoints())
        done()

      search.criteria("")

    it "sets correct titles", () ->
      search = new TerraceSearch({mapData, nearestPoints})
      expect(search.resultTitle()).to.be.a('String').and.to.equal('Lähimmät terassit')
      search.criteria("asd")
      expect(search.resultTitle()).to.be.a('String').and.to.equal('Hakutulokset')
      search.criteria("")
      expect(search.resultTitle()).to.be.a('String').and.to.equal('Lähimmät terassit')

