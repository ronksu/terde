define ['lodash', 'knockout','../scripts/TerraceSearch'], (_, ko, TerraceSearch) ->
  mapData = false

  generatePointFunctor = (prefix) ->
    (accu, value, key) ->
      accu.push
        name: "#{prefix}#{key}"
        address: "#{prefix}#{key}address"
      accu

  beforeEach ->
    mapData = ko.observable(_.reduce [1..20], generatePointFunctor('data'), [])

  expectDefaultSearchResults = (data) ->
    expect(data).to.be.a('Array').and.to.have.length(0)

  describe "Terrace search", ->
    it "returns empty on init", (done) ->
      search = new TerraceSearch({mapData})
      search.results.subscribe (data) ->
        expectDefaultSearchResults(data)
        done()

      search.results.notifySubscribers(search.results())

    it "does not return new set on mapData change", ->
      search = new TerraceSearch({mapData})
      search.results.subscribe (data) ->
        fail('results changed')
      mapData([])
      expectDefaultSearchResults([])

    it "returns matching search results on search string change", (done) ->
      search = new TerraceSearch({mapData})
      search.results.subscribe (data) ->
        expect(data).to.be.a('Array').and.to.have.length(1)
        expect(data[0].name).to.be.a('String').and.to.equal("data0")
        expect(data[0].address).to.be.a('String').and.to.equal("data0address")
        done()

      search.criteria("data0")

    it "returns nearest when search string cleared", (done) ->
      search = new TerraceSearch({mapData})
      search.criteria("data0")

      search.results.subscribe (data) ->
        expectDefaultSearchResults(data)
        done()

      search.criteria("")

    it "activate callback is called on search string change", (done) ->
      search = new TerraceSearch({mapData, onActivate: () -> done()})
      search.criteria("data0")
