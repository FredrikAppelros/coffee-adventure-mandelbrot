renderer = require './renderer'
region = require './region'
zoom = require './zoom'
controls = require './controls'

renderer.drawImage()
controls.updateControls region.currentRegion
