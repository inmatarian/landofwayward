
Graphics = {
  gameWidth = 320,
  gameHeight = 240,
  tileFilename = "gfx/tileset.png",
  spriteFilename = "gfx/sprites.png",
  fontFilename = "gfx/wayfont.png",
  logoFilenames = {
    planetbadness = "gfx/planetbadness.png"
  },
  tiles = {},
  sprites = {},
  tileBounds = Util.strict {},
  spriteMeterBounds = Util.strict {
    [SpriteCode.LIFEBAR]  = { x=  0, y=493, w=103, h=9, fx=104, fy=493, g=2 },
    [SpriteCode.ENEMYBAR] = { x=  0, y=503, w=103, h=9, fx=104, fy=503, g=2 },
    [SpriteCode.AUDIOBAR] = { x=208, y=493, w= 42, h=3, fx=208, fy=497, g=1 },
  },
  tilesDrawn = 0,
  spritesDrawn = 0,
  fps = 0,
  mem = 0,
  fontset = [==[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]==],
}
Graphics.xScale = math.floor(love.graphics.getWidth() / Graphics.gameWidth)
Graphics.yScale = math.floor(love.graphics.getHeight() / Graphics.gameHeight)

Graphics.resolutions = {
  { 320, 240 },
  { 640, 480 },
  { 800, 480 },
  { 800, 600 },
  { 960, 720 },
  { 1280, 720 },
  { 1366, 768 },
  { 1280, 960 },
  { 1920, 1080 },
}

local WHITE = Util.strict { 255, 255, 255, 255 }
local GRAY = Util.strict { 144, 144, 144, 255 }
local BLACK = Util.strict { 0, 0, 0, 255 }

function Graphics:init()
  love.graphics.setColorMode("modulate")
  love.graphics.setBlendMode("alpha")
  self:loadFont(self.fontFilename)
  self:specialLoadImage("gfx/wayward0.png")
  -- self:loadTileset(self.tileFilename)
  self:loadSprites(self.spriteFilename)
  self:loadAllLogoImages()

  self.fpsClock = Util.CallbackTimer(1, Util.MethodBinding(self, self.updateFPS))
  self.memClock = Util.CallbackTimer(1, Util.MethodBinding(self, self.updateMEM))
end

function Graphics:update(dt)
  self.fpsClock:update(dt)
  self.memClock:update(dt)
end

function Graphics:updateFPS()
  self.fps = love.timer.getFPS()
end

function Graphics:updateMEM()
  self.mem = collectgarbage("count")
end

function Graphics:start()
  local winWidth = love.graphics.getWidth()
  local winHeight = love.graphics.getHeight()
  local width = self.gameWidth * self.xScale
  local height = self.gameHeight * self.yScale
  local x = (winWidth-width)/2
  local y = (winHeight-height)/2

  love.graphics.setScissor( x, y, width, height )
  love.graphics.translate( x, y )
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
        self.tilesDrawn, self.spritesDrawn, self.fps, self.mem ) )
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

function Graphics:addSprite( id, x, y, w, h, sw, sh )
  self.sprites[id] = love.graphics.newQuad(x, y, w, h, sw, sh)
end

function Graphics:loadSprites(name)
  self.spriteImage = love.graphics.newImage(name)
  self.spriteImage:setFilter("nearest", "nearest")
  local sw, sh = self.spriteImage:getWidth(), self.spriteImage:getHeight()
  local i = 1
  for y = 0, sh-1, 16 do
    for x = 0, sw-1, 16 do
      self:addSprite( i, x, y, 16, 16, sw, sh )
      i = i + 1
    end
  end

  for id, b in pairs( self.spriteMeterBounds ) do
    self:addSprite( id, b.x, b.y, b.w, b.h, sw, sh )
    print("Added sprite", id, b.x, b.y, b.w, b.h, sw, sh )
    for i = 1, b.w-(b.g*2) do
      self:addSprite( id+i, b.fx+b.g+(i-1), b.fy, 1, b.h, sw, sh )
    end
  end
end

function Graphics:loadLogoImage(name)
  local image = love.graphics.newImage(name)
  image:setFilter("nearest", "nearest")
  return image
end

function Graphics:loadAllLogoImages()
  self.logos = {}
  for i, v in pairs(self.logoFilenames) do
    self.logos[i] = self:loadLogoImage(v)
  end
end

function Graphics:prepareTiles( index, x, y, w, h, sw, sh )
  for ty = y, y+h-1, 16 do
    for tx = x, x+w-1, 16 do
      self.tiles[index] = love.graphics.newQuad(tx, ty, 16, 16, sw, sh)
      index = index + 1
    end
  end
end

