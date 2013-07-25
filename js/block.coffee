blockGame = ->
  x = 150
  y = 150
  dx = 2
  dy = 4
  block = document.getElementById("block")
  ctx = block.getContext("2d")
  WIDTH = block.width
  HEIGHT = block.height
  rightDown = false
  leftDown = false

  circle = (x,y,r) ->
    ctx.beginPath()
    ctx.arc(x,y,r,0,Math.PI*2, true)
    ctx.fill()
  
  rect = (x,y,w,h) ->
    ctx.beginPath()
    ctx.rect(x,y,w,h)
    ctx.closePath()
    ctx.fill()

  clear = ->
    # ctx.clearRect(0,0,WIDTH,HEIGHT)
    ctx.fillStyle = "#EEEEEE"
    rect(0,0,WIDTH,WIDTH)
    ctx.fillStyle = "#000000"

  class Paddle
    x: WIDTH/2
    h: 10
    w: 90
    d: 3
    draw: ->
      rect(@x,HEIGHT-@h,@w,@h)
    hit: (x) ->
      x > @x and x < @x + @w
    rightMove: ->
      @x += @d
    leftMove: ->
      @x -= @d
  
  # start code
  document.onkeydown = (e) ->
    if(e.keyCode is 39) then rightDown = true
    if(e.keyCode is 37) then leftDown = true
  document.onkeyup =(e) ->
    if(e.keyCode is 39) then rightDown = false
    if(e.keyCode is 37) then leftDown = false
  draw = ->
    clear()
    circle(x,y,10)
    Paddle::draw()
    if(rightDown) then Paddle::rightMove()
    if(leftDown) then Paddle::leftMove()

    if(x + dx > WIDTH or x + dx < 0 )
      dx = -dx
    if(y + dy < 0)
      dy = -dy
    else if(y + dy > HEIGHT)
      if(Paddle::hit(x))
        dy = -dy
      else
        clearInterval(intervalId)
    x += dx
    y += dy
  
  intervalId = setInterval(draw,10)

window.addEventListener("load",blockGame,false)

