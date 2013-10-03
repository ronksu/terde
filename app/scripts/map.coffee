define ['mapBox', 'lodash'], (L, _) ->
  @map
  init = () ->
    position = undefined
    map = L
      .mapbox
      .map('map', 'lacation.map-soa2wal6')
      .setView([60.1708, 24.9375], 12)
      .locate({setView: false, watch: true})
      .on 'locationfound', (e) ->
        # radius = e.accuracy / 4?
        if _.isUndefined position
          position = L.circleMarker(e.latlng, {
            radius: 5,
            color: '#fff',
            opacity: 1,
            weight: 2,
            fillColor: '#000',
            fillOpacity: 0.6
          })
          .addTo(map)
        else
          position.setLatLng(e.latlng)

        # @TODO set zooming to show e.g. 10 nearest?
        map.setView(e.latlng, 18)
      .on 'locationerror', (err) ->
        # @TODO initial helsinki is fine?

    @map = map

  {init}
