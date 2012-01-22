
Graphics = {
  gameWidth = 320,
  gameHeight = 240,
  tileBounds = Util.strict {},
  tileFilename = "gfx/tileset.png",
  spriteFilename = "gfx/sprites.png",
  fontFilename = "gfx/wayfont.png",
  tiles = {},
  sprites = {},
  tilesDrawn = 0,
  spritesDrawn = 0,
  fps = 0,
  fpsClock = 0,
  fontset = [==[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]==],
}
Graphics.xScale = math.floor(love.graphics.getWidth() / Graphics.gameWidth)
Graphics.yScale = math.floor(love.graphics.getHeight() / Graphics.gameHeight)

WHITE = Util.strict { 255, 255, 255, 255 }
GRAY = Util.strict { 144, 144, 144, 255 }
BLACK = Util.strict { 0, 0, 0, 255 }

function Graphics:init()
  love.graphics.setColorMode("modulate")
  love.graphics.setBlendMode("alpha")
  self:loadFont(self.fontFilename)
  self:loadTileset(self.tileFilename)
  self:loadSprites(self.spriteFilename)
end

function Graphics:update(dt)
  self.fpsClock = self.fpsClock + dt
  if self.fpsClock > 1 then
    self.fpsClock = self.fpsClock - 1
    self.fps = love.timer.getFPS()
  end
end

function Graphics:start()
  love.graphics.scale( Graphics.xScale, Graphics.yScale )
  love.graphics.setLine( Graphics.xScale, "smooth" )
  love.graphics.setColor( 255, 255, 255 )
  self.tilesDrawn = 0
  self.spritesDrawn = 0
end

function Graphics:stop( outputDebug )
  if outputDebug then
    self:text( 8, 224, WHITE,
      string.format("T:%i S:%i FPS:%i MEM:%ik",
        self.tilesDrawn, self.spritesDrawn, self.fps, collectgarbage("count") ) )
  end
end

function Graphics:loadTileset(name)
  self.tilesetImage = love.graphics.newImage(name)
  self.tilesetImage:setFilter("nearest", "nearest")
  local sw, sh = self.tilesetImage:getWidth(), self.tilesetImage:getHeight()
  local i = 1
  for y = 0, sh-1, 16 do
    for x = 0, sw-1, 16 do
      self.tiles[i] = love.graphics.newQuad(x, y, 16, 16, sw, sh)
      i = i + 1
    end
  end
end

function Graphics:loadSprites(name)
  self.spriteImage = love.graphics.newImage(name)
  self.spriteImage:setFilter("nearest", "nearest")
  local sw, sh = self.spriteImage:getWidth(), self.spriteImage:getHeight()
  local i = 1
  for y = 0, sh-1, 16 do
    for x = 0, sw-1, 16 do
      self.sprites[i] = love.graphics.newQuad(x, y, 16, 16, sw, sh)
      i = i + 1
    end
  end
end

function Graphics:loadFont(name)
  local fontimage = love.graphics.newImage(name)
  fontimage:setFilter("nearest", "nearest")
  self.font = love.graphics.newImageFont(fontimage, self.fontset)
  self.font:setLineHeight( fontimage:getHeight() )
  love.graphics.setFont(self.font)
end

function Graphics:setColor( color )
  love.graphics.setColor( color )
end

function Graphics:drawPixel( x, y, r, g, b )
  love.graphics.setColor( r, g, b )
  love.graphics.rectangle( "fill", x, y, 1, 1 )
end

function Graphics:drawTile( x, y, tile )
  if tile == 0 then end
  local xs, ys = self.xScale, self.yScale
  love.graphics.drawq( self.tilesetImage, self.tiles[tile],
    math.floor(x*ys)/ys, math.floor(y*ys)/ys )
  self.tilesDrawn = self.tilesDrawn + 1
end

function Graphics:drawRect( x, y, w, h, color, lined )
  if color then self:setColor(color) end
  love.graphics.rectangle( lined and "line" or "fill" , x, y, w, h)
end

function Graphics:drawSprite( x, y, idx )
  if idx == 0 then end
  local xs, ys = self.xScale, self.yScale
  love.graphics.drawq( self.spriteImage, self.sprites[idx],
    math.floor(x*ys)/ys, math.floor(y*ys)/ys )
  self.spritesDrawn = self.spritesDrawn + 1
end

function Graphics:saveScreenshot()
  local screen = love.graphics.newScreenshot()
  local filedata = love.image.newEncodedImageData(screen, "bmp")
  local name = string.format("screenshot-%s.bmp", os.date("%Y%m%d-%H%M%S"))
  love.filesystem.write( name, filedata )
  print( "Saved Screenshot: " .. name )
end

function Graphics:changeScale( size )
  self.xScale, self.yScale = size, size
  love.graphics.setMode( self.gameWidth*size, self.gameHeight*size, false )
end

function Graphics:toggleScale()
  local size = (self.xScale % 4) + 1
  self:changeScale( size )
end

function Graphics:text( x, y, color, str )
  if x == "center" then x = 160-(str:len()*4) end
  if y == "center" then y = 116 end
  love.graphics.setColor(color)
  for c in str:gmatch('.') do
    love.graphics.print(c, x, y)
    x = x + self.font:getWidth(c) - 2
  end
end

