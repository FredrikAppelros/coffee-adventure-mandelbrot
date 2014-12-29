canvas = document.getElementById 'canvas'
ctx = canvas.getContext '2d'
image = ctx.createImageData canvas.width, canvas.height

w = image.width
h = image.height
num_pixels = w * h
max_itr = 1000

ms = new Array num_pixels
hgram = (0 for i in [0...max_itr])

palette = chroma.scale('RdYlBu')

mandelbrot = (px, py) ->
  x0 = px / w * 3.5 - 2.5
  y0 = py / h * 2 - 1
  x = 0
  y = 0
  itr = 0
  while x * x + y * y < (1 << 16) and itr < max_itr
    tx = x * x - y * y + x0
    y = 2 * x * y + y0
    x = tx
    itr++
  if itr < max_itr
    zn = Math.sqrt x * x + y * y
    nu = Math.log(Math.log zn / Math.log 2) / Math.log 2
    itr = itr + 1 - nu
  itr - 1

render = (idx) ->
  level = Math.floor ms[idx] + 1
  phue = hue = 0
  for i in [0..level]
    phue = hue
    hue += hgram[i]
  c1 = palette(phue / num_pixels)
  c2 = palette(hue / num_pixels)
  c = chroma(chroma.interpolate c1, c2, ms[idx] % 1)
  [r, g, b] = c.rgb()
  image.data[idx * 4 + 0] = r
  image.data[idx * 4 + 1] = g
  image.data[idx * 4 + 2] = b
  image.data[idx * 4 + 3] = 255

for y in [0...h]
  for x in [0...w]
    m = mandelbrot x, y
    ms[y * w + x] = m
    hgram[Math.round m]++

for i in [0...ms.length]
  render i


ctx.putImageData image, 0, 0
