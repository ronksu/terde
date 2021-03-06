define ['lodash', './terraceMarker'], (_, terraceMarker) ->

  updateDataPoints = (layer, points) ->
    # @TODO optimize to update only changed layers
    layer.clearLayers();

    _.each points, (point) ->
      # TODO extract functionality, dont make dupes out of icons
      icon = L.icon
        iconUrl: switch _.first(point.shine).level
          when 3 then 'images/sunsymbol_131113.png'
          when 2 then 'images/sunsymbol_131113.png'
          when 1 then 'images/partialshadesymbol_131113.png'
          else 'images/shadesymbol_131113.png'
        iconSize: [45, 64]
        iconAnchor: [21, 51]
        popupAnchor: [10, -32]
      layer
        .addLayer terraceMarker(point.coordinates, {icon, id: point.id})
          .bindPopup(
            "<b>#{point.name}</b><br>#{point.address}",
            autoPan: false
            zoomAnimation: false
          )
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
      .map(
        'map', 
        'https://api.mapbox.com/styles/v1/lacation/ckbt6weka0lvh1iohkmi70548/?fresh=true&access_token=pk.eyJ1IjoibGFjYXRpb24iLCJhIjoiSk1xbWNhVSJ9.TRkpQuh19OOgq5Bl-AZz1g',
        {accessToken: 'pk.eyJ1IjoibGFjYXRpb24iLCJhIjoiSk1xbWNhVSJ9.TRkpQuh19OOgq5Bl-AZz1g'}
      )
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
