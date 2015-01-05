mandelbrot = require './mandelbrot'
region = require './region'

canvas = document.getElementById 'canvas'
progress = document.getElementById 'progress'

ctx = canvas.getContext '2d'
image = ctx.createImageData canvas.width, canvas.height

worker = new Worker 'js/worker.min.js'
worker.postMessage ['create', image]

start = 0

worker.onmessage = (event) ->
  [type, data] = event.data
  switch type
    when 'render'
      ctx.putImageData data, 0, 0
      end = new Date().getTime()
      console.log 'Time elapsed:', end - start, 'ms'
    when 'progress' then reportProgress data

drawImage = ->
  start = new Date().getTime()
  progress.style.width = '0%'
  worker.postMessage ['render', region.currentRegion]

reportProgress = (percentage) ->
  progress.style.width = percentage + '%'

exports.drawImage = drawImage
