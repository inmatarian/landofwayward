
PlaceholderState = class()

function PlaceholderState:init( nextStateClass, ... )
  local arg = {...}
  self.nextState = function()
    return nextStateClass( unpack(arg) )
  end
end

function PlaceholderState:draw() end

function PlaceholderState:update(dt)
  Waygame:popState()
  Waygame:pushState( self.nextState() )
end

