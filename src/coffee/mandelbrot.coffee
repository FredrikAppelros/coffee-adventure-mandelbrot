chroma = require 'chroma-js'
events = require 'events'

class Renderer extends events.EventEmitter
  constructor: (@image, @maxItr = 1000, @palette = chroma.scale 'RdYlBu') ->
    @width = @image.width
    @height = @image.height
    @numPixels = @width * @height
    @colorCache = {}

    # Set the alpha channel for all pixels in the image
    @image.data[i * 4 + 3] = 255 for i in [0...@numPixels]

  mandelbrot: (region, px, py) ->
    x0 = px / @width * region.width + region.left
    y0 = py / @height * region.height + region.top
    x = 0
    y = 0

    itr = 0
    while x * x + y * y < (1 << 16) and itr < @maxItr
      tx = x * x - y * y + x0
      y = 2 * x * y + y0
      x = tx
      itr++

    if itr < @maxItr
      zn = Math.sqrt x * x + y * y
      nu = Math.log(Math.log zn / Math.log 2) / Math.log 2
      itr = itr + 1 - nu

    itr - 1

  renderPixel: (idx) ->
    v = @values[idx]
    c = @colorCache[v]

    unless c?
      level = Math.floor v + 1
      phue = hue = 0
      for i in [0..level]
        phue = hue
        hue += @hgram[i]

      c1 = @palette(phue / @numPixels)
      c2 = @palette(hue / @numPixels)
      c = chroma(chroma.interpolate c1, c2, v % 1)
      @colorCache[v] = c

    [r, g, b] = c.rgb()
    @image.data[idx * 4 + 0] = r
    @image.data[idx * 4 + 1] = g
    @image.data[idx * 4 + 2] = b

  renderImage: (region) ->
    @values = new Array @numPixels
    @hgram = (0 for i in [0...@maxItr])

    for y in [0...@height]
      for x in [0...@width]
        v = @mandelbrot region, x, y
        @values[y * @width + x] = v
        @hgram[Math.round v]++

    lastProgress = 0
    for i in [0...@numPixels]
      @renderPixel i

      if i % 100 == 0
        currentProgress = Math.round 100 * i / @numPixels
        if currentProgress > lastProgress
          @emit 'progress', currentProgress
          lastProgress = currentProgress

    @image

exports.Renderer = Renderer
