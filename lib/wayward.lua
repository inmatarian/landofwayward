
Wayward = class()

function Wayward:init()
  -- Global Variable and Singleton
  assert( Waygame == nil )
  Waygame = self

  math.randomseed( os.time() )
  Graphics.init()
  Sound.init()

  self.keypress = Util.setDefaultValue( {}, 0 );

  self.stateStack = {}
  self:pushState( TestState() )
  self:pushState( LogoState() )
end

function Wayward:update(dt)
  local key = self.keypress
  if key["f2"] == 1 then Graphics.saveScreenshot() end
  if key["f10"] == 1 then love.event.push('q') end

  local scale
  for i = 1, 4 do
    if key[ "" .. i ] == 1 then scale = i end
  end
  if scale then Graphics.changeScale(scale) end

  if #self.stateStack > 0 then
    self.stateStack[#self.stateStack]:update(dt)
  end

  Sound.update()
  for i, v in pairs(key) do
    key[i] = v + dt
  end
  if #self.stateStack == 0 then love.event.push('q') end
end

function Wayward:draw()
  love.graphics.scale( Graphics.xScale, Graphics.yScale )
  love.graphics.setColor( 255, 255, 255 )
  if #self.stateStack > 0 then
    self.stateStack[#self.stateStack]:draw()
  end
end

function Wayward:keypressed(key, unicode)
  self.keypress[key] = 1
end

function Wayward:keyreleased(key, unicode)
  self.keypress[key] = nil
end

function Wayward:focus( focused )
  -- Pause?
end

function Wayward:quit()
  -- Yes no maybe so?
end

function Wayward:pushState( state )
  print( "State Machine Push", state )
  table.insert( self.stateStack, state )
end

function Wayward:popState()
  print( "State Machine", state )
  table.remove( self.stateStack )
end

----------------------------------------

TestState = class()

function TestState:init()
  self.map = Map("maps/testboard.tmx")
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
  if key["escape"]==1 then Waygame:popState() end
  if key["p"]==1 then Waygame:pushState( PauseState() ) end
  self.player:handleKeypress(key["up"], key["down"], key["left"], key["right"])
  self.map:update(dt)
  self.camera:update(dt)
end

