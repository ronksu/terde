define [],() ->

  TerraceMarker = L.Marker.extend
    options:
      id: 'TerraceId'

  (coordinates, options) ->
    new TerraceMarker(coordinates, options)
