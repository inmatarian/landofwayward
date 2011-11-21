
Wayward = class {
  ammoMax = 0,
  ammoRecover = 0,
  ammo = 0,
  health = 100,
  debug = false
}

function Wayward:init()
  -- Global Variable and Singleton
  assert( Waygame == nil )
  Waygame = self

  math.randomseed( os.time() )
  Graphics:init()
  Sound:init()

  self.keypress = Util.setDefaultValue( {}, 0 );

  self.stateStack = {}
  self:pushState( PlaceholderState( ExplorerState ) )
  self:pushState( LogoState() )

  self.deadItems = {}
end

function Wayward:shutdown()
  print("Shutting down...")
  Util.printr(self)
  print("#end")
end

function Wayward:update(dt)
  local key = self.keypress
  if key["f2"] == 1 then Graphics:saveScreenshot() end
  if key["f3"] == 1 then self.debug = not self.debug end
  if key["f10"] == 1 then love.event.push('q') end

  local scale
  for i = 1, 4 do
    if key[ "" .. i ] == 1 then scale = i end
  end
  if scale then Graphics:changeScale(scale) end

  if #self.stateStack > 0 then
    self.stateStack[#self.stateStack]:update(dt)
  end

  Sound:update(dt)
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
  Graphics:stop(self.debug)
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

