renderer = require './renderer'
region = require './region'
zoom = require './zoom'
controls = require './controls'

renderer.renderImage()
controls.updateControls region.currentRegion
