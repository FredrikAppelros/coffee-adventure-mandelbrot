mandelbrot = require './mandelbrot'
region = require './region'

canvas = document.getElementById 'canvas'

renderer = new mandelbrot.Renderer canvas

drawImage = ->
  start = new Date().getTime()

  renderer.renderImage region.currentRegion

  end = new Date().getTime()

  console.log 'Time elapsed:', end - start, 'ms'

exports.drawImage = drawImage
