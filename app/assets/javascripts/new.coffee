leafletApp.newShape = ->
  map = L.map('map').setView([51.505, -0.09], 4)

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map)

  drawnItems = new L.FeatureGroup()
  map.addLayer(drawnItems)

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
      circle: false,
      marker: false,
      polyline: false
    }
    edit: featureGroup: drawnItems
  )
  map.addControl(drawControl)

  shapes = { type: 'Feature', properties: {}, geometry:{ type: 'MultiPolygon', coordinates: [] } }
  map.on 'draw:created', (e) ->
    layer = e.layer
    drawnItems.addLayer layer
    shapes.geometry.coordinates.push layer.toGeoJSON().geometry.coordinates
    $('#create_field').on 'click', ->
      $('#field_geo_json').val(JSON.stringify(shapes))
