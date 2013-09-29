define ['jquery', 'knockout', 'lodash'], ($, ko, _) ->
  class terdeViewModel
    constructor: () ->
      @locationData = ko.observable()

      @terdeDataMapping =
        key: (item) ->
          item
        create: (data) ->
          _.map data.data.features, (feature) ->
            ko.observable feature

    init: () ->
      # @TODO separate to own component
      mapDataRequest = $.ajax
        url: '/geoproxy'
        dataType: 'json'

      mapDataRequest.done (data) =>
        ko.mapping.fromJS [data], @terdeDataMapping, @locationData

      mapDataRequest.fail (jqXHR, textStatus, errorThrown) ->
        # @TODO fail nicely
