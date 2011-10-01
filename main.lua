
require "class"
require "sprite"
require "util"
require "graphics"
require "sound"
require "map"

----------------------------------------

keypress = Util.setDefaultValue( {}, 0 )

----------------------------------------

StateMachine = {
  stack = {}
}

function StateMachine.push( state )
  print( "State Machine Push", state )
  table.insert( StateMachine.stack, state )
end

function StateMachine.pop()
  print( "State Machine", state )
  table.remove( StateMachine.stack )
end

function StateMachine.isEmpty()
  return ( #StateMachine.stack == 0 )
end

function StateMachine.draw()
  local n = #StateMachine.stack
  if n > 0 then
    StateMachine.stack[n]:draw()
  end
end

function StateMachine.update( dt )
  local n = #StateMachine.stack
  if n > 0 then
    StateMachine.stack[n]:update(dt)
  end
end

----------------------------------------

Animator = class()

function Animator:init( frames )
  self.frames = frames or {}
  self.index = 1
  self.clock = 0
end

function Animator:add( name, length )
  table.insert(self.frames, {name=name, length=length})
end

function Animator:update(dt)
  self.clock = self.clock + dt
  while self.clock >= self.frames[self.index].length do
    self.clock = self.clock - self.frames[self.index].length
    self.index = self.index + 1
    if self.index > #self.frames then
      self.index = 1
    end
  end
end

function Animator:current()
  return self.frames[self.index].name
end

----------------------------------------

PlainMap = class()

function PlainMap:init( x, y, width, height )
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.data = {}
end

function PlainMap:set( x, y, v )
  if x < self.x or y < self.y or x >= self.x+self.width or y >= self.y+self.height then return end
  if not self.data[y] then self.data[y] = {} end
  self.data[y][x] = v
end

function PlainMap:get( x, y )
  if x < self.x or y < self.y or x >= self.x+self.width or y >= self.y+self.height then return end
  if not self.data[y] then return end
  return self.data[y][x]
end

----------------------------------------

WorldChunk = class()

-- In the algo, the corners are clockwise.
-- In the ctor, the corners are TL TR BL BR for ease of use.
function WorldChunk:init( x, y, w, h, tl, tr, bl, br )
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.tl = tl
  self.tr = tr
  self.bl = bl
  self.br = br
  self.heightMap = PlainMap( x, y, w, h )
  self.floor = PlainMap( x, y, w, h )
end

function WorldChunk:generate()
  local noiseMap = NoiseMap(self.x, self.y, self.w, self.h, self.tl, self.tr, self.br, self.bl)
  local heightMap = self.heightMap
  local floorMap = self.floor
  for y = self.y, self.y+self.h-1 do
    for x = self.x, self.x+self.w-1 do
      local v = noiseMap:get(x, y)
      local cell
      if v < 0.25 then cell = 4
      elseif v < 0.35 then cell = 6
      elseif v < 0.65 then cell = 5
      else cell = 7 end
      floorMap:set( x, y, cell )
      heightMap:set( x, y, v )
    end
  end
end

function WorldChunk:containsPoint( px, py )
  return ( px >= self.x and px < self.x + self.w ) and
         ( py >= self.y and py < self.y + self.h )
end

function intersect( ax, ay, aw, ah, bx, by, bw, bh )
  local min, max = math.min, math.max
  local ax2, ay2 = ax + aw, ay + ah
  local bx2, by2 = bx + bw, by + bh
  local tx1 = max(ax, bx);
  local tx2 = min(ax2, bx2);
  local ty1 = max(ay, by);
  local ty2 = min(ay2, by2);
  local tw = tx2 - tx1
  local th = ty2 - ty1
  if tw < 0 or th < 0 then return end
  return tx1, ty1, tw, th
end

--[==[
function WorldChunk:draw( px, py, ox, oy )
  local vx, vy, vw, vh = intersect( self.x, self.y, self.w, self.h, px-10, py-7, 22, 16 )
  if not vx then return end
  for y = vy, vy+vh-1 do
    for x = vx, vx+vw-1 do
      local floor = self.floor:get( x, y )
      if floor then
        local tx, ty = (x-px-ox)*16+152, (y-py-oy)*16+112
        Graphics.drawTile( tx, ty, floor )
        visi = visi + 1
      end
    end
  end
end
]==]
----------------------------------------

WorldMap = class()
WorldMap.CHUNK_SIZE = 64

function WorldMap:init()
  self.chunks = PlainMap( -128, -128, 256, 256 )
end

function WorldMap:draw( px, py )
  pfx, pfy = math.floor(px), math.floor(py)
  ox, oy = px - pfx, py - pfy
  local wx, wy = math.floor(pfx/self.CHUNK_SIZE), math.floor(pfy/self.CHUNK_SIZE)
  for y = wy - 1, wy + 1 do
    for x = wx - 1, wx + 1 do
      chunk = self.chunks:get( x, y )
      if chunk then chunk:draw( pfx, pfy, ox, oy ) end
    end
  end
end

function WorldMap:generate( px, py )
  px, py = math.floor(px), math.floor(py)
  local SIZE = self.CHUNK_SIZE
  local wx, wy = math.floor(px/SIZE), math.floor(py/SIZE)
  for y = wy - 1, wy + 1 do
    for x = wx - 1, wx + 1 do
      chunk = self.chunks:get( x, y )
      if not chunk then
        local tl, tr, bl, br
        local north = self.chunks:get( x, y-1 )
        if north then tl = north.bl; tr = north.br end
        local south = self.chunks:get( x, y+1 )
        if south then bl = south.tl; br = south.tr end
        local west = self.chunks:get( x-1, y )
        if west then tl = west.tr; bl = west.br end
        local east = self.chunks:get( x+1, y )
        if east then tr = east.tl; br = east.bl end

        if not tl then tl = math.random() end
        if not tr then tr = math.random() end
        if not bl then bl = math.random() end
        if not br then br = math.random() end

        print( "Generating chunk at", x, y, px, py, tl, tr, bl, br )
        local newChunk = WorldChunk( x*SIZE, y*SIZE, SIZE, SIZE, tl, tr, bl, br )
        newChunk:generate()
        self.chunks:set( x, y, newChunk )
      end
    end
  end
end

----------------------------------------

Player = Sprite:subclass()

function Player:init( x, y )
  print("Player.init", self, x, y )
  Player:superinit(self, x, y, 1, 1)
end

function Player:handleKeypress( u, d, l, r )
  local dir, least = "I", 9999999
  if u > 0 and u < least then dir, least = "N", u end
  if d > 0 and d < least then dir, least = "S", d end
  if l > 0 and l < least then dir, least = "W", l end
  if r > 0 and r < least then dir, least = "E", r end
  if dir ~= "I" then self:move( dir ) end
end

function Player:draw(camera)
  Player.__index.draw(self, camera)
end

----------------------------------------

Camera = class()

function Camera:init( sprite )
  self.following = sprite
  self.x = sprite.x
  self.y = sprite.y
  self.left, self.top, self.right, self.bottom = 0, 0, 256, 256
end

function Camera:setBounds( left, top, right, bottom )
  self.left, self.top, self.right, self.bottom = left, top, right, bottom
end

function Camera:update(dt)
  local spr = self.following
  local dx, dy = self.x - spr.x, self.y - spr.y

  if dx < -2 then
    self.x = spr.x - 2
  elseif dx > 2 then
    self.x = spr.x + 2
  end

  if dy < -2 then
    self.y = spr.y - 2
  elseif dy > 2 then
    self.y = spr.y + 2
  end

  if self.x < self.left then self.x = self.left
  elseif self.x > self.right-21 then self.x = self.right-21 end
  if self.y < self.top then self.y = self.top
  elseif self.y > self.bottom-15 then self.y = self.bottom-15 end

end

function Camera:viewPos()
  return self.x-(0.5*Graphics.gameWidth), self.y-(0.5*Graphics.gameHeight)
end

function Camera:screenTranslate( x, y, w, h )
  w = (w or 0) * 16
  h = (h or 0) * 16
  x = (x-self.x)*16+(0.5*Graphics.gameWidth)-(0.5*w)
  y = (y-self.y)*16+(0.5*Graphics.gameHeight)-(0.5*h)
  return x, y, w, h
end

function Camera:layerDrawingParameters()
  -- return left, top, right, bottom, offx, offy
  local floor = math.floor
  local hardx, hardy = floor(self.x), floor(self.y)
  local offx, offy = self.x - hardx, self.y - hardy

  return hardx, hardy, hardx+21, hardy+15, offx, offy
end

----------------------------------------

TestState = class()

function TestState:init()
  self.player = Player( 1, 1 )
  self.camera = Camera(self.player)
  self.map = Map("field.tmx")
  self.camera:setBounds( 0, 0, self.map.width, self.map.height )
end

function TestState:draw()
  local pl = self.player
  local ca = self.camera
  love.graphics.setColor( WHITE )
  visi = 0
  self.map:draw(ca)
  pl:draw( ca )
  Graphics.text( 0, 0, WHITE, string.format("%.2f %.2f %.2f %.2f %i %i", pl.x, pl.y, pl.xexcess, pl.yexcess, pl.xtarget, pl.ytarget) )
  local vx, vy = ca:screenTranslate( pl.x, pl.y )
  Graphics.text( 0, 8, WHITE, string.format("%.2f %.2f %.2f %.2f", ca.x, ca.y, vx, vy) )
end

function TestState:update(dt)
  if keypress["escape"]==1 then StateMachine.pop() end
  self.player:handleKeypress(keypress["up"], keypress["down"], keypress["left"], keypress["right"])
  self.player:update(dt)
  self.camera:update(dt)
end

----------------------------------------

function love.load()
  math.randomseed( os.time() )
  Graphics.init()
  Sound.init()
  StateMachine.push( TestState() )
end

function love.update(dt)
  if dt > 0.1 then dt = 0.1 end
  if keypress["f2"] == 1 then Graphics.saveScreenshot() end
  if keypress["f10"] == 1 then love.event.push('q') end

  local scale
  for i = 1, 4 do
    if keypress[ "" .. i ] == 1 then scale = i end
  end
  if scale then Graphics.changeScale(scale) end

  StateMachine.update(dt)
  Sound.update()
  if StateMachine.isEmpty() then love.event.push('q') end
  for i, v in pairs(keypress) do
    keypress[i] = v + dt
  end
end

function love.draw()
  love.graphics.scale( Graphics.xScale, Graphics.yScale )
  love.graphics.setColor( 255, 255, 255 )
  StateMachine.draw(dt)
end

function love.keypressed(key, unicode)
  keypress[key] = 1
end

function love.keyreleased(key, unicode)
  keypress[key] = nil
end

--[==[
function love.focus(focused)
  if not focused then
    local n = #stateStack
    if (n > 0) and (stateStack[n].pause) then
      stateStack[n]:pause()
    end
  end
end
]==]

