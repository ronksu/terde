define ['mapBox'], (L) ->

  init = () ->
    @map = L
      .mapbox.map('map', 'lacation.map-soa2wal6')
      .setView([40, -74.50], 9);

  {init}
