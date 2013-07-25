blockGame = ->
  #canvas library
  circle = (x,y,r) ->
    ctx.beginPath()
    ctx.arc(x,y,r,0,Math.PI*2, true)
    ctx.fill()
    
  rect = (x,y,w,h) ->
    ctx.beginPath()
    ctx.rect(x,y,w,h)
    ctx.closePath()
    ctx.fill()

  text = (str,x,y) ->
    ctx.font = "bold 50px 'Arial'";
    ctx.textAlign = 'center'
    ctx.fillText(str,x,y)
  
  clear = ->
    # ctx.clearRect(0,0,WIDTH,HEIGHT)
    ctx.fillStyle = "#EEEEEE"
    rect(0,0,WIDTH,WIDTH)
    ctx.fillStyle = "#000000"
    ctx.strokeStyle = "#000000"

  # var
  canvas = document.getElementById("block")
  ctx = canvas.getContext("2d")
  WIDTH = canvas.width
  HEIGHT = canvas.height
  rightDown = false
  leftDown = false

  #interface
  document.onkeydown = (e) ->
    if(e.keyCode is 39) then rightDown = true
    if(e.keyCode is 37) then leftDown = true
  document.onkeyup =(e) ->
    if(e.keyCode is 39) then rightDown = false
    if(e.keyCode is 37) then leftDown = false
  canvas.onmousemove = (e) ->
    Paddle::move(e.offsetX)

  #object
  class Ball
    constructor:(@x,@y,@r) ->
      @dx = 2
      @dy = 4
    draw: ->
      circle(@x, @y, @r)
    move: ->
      @x += @dx
      @y += @dy
    collision: (blocks)->
      if (res = Block::hit(@x,@y)) isnt false
        if blocks[res].exist
          @dy = -@dy
          blocks[res].destory()
    bound: ->
      if(@x + @dx > WIDTH or @x  + @dx < 0 )
        @dx = -@dx
      if(@y + @dy < 0)
        @dy = -@dy
      else if(@y + @dy > HEIGHT )
        if(Paddle::hit(this))
          @dx = (@x-(Paddle::x+Paddle::w/2))/Paddle::w*8
          @dy = -@dy
        else
          gameOver()

  class Paddle
    x: WIDTH/2
    h: 10
    w: 90
    d: 3
    draw: ->
      rect(@x,HEIGHT-@h,@w,@h)
    hit: (ball) ->
      ball.x > @x and ball.x < @x + @w
    rightMove: ->
      @x += @d
    leftMove: ->
      @x -= @d
    move: (x) ->
      @x = x - @w/2

  class Block
    ROWS: 5
    COLS: 5
    PADDING: 1
    WIDTH: (WIDTH/this::COLS) - 1
    HEIGHT: 15
    @SIZE: this::ROWS * this::COLS - 1
    constructor: (@x,@y) ->
      @exist = true
    draw: ->
      rect(@x * (@WIDTH + @PADDING) + @PADDING,@y * (@HEIGHT + @PADDING) + @PADDING,@WIDTH,@HEIGHT)
    destory: ->
      @exist = false
      Block.SIZE--
    hit: (x,y) ->
      height = @HEIGHT + @PADDING
      width = @WIDTH + @PADDING
      row = Math.floor(y/height)
      col = Math.floor(x/width)
      if(0 <= row and row < @ROWS and 0 <= col and col < @COLS) then row * @ROWS + col
      else false

  # initialize
  blocks = new Array(Block::SIZE)
  [0..Block.SIZE].forEach (i) ->
    blocks[i] = new Block(i % Block::ROWS, Math.floor(i / Block::ROWS))
  ball = new Ball(150,150,5)
  
  #main
  run = ->
    clear()
    ball.draw()

    if(rightDown) then Paddle::rightMove()
    if(leftDown) then Paddle::leftMove()
    Paddle::draw()

    #only existing ball is drawed
    blocks.forEach (block) ->
      block.draw() if block.exist

    #check collision
    ball.collision(blocks)
    gameClear() if Block.SIZE is -1
    ball.bound()
    ball.move()

  intervalId = setInterval(run,10)

  gameOver = ->
    clearInterval(intervalId)
    clear()
    text("Game Over",WIDTH/2,HEIGHT/2)

  gameClear = ->
    clearInterval(intervalId)
    clear()
    text("Clear!",WIDTH/2,HEIGHT/2)


window.addEventListener("load",blockGame,false)

