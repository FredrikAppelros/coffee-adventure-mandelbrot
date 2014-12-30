renderer = require './renderer'
region = require './region'
controls = require './controls'

startX = startY = endX = endY = 0

overlay = document.createElement 'canvas'
overlay.id = 'overlay'
overlay.width = canvas.width
overlay.height = canvas.height
ctx = overlay.getContext '2d'
canvas.parentNode.appendChild overlay

getSelection = ->
  x = Math.min endX, startX
  y = Math.min endY, startY
  w = Math.abs endX - startX
  h = Math.abs endY - startY

  [x, y, w, h]

getRegion = (selection) ->
  currentRegion = region.currentRegion

  [x, y, w, h] = selection

  region.selectedRegion =
    left: x / overlay.width * currentRegion.width + currentRegion.left
    top: y / overlay.height * currentRegion.height + currentRegion.top
    width: w / overlay.width * currentRegion.width
    height: h / overlay.height * currentRegion.height

onMouseDown = (event) ->
  startX = event.layerX
  startY = event.layerY

  overlay.addEventListener 'mousemove', onMouseMove
  overlay.addEventListener 'mouseup', onMouseUp
  overlay.removeEventListener 'mousedown', onMouseDown

onMouseMove = (event) ->
  endX = event.layerX
  endY = event.layerY

  if controls.keepRatio
    ratio = overlay.width / overlay.height

    w = endX - startX
    h = endY - startY

    if (Math.abs(w) / overlay.width) > (Math.abs(h) / overlay.height)
      signX = if w < 0 then -1 else 1
      endX = startX + Math.abs(h) * ratio * signX
    else
      signY = if h < 0 then -1 else 1
      endY = startY + Math.abs(w) / ratio * signY

  selection = getSelection()
  controls.updateControls getRegion selection
  [x, y, w, h] = selection

  ctx.clearRect 0, 0, overlay.width, overlay.height
  ctx.strokeRect x, y, w, h

onMouseUp = (event) ->
  ctx.clearRect 0, 0, overlay.width, overlay.height

  region.currentRegion = region.selectedRegion

  renderer.drawImage()

  overlay.addEventListener 'mousedown', onMouseDown
  overlay.removeEventListener 'mousemove', onMouseMove
  overlay.removeEventListener 'mouseup', onMouseUp

overlay.addEventListener 'mousedown', onMouseDown
