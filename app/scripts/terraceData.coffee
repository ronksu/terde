define [
  'knockout'
  'lodash'
  './terraceDataRequest'
],(
  ko
  _
  terraceDataRequest
) ->
  getShiningLevels = ({levels, currentHour}) ->
    getShineLevel = (accu, hourAdd) ->
      accu.push(parseInt(levels[(currentHour + hourAdd) % 23] ? 0))
      accu

    _.reduce [0..5], getShineLevel, []

  terdeDataMapping =
    create: (data) ->
      _.map data.data.features, (feature) ->
        # @TODO fix here wrong coordinate order in data for now..
        feature.geometry.coordinates.reverse()
        feature.id = _.uniqueId()
        ko.observable feature

  (clock) ->
    rawData = ko.observable()

    mapDataRequest = terraceDataRequest.init()
    mapDataRequest.done (data) =>
      ko.mapping.fromJS [data], terdeDataMapping, rawData

    ko.computed =>
      extractedLocationData = _.flatten(rawData())
      _.map extractedLocationData, (observable) =>
        item = observable()

        id: item.id
        name: item.properties.nimi
        address: item.properties.pisteen_os ? ""
        shine: getShiningLevels({levels:item.properties.shine, currentHour: clock()})
        coordinates: item.geometry.coordinates
