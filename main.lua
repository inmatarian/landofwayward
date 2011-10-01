
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
  self.pattern = nil
  self.index = 1
  self.clock = 0
end

function Animator:addPattern( name, pattern )
  self.frames[name] = pattern
end

function Animator:setPattern( name )
  if self.pattern ~= name then
    self.pattern = name
    self.index = 1
    self.clock = 0
  end
end

function Animator:update(dt)
  if not self.pattern then return end
  self.clock = self.clock + dt
  local length = self.frames[self.pattern][self.index][2]
  while self.clock >= length do
    self.clock = self.clock - length
    self.index = self.index + 1
    if self.index > #self.frames[self.pattern] then
      self.index = 1
    end
  end
end

function Animator:current()
  if not self.pattern then return 0 end
  return self.frames[self.pattern][self.index][1]
end

----------------------------------------

Player = Sprite:subclass()
do
  local LENGTH = 0.25
  Player.animFrames = {
    N = { { 1, LENGTH }, { 2, LENGTH } },
    S = { { 3, LENGTH }, { 4, LENGTH } },
    W = { { 5, LENGTH }, { 6, LENGTH } },
    E = { { 7, LENGTH }, { 8, LENGTH } }
  }
end

function Player:init( x, y )
  print("Player.init", self, x, y )
  Player:superinit(self, x, y, 1, 1)
  self.frame = 1
  self.animator = Animator( Player.animFrames )
end

function Player:handleKeypress( u, d, l, r )
  local dir, least = "I", 9999999
  if u > 0 and u < least then dir, least = "N", u end
  if d > 0 and d < least then dir, least = "S", d end
  if l > 0 and l < least then dir, least = "W", l end
  if r > 0 and r < least then dir, least = "E", r end
  if dir ~= "I" then self:move( dir ) end
end

function Player:move( dir )
  if self.moving then return end
  Player.__index.move(self, dir)
  self.animator:setPattern(dir)
end

function Player:update(dt)
  Player.__index.update(self, dt)
  self.animator:update(dt)
  self.frame = self.animator:current()
end

----------------------------------------

Camera = class()

function Camera:init( sprite )
  self.following = sprite
  self.x = sprite.x - 9.5
  self.y = sprite.y - 7
  self.left, self.top, self.right, self.bottom = 0, 0, 256, 256
  self:restrictBounds()
end

function Camera:setBounds( left, top, right, bottom )
  self.left, self.top, self.right, self.bottom = left, top, right, bottom
  self:restrictBounds()
end

function Camera:update(dt)
  local spr = self.following
  -- local xwindow, ywindow = 3, 2
  local tx, ty = spr.x-9.5, spr.y-7
  local dx, dy = tx-self.x, ty-self.y
  local speed = dt * 2.5

  self:scroll( dx*speed, dy*speed )
end

function Camera:scroll( dx, dy )
  self.x = self.x + dx
  self.y = self.y + dy
  self:restrictBounds()
end

function Camera:restrictBounds()
  if self.x < self.left then self.x = self.left
  elseif self.x > self.right-20 then self.x = self.right-20 end
  if self.y < self.top then self.y = self.top
  elseif self.y > self.bottom-15 then self.y = self.bottom-15 end
end

function Camera:viewPos()
  return self.x-(0.5*Graphics.gameWidth), self.y-(0.5*Graphics.gameHeight)
end

function Camera:screenTranslate( x, y, w, h )
  w = (w or 0) * 16
  h = (h or 0) * 16
  x = (x-self.x)*16 -- +(0.5*Graphics.gameWidth)-(0.5*w)
  y = (y-self.y)*16 -- +(0.5*Graphics.gameHeight)-(0.5*h)
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

