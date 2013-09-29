define ['mapBox'], (L) ->
  @map
  init = () ->
    map = L
      .mapbox
      .map('map', 'lacation.map-soa2wal6')
      .setView([60.1708, 24.9375], 12)
      .locate({setView: false, watch: true})
      .on 'locationfound', (e) ->
        # radius = e.accuracy / 4?
        L.circle(e.latlng, 2, {
          color: '#fff',
          opacity: 1,
          weight: 2,
          fillColor: '#000',
          fillOpacity: 0.6
        })
        .addTo(map)

        # @TODO set zooming to show e.g. 10 nearest?
        map.setView(e.latlng, 18)
      .on 'locationerror', (err) ->
        # @TODO initial helsinki is fine?



    @map = map

  {init}
