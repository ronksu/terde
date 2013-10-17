define ['lodash'], (_) ->

  updateDataPoints = (layer, points) ->
    # @TODO optimize to update only changed layers
    layer.clearLayers();

    _.each points, (point) ->
      # TODO extract functionality, dont make dupes out of icons
      icon = L.icon
        iconUrl: switch _.first(point.shine)
          when 3 then 'images/sunsymbol.svg'
          when 2 then 'images/sunsymbol.svg'
          when 1 then 'images/partialshadesymbol.svg'
          else 'images/shadesymbol.svg'
        iconSize: [45, 64]
        iconAnchor: [21, 51]
        popupAnchor: [10, -32] #-24, 62
      layer.addLayer(L.marker(point.coordinates))
      layer
        .addLayer L
          .marker(point.coordinates, {icon})
          .bindPopup("<b>#{point.name}</b><br>#{point.address}")
      #@TODO templatize.

  initDataLayer = (map, mapData) ->
    dataLayer = L
      .layerGroup()
      .addTo(map)

    updateDataPoints(dataLayer, mapData())

    mapData.subscribe (points) ->
      updateDataPoints(dataLayer, points)

  init = (mapData, userLocation) ->
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
        # @TODO set zooming to show e.g. 10 nearest?
          map.setView(e.latlng, 16)
          userLocation(e.latlng)
        else
          position.setLatLng(e.latlng)
      .on 'locationerror', (err) ->
        # @TODO initial helsinki is fine?

    initDataLayer(map, mapData)

  {init}
