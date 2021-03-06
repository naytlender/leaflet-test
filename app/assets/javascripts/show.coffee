leafletApp.showMap = ->
  map = L.map('map').setView([51.505, 60.09], 4);

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map);

  drawnItems = new L.FeatureGroup()
  map.addLayer(drawnItems)

  drawnItems = L.geoJson(gon.field_shape,
    style: color: "#666666"
    onEachFeature: (feature, layer) ->
      layer.on 'click', ->
        console.log 'clicked'
      layer.on 'mouseover', (e) ->
        layer.setStyle color: 'red'
      layer.on 'mouseout', (e) ->
        layer.setStyle color: '#666666'
      L.marker(layer.getBounds().getCenter()).addTo(map).bindPopup(feature.properties.name)
  ).addTo(map)
