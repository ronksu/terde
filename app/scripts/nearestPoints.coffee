# @TODO remove unnecessary conversions
define ['knockout'], (ko) ->
  toGeoJson = (point) ->
    type: "Feature"
    geometry:
      type: "Point"
      coordinates: point.coordinates

  getNearestPoints = (userPosition, points) ->
    geoJsonLayer = new L.GeoJSON(
      _.map points, toGeoJson
    )

    nearestCoordinates = leafletKnn(geoJsonLayer)
      .nearest([userPosition.lat, userPosition.lng], 5)

    _.map nearestCoordinates, (nearestPoint) ->
      _.first(_.where(points, {coordinates: [nearestPoint.lat], coordinates: [nearestPoint.lon]}))

  ({userLocation, mapData}) ->
    ko.computed =>
      if (userLocation() instanceof L.LatLng) and mapData().length > 0
        getNearestPoints userLocation(), mapData()
      else
        []


