mandelbrot = require './mandelbrot'

renderer = undefined

onProgress = (percentage) ->
  postMessage ['progress', percentage]

onmessage = (event) ->
  [type, data] = event.data
  switch type
    when 'create'
      renderer = new mandelbrot.Renderer data
      renderer.on 'progress', onProgress
    when 'render'
      image = renderer.renderImage data
      postMessage ['render', image]

self.onmessage = onmessage
