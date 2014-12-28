canvas = document.getElementById 'canvas'
ctx = canvas.getContext '2d'

image = ctx.createImageData canvas.width, canvas.height
w = image.width
h = image.height

render = (x, y) ->
  v = y / h * 255
  [v, v, v]

for y in [0...h]
  for x in [0...w]
    idx = (y * w + x) * 4
    [r, g, b] = render x, y
    image.data[idx] = r
    image.data[idx + 1] = g
    image.data[idx + 2] = b
    image.data[idx + 3] = 255

ctx.putImageData image, 0, 0
