
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

  Graphics:init()
  Sound:init()
  Input:init()

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

function Wayward:stateSend( message, ... )
  local object = self.stateStack[#self.stateStack]
  if not object then return end
  func = object[message]
  if not func then return end
  func( object, ... )
end

function Wayward:stateDownSend( object, message, ... )
  local N = #self.stateStack
  while (self.stateStack[N] ~= object) and (N > 0) do N = N - 1 end
  local downObject = self.stateStack[N-1]
  if not downObject then return end
  local func = downObject[message]
  if not func then return end
  func( downObject, ... )
end

function Wayward:update(dt)
  Animator.updateAll(dt)

  if Input:isClicked("f2") then Graphics:saveScreenshot() end
  if Input:isClicked("f3") then self.debug = not self.debug end
  if Input:isClicked("f5") then Graphics:toggleScale() end
  if Input:isClicked("f8") then collectgarbage("collect") end
  if Input:isClicked("f10") then love.event.quit() end

  self:stateSend( "update", dt )

  Sound:update(dt)
  Graphics:update(dt)
  Input:update(dt)
  if #self.stateStack == 0 then love.event.quit() end
end

function Wayward:downupdate( object, dt )
  self:stateDownSend( object, "update", dt )
end

function Wayward:draw()
  Graphics:start()
  self:stateSend( "draw" )
  Graphics:stop(self.debug)
end

function Wayward:downdraw( object )
  self:stateDownSend( object, "draw" )
end

function Wayward:keypressed(key, unicode)
  Input:handlePressed(key)
end

function Wayward:keyreleased(key, unicode)
  Input:handleReleased(key)
end

function Wayward:focus( focused )
  -- Pause?
end

function Wayward:quit()
  -- Yes no maybe so?
end

function Wayward:pushState( state )
  print( "State Machine Push", state )
  self:stateSend( "statePause" )
  table.insert( self.stateStack, state )
  self:stateSend( "stateEnter" )
end

function Wayward:popState()
  print( "State Machine", state )
  self:stateSend( "stateExit" )
  table.remove( self.stateStack )
  self:stateSend( "stateResume" )
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

function Wayward:killItem( id )
  self.deadItems[id] = true
end

function Wayward:isItemDead( id )
  return (self.deadItems[id] == true)
end

