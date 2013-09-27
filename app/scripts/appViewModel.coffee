define ['jquery', 'knockout'], ($, ko) ->
  class terdeViewModel
    constructor: () ->
      @locationData = ko.mapping.fromJS [1]

      @terdeDataMapping =
        key: (item) ->
          item
        create: (data) ->
          ko.observable(data.data.features)

    init: () ->
      # @TODO separate to own component
      mapDataRequest = $.ajax
        url: '/geoproxy'
        dataType: 'json'

      mapDataRequest.done (data) =>
        ko.mapping.fromJS [data], @locationData

      mapDataRequest.fail (jqXHR, textStatus, errorThrown) ->
        # @TODO fail nicely
