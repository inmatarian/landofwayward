
Wayward = class {
  ammoMax = 0,
  ammoRecover = 0,
  ammo = 0,
  health = 100,
  debug = false,
  keyDelay = 0.500,
  keyRate = 0.050
}

function Wayward:init()
  -- Global Variable and Singleton
  assert( Waygame == nil )
  Waygame = self

  math.randomseed( os.time() )
  Graphics:init()
  Sound:init()

  self.keypress = Util.setDefaultValue( {}, 0 );
  self.keyrepeat = Util.setDefaultValue( {}, 0 );

  self.stateStack = {}
  self:pushState( PlaceholderState( TitleState ) )
  self:pushState( LogoState() )

  self.deadItems = {}
end

function Wayward:shutdown()
  print("Shutting down...")
  Util.printr(self)
  print("#end")
end

function Wayward:update(dt)
  if self:isKey("f2") then Graphics:saveScreenshot() end
  if self:isKey("f3") then self.debug = not self.debug end
  if self:isKey("f10") then love.event.push('q') end

  local scale
  for i = 1, 4 do if self:isKey(i) then scale = i end end
  if scale then Graphics:changeScale(scale) end

  if #self.stateStack > 0 then
    self.stateStack[#self.stateStack]:update(dt)
  end

  Sound:update(dt)
  Graphics:update(dt)
  self:updateKeys(dt)
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
  self.keyrepeat[key] = 1
end

function Wayward:keyreleased(key, unicode)
  self.keypress[key] = nil
  self.keyrepeat[key] = nil
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

function Wayward:updateKeys(dt)
  local keys = self.keypress
  local repeats = self.keyrepeat
  for i, v in pairs(repeats) do
    if v == 1 then
      repeats[i] = 1 + self.keyDelay
    elseif keys[i] >= v then
      repeats[i] = v + self.keyRate
    end
  end
  for i, v in pairs(keys) do
    keys[i] = v + dt
  end
end

-- True if any of the keys is pressed==1
function Wayward:isKey(...)
  local key = self.keypress
  local N = select('#', ...)
  for i = 1, N do
    if key[tostring(select(i,...))]==1 then return true end
  end
  return false
end

-- Takes into account key repeats on any key
function Wayward:isPressed(...)
  local key, repeats = self.keypress, self.keyrepeat
  local N = select('#', ...)
  for i = 1, N do
    local k = tostring(select(i,...))
    local a, b = key[k], repeats[k]
    if (a >= 1) and (a >= b) then return true end
  end
  return false
end

