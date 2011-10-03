
require "class"
require "sprite"
require "util"
require "graphics"
require "sound"
require "map"
require "player"
require "camera"

----------------------------------------

Waygame = {
  keypress = Util.setDefaultValue( {}, 0 );
}

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

TestState = class()

function TestState:init()
  self.map = Map("testboard.tmx")
  local px, py = self.map:locateEntity( 785 )
  px, py = px or 1, py or 1
  self.player = Player( px, py )
  self.camera = Camera(self.player)
  self.map:addSprite(self.player)
  self.camera:setBounds( 0, 0, self.map.width, self.map.height )
end

function TestState:draw()
  love.graphics.setColor( WHITE )
  local cam = self.camera
  self.map:draw(cam)

  -- debug
  local pl = self.player
  Graphics.text( 0, 0, WHITE, string.format("%.2f %.2f %.2f %.2f %i %i", pl.x, pl.y, pl.xexcess, pl.yexcess, pl.xtarget, pl.ytarget) )
  local vx, vy = cam:screenTranslate( pl.x, pl.y )
  Graphics.text( 0, 8, WHITE, string.format("%.2f %.2f %.2f %.2f", cam.x, cam.y, vx, vy) )
end

function TestState:update(dt)
  local key = Waygame.keypress
  if key["escape"]==1 then StateMachine.pop() end
  self.player:handleKeypress(key["up"], key["down"], key["left"], key["right"])
  self.map:update(dt)
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
  local key = Waygame.keypress
  if dt > 0.1 then dt = 0.1 end
  if key["f2"] == 1 then Graphics.saveScreenshot() end
  if key["f10"] == 1 then love.event.push('q') end

  local scale
  for i = 1, 4 do
    if key[ "" .. i ] == 1 then scale = i end
  end
  if scale then Graphics.changeScale(scale) end

  StateMachine.update(dt)
  Sound.update()
  if StateMachine.isEmpty() then love.event.push('q') end
  for i, v in pairs(key) do
    key[i] = v + dt
  end
end

function love.draw()
  love.graphics.scale( Graphics.xScale, Graphics.yScale )
  love.graphics.setColor( 255, 255, 255 )
  StateMachine.draw(dt)
end

function love.keypressed(key, unicode)
  Waygame.keypress[key] = 1
end

function love.keyreleased(key, unicode)
  Waygame.keypress[key] = nil
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

