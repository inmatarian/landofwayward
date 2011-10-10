
Wayward = class {
  ammo = 0,
  health = 100,
}

function Wayward:init()
  -- Global Variable and Singleton
  assert( Waygame == nil )
  Waygame = self

  math.randomseed( os.time() )
  Graphics:init()
  Sound.init()

  self.keypress = Util.setDefaultValue( {}, 0 );

  self.stateStack = {}
  self:pushState( PlaceholderState() )
  self:pushState( LogoState() )
end

function Wayward:update(dt)
  local key = self.keypress
  if key["f2"] == 1 then Graphics:saveScreenshot() end
  if key["f10"] == 1 then love.event.push('q') end

  local scale
  for i = 1, 4 do
    if key[ "" .. i ] == 1 then scale = i end
  end
  if scale then Graphics:changeScale(scale) end

  if #self.stateStack > 0 then
    self.stateStack[#self.stateStack]:update(dt)
  end

  Sound.update(dt)
  Graphics:update(dt)
  for i, v in pairs(key) do
    key[i] = v + dt
  end
  if #self.stateStack == 0 then love.event.push('q') end
end

function Wayward:draw()
  Graphics:start()
  if #self.stateStack > 0 then
    self.stateStack[#self.stateStack]:draw()
  end
  Graphics:stop(true)
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
PlaceholderState = class()
function PlaceholderState:draw() end
function PlaceholderState:update(dt)
  Waygame:popState()
  Waygame:pushState( TestState() )
end
----------------------------------------

TestState = class()

function TestState:init()
  self.map = Map("maps/testboard.tmx")
  local px, py = self.map:locateEntity(EntityCode.SYLVIA)
  px, py = px or 1, py or 1
  self.player = Player( px, py )
  self.camera = Camera(self.player)
  self.map:addSprite(self.player)
  self:loadThings()
  self.camera:setBounds( 0, 0, self.map.width, self.map.height )
end

function TestState:loadThings()
  for y = 0, self.map.height do
    for x = 0, self.map.width do
      local code = self.map:getEntity( x, y )
      local factory = self.entityFactory[code]
      if factory then self.map:addSprite( factory(self, x, y) ) end
    end
  end
end

do
  local factory = {}
  factory[EntityCode.AMMO] = function(self, x, y) return Ammo(x, y) end;
  factory[EntityCode.HEALTH] = function(self, x, y) return Health(x, y) end;
  TestState.entityFactory = factory
end

function TestState:draw()
  love.graphics.setColor( WHITE )
  local cam = self.camera
  self.map:draw(cam)

  -- debug
  local pl = self.player
  Graphics:text( 0, 0, WHITE, string.format("PLY P(%.2f,%.2f) X(%.2f,%.2f) T(%i,%i)", pl.x, pl.y, pl.xexcess, pl.yexcess, pl.xtarget, pl.ytarget) )
  local vx, vy = cam:screenTranslate( pl.x, pl.y )
  Graphics:text( 0, 8, WHITE, string.format("CAM P(%.2f,Y%.2f) S(X%.2f,Y%.2f)", cam.x, cam.y, vx, vy) )
end

function TestState:update(dt)
  local key = Waygame.keypress
  if key["escape"]==1 then
    collectgarbage()
    local count = 0
    for i, v in pairs(Sprite.weakSpritesTable) do count = count + 1 end
    print( "Living sprites", count, "Ammo", Waygame.ammo )
    Waygame:popState()
  end
  if key["p"]==1 then Waygame:pushState( PauseState() ) end
  self.player:handleKeypress(key["up"], key["down"], key["left"], key["right"])
  self.map:update(dt)
  self.camera:update(dt)
end

