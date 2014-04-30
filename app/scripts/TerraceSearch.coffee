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
    constructor: ({mapData}) ->
      @criteria = ko.observable()
      @results = ko.computed =>
        if validSearchString(@criteria())
          testPoint = testPointFunctor(@criteria())
          _.filter mapData(), testPoint
        else
          []
