define [
  'knockout'
  'lodash'
],(
  ko
  _
) ->

  validSearchString = (searchString) ->
    _.isString(searchString) and searchString.length > 0

  testPointFunctor = (searchString) ->
    (point) ->
      point.name?.toLowerCase().indexOf(searchString.toLowerCase()) >= 0 or
      point.address?.toLowerCase().indexOf(searchString.toLowerCase()) >= 0

  class TerraceSearch
    constructor: ({mapData, onActivate}) ->
      @criteria = ko.observable()

      @criteriaDelayed = ko.computed(@criteria)
        .extend
          rateLimit:
            method: "notifyWhenChangesStop"
            timeout: 600

      @results = ko.computed =>
        if validSearchString(@criteriaDelayed())
          onActivate?()
          testPoint = testPointFunctor(@criteriaDelayed())
          _.filter mapData(), testPoint
        else
          []
