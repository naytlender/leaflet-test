leafletApp.editMap = ->
  map = L.map('map').setView([51.505, 40.09], 4);

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map);

  drawnItems = new L.featureGroup()
  map.addLayer(drawnItems)
  map.on 'draw:created', (e) ->
    drawnItems.addLayer e.layer

  latlngs = []
  L.geoJson(gon.field_shape,
    onEachFeature: (feature, layer) ->
      latlngs.push(feature.coordinates);
  )

  flip = (array) ->
    for coords, i in array
      array[i] = coords.reverse()

  for latlng in latlngs[0]
    layer = L.polygon(flip(latlng[0]))
    drawnItems.addLayer(layer)

  disableEditing = false
  drawControl = new L.Control.Draw(
    draw: {
      position : 'topleft'
      polygon : {
        drawError : {
          color : '#b00b00',
          timeout : 1000
        },
        shapeOptions : {
          color : '#111111'
        },
      },
      circlemaker: false,
      circle: false,
      marker: false,
      polyline: false
    }
    edit: {
      featureGroup: drawnItems,
      edit: true
    }
  )
  map.addControl(drawControl)

  getJsonCoordinates = (json) ->
    json.geometry.coordinates
  toMultiPolygon = (featureGroup)->
    shapes = { type: 'Feature', properties: {}, geometry:{ type: 'MultiPolygon', coordinates: [] } }
    drawnItems.toGeoJSON().features.forEach (feature) ->
      shapes.geometry.coordinates.push(getJsonCoordinates(feature))
    JSON.stringify(shapes)

  $('#update_field').on 'click', ->
    $('#field_geo_json').val toMultiPolygon(drawnItems)
