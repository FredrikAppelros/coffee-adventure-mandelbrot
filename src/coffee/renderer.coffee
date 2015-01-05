mandelbrot = require './mandelbrot'
region = require './region'

canvas = document.getElementById 'canvas'
progress = document.getElementById 'progress'

ctx = canvas.getContext '2d'

maxItr = 1000
numWorkers = 8
workerHeight = canvas.height / numWorkers

numResults = 0
numDone = 0
sumPercentages = 0
start = 0

workers = []
values = []
images = []

renderImage = ->
  progress.style.width = '0%'

  numResults = 0
  numDone = 0
  sumPercentages = 0

  values = []

  start = new Date().getTime()

  workerRegionHeight = region.currentRegion.height / numWorkers
  for worker, i in workers
    subRegion =
      left: region.currentRegion.left
      top: i * workerRegionHeight + region.currentRegion.top
      width: region.currentRegion.width
      height: workerRegionHeight

    worker.postMessage ['calculate', subRegion]

processValues = ->
  hgram = (0 for i in [0...maxItr])
  hgram[Math.round v]++ for v in values

  worker.postMessage ['render', hgram] for worker in workers

drawImage = ->
  for image, i in images
    ctx.putImageData image, 0, i * workerHeight

  end = new Date().getTime()
  console.log 'Time elapsed:', end - start, 'ms'

reportProgress = (percentage) ->
  sumPercentages += percentage
  progress.style.width = sumPercentages / numWorkers + '%'

for i in [0...numWorkers]
  do (i) ->
    image = ctx.createImageData canvas.width, workerHeight

    data =
      image: image
      maxItr: maxItr

    worker = new Worker 'js/worker.min.js'
    worker.postMessage ['create', data]
    workers[i] = worker

    worker.onmessage = (event) ->
      [type, data] = event.data
      switch type
        when 'progress' then reportProgress data
        when 'result'
          values = values.concat data
          processValues() if ++numResults == numWorkers
        when 'done'
          images[i] = data
          drawImage() if ++numDone == numWorkers

exports.renderImage = renderImage
