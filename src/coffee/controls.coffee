renderer = require './renderer'
region = require './region'

keepRatio = true

left = document.getElementById 'left'
top = document.getElementById 'top'
width = document.getElementById 'width'
height = document.getElementById 'height'
ratio = document.getElementById 'ratio'
reset = document.getElementById 'reset'

updateControls = (region) ->
  left.value = region.left
  top.value = region.top
  width.value = region.width
  height.value = region.height

onRatioChange = ->
  keepRatio = not keepRatio

onResetClick = ->
  region.currentRegion = region.defaultRegion
  renderer.renderImage()
  updateControls region.currentRegion

ratio.addEventListener 'change', onRatioChange
reset.addEventListener 'click', onResetClick

Object.defineProperty exports, 'keepRatio',
  get: -> keepRatio
  set: (newValue) -> keepRatio = newValue

exports.updateControls = updateControls
