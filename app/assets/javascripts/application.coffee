#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require leaflet/dist/leaflet
#= require leaflet-draw/dist/leaflet.draw
#= require_self
#= require_tree .

L.Icon.Default.imagePath = '/assets';

window.leafletApp = {}
$(document).ready ->
