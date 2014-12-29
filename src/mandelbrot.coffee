canvas = document.getElementById 'canvas'
ctx = canvas.getContext '2d'

image = ctx.createImageData canvas.width, canvas.height
w = image.width
h = image.height

max_itr = 1000

palette = chroma.scale('RdYlBu')
  .domain([0, max_itr], max_itr + 1)
  .mode('lab')

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

for y in [0...h]
  for x in [0...w]
    m = mandelbrot x, y
    c1 = palette Math.floor m
    c2 = palette Math.floor m + 1
    c = chroma(chroma.interpolate c1, c2, m % 1, 'lab')
    [r, g, b] = c.rgb()
    idx = (y * w + x) * 4
    image.data[idx + 0] = r
    image.data[idx + 1] = g
    image.data[idx + 2] = b
    image.data[idx + 3] = 255

ctx.putImageData image, 0, 0
