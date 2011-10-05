
require "util"

Graphics = {
  gameWidth = 320,
  gameHeight = 240,
  tileBounds = Util.strict {},
  tileFilename = "tileset.png",
  spriteFilename = "sprites.png",
  fontFilename = "wayfont.png",
  tiles = {},
  sprites = {},
  fontset = [==[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]==],
}
Graphics.xScale = math.floor(love.graphics.getWidth() / Graphics.gameWidth)
Graphics.yScale = math.floor(love.graphics.getHeight() / Graphics.gameHeight)

WHITE = Util.strict { 255, 255, 255, 255 }
GRAY = Util.strict { 144, 144, 144, 255 }

function Graphics.init()
  love.graphics.setColorMode("modulate")
  love.graphics.setBlendMode("alpha")
  Graphics.loadFont(Graphics.fontFilename)
  Graphics.loadTileset(Graphics.tileFilename)
  Graphics.loadSprites(Graphics.spriteFilename)
end

function Graphics.loadTileset(name)
  Graphics.tilesetImage = love.graphics.newImage(name)
  Graphics.tilesetImage:setFilter("nearest", "nearest")
  local sw, sh = Graphics.tilesetImage:getWidth(), Graphics.tilesetImage:getHeight()
  local i = 1
  for y = 0, sh-1, 16 do
    for x = 0, sw-1, 16 do
      Graphics.tiles[i] = love.graphics.newQuad(x, y, 16, 16, sw, sh)
      i = i + 1
    end
  end
end

function Graphics.loadSprites(name)
  Graphics.spriteImage = love.graphics.newImage(name)
  Graphics.spriteImage:setFilter("nearest", "nearest")
  local sw, sh = Graphics.spriteImage:getWidth(), Graphics.spriteImage:getHeight()
  local i = 1
  for y = 0, sh-1, 16 do
    for x = 0, sw-1, 16 do
      Graphics.sprites[i] = love.graphics.newQuad(x, y, 16, 16, sw, sh)
      i = i + 1
    end
  end
end

function Graphics.loadFont(name)
  local fontimage = love.graphics.newImage(name)
  fontimage:setFilter("nearest", "nearest")
  Graphics.font = love.graphics.newImageFont(fontimage, Graphics.fontset)
  Graphics.font:setLineHeight( fontimage:getHeight() )
  love.graphics.setFont(Graphics.font)
end

function Graphics.drawPixel( x, y, r, g, b )
  love.graphics.setColor( r, g, b )
  love.graphics.rectangle( "fill", x, y, 1, 1 )
end

function Graphics.drawTile( x, y, tile )
  local xs, ys = Graphics.xScale, Graphics.yScale
  love.graphics.drawq( Graphics.tilesetImage, Graphics.tiles[tile],
    math.floor(x*ys)/ys, math.floor(y*ys)/ys )
end

function Graphics.drawSprite( x, y, idx )
  local xs, ys = Graphics.xScale, Graphics.yScale
  love.graphics.drawq( Graphics.spriteImage, Graphics.sprites[idx],
    math.floor(x*ys)/ys, math.floor(y*ys)/ys )
end

function Graphics.saveScreenshot()
  local screen = love.graphics.newScreenshot()
  local filedata = love.image.newEncodedImageData(screen, "bmp")
  love.filesystem.write( "screenshot.bmp", filedata)
end

function Graphics.changeScale( size )
  Graphics.xScale, Graphics.yScale = size, size
  love.graphics.setMode( Graphics.gameWidth*size, Graphics.gameHeight*size, false )
end

function Graphics.text( x, y, color, str )
  if x == "center" then x = 80-(str:len()*4) end
  love.graphics.setColor(color)
  for c in str:gmatch('.') do
    love.graphics.print(c, x, y)
    x = x + Graphics.font:getWidth(c) - 2
  end
end

