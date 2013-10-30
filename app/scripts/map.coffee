define ['lodash', './terraceMarker'], (_, terraceMarker) ->

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
        popupAnchor: [10, -32]
      layer
        .addLayer terraceMarker(point.coordinates, {icon, id: point.id})
          .bindPopup("<b>#{point.name}</b><br>#{point.address}")
      #@TODO templatize.

  initDataLayer = (map, mapData) ->
    dataLayer = L
      .layerGroup()
      .addTo(map)

    updateDataPoints(dataLayer, mapData())

    mapData.subscribe (points) ->
      updateDataPoints(dataLayer, points)

    dataLayer

  initShowSelectedTerrace = (map, dataLayer, selectedTerrace) ->
    selectedTerrace.subscribe (terrace) ->
      selectedTerraceMarker =
        _.find(
          dataLayer.getLayers(),
          (marker) ->
            marker.options.id is terrace.id
        )

      if selectedTerraceMarker
        selectedTerraceMarker.openPopup()
        map.setView(selectedTerraceMarker.getLatLng(), 16)

  init = ({mapData, userLocation, selectedTerrace}) ->
    position = undefined
    map = L
      .mapbox
      .map('map', 'lacation.map-soa2wal6')
      .setView([60.1708, 24.9375], 12)
      .locate({setView: false, watch: true})
      .on 'locationfound', (e) ->
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
          map.setView(e.latlng, 15)
          userLocation(e.latlng)
        else
          position.setLatLng(e.latlng)

    dataLayer = initDataLayer(map, mapData)
    initShowSelectedTerrace(map, dataLayer, selectedTerrace)

  {init}
