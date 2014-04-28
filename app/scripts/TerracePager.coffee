define [
  'knockout'
  'lodash'
],(
  ko
  _
) ->
  ITEMS_ON_PAGE = 5

  class TerracePager
    constructor: ({results}) ->
      currentPage = ko.observable(1)

      pageCount = ko.computed =>
        currentPage(1)
        Math.ceil(results().length / ITEMS_ON_PAGE)

      changePage = (number) ->
        previousPage = currentPage()
        currentPage(previousPage + number)

      @pageData = ko.computed =>
        offset = (currentPage() - 1)*(ITEMS_ON_PAGE)
        results().slice(offset, offset+ITEMS_ON_PAGE)

      @visible = ko.computed =>
        pageCount() > 1

      @nextDisabled = ko.computed =>
        currentPage() is pageCount()

      @previousDisabled = ko.computed =>
        currentPage() is 1

      @next = =>
        if not @nextDisabled()
          changePage(1)

      @previous = =>
        if not @previousDisabled()
          changePage(-1)

