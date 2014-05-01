define [
  'knockout'
  'lodash'
],(
  ko
  _
) ->

  class Tabs
    constructor: () ->
      @tabs = ko.observable [
        {name: 'nearest', label: 'Lähimmät', active: true}
        {name: 'shiniest', label: 'Porottavimmat', active: false}
        {name: 'search', label: 'Hakutulokset', active: false}
      ]

      @activeTab = ko.computed =>
        _.where(@tabs(), {active: true})[0]

      @activate = (tab) =>
        activateTab = (tabItem) ->
          tabItem.active = tabItem.name is tab.name
          tabItem

        @tabs(_.map(@tabs.peek(), activateTab))

      @isVisible = (name) =>
        _.where(@tabs(), {name})[0].active
