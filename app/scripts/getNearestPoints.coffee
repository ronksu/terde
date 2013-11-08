# @TODO test!, remove unnecessary conversions, etc..
define [], () ->
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

