canvas = document.getElementById('world')
ctx = canvas.getContext('2d')
h = canvas.height
w = canvas.width
livePixelImageData = ctx.createImageData(1, 1)
deadPixelImageData = ctx.createImageData(1, 1)
lifeMap = []
neighbors = []
neighborsMap = [[-1, -1], [-1, 0], [-1, 1],
                [0, -1],           [0, 1],
                [1, -1],  [1, 0],  [1, 1]]

init = () ->
  for y in [0..(h - 1)]
    for x in [0..(w - 1)]
      pos = y * w + x
      lifeMap[pos] = false
      neighbors[pos] = 0

  for i in [0..2]
    livePixelImageData.data[i] = 0
    deadPixelImageData.data[i] = 255
  livePixelImageData.data[3] = 255

  for i in [1..(h * w >> 3)]
    addPoint Math.floor(Math.random() * w), Math.floor(Math.random() * h)

  iterate 10, ->
    refreshWorld()
  return

addPoint = (x, y) ->
  pos = y * w + x
  if !lifeMap[pos]
    lifeMap[pos] = true
    ctx.putImageData(livePixelImageData, x, y)
    for offset in neighborsMap
      neighbors[(y + offset[1]) * w + (x + offset[0])] += 1
  return

removePoint = (x, y) ->
  pos = y * w + x
  if lifeMap[pos]
    lifeMap[pos] = false
    ctx.putImageData(deadPixelImageData, x, y)
    for offset in neighborsMap
      neighbors[(y + offset[1]) * w + (x + offset[0])] -= 1
  return

iterate = (ms, callback) ->
  setInterval callback, ms

refreshWorld = () ->
  for y in [0..(h - 1)]
    for x in [0..(w - 1)]
      pos = y * w + x
      if lifeMap[pos]
        if !neighbors[pos] || neighbors[pos] <= 1 || neighbors[pos] > 3
          removePoint(x, y)
      else
        if neighbors[pos] == 3
          addPoint(x, y) if Math.random() > 0.18
  return

init()