function Graphics:specialLoadImage(name)
  local iw, ih = 512, 512
  local source = love.image.newImageData(name)

  local merge = love.image.newImageData(iw, ih)
  merge:paste(source,   0,   0,   0,    0, 256, 256)
  merge:paste(source, 256,   0,   0, 1296, 256, 176)
  merge:paste(source, 256, 176, 128,  256, 128,  64)
  merge:paste(source, 256, 256,   0, 1024, 256, 256)

  local image = love.graphics.newImage(merge)
  image:setFilter("nearest", "nearest")

  self:prepareTiles(    1,   0,   0, 256, 256, iw, ih )
  self:prepareTiles( 1297, 256,   0, 256, 176, iw, ih )
  self:prepareTiles( 1025, 256, 256, 256, 256, iw, ih )

  self.tilesetImage = image
end

function Graphics:loadFont(name)
  local fontimage = love.graphics.newImage(name)
  fontimage:setFilter("nearest", "nearest")
  self.font = love.graphics.newImageFont(fontimage, self.fontset)
  self.font:setLineHeight( fontimage:getHeight() )
  love.graphics.setFont(self.font)
end

function Graphics:resetColor()
  love.graphics.setColor( 255, 255, 255, 255 )
end

function Graphics:setColor( color, ... )
  love.graphics.setColor( color, ... )
end

function Graphics:drawPixel( x, y, color, ... )
  love.graphics.setColor( color, ... )
  love.graphics.rectangle( "fill", x, y, 1, 1 )
end

function Graphics:drawTile( x, y, tile )
  local quad = self.tiles[tile]
  if not quad then return end
  local xs, ys = self.xScale, self.yScale
  love.graphics.drawq( self.tilesetImage, quad,
    math.floor(x*ys)/ys, math.floor(y*ys)/ys )
  self.tilesDrawn = self.tilesDrawn + 1
end

function Graphics:drawRect( x, y, w, h, color, lined )
  if color then self:setColor(color) end
  love.graphics.rectangle( lined and "line" or "fill", x, y, w, h)
end

function Graphics:fillScreen( color, ... )
  if color then self:setColor(color, ...) end
  love.graphics.rectangle( "fill", 0, 0, self.gameWidth, self.gameHeight)
end

function Graphics:drawSprite( x, y, idx )
  local quad = self.sprites[idx]
  if not quad then return end
  local xs, ys = self.xScale, self.yScale
  love.graphics.drawq( self.spriteImage, quad,
    math.floor(x*ys)/ys, math.floor(y*ys)/ys )
  self.spritesDrawn = self.spritesDrawn + 1
end

function Graphics:drawLogo( x, y, name, color )
  if color then self:setColor(color) end
  local logo = self.logos[name]
  if not logo then return end
  if x == "center" then
    local w = logo:getWidth()
    x = math.floor((self.gameWidth - w) / 2)
  end
  if y == "center" then
    local h = logo:getHeight()
    y = math.floor((self.gameHeight - h) / 2)
  end
  love.graphics.draw( logo, x, y )
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
  local winWidth = love.graphics.getWidth()
  local winHeight = love.graphics.getHeight()
  local id = 1
  for i, v in pairs(self.resolutions) do
    if winWidth >= v[1] and winHeight >= v[2] then id = i end
  end
  id = (id % #self.resolutions) + 1
  local mode = self.resolutions[id]
  self:setResolution( mode[1], mode[2] )
end

function Graphics:setResolution( width, height )
  love.graphics.setMode( width, height, false )
  local xscale = math.floor(love.graphics.getWidth() / Graphics.gameWidth)
  local yscale = math.floor(love.graphics.getHeight() / Graphics.gameHeight)
  self.xScale = math.min( xscale, yscale )
  self.yScale = self.xScale
  print( "New Display Mode", width, height, self.xScale )
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

function Graphics:drawMeterBar( x, y, id, val, direction )
  direction = direction or "right"
  local meter = self.spriteMeterBounds[id]
  local width = meter.w
  val = math.max(0, math.min(val, 100))

  local total = math.floor((val/100)*width)

  self:drawSprite( x, y, id )
  if direction ~= "right" then
    for i = 1, total do
      self:drawSprite( x+meter.g+(i-1), y, id + i )
    end
  else
    -- TODO: this code isn't finished.
    for i = total, 1, -1 do
      self:drawSprite( x+width-i, y, id + i )
    end
  end
  self:drawPixel( x, y, WHITE )
end

function Graphics:drawFixedSign( x, y, w, h, color )
  self:setColor(color)
  love.graphics.rectangle( "fill", x+4, y+4, w-8, h-8 )
  local U, D = SpriteCode.WINDOWU, SpriteCode.WINDOWD
  local L, R = SpriteCode.WINDOWL, SpriteCode.WINDOWR
  for i = 16, SignState.w-32, 16 do
    self:drawSprite( x+i, y, U )
    self:drawSprite( x+i, y+h-16, D )
  end
  for i = 16, SignState.h-32, 16 do
    self:drawSprite( x, y+i, L )
    self:drawSprite( x+w-16, y+i, R )
  end
  self:drawSprite( x, y, SpriteCode.WINDOWUL )
  self:drawSprite( x+w-16, y, SpriteCode.WINDOWUR )
  self:drawSprite( x, y+h-16, SpriteCode.WINDOWDL )
  self:drawSprite( x+w-16, y+h-16, SpriteCode.WINDOWDR )
end




