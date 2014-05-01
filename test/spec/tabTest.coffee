# @TODO rename data-source to outdoor seating area or such
define ['lodash', '../scripts/Tabs'], (_, Tabs) ->
  describe "Tabs", ->
    tabs = undefined

    beforeEach ->
      tabs = new Tabs()

    afterEach ->
      tabs = undefined

    assertActiveTab = (tabName) ->
      expect(tabs.tabs()).to.equalAsSetsOfObjects [
        {name: 'nearest', label: 'Lähimmät', active: tabName is 'nearest'}
        {name: 'shiniest', label: 'Porottavimmat', active: tabName is 'shiniestt'}
        {name: 'search', label: 'Hakutulokset', active: tabName is 'search'}
      ], ['name', 'label', 'active']

      expect(tabs.activeTab().name).to.equal(tabName)
      expect(tabs.isVisible('nearest')).to.equal(tabName is 'nearest')
      expect(tabs.isVisible('shiniest')).to.equal(tabName is 'shiniest')
      expect(tabs.isVisible('search')).to.equal(tabName is 'search')

    it "initial state", ->
      assertActiveTab('nearest')

    it "activate tab", (done) ->
      tabs.tabs.subscribe ->
        assertActiveTab('search')
        done()

      tabs.activate(name: 'search')