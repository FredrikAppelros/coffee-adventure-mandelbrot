mandelbrot = require './mandelbrot'

renderer = undefined

onProgress = (percentage) ->
  postMessage ['progress', percentage]

onmessage = (event) ->
  [type, data] = event.data
  switch type
    when 'create'
      renderer = new mandelbrot.Renderer data.image, data.maxItr
      renderer.on 'progress', onProgress
    when 'calculate'
      values = renderer.calculateRegion data
      postMessage ['result', values]
    when 'render'
      image = renderer.renderImage data
      postMessage ['done', image]

self.onmessage = onmessage
