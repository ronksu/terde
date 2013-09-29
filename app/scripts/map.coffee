define ['mapBox'], (L) ->
  @map
  init = () ->
    map = L
      .mapbox
      .map('map', 'lacation.map-soa2wal6')
      .setView([60.1708, 24.9375], 12)
      .locate({setView: true, watch: true})
      .on 'locationfound', (e) ->
        # radius = e.accuracy / 4?
          L.circle(e.latlng, 1, {
            color: '#fff',
            opacity: 1,
            weight: 1,
            fillColor: '#000',
            fillOpacity: 0.6
          })
          .addTo(map)

    @map = map

  {init}
