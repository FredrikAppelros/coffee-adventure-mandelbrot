canvas = document.getElementById 'canvas'
ctx = canvas.getContext '2d'

image = ctx.createImageData canvas.width, canvas.height
w = image.width
h = image.height

max_itr = 1000

ms = new Array w * h
hgram = (0 for i in [0...max_itr])
palette = ([i, i, i] for i in [0..255])

mandelbrot = (px, py) ->
  x0 = px / w * 3.5 - 2.5
  y0 = py / h * 2 - 1
  x = 0
  y = 0
  itr = 0
  while x * x + y * y < 2 * 2 and itr < max_itr
    tx = x * x - y * y + x0
    y = 2 * x * y + y0
    x = tx
    itr++
  itr - 1

render = (idx) ->
  hue = 0
  for i in [0..ms[idx]]
    hue += hgram[i]
  hue = Math.round hue / (w * h) * 255
  [r, g, b] = palette[hue]
  image.data[idx * 4 + 0] = r
  image.data[idx * 4 + 1] = g
  image.data[idx * 4 + 2] = b
  image.data[idx * 4 + 3] = 255

for y in [0...h]
  for x in [0...w]
    m = mandelbrot x, y
    ms[y * w + x] = m
    hgram[m]++

for i in [0...ms.length]
  render i

ctx.putImageData image, 0, 0
